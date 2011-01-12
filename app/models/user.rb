class User < ActiveRecord::Base
  belongs_to :course
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # Virtual attribute for authenticating by either username or email
   # This is in addition to a real persisted field like 'username'
   attr_accessor :login
         
  # Setup accessible (or protected) attributes for your model : login is a virtual attribute
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :login, :admin, :grader, :course_id
  
  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["LOWER(username) = LOWER(:value) OR LOWER(email) = LOWER(:value)", { :value => login.strip }]).first
  end
  
  protected

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end 

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    case_insensitive_keys.each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
         login = attributes.delete(:login)
         record = where(attributes).where(["username = :value OR email = :value", { :value => login }]).first
      else  
        record = where(attributes).first
      end  
    end  

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end  
    end  
    record
  end
end