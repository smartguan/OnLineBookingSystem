class UsersController < ApplicationController
  SUCCESS = 1 
  FIRST_NOT_VALID = 101
  LAST_NOT_VALID = 102
  EMAIL_NOT_VALID = 103
  PASS_NOT_VALID = 104
  PASS_NOT_MATCH = 109
  DOB_NOT_VALID = 105
  ZIP_NOT_VALID = 106
  USER_EXISTS = 107
  BAD_CREDENTIALS = 108
  DEFAULT = 999
  
  def add
    @user = User.new(first: params[:first], last: params[:last], email: params[:email],
                     password: params[:password], 
                     password_confirmation: params[:password_confirmation],
                     dob: params[:dob], zip: params[:zip], admin: params[:admin])
    respond_to do |format| 
      if @user.save
        format.json { render json: { errCode: SUCCESS } } 
        session[:user_id] = @user.id
      else 
        if @user.errors.messages[:first] 
          format.json { render json: { errCode: FIRST_NOT_VALID } }
        elsif @user.errors.messages[:last]
          format.json { render json: { errCode: LAST_NOT_VALID } }
        elsif @user.errors.messages[:email]
          if not @user.errors.messages[:email].grep(/taken/).empty?
            format.json { render json: { errCode: USER_EXISTS } }
          elsif not @user.errors.messages[:email].grep(/invalid/).empty?
            format.json { render json: { errCode: EMAIL_NOT_VALID } }
          end
        elsif @user.errors.messages[:password]
          if not @user.errors.messages[:password].grep(/(blank)|(short)/).empty?
            format.json { render json: { errCode: PASS_NOT_VALID } }
          elsif not @user.errors.messages[:password].grep(/match/).empty?
            format.json { render json: { errCode: PASS_NOT_MATCH } }
          else
            format.json { render json: { errCode: "Error in password" } }
          end
        elsif @user.errors.messages[:dob]
          format.json { render json: { errCode: DOB_NOT_VALID } }
        elsif @user.errors.messages[:zip]
          format.json { render json: { errCode: ZIP_NOT_VALID } }
        end
      end
    end
  end

  def login
    user = User.find_by_email(params[:email].downcase)
    
    respond_to do |format|  
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        format.json { render json: { errCode: SUCCESS, admin: user.admin } }
        session[:user_id] = user.id
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end 
  end

  def delete
    if not session.has_key?(:user_id)
      user = nil
    elsif not session[:user_id] == nil
      user = User.find(session[:user_id])
    else
      user = nil
    end
#    user = User.find_by_email(params[:email].downcase)
    respond_to do |format|  
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        User.delete(user.id) 
        session[:user_id] = nil
        format.json { render json: { errCode: SUCCESS } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end 
  end


  def changePassword
  end


  def update
    if not session.has_key?(:user_id)
      user = nil
    elsif not session[:user_id] == nil
      user = User.find(session[:user_id])
    else
      user = nil
    end
#    user = User.find_by_email(params[:ref_email].downcase)
    respond_to do |format|
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:password])
        user.update_attributes(first: params[:first], last: params[:last], 
                               email: params[:email], password: params[:password], 
                               password_confirmation: params[:password], 
                               zip: params[:zip], dob: params[:dob])
#        list = [:first, :last, :email, :password, :password_confirmation, :dob, :zip] 
#        list.each do |index|
#          if not params[index] == "0"
#            if index == :password or index == :password_confirmation
#              user.update_attributes(password: params[:password], 
#                                     password_confirmation: params[:password_confirmation])
#            else 
#              user.update_attributes(index => params[index], 
#                                     password: params[:password],
#                                     password_confirmation: params[:password_confirmation])
#            end
#          end
#        end
#        user.update_attributes(user_dict)
        if user.errors.messages.empty? 
          session[:user_id] = nil
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
        elsif user.errors.messages[:zip]
          format.json { render json: { errCode: ZIP_NOT_VALID } }
        else
          format.json { render json: { errCode: user } }
        end
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end

  def profile
    if not session.has_key?(:user_id)
      user = nil
    elsif not session[:user_id] == nil
      user = User.find(session[:user_id])
    else
      user = nil
    end
#    user = User.find_by_email(params[:email])
    respond_to do |format| 
      if user
        format.json { render json: { errCode: SUCCESS, user: user } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } } 
      end
    end
  end

  def logout  
    respond_to do |format|
      if not session.has_key?(:user_id)
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif not session[:user_id] == nil
        session[:user_id] = nil
        format.json { render json: { errCode: SUCCESS } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end

  def exportCsv
    users = User.order(:id)
    database = users.to_csv
    send_data database, filename: "database", type: "text/csv" 
  end
end
