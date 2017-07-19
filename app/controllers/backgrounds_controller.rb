class BackgroundsController < ApplicationController
  before_action :set_background, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @backgrounds = Background.all
    respond_with(@backgrounds)
  end

  def show
    respond_with(@background)
  end

  def new
    @background = Background.new
    respond_with(@background)
  end

  def edit
  end

  def create
    @background = Background.new(background_params)
    @background.save
    respond_with(@background)
  end

  def update
    @background.update(background_params)
    respond_with(@background)
  end

  def destroy
    @background.destroy
    respond_with(@background)
  end

  private
    def set_background
      @background = Background.find(params[:id])
    end

    def background_params
      params.require(:background).permit(:color, :image)
    end
end
