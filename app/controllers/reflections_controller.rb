class ReflectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reflection, only: %i[ show edit update destroy ]

  def index
    @reflections = current_user.reflections.order(date: :desc)
  end

  def show
  end

  def new
    @reflection = current_user.reflections.build(date: Date.today, reflection_type: :daily)
  end

  def edit
  end

  def create
    @reflection = current_user.reflections.build(reflection_params)

    if @reflection.save
      redirect_to reflections_url, notice: t("reflections.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @reflection.update(reflection_params)
      redirect_to reflections_url, notice: t("reflections.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @reflection.destroy
    redirect_to reflections_url, notice: t("reflections.destroy.success"), status: :see_other
  end

  private
    def set_reflection
      @reflection = current_user.reflections.find_by(id: params[:id])
      if @reflection.nil?
        redirect_to root_path, alert: t("reflections.not_found")
        nil
      end
    end

    def reflection_params
      params.require(:reflection).permit(:date, :content, :score, :reflection_type)
    end
end
