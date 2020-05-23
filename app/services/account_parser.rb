class AccountParser
  LOG_PATH = "#{Rails.root}/log/#{Rails.env}_salesforce.log"
  
  def initialize(event)
    @event = event
  end
  
  def save_account
    account_params = sanitize_account
    account = Account.where(sf_id: account_params[:sf_id]).first
    if account.present?
      account.update_attributes(account_params)
    else
      account = Account.create(account_params)
    end
    Logger.new(LOG_PATH).info("Account saved ID: #{account.sf_id}")
  end
  
  private
  
  def sanitize_account
    sobject = @event['sobject']
    deleted = sobject['IsDeleted']
    is_deleted = deleted.present? && deleted.is_a?(Boolean) ? deleted : false
    {
      name: sobject['Name'],
      phone: sobject['Phone'],
      sf_id: sobject['Id'],
      created_at: @event['event']['createdDate'],
      type: sobject['Type'],
      owner_id: sobject['OwnerId'],
      parent_id: sobject['ParentId'],
      is_deleted: is_deleted,
    }
  end
end