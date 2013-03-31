class RegistrationsController < ApplicationController


  #--------------------------------
  #Error message => errCode
  SUCCESS = 1
  
  #Error codes can only be used by Admin/section modifications
  SEC_NAME_INVALID = 200
  DAY_INVALID = 201
  DESCR_INVALID = 202
  TEACHER_INVALID = 203
  SEC_OVERLAP_FOR_TEACHER = 204
  TIME_INVALID = 205
  DATE_INVALID = 206
  FAILED_TO_DELETE = 207

  #Error codes can be used by all users
  NO_SECTION_TO_SHOW = 300
  FAILED_TO_MAKE_REG = 301
    #statusCodes
    USER_ALREADY_IN_SEC = 2
    ADD_TO_WAIT_LIST = 3
    WAIT_LIST_FULL = 4
    PASS_ADD_DEADLINE = 5
  USER_NOT_REG = 303

  #--------------------------------



  #for users to register for sections
  def register
    if session[:user_id] != nil
      @user = User.find_by_id(session[:user_id])
    #deprecated in the future
    else  
      @user = User.find_by_email(params[:user_email].downcase)
    end
    @sec = Section.find_by_name(params[:section_name].upcase)
    
    respond_to do |format|
      if @user.sections.exists?(:name => @sec.name) or
         @sec.users.exists?(:id=>@user.id)
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:2}], 
                                     errCode:301 } }
      elsif @sec.enroll_cur == @sec.enroll_max and 
            @sec.waitlist_cur < @sec.waitlist_max
        @user.sections << @sec
        @reg = Registration.where(:user_id => @user.id, :section_id => @sec.id).first
        @reg.update_attributes(waitlist_place:(@sec.waitlist_cur + 1))
        @sec.update_attributes(waitlist_cur:(@sec.waitlist_cur + 1))
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                waitlist_place:@reg.waitlist_place,
                                                statusCode:3}],
                                     errCode:301} }        
      elsif @sec.waitlist_cur == @sec.waitlist_max
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:4}],
                                     errCode:301} }        
      else
        #since it's a join table, the entry added by one key can be 
        #view or accessed by the other key
        @user.sections << @sec
        #@sec.users << @user
        @reg = Registration.where(:user_id => @user.id, :section_id => @sec.id).first
        @reg.update_attributes(waitlist_place:0)
        @sec.update_attributes(enroll_cur:(@sec.enroll_cur + 1))
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:1}],
                                     errCode:1} }        
      end
    end
  end


  #for users to drop a registered section
  def drop
    #assuming user already has at least 1 section
    if session[:user_id] != nil
      @user = User.find_by_id(session[:user_id])
    #deprecated in the future
    else  
      @user = User.find_by_email(params[:user_email].downcase)
    end
    @sec = Section.find_by_name(params[:section_name].upcase)
    
    respond_to do |format|
      @user.sections.delete(@sec)
      @sec.users.delete(@user)
      if @sec.waitlist_cur == 0
        @sec.enroll_cur -= 1
      else
        #shift the person 1st in the waitlist to the enrolled list
        @sec.waitlist_cur -= 1
        
        if @sec.waitlist_cur != 0
          Registration.where("section_id = :section_id, 
                              waitlist_place > 0", 
                              :section_id => @sec.id).each do |r|
            r.update_attributes(waitlist_place:(r.waitlist_place - 1))
          end
        end
      end
      @sec.update_attributes(enroll_cur:@sec.enroll_cur, 
                             waitlist_cur:@sec.waitlist_cur)
      format.json { render json: { section_id:@sec.id, 
                                   section_name:@sec.name, 
                                   errCode:1 } }
    end
  end


  #for users to view his/her enrolled sections
  def viewEnrolledSections
    if session[:user_id] != nil
      @user = User.find_by_id(session[:user_id])
    #deprecated in the future
    else  
      @user = User.find_by_email(params[:user_email].downcase)
    end
    
    respond_to do |format|
      if @user.sections.empty?
        format.json { render json: { sections:[], errCode:303 } }
      else
        enrolled_sections = @user.sections.all
        sections_info = []
        for section in enrolled_sections do
          @reg = Registration.where(:user_id => @user.id, 
                                    :section_id => section.id).first
          temp_sec = section.attributes
          temp_sec[:waitlist_place] = @reg.waitlist_place
          sections_info << temp_sec
        end
        format.json { render json: { sections:sections_info, errCode:1 } }
      end
    end
  end


end
