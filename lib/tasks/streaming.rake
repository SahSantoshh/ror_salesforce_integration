namespace :streaming do
  desc 'Fetch updates of Accounts data from salesforce push stream and update in database'
  task accounts_and_contacts: :environment do
    subscriber = SalesforceSubscriber.new
    subscriber.create_account_push_topic
    subscriber.create_contact_push_topic
    subscriber.subscribe
  end
end