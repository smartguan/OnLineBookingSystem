class UsersController < ApplicationController
  
  # Error Codes 
  SUCCESS = 1 
  FIRST_NOT_VALID = 101
  LAST_NOT_VALID = 102
  EMAIL_NOT_VALID = 103
  PASS_NOT_VALID = 104
  PASS_NOT_MATCH = 109
  DOB_NOT_VALID = 105
  ADDRESS_NOT_VALID = 110
  CITY_NOT_VALID = 111
  ZIP_NOT_VALID = 106
  CONTACT_ONE_NOT_VALID = 112
  CONTACT_ONE_PRIMARY_NOT_VALID = 113
  CONTACT_ONE_SECONDARY_NOT_VALID = 113
  CONTACT_TWO_NOT_VALID = 114
  CONTACT_TWO_PRIMARY_NOT_VALID = 115
  CONTACT_TWO_SECONDARY_NOT_VALID = 116
  GENDER_NOT_VALID = 120
  SKILL_NOT_VALID = 118
  EXTRA_NOT_VALID = 119
  USER_EXISTS = 107
  BAD_CREDENTIALS = 108
  DEFAULT = 999

  def login
    user = User.find_by_email(params[:email].downcase)
    respond_to do |format|  
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.type == "AnonymousStudent"
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        format.json { render json: { errCode: SUCCESS, type: user.type } }
        cookies[:user_id] = user.id
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end 
  end

  def update
    if cookies.has_key?(:user_id)
      user = User.find(cookies[:user_id])
    else
      user = nil
    end
    respond_to do |format|
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        if user.type == "MemberStudent"
          user.update_attributes(first: params[:first], last: params[:last], 
             dob: params[:dob], address: params[:residence][:address],
             city: params[:residence][:city], 
             zip: params[:residence][:zip],
             contact_one: params[:contacts][:first][:name],
             contact_one_primary: params[:contacts][:first][:primary],
             contact_one_secondary: params[:contacts][:first][:secondary],
             contact_two: params[:contacts][:second][:name],
             contact_two_primary: params[:contacts][:second][:primary],
             contact_two_secondary: params[:contacts][:second][:secondary],
             email: params[:email],
             password: params[:password],
             password_confirmation: params[:password],
             gender: params[:gender], skill: params[:skill],
             extra: params[:extra], access_code: 0)
        elsif user.type == "Instructor"
          user.update_attributes(first: params[:first], last: params[:last], 
             dob: params[:dob], address: params[:residence][:address],
             city: params[:residence][:city], 
             zip: params[:residence][:zip],
             contact_one: params[:contacts][:first][:name],
             contact_one_primary: params[:contacts][:first][:primary],
             contact_one_secondary: params[:contacts][:first][:secondary],
             contact_two: "nobody",
             contact_two_primary: "(000) 000-0000",
             contact_two_secondary: "(000) 000-0000",
             email: params[:email],
             password: params[:password],
             password_confirmation: params[:password],
             gender: "other", skill: "advanced",
             extra: "", access_code: 0)
        elsif user.type == "Admin"
          user.update_attributes(first: params[:first], last: params[:last], 
             dob: params[:dob], address: params[:residence][:address],
             city: params[:residence][:city], 
             zip: params[:residence][:zip],
             contact_one: params[:contacts][:first][:name],
             contact_one_primary: params[:contacts][:first][:primary],
             contact_one_secondary: params[:contacts][:first][:secondary],
             contact_two: "nobody",
             contact_two_primary: "(000) 000-0000",
             contact_two_secondary: "(000) 000-0000",
             email: params[:email],
             password: params[:password],
             password_confirmation: params[:password],
             gender: "other", skill: "advanced",
             extra: "", access_code: 0)
        else
          user.update_attributes(first: params[:first], last: params[:last], 
            dob: params[:dob], address: params[:residence][:address],
            city: params[:residence][:city], 
            zip: params[:residence][:zip],
            contact_one: params[:contacts][:first][:name],
            contact_one_primary: params[:contacts][:first][:primary],
            contact_one_secondary: params[:contacts][:first][:secondary],
            contact_two: params[:contacts][:second][:name],
            contact_two_primary: params[:contacts][:second][:primary],
            contact_two_secondary: params[:contacts][:second][:secondary],
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password],
            gender: params[:gender], skill: params[:skill],
            extra: params[:extra], access_code: 0)
        end
        if user.errors.messages.empty? 
          format.json { render json: { errCode: SUCCESS } }
        elsif user.errors.messages[:first] 
          format.json { render json: { errCode: FIRST_NOT_VALID } }
        elsif user.errors.messages[:last]
          format.json { render json: { errCode: LAST_NOT_VALID } }
        elsif user.errors.messages[:email]
          if not user.errors.messages[:email].grep(/taken/).empty?
            format.json { render json: { errCode: USER_EXISTS } }
          elsif not user.errors.messages[:email].grep(/invalid/).empty?
            format.json { render json: { errCode: EMAIL_NOT_VALID } }
          end
        elsif user.errors.messages[:dob]
          format.json { render json: { errCode: DOB_NOT_VALID } }
        elsif user.errors.messages[:address]
          format.json { render json: { errCode: ADDRESS_NOT_VALID } }
        elsif user.errors.messages[:city]
          format.json { render json: { errCode: CITY_NOT_VALID } }
        elsif user.errors.messages[:zip]
          format.json { render json: { errCode: ZIP_NOT_VALID } }
        elsif user.errors.messages[:contact_one]
          format.json { render json: { errCode: CONTACT_ONE_NOT_VALID } }
        elsif user.errors.messages[:contact_one_primary]
          format.json { render json: { errCode: CONTACT_ONE_PRIMARY_NOT_VALID } }
        elsif user.errors.messages[:contact_one_secondary]
          format.json { render json: { errCode: CONTACT_ONE_SECONDARY_NOT_VALID } }
        elsif user.errors.messages[:contact_two]
          format.json { render json: { errCode: CONTACT_TWO_NOT_VALID } }
        elsif user.errors.messages[:contact_two_primary]
          format.json { render json: { errCode: CONTACT_TWO_PRIMARY_NOT_VALID } }
        elsif user.errors.messages[:contact_two_secondary]
          format.json { render json: { errCode: CONTACT_TWO_SECONDARY_NOT_VALID } }
        elsif user.errors.messages[:gender]
          format.json { render json: { errCode: GENDER_NOT_VALID } }
        elsif user.errors.messages[:skill]
          format.json { render json: { errCode: SKILL_NOT_VALID } }
        elsif user.errors.messages[:extra]
          format.json { render json: { errCode: EXTRA_NOT_VALID } }
        else
          format.json { render json: { errCode: DEFAULT } }
        end
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end

  def updatePassword
    if cookies.has_key?(:user_id)
      user = User.find(cookies[:user_id])
    else
      user = nil
    end
    respond_to do |format|
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        user.update_attributes(password: params[:new_password], 
                               password_confirmation: 
                                params[:new_password_confirmation])
        if user.errors.messages.empty? 
          format.json { render json: { errCode: SUCCESS } }
        elsif user.errors.messages[:password]
          if not user.errors.messages[:password].grep(/(blank)|(short)/).empty?
            format.json { render json: { errCode: PASS_NOT_VALID } }
          elsif not user.errors.messages[:password].grep(/match/).empty?
            format.json { render json: { errCode: PASS_NOT_MATCH } }
          else
            format.json { render json: { errCode: DEFAULT } }
          end
        end
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end
  
  def profile
    if cookies.has_key?(:user_id)
      user = User.find(cookies[:user_id])
    else
      user = nil
    end
    respond_to do |format| 
      if user
        user_hash = user.attributes.symbolize_keys!
        user_hash[:residence] = {}
        user_hash[:residence][:address] = user_hash[:address]
        user_hash[:residence][:city] = user_hash[:city]
        user_hash[:residence][:zip] = user_hash[:zip]
        user_hash[:contacts] = {}
        user_hash[:contacts][:first] = {}
        user_hash[:contacts][:second] = {}
        user_hash[:contacts][:first][:name] = user_hash[:contact_one]
        user_hash[:contacts][:first][:primary] = user_hash[:contact_one_primary]
        user_hash[:contacts][:first][:secondary] = user_hash[:contact_one_secondary]
        user_hash[:contacts][:second][:name] = user_hash[:contact_two]
        user_hash[:contacts][:second][:primary] = user_hash[:contact_two_primary]
        user_hash[:contacts][:second][:secondary] = user_hash[:contact_two_secondary]
        format.json { render json: { errCode: SUCCESS, user: user_hash } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } } 
      end
    end
  end

  def logout  
    respond_to do |format|
      if cookies.has_key?(:user_id)
        cookies.delete(:user_id)
        format.json { render json: { errCode: SUCCESS } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end
end
