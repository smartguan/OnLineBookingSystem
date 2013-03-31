class SectionsController < ApplicationController

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

  # create, for admin only
  def createSection
    @sec = newSection
    respond_to do |format|
      if @sec.save
        self.returnSuccess format
      else
        self.returnAdminError format
      end
    end
  end


  #edit for admin only  
  def editSection
    @sec = Section.find_by_name(params[:name].upcase)

    respond_to do |format|
      if @sec.update_attributes(day:params[:day], 
                                description:params[:description], 
                                end_date:params[:end_date],
                                end_time:params[:end_time],
                                enroll_max:params[:enroll_max], 
                                start_date:params[:start_date],
                                start_time:params[:start_time], 
                                teacher:params[:teacher], 
                                waitlist_max:params[:waitlist_max])
        self.returnSuccess format
      else
        self.returnAdminError format
      end
    end
  end


  #delete a section
  def deleteSection
    @sec = Section.find_by_name(params[:name].upcase)

    respond_to do |format|
      if @sec.destroy
        returnSuccess format
      #might be implemented later. e.g. can't destroy user with booking payment
      else
        format.json { render json: { errCode: 207 } }
      end
    end
  end



  #get schedule 
  #note: for now just return all the sections.
  #later may be divided to return schedule according to different sort. e.g. time, date
  def getSchedule
    secs_list = Section.all

    respond_to do |format|
      if not secs_list.empty?
        format.json { render json: { :sections => secs_list, errCode: 1} }
      else
        format.json { render json: { errCode: 300 } }
      end
    end
  end


  #view one section
  #later may be divided to return schedule according to different sort. e.g. time, date
  def viewOneSection
    sec = Section.where(name:params[:name]).first

    respond_to do |format|
      if sec != nil
        format.json { render json: { :sections => [sec], errCode: 1} }
      else
        format.json { render json: { :sections => [], errCode: 300 } }
      end
    end
  end

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

  ##for users to register for sections
  #def register
  #  if session[:user_id] != nil
  #    @user = User.find_by_id(session[:user_id])
  #  #deprecated in the future
  #  else  
  #    @user = User.find_by_email(params[:user_email].downcase)
  #  end
  #  @sec = Section.find_by_name(params[:section_name].upcase)
  #  
  #  respond_to do |format|
  #    if @user.sections.exists?(:name => @sec.name) or
  #       @sec.users.exists?(:id=>@user.id)
  #      format.json { render json: { sections:[{section_id:@sec.id, 
  #                                              section_name:@sec.name, 
  #                                              statusCode:2}], 
  #                                   errCode:301 } }
  #    elsif @sec.enroll_cur == @sec.enroll_max and 
  #          @sec.waitlist_cur < @sec.waitlist_max
  #      @user.sections << @sec
  #      @reg = Registration.where(:user_id => @user.id, :section_id => @sec.id).first
  #      @reg.update_attributes(waitlist_place:(@sec.waitlist_cur + 1))
  #      @sec.update_attributes(waitlist_cur:(@sec.waitlist_cur + 1))
  #      format.json { render json: { sections:[{section_id:@sec.id, 
  #                                              section_name:@sec.name, 
  #                                              statusCode:3}],
  #                                   errCode:301} }        
  #    elsif @sec.waitlist_cur == @sec.waitlist_max
  #      format.json { render json: { sections:[{section_id:@sec.id, 
  #                                              section_name:@sec.name, 
  #                                              statusCode:4}],
  #                                   errCode:301} }        
  #    else
  #      #since it's a join table, the entry added by one key can be 
  #      #view or accessed by the other key
  #      @user.sections << @sec
  #      #@sec.users << @user
  #      @reg = Registration.where(:user_id => @user.id, :section_id => @sec.id).first
  #      @reg.update_attributes(waitlist_place:0)
  #      @sec.update_attributes(enroll_cur:(@sec.enroll_cur + 1))
  #      format.json { render json: { sections:[{section_id:@sec.id, 
  #                                              section_name:@sec.name, 
  #                                              statusCode:1}],
  #                                   errCode:1} }        
  #    end
  #  end
  #end



  ##for users to drop a registered section
  #def drop
  #  #assuming user already has at least 1 section
  #  if session[:user_id] != nil
  #    @user = User.find_by_id(session[:user_id])
  #  #deprecated in the future
  #  else  
  #    @user = User.find_by_email(params[:user_email].downcase)
  #  end
  #  @sec = Section.find_by_name(params[:section_name].upcase)
  #  
  #  respond_to do |format|
  #    @user.sections.delete(@sec)
  #    @sec.users.delete(@user)
  #    if @sec.waitlist_cur == 0
  #      @sec.enroll_cur -= 1
  #    else
  #      #shift the person 1st in the waitlist to the enrolled list
  #      @sec.waitlist_cur -= 1
  #      @update_reg = Registration.where(:waitlist_place => 1).first
  #      @update_reg.update_attributes(waitlist_place:0)
  #      
  #      if @sec.waitlist_cur != 0
  #        Registration.where("user_id = :user_id, section_id = :section_id, 
  #                            waitlist_place >= :one",  
  #                            :user_id => @user.id, :section_id => @sec.id, 
  #                            :one => 1 ).each do |r|
  #          r.update_attributes(waitlist_place:(r.waitlist_place - 1))
  #        end
  #      end
  #    end
  #    @sec.update_attributes(enroll_cur:@sec.enroll_cur, 
  #                           waitlist_cur:@sec.waitlist_cur)
  #    format.json { render json: { section_id:@sec.id, 
  #                                 section_name:@sec.name, 
  #                                 errCode:1 } }
  #  end
  #end


  ##for users to view his/her enrolled sections
  #def viewEnrolledSections
  #  if session[:user_id] != nil
  #    @user = User.find_by_id(session[:user_id])
  #  #deprecated in the future
  #  else  
  #    @user = User.find_by_email(params[:user_email].downcase)
  #  end
  #  
  #  respond_to do |format|
  #    if @user.sections.empty?
  #      format.json { render json: { sections:[], errCode:303 } }
  #    else
  #      format.json { render json: { sections:@user.sections.all, errCode:1 } }
  #    end
  #  end
  #end


  #creat
  def newSection
   return Section.new(name:params[:name], day:params[:day], 
                            description:params[:description], end_date:params[:end_date],
                            end_time:params[:end_time], enroll_cur:0,
                            enroll_max:params[:enroll_max], start_date:params[:start_date],
                            start_time:params[:start_time], teacher:params[:teacher], 
                            waitlist_cur:0, waitlist_max:params[:waitlist_max])
  end

  
  #return success code
  def returnSuccess format
    format.json { render json: { name:@sec.name, errCode: 1 } }
  end
  
  #return error code
  def returnAdminError format
    if not @sec.errors[:name].empty?
      format.json { render json: { name:@sec.name, errCode: 200 } }
    elsif not @sec.errors[:day].empty?
      format.json { render json: { name:@sec.name, errCode: 201 } }
    elsif not @sec.errors[:description].empty?
      format.json { render json: { name:@sec.name, errCode: 202 } }
    elsif not @sec.errors[:teacher].empty?
      if @sec.errors[:teacher][0] == 'section_overlapped'
        format.json { render json: { name:@sec.name, errCode: 204 } }
      else 
        format.json { render json: { name:@sec.name, errCode: 203 } }
      end
    elsif not @sec.errors[:start_time].empty? or not @sec.errors[:end_time].empty?
      format.json { render json: { name:@sec.name, errCode: 205 } }
    elsif not @sec.errors[:start_date].empty? or not @sec.errors[:end_date].empty?
      format.json { render json: { name:@sec.name, errCode: 206 } }
    end
  end



end
