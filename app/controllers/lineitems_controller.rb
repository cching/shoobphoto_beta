class Invoices::LineitemsController < ApplicationController
    def show
    end

    def new
        @invoice = Invoice.find(params[:invoice_id])
        @lineitem = Lineitem.new 

    def edit
        
    end

    def create
        @invoice = Invoice.find(params[:invoice_id])
        @lineitem = @invoice.lineitems.new(params[:lineitem])
        @lineitem.save
    end 
end 

private

    def set_lineitem
        @lineitem = Lineitem.find(params[:id])
    end

    def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
    end 
    def invoice_params
        params.require(:lineitems).permit(:id, :quantity, :product, :price, 
        :extended_price, :created_at, :updated_at, invoice attributes: [:id])
    end 
end 

