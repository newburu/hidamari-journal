class AnnualThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_theme, only: %i[ show edit update destroy ]

  def index
    @annual_themes = current_user.annual_themes.order(year: :desc)
  end

  def show
  end

  def new
    @annual_theme = current_user.annual_themes.new(year: Date.current.year)
  end

  def edit
  end

  def create
    @annual_theme = current_user.annual_themes.new(annual_theme_params)

    if @annual_theme.save
      redirect_to annual_theme_url(@annual_theme), notice: "Annual theme was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @annual_theme.update(annual_theme_params)
      redirect_to annual_theme_url(@annual_theme), notice: "Annual theme was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @annual_theme.destroy!

    redirect_to annual_themes_url, notice: "Annual theme was successfully destroyed."
  end

  private
    def set_annual_theme
      @annual_theme = current_user.annual_themes.find(params[:id])
    end

    def annual_theme_params
      params.require(:annual_theme).permit(:year, :kanji, :meaning)
    end
end
