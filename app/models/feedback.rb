class Feedback
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates :name, presence: true, 
                   length: { minimum: 2, maximum: 50 }
                   
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
                    
  validates :message, presence: true, 
                      length: { minimum: 10, maximum: 1000 }
end
