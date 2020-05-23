# Restforce uses faye as the underlying implementation for CometD.

require 'restforce'
require 'faye'

class SalesforceSubscriber
  attr_reader :client
  LOG_PATH = "#{Rails.root}/log/#{Rails.env}_salesforce.log"
  # Initialize a client with your username/password/oauth token/etc.
  def initialize
    @client = Restforce.new(username: ENV['SF_USERNAME'],
                            password: ENV['SF_PASSWORD'],
                            security_token: ENV['SF_SECURITY_TOKEN'],
                            client_id: ENV['SF_CLIENT_ID'],
                            client_secret: ENV['SF_SECRET_ID'])
  end
  
  def create_account_push_topic
    # Create a PushTopic for subscribing to Account changes.
    delete_account_topics
    account_topic = @client.create('PushTopic',
                                   ApiVersion: '48.0',
                                   Name: ENV['ACCOUNT_PUSH_TOPIC_NAME'],
                                   Description: 'all account records',
                                   NotifyForOperations: 'All',
                                   NotifyForFields: 'All',
                                   Query: 'select Id, Name, Phone, Type, Ownerid, ParentId, IsDeleted from Account')
    
    PushTopic.create(sf_id: account_topic, is_account: true) if account_topic.present? && account_topic.is_a?(String)
    Logger.new(LOG_PATH).info('Account Push Topic Id: ' + account_topic)
  rescue Restforce::ErrorCode::DuplicateValue
    delete_account_topics
    create_account_push_topic
  end
  
  def create_contact_push_topic
    # Create a PushTopic for subscribing to Contact changes.
    delete_contact_topics
    contact_topic = @client.create('PushTopic',
                                   ApiVersion: '48.0',
                                   Name: ENV['CONTACT_PUSH_TOPIC_NAME'],
                                   Description: 'all contact records',
                                   NotifyForOperations: 'All',
                                   NotifyForFields: 'All',
                                   Query: 'select Id, FirstName, LastName, Title, Email, Phone, MobilePhone, OtherPhone, AccountId, OwnerId, IsDeleted from Contact')
    
    PushTopic.create(sf_id: contact_topic, is_account: false) if contact_topic.present? && contact_topic.is_a?(String)
    Logger.new(LOG_PATH).info('Contact Push Topic Id: ' + contact_topic)
  rescue Restforce::ErrorCode::DuplicateValue
    delete_contact_topics
    create_contact_push_topic
  end
  
  def subscribe
    EM.run do
      # Subscribe to the account PushTopic.
      account_topic = ENV['ACCOUNT_PUSH_TOPIC_NAME']
      contact_topic = ENV['CONTACT_PUSH_TOPIC_NAME']
      @client.subscription "/topic/#{account_topic}" do |message|
        Logger.new(LOG_PATH).info('Account Received')
        AccountParser.new(message).save_account
      end
      
      # Subscribe to the contact PushTopic.
      @client.subscription "/topic/#{contact_topic}" do |message|
        Logger.new(LOG_PATH).info('Contact Received')
        ContactParser.new(message).save_contact
      end
    end
  end
  
  def delete_account_topics
    topics = PushTopic.where(is_account: true)
    if topics.present?
      topics.each do |topic|
        @client.destroy('PushTopic', topic.sf_id)
        Logger.new(LOG_PATH).info('Account PushTopic destroyed: ' + topic.sf_id)
        topic.destroy
      end
    end
  end
  
  def delete_contact_topics
    topics = PushTopic.where(is_account: false)
    if topics.present?
      topics.each do |topic|
        @client.destroy('PushTopic', topic.sf_id)
        Logger.new(LOG_PATH).info('Contact PushTopic destroyed: ' + topic.sf_id)
        topic.destroy
      end
    end
  end
end
