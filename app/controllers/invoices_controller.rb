class InvoicesController < ApplicationController
    respond_to :html, :xml, :json
    
    before_filter :set_dproject
    def show        
        @dproject = Dproject.find(params[:id])
        @invoice = Invoice.find(params[:id])
    end
    def print
        @invoice = Invoice.find(params[:id])
        @dproject = Dproject.find(params[:dproject_id])
        @lineitems = Lineitem.all 
    end 
    def new
        @dproject = Dproject.find(params[:dproject_id])
        @lineitems = Lineitem.new 
        @invoice = @dproject.invoices.build
    end
     
    def edit
        @dproject = Dproject.find(params[:dproject_id])
        @invoice = @dproject.invoices.find(params[:id])
    end

    def index
        params[:q].reject { |_, v| v.blank? } if params[:q]
        @lineitems = Lineitem.all 
    end 

    def update
        redirect_to print_dproject_invoice_path
    end 
    def create
        @invoice = @dproject.invoices.new(invoice_params)
        if @invoice.save
            flash[:success] = "Invoice saved"
            redirect_to dproject_invoices_path
        else
            redirect_to new_dproject_invoices_path
        
      end
    end 
 

    
    
      # respond_with(@dproject)
   
private
    def set_dproject
        @dproject = Dproject.find(params[:dproject_id])
    end 
    def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
    end 
    def invoice_params
        params.require(:invoice).permit(:id, :dproject_id,
        lineitems_attributes: [:invoice_id, :id, :quantity, :product, :price, :extended_price, :sales_tax, :final_price])
    end 
end 
