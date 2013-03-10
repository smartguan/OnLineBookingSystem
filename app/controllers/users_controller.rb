class UsersController < ApplicationController
  SUCCESS = 1 
  FIRST_NOT_VALID = 101
  LAST_NOT_VALID = 102
  EMAIL_NOT_VALID = 103
  PASS_NOT_VALID = 104
  PASS_NOT_MATCH = 109
  DOB_NOTVALID = 105
  ZIP_NOT_VALID = 106
  USER_EXISTS = 107  
  DEFAULT = 999
  
  def add
    @user = User.new(first: params[:first], last: params[:last], email: params[:email],
                     password: params[:password], 
                     password_confirmation: params[:password_confirmation],
                     dob: params[:dob], zip: params[:zip], admin: params[:admin])
    respond_to do |format| 
      if @user.save
        format.json { render json: { errCode: SUCCESS } }
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
  end

  def delete
  end

  def update
  end

  def profile
  end
  
  def new 
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      flash[:notice] = "logging in"
      redirect_to root_url      #go back to home page
    else
      render :action => "new" #keep the same
    end

  end



end
