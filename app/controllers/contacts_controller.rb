class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
layout 'fullwidth'  
  respond_to :html

  def index
    @contacts = Contact.all
    respond_with(@contacts)
  end

  def csv
    export = ContactExport.create
      ExportContact.perform_async(export.id)

      redirect_to export_admin_schools_path, notice: "The new order CSV is currently being generated."
  end

  def scheduling
  end

  def show
    respond_with(@contact)
  end

  def new
    @contact = Contact.new
    respond_with(@contact)
  end

  def edit
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save

    ContactMailer.send_mail(@contact).deliver
    redirect_to root_path, notice: "Thank you for contacting us! We'll get back to you soon."
    else
      render('new')
    end
  end

  def update
    @contact.update(contact_params)
    respond_with(@contact)
  end

  def destroy
    @contact.destroy
    respond_with(@contact)
  end

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:name, :file, :school, :student, :grade, :jobseeker, :teacher, :address, :city, :email, :phone, :message, :admin, :teacher_name, :parent)
    end
end
