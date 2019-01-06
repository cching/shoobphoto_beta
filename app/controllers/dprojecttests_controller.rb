class DprojecttestsController < ApplicationController
    def new
        @dprojecttest = Dprojecttest.new
    end

    def dprojecttest_params
        params.require(:dprojecttest).permit(:dproject_id, :comment,  dproject_attributes:  [:id])
  end
end
