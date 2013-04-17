class AdminController < ApplicationController
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

  def addInstructor
    user = Instructor.new(first: params[:first], last: params[:last], 
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
           password_confirmation: params[:password_confirmation],
           gender: "other", skill: "advanced",
           extra: "", access_code: 0)
    respond_to do |format| 
      if user.save
        format.json { render json: { errCode: SUCCESS } } 
      else 
        if user.errors.messages[:first] 
          format.json { render json: { errCode: FIRST_NOT_VALID } }
        elsif user.errors.messages[:last]
          format.json { render json: { errCode: LAST_NOT_VALID } }
        elsif user.errors.messages[:email]
          if not user.errors.messages[:email].grep(/taken/).empty?
            format.json { render json: { errCode: USER_EXISTS } }
          elsif not user.errors.messages[:email].grep(/invalid/).empty?
            format.json { render json: { errCode: EMAIL_NOT_VALID } }
          end
        elsif user.errors.messages[:password]
          if not user.errors.messages[:password].grep(/(blank)|(short)/).empty?
            format.json { render json: { errCode: PASS_NOT_VALID } }
          elsif not user.errors.messages[:password].grep(/match/).empty?
            format.json { render json: { errCode: PASS_NOT_MATCH } }
          else
            format.json { render json: { errCode: "Error in password" } }
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
        else
          format.json { render json: { errCode: DEFAULT } }
        end
      end
    end
  end

  def delete
    #Add functionality to check whether an admin is logged in
    user = User.find_by_email(params[:email])
    respond_to do |format| 
      if user
        format.json { render json: { errCode: SUCCESS } }
        user.delete
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end

  def exportCsv
    #Add functionality to check whether and admin is logged in
    users = User.order(:id)
    database = users.to_csv
    send_data database, filename: "database", type: "text/csv"
  end
end