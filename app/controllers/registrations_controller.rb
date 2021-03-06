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

  #Error codes can be used by all students
  NO_SECTION_FOUND = 300
  FAILED_TO_MAKE_REG = 301
    #statusCodes
    USER_ALREADY_IN_SEC = 2
    ADD_TO_WAIT_LIST = 3
    WAIT_LIST_FULL = 4
    PASS_ADD_DEADLINE = 5
  USER_NOT_REG = 303

  #--------------------------------



  #for students to register for sections
  def register
    if cookies[:remember_token] != nil
      @student = Student.find_by_remember_token(cookies[:remember_token])
    end
    @sec = Section.find_by_id(params[:section_id])
    
    respond_to do |format|
      if @student.sections.exists?(:id => @sec.id) or
         @sec.students.exists?(:id=>@student.id)
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:2}], 
                                     errCode:301 } }
      elsif @sec.enroll_cur == @sec.enroll_max and 
            @sec.waitlist_cur < @sec.waitlist_max
        @student.sections << @sec
        @reg = @student.registrations.where(:section_id => @sec.id).first
        @reg.update_attributes(waitlist_place:(@sec.waitlist_cur + 1))
        @sec.update_attributes(waitlist_cur:(@sec.waitlist_cur + 1))
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                waitlist_place:@reg.waitlist_place,
                                                statusCode:3}],
                                     errCode:301} }        
      elsif @sec.waitlist_cur == @sec.waitlist_max and
            @sec.waitlist_max != 0
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:4}],
                                     errCode:301} }        
      else
        #since it's a join table, the entry added by one key can be 
        #view or accessed by the other key
        @student.sections << @sec
        #@sec.students << @student
        @reg = @student.registrations.where(:section_id => @sec.id).first
        @reg.update_attributes(waitlist_place:0)
        @sec.update_attributes(enroll_cur:(@sec.enroll_cur + 1))
        format.json { render json: { sections:[{section_id:@sec.id, 
                                                section_name:@sec.name, 
                                                statusCode:1}],
                                     errCode:1} }        
      end
    end
  end


  #for students to drop a registered section
  def drop
    if cookies[:remember_token] != nil
      @student = Student.find_by_remember_token(cookies[:remember_token])
    end
    @sec = Section.find_by_id(params[:section_id])
    
    respond_to do |format|
      
      if @student.sections.where(:id => @sec.id).first == nil
        format.json { render json: { errCode: 304 } }
      else
        @student.sections.delete(@sec)
        errCode = 1
        #@sec.students.delete(@student)
        if @sec.waitlist_cur == 0
          @sec.enroll_cur -= 1
        else
          #shift the person 1st in the waitlist to the enrolled list
          @sec.waitlist_cur -= 1
          
          Registration.where("section_id = :section_id and 
                              waitlist_place > 0", 
                              :section_id => @sec.id).each do |r|
            r.update_attributes(waitlist_place:(r.waitlist_place - 1))
          end
        end
        @sec.update_attributes(enroll_cur:@sec.enroll_cur, 
                               waitlist_cur:@sec.waitlist_cur)
        format.json { render json: { section_id:@sec.id, 
                                   section_name:@sec.name, 
                                   errCode:1 } }
      end
    end
    #print "\n**************\n"
    #print cookies
    #print "\n"
    #print @student.id
    #print "\n"
    #print Registration.all
    #print "\n**************\n"
  end


  #for students to view his/her enrolled sections
  def getEnrolledSections
    if cookies[:remember_token] != nil
      @student = Student.find_by_remember_token(cookies[:remember_token])
    end
    
    respond_to do |format|
      if @student.sections.empty?
        format.json { render json: { sections:[], errCode:303 } }
      else
        enrolled_sections = @student.sections.all
        sections_info = []
        for section in enrolled_sections do
          @reg = @student.registrations.where(:section_id => section.id).first
          #print section.attributes
          #print "\n******************\n"
          #print @reg.attributes
          #print "\n******************\n"
          #print @student.attributes
          #print "\n******************\n"
          temp_sec = section.attributes
          temp_sec[:waitlist_place] = @reg.waitlist_place
          sections_info << temp_sec
        end
        format.json { render json: { sections:sections_info, errCode:1 } }
      end
    end
  end


  # drop a section and get the rest enrolled sections
  def dropAndGetEnrolledSections
    if cookies[:remember_token] != nil
      @student = Student.find_by_remember_token(cookies[:remember_token])
    end
    @sec = Section.find_by_id(params[:section_id])
    
    respond_to do |format|
      
      if @student.sections.where(:id => @sec.id).first == nil
        format.json { render json: {sections:@student.sections.all, errCode: 304 } }
      else
        @student.sections.delete(@sec)
        if @sec.waitlist_cur == 0
          @sec.enroll_cur -= 1
        else
          #shift the person 1st in the waitlist to the enrolled list
          @sec.waitlist_cur -= 1
          
          Registration.where("section_id = :section_id and 
                              waitlist_place > 0", 
                              :section_id => @sec.id).each do |r|
            r.update_attributes(waitlist_place:(r.waitlist_place - 1))
          end
        end
        @sec.update_attributes(enroll_cur:@sec.enroll_cur, 
                               waitlist_cur:@sec.waitlist_cur)
        format.json { render json: { sections: @student.sections.all,
                                   errCode:1 } }
      end
    end

  end

end
