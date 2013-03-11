class RegistrationsController < ApplicationController

  #--------------------------------
  #Error message => errCode
  SUCCESS = 1
  
  #Error codes can only be used by Admin
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

  #--------------------------------

  # create, for admin only
  def createSection
    @reg = newSection

    respond_to do |format|
      if @reg.save
        self.returnSuccess format
      else
        self.returnError format
      end
    end
  end


  #edit for admin only  
  def editSection
    @reg = Registration.find_by_name(params[:name])

    respond_to do |format|
      if @reg.update_attributes(day:params[:day], 
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
        self.returnError format
      end
    end
  end


  #delete a section
  def deleteSection
    @reg = Registration.find_by_name(params[:name])

    respond_to do |format|
      if @reg.destroy
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
    regs_list = Registration.all

    respond_to do |format|
      if not regs_list.empty?
        format.json { render json: { :sections => regs_list, errCode: 1} }
      else
        format.json { render json: { errCode: 300 } }
      end
    end
  end


  #creat
  def newSection
   return Registration.new(name:params[:name], day:params[:day], 
                            description:params[:description], end_date:params[:end_date],
                            end_time:params[:end_time], enroll_cur:0,
                            enroll_max:params[:enroll_max], start_date:params[:start_date],
                            start_time:params[:start_time], teacher:params[:teacher], 
                            waitlist_cur:0, waitlist_max:params[:waitlist_max])
  end

  
  #return success code
  def returnSuccess format
    format.json { render json: { name:@reg.name, errCode: 1 } }
  end
  
  #return error code
  def returnError format
    if not @reg.errors[:name].empty?
      format.json { render json: { name:@reg.name, errCode: 200 } }
    elsif not @reg.errors[:day].empty?
      format.json { render json: { name:@reg.name, errCode: 201 } }
    elsif not @reg.errors[:description].empty?
      format.json { render json: { name:@reg.name, errCode: 202 } }
    elsif not @reg.errors[:teacher].empty?
      if @reg.errors[:teacher][0] == 'section_overlapped'
        format.json { render json: { name:@reg.name, errCode: 204 } }
      else 
        format.json { render json: { name:@reg.name, errCode: 203 } }
      end
    elsif not @reg.errors[:start_time].empty? or not @reg.errors[:end_time].empty?
      format.json { render json: { name:@reg.name, errCode: 205 } }
    elsif not @reg.errors[:start_date].empty? or not @reg.errors[:end_date].empty?
      format.json { render json: { name:@reg.name, errCode: 206 } }
    end
  end



end
