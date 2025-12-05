class MonthlyGoalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_annual_theme
  before_action :set_monthly_goal, only: %i[ edit update destroy ]

  def index
    @monthly_goals = @annual_theme.monthly_goals.order(:month)
  end

  def new
    @monthly_goal = @annual_theme.monthly_goals.new
  end

  def edit
  end

  def create
    @monthly_goal = @annual_theme.monthly_goals.new(monthly_goal_params)
    @monthly_goal.user = current_user

    if @monthly_goal.save
      redirect_to annual_theme_monthly_goals_path(@annual_theme), notice: "Monthly goal was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @monthly_goal.update(monthly_goal_params)
      redirect_to annual_theme_monthly_goals_path(@annual_theme), notice: "Monthly goal was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @monthly_goal.destroy!
    redirect_to annual_theme_monthly_goals_path(@annual_theme), notice: "Monthly goal was successfully destroyed."
  end

  private
    def set_annual_theme
      @annual_theme = current_user.annual_themes.find(params[:annual_theme_id])
    end

    def set_monthly_goal
      @monthly_goal = @annual_theme.monthly_goals.find(params[:id])
    end

    def monthly_goal_params
      params.require(:monthly_goal).permit(:month, :goal, :mandala_item_id)
    end
end
