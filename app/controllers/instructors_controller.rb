class InstructorsController < ApplicationController

  # -------------------------------------------- #
  NO_INSTRUCTOR_FOUND = 122
  
  # -------------------------------------------- #

  def getAllInstructors
    instructors_list = Instructor.all
    respond_to do |format|
      if instructors_list != []
        format.json { render json: { instructors: instructors_list, errCode:1 } }
      else
        format.json { render json: { instructors: instructors_list, errCode: 122 } }
      end
    end
  end

  
  # return all available instructors according to the type, date and time given 
  def getAvailableInstructors
    instructors_list = []

    Instructor.all.each do |inst|
    if inst.sections.where("((:start_time BETWEEN start_time AND end_time) OR 
                           (:end_time BETWEEN start_time AND end_time) OR 
                           (:start_time <= start_time AND :end_time >= end_time)) AND
                            
                            ((:start_date BETWEEN start_date AND end_date) OR 
                            (:end_date BETWEEN start_date AND end_date) OR 
                            (:start_date <= start_date AND :end_date >= end_date)) AND
                              
                              ((:section_type = section_type) OR
                            
                            ((:day IN (1,2,3,4)) AND
                              (:section_type = 'C' AND section_type = 'A')) OR
                              
                            ((day IN ('MONDAY','TUESDAY', 'WEDNESDAY', 'THURSDAY')) AND
                              (:section_type = 'A' AND section_type = 'C')) OR
                              
                            ((:day IN (6,0)) AND
                              (:section_type = 'C' AND section_type = 'B')) OR
                              
                            ((day IN ('SATURDAY', 'SUNDAY')) AND
                              (:section_type = 'B' AND section_type = 'C')))",
                          :start_time => params[:start_time], 
                          :end_time => params[:end_time], 
                          :start_date => params[:start_date].to_date, 
                          :end_date => params[:end_date].to_date,
                          :day => params[:start_date].to_date.wday,
                          :section_type => params[:section_type]).first == nil
   

        instructors_list << inst
      end
    end

    respond_to do |format|
      if instructors_list != []
        format.json { render json: { instructors: instructors_list, errCode:1 } }
      else
        format.json { render json: { instructors: instructors_list, errCode: 122 } }
      end
    end
    
  end

end
