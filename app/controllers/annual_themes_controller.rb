class AnnualThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_theme, only: %i[ show edit update destroy chart ]

  def index
    @annual_themes = current_user.annual_themes.order(year: :desc)
  end

  def show
  end

  def chart
    if @annual_theme.level == 3
      @center_item = @annual_theme.mandala_items.includes(children: :children).find_by(is_center: true, parent_id: nil)
      # Ensure all 8 surrounding items exist for the center item
      child_items = (0..8).map do |position|
        next if position == 4 # Center
        @annual_theme.mandala_items.find_or_create_by!(position: position, parent: @center_item, is_center: false)
      end.compact

      # Ensure all 8 children exist for each of the child items
      child_items.each do |child|
        (0..8).each do |position|
          next if position == 4 # Center
          @annual_theme.mandala_items.find_or_create_by!(position: position, parent: child, is_center: false)
        end
      end

      # Eager load all items again to get the newly created ones
      @center_item = @annual_theme.mandala_items.includes(children: :children).find(@center_item.id)
      @mandala_items = @center_item.children.order(:position)
    else # Level 2
      @center_item = @annual_theme.mandala_items.find_by(is_center: true, parent_id: nil)
      # Ensure all 8 surrounding items exist
      (0..8).each do |position|
        next if position == 4 # Center
        @annual_theme.mandala_items.find_or_create_by!(position: position, parent: @center_item, is_center: false)
      end
      @mandala_items = @annual_theme.mandala_items.where(parent: @center_item).or(MandalaItem.where(id: @center_item.id)).order(:position)
    end
  end

  def new
    @annual_theme = current_user.annual_themes.new(year: Date.current.year)
  end

  def edit
  end

  def create
    @annual_theme = current_user.annual_themes.new(annual_theme_params)

    if @annual_theme.save
      redirect_to annual_theme_url(@annual_theme), notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @annual_theme.update(annual_theme_params)
      redirect_to annual_theme_url(@annual_theme), notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @annual_theme.destroy!

    redirect_to annual_themes_url, notice: t(".success")
  end

  private
    def set_annual_theme
      @annual_theme = current_user.annual_themes.find_by(id: params[:id])
      if @annual_theme.nil?
        redirect_to root_path, alert: t("annual_themes.not_found")
        nil
      end
    end

    def annual_theme_params
      params.require(:annual_theme).permit(:year, :kanji, :meaning, :level)
    end
end
