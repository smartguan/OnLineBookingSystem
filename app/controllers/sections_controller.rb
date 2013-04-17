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
  def create
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
  def edit
    @sec = Section.find_by_id(params[:id])

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
  def delete
    @sec = Section.find_by_id(params[:id])

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
  def getAllSections
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
  def getSectionByID
    sec = Section.where(id:params[:id]).first

    respond_to do |format|
      if sec != nil
        format.json { render json: { :sections => [sec], errCode: 1} }
      else
        format.json { render json: { :sections => [], errCode: 300 } }
      end
    end
  end


  #view sections by date and types
  #later may be divided to return schedule according to different sort. e.g. time, date
  def getSectionsByDateAndTypes
    sec = Section.where(id:params[:id]).first

    respond_to do |format|
      if sec != nil
        format.json { render json: { :sections => [sec], errCode: 1} }
      else
        format.json { render json: { :sections => [], errCode: 300 } }
      end
    end
  end



  #newSection
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
