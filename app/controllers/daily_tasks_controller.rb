class DailyTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_task, only: %i[ update destroy ]

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @daily_tasks = current_user.daily_tasks.where(date: @date).order(:created_at)

    # Preload monthly goals for the current month to allow quick selection
    current_annual_theme = current_user.annual_themes.find_by(year: @date.year)
    @monthly_goals = if current_annual_theme
                       current_annual_theme.monthly_goals.where(month: @date.month)
    else
                       []
    end

    @daily_task = current_user.daily_tasks.new(date: @date)
  end

  def calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @daily_tasks = current_user.daily_tasks.where(date: start_date.all_month)
  end

  def create
    @daily_task = current_user.daily_tasks.new(daily_task_params)

    if @daily_task.save
      redirect_to daily_tasks_path(date: @daily_task.date), notice: t("daily_tasks.create.success")
    else
      redirect_to daily_tasks_path(date: @daily_task.date), alert: t("daily_tasks.create.failure")
    end
  end

  def update
    if @daily_task.update(daily_task_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to daily_tasks_path(date: @daily_task.date), notice: t("daily_tasks.update.success") }
      end
    else
      redirect_to daily_tasks_path(date: @daily_task.date), alert: t("daily_tasks.update.failure")
    end
  end

  def destroy
    date = @daily_task.date
    @daily_task.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@daily_task) }
      format.html { redirect_to daily_tasks_path(date: date), notice: t("daily_tasks.destroy.success") }
    end
  end

  private

  def set_daily_task
    @daily_task = current_user.daily_tasks.find(params[:id])
  end

  def daily_task_params
    params.require(:daily_task).permit(:title, :date, :completed, :monthly_goal_id)
  end
end
