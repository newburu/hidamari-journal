class DailyTasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_task, only: %i[ update destroy ]
  before_action :set_date, only: %i[ index new create ]
  before_action :set_monthly_goals, only: %i[ index new create ]

  def index
    @daily_tasks = current_user.daily_tasks.where(date: @date).order(:created_at)
    @daily_task = current_user.daily_tasks.new(date: @date)
  end

  def new
    @daily_task = current_user.daily_tasks.new(date: @date)
  end

  def calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @daily_tasks = current_user.daily_tasks.where(date: start_date.all_month)
  end

  def create
    @daily_task = current_user.daily_tasks.new(daily_task_params)

    respond_to do |format|
      if @daily_task.save
        format.turbo_stream
        format.html { redirect_to daily_tasks_path(date: @daily_task.date), notice: t("daily_tasks.create.success") }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("modal", partial: "form", locals: { daily_task: @daily_task, monthly_goals: @monthly_goals }) }
        format.html { render :index, status: :unprocessable_entity }
      end
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

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
  end

  def set_monthly_goals
    current_annual_theme = current_user.annual_themes.find_by(year: @date.year)
    @monthly_goals = if current_annual_theme
                       current_annual_theme.monthly_goals.where(month: @date.month)
    else
                       []
    end
  end

  def set_daily_task
    @daily_task = current_user.daily_tasks.find_by(id: params[:id])
    if @daily_task.nil?
      redirect_to root_path, alert: t("daily_tasks.not_found")
      nil
    end
  end

  def daily_task_params
    params.require(:daily_task).permit(:title, :date, :completed, :monthly_goal_id)
  end
end
