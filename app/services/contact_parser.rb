class ContactParser
  LOG_PATH = "#{Rails.root}/log/#{Rails.env}_salesforce.log"
  
  def initialize(event)
    @event = event
  end
  
  def save_contact
    contact_params = sanitize_contact
    contact = Customer.where(sf_id: contact_params[:sf_id]).first
    account = Account.where(sf_id: contact_params[:sf_account_id]).first
    
    if account.present?
      contact_params.merge!(company_name: account.name, account_id: account.id.to_s)
    end
    contact_params.merge!(contact_and_account: "#{contact_params[:name]} | #{contact_params[:company_name]}")
    if contact.present?
      contact.update_attributes(contact_params)
    else
      contact = Customer.create(contact_params)
    end
    Logger.new(LOG_PATH).info('Contact saved ID: ' + contact.sf_id)
  end
  
  private
  
  def sanitize_contact
    sobject = @event['sobject']
    {
      first_name: sobject['FirstName'],
      last_name: sobject['LastName'],
      name: "#{sobject['FirstName']} #{sobject['LastName']}",
      title: sobject['Title'],
      email: sobject['Email'],
      sf_id: sobject['Id'],
      phone: sobject['Phone'],
      mobile_phone: sobject['MobilePhone'],
      other_phone: sobject['OtherPhone'],
      created_at: @event['event']['createdDate'],
      owner_id: sobject['OwnerId'],
      sf_account_id: sobject['AccountId']
      # contact_and_account:
    }
  end
end
