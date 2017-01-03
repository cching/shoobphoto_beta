class AwardsController < ApplicationController

  respond_to :html

  def index
    if current_user
    else
      redirect_to new_user_session_path
    end
  end


  def clear
    @award_info = AwardInfo.find(params[:id])
    @award_info.students = []
    redirect_to award_students_path(@award_info.id)
  end

  def multiple_clear
    @export_list = ExportList.find(params[:id])
    @export_list.award_infos.each do |award_info|
      award_info.students = []
    end
    redirect_to award_multiple_students_path(@export_list.uniq_id)
  end
  
  def new
    if current_user
      @export_list = ExportList.create(:submitted => false, :user_id => current_user.id, :multiple => current_user.school.multiple)
      @export_list.save
      @export_list.update(:uniq_id => SecureRandom.hex(8))
      if current_user.school.multiple?
        redirect_to awards_multiple_path(@export_list.uniq_id)
      else
        redirect_to awards_single_path(@export_list.uniq_id)
      end
    else
      redirect_to new_user_session_path
    end
  end

  def single
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
  end

  def review
    @award_info = AwardInfo.find(params[:id])
    @search = @award_info.students.search(params[:q])
    @school = current_user.school

    if params[:q].nil?
      @students = @search.result.order(:teacher).order(:last_name)
    else
      @students = @search.result.order(:teacher).order(:last_name)
    end
  end

  def review_multiple
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
    @search = @export_list.award_infos.first.students.search(params[:q])
    @school = current_user.school

    if params[:q].nil?
      @students = @search.result.order(:teacher).order(:last_name)
    else
      @students = @search.result.order(:teacher).order(:last_name)
    end
  end

  def review_all
  end

  def in_progress
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
  end

  def confirm
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
  end

  def submit
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
    @export_list.update(:submitted => true)
  end

  def single_update
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
    @award = Award.find(params[:award_id])
    i = @export_list.award_infos.count 
    @award_info = AwardInfo.create(:export_list_id => @export_list.id, :award_id => @award.id, :index => i) 
    redirect_to award_add_info_path(params[:id], params[:award_id], @award_info.id, :i => i)
  end 

  def multiple_update
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")

    vals = []
    award_ids = @export_list.award_infos.pluck(:award_id)
    
    params[:award_ids].each do |val|
      unless award_ids.include?(val.to_i)
        @award_info = AwardInfo.create(:export_list_id => @export_list.id, :award_id => val.to_i) 
      end
      vals << val.to_i
    end

    @export_list.award_infos.each do |award_info|
      unless vals.include?(award_info.award.id)
        @export_list.award_infos.delete(award_info)
      end
    end

    redirect_to award_multiple_add_info_path(params[:id])
  end 


  def add_info
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
    @award = Award.find(params[:award_id])
    @award_info = @export_list.award_infos.find(params[:award_info])
  end

  def multiple_add_info
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
  end

  def update_award_info
    @award_info = AwardInfo.find(params[:id])
    @award_info.update(award_info_params)
    redirect_to award_students_path(@award_info.id)
  end

  def update_multiple_award_info
    @export_list = ExportList.find(params[:id])
    @export_list.update(export_list_params)

    redirect_to award_multiple_students_path(@export_list.uniq_id)
  end

  def multiple_students
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
    @school = current_user.school

    @students = Student.searching(@school.id, params[:first_name], params[:last_name], params[:grade], params[:teacher], params[:student_id]).where(:id_only => true).where(:enrolled => true).paginate(:per_page => 25,:page => params[:page])
      

    @image = @school.packages.where("name like ?", "%Fall%").last

    if @image.nil?
      @image = @school.packages.first
    end
  end

  def students
    @award_info = AwardInfo.find(params[:id])
    @award = @award_info.award
    @school = current_user.school

    @students = Student.searching(@school.id, params[:first_name], params[:last_name], params[:grade], params[:teacher], params[:student_id]).where(:id_only => true).where(:enrolled => true).paginate(:per_page => 25,:page => params[:page])
      

    @image = @school.packages.where("name like ?", "%Fall%").last

    if @image.nil?
      @image = @school.packages.first
    end

  end

  def new_student
    @award_info = AwardInfo.find(params[:award_id])
    @student = Student.new
    @school = current_user.school
    @image = @school.packages.where("name like ?", "%Fall%").last

    if @image.nil?
      @package = @school.packages.first
    end
    @teacher = @school.students.where(:id_only => true).select(:teacher).order(:teacher).map(&:teacher).uniq

    respond_to :js
  end

  def create_student
    @award_info = AwardInfo.find(params[:award_id])
    @school = current_user.school
    @student = @school.students.new(student_params)
    @image = Package.find(params[:package])

      image = @student.student_images.new(:package_id => @image.id)
      
      image.image = params[:image]
      image.index = params[:image]
      image.save

    @student.id_only = true
    
  @student.save
  @student.update(:enrolled => true)
  @school = @student.school
  @award_info.students << @student
    respond_to do |format|
      format.js { render 'create_student'}

    end
  end

  def multiple_new_student
    @export_list = ExportList.find(params[:id])
    @student = Student.new
    @school = current_user.school
    @image = @school.packages.where("name like ?", "%Fall%").last

    if @image.nil?
      @package = @school.packages.first
    end
    @teacher = @school.students.where(:id_only => true).select(:teacher).order(:teacher).map(&:teacher).uniq

    respond_to :js
  end

  def multiple_create_student
    @export_list = ExportList.find(params[:id])
    @school = current_user.school
    @student = @school.students.new(student_params)
    @image = Package.find(params[:package])

      image = @student.student_images.new(:package_id => @image.id)
      
      image.image = params[:image]
      image.index = params[:image]
      image.save

    @student.id_only = true
    
  @student.save
  @student.update(:enrolled => true)
  @school = @student.school
    respond_to do |format|
      format.js { render 'multiple_create_student'}

    end
  end

  def multiple
    @export_list = ExportList.find_by_uniq_id("#{params[:id]}")
  end

  def edit
  end

  def create
    @export_list = ExportList.new(export_list_params)

    redirect_to export_awards_path(@export_list.uniq_id)
  end

  def update
    @export_list.update(export_list_params)
    redirect_to export_awards_path(@export_list.uniq_id)
  end

  def destroy
    @award.destroy
    respond_with(@award)
  end

  private



    def export_list_params
      params.require(:export_list).permit(:user_id, award_infos_attributes: [:title, :abbreviation, :awarded_for, :definition, :time_period, :award_date, :export_list_id, :recieve_by, :id, :receive_by])
    end

    def award_info_params
      params.require(:award_info).permit(:awarded_for, :definition, :time_period, :award_date, :receive_by)
    end

    def student_params
            params.require(:student).permit(:first_name, :last_name, :id_only, :grade, :school_id, :student_id, :grade, :image, :index, :dob, :teacher, :data1, :data2, :data3, :data4, student_images_attributes: [:image])
    end
end
