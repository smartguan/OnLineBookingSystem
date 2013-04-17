class AnonymousStudentsController < ApplicationController
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

  def add
    rand_five_digit = rand(100000 - 10000) + 10000
    user = AnonymousStudent.new(first: params[:first], last: params[:last], 
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
           password: "password",
           password_confirmation: "password",
           gender: params[:gender], skill: params[:skill],
           extra: params[:extra], access_code: rand_five_digit)
    respond_to do |format| 
      if user.save
        format.json { render json: { errCode: SUCCESS, 
                                     access_code: rand_five_digit } } 
        cookies[:user_id] = user.id
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
      end
    end
  end
end
