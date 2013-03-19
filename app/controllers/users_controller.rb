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
        format.json { render json: { errCode: SUCCESS } }
        session[:user_id] = user.id
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end 
  end

  def delete
    if not session[:user_id] == nil
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

  def update
    if not session[:user_id] == nil
      user = User.find(session[:user_id])
    else
      user = nil
    end
#    user = User.find_by_email(params[:ref_email].downcase)
    respond_to do |format|
      if not user
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      elsif user.authenticate(params[:ref_password])
        list = [:first, :last, :email, :password, :password_confirmation, :dob, :zip] 
        user_dict = {}
        list.each do |index|
          if not params[index] == "0"
#            user_dict[index] = params[index]
#          elsif index == password or index == password_confirmation
#            user_dict[:password] 
#          else
#            user_dict[index] = user[index]
            if index == :password or index == :password_confirmation
              user.update_attributes(password: params[:password], 
                                     password_confirmation: params[:password_confirmation])
            else 
              user.update_attributes(index => params[index], 
                                     password: params[:ref_password],
                                     password_confirmation: params[:ref_password])
            end
          end
        end
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
    if not session[:user_id] == nil
      user = User.find(session[:user_id])
    else
      user = nil
    end
#    user = User.find_by_email(params[:email])
    respond_to do |format| 
      if user
        format.json { render json: { errCode: SUCCESS, user: user } }
        session[:user_id] = nil
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } } 
      end
    end
  end

  def logout  
    respond_to do |format|
      if not session[:user_id] == nil
        session[:user_id] = nil
        format.json { render json: { errCode: SUCCESS } }
      else
        format.json { render json: { errCode: BAD_CREDENTIALS } }
      end
    end
  end

  def new 
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      redirect_to :controller => :users, :action => 'show', :id => @user.id
      # redirect_to @user
    else
      render :action => "new" #keep the same
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
end
