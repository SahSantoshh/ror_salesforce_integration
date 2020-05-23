class Contact < ApplicationRecord
  belongs_to :account, optional: true
end
