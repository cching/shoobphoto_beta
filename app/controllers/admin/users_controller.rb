class Admin::UsersController < ApplicationController
	def csv
	end

	def import
    chunk = SmarterCSV.process(params[:file].tempfile, {:chunk_size => 500, row_sep: :auto}) do |chunk|
      UserImport.perform_async(chunk)
    end
    redirect_to admin_users_csv_path, notice: "Users successfully imported."
  end
end