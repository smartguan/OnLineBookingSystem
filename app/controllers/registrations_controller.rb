class RegistrationsController < ApplicationController

  #--------------------------------
  #Error message => errCode
  SEC_NAME_INVALID = 200
  DAY_INVALID = 201
  DESCR_INVALID = 202
  TEACHER_INVALID = 203
  SEC_OVERLAP_FOR_TEACHER = 204
  TIME_INVALID = 205
  DATE_INVALID = 206
  #--------------------------------

  #creat
  def newSection
    return Registration.new(name:params[:name], day:params[:day], 
                            description:param[:description], end_date:params[:end_date],
                            end_time:params[:end_time], enroll_cur:0,
                            enroll_max:params[:enroll_max], start_date:params[:start_date],
                            start_time:params[:start_time], teacher:params[:teacher], 
                            waitlist_cur:0, waitlist_max:params[:waitlist_max])
  end

  def createSection
    @reg = newSection
    
    respond_to do |format|
      if @reg.save
        if @reg.errors[:name]
          format.json { render json: { errCode: 200 } }
        elsif @reg.errors[:day]
          format.json { render json: { errCode: 201 } }
        elsif @reg.errors[:description]
          format.json { render json: { errCode: 202 } }
        elsif @reg.errors[:teacher]
          if @reg.errors[:teacher][0] == 'section_overlapped'
            format.json { render json: { errCode: 204 } }
          elsif 
            format.json { render json: { errCode: 203 } }
          end
        elsif @reg.errors[:start_time] or @reg.errors[:end_time]
          format.json { render json: { errCode: 205 } }
        elsif @reg.errors[:start_date] or @reg.errors[:end_date]
          format.json { render json: { errCode: 206 } }
        end
      end
    end
    
  end

  #delete
  def delete
  
  end



  #get schedule
  def getSchedule
    
  end

end
