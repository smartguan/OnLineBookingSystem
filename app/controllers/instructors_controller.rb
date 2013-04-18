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

  
  


  def getAvailableInstructors

    
  end

end
