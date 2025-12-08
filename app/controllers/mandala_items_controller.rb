class MandalaItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mandala_item

  def edit
  end

  def update
    if @mandala_item.update(mandala_item_params)
      # Sync center item content with AnnualTheme kanji if it's the center
      if @mandala_item.is_center? && @mandala_item.parent_id.nil?
         @mandala_item.annual_theme.update(kanji: @mandala_item.content)
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chart_annual_theme_path(@mandala_item.annual_theme), notice: t("mandala_items.update.success") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_mandala_item
    @mandala_item = MandalaItem.find(params[:id])
    # Ensure ownership
    unless @mandala_item.annual_theme.user_id == current_user.id
      redirect_to root_path, alert: t("mandala_items.authorization_error")
    end
  end

  def mandala_item_params
    params.require(:mandala_item).permit(:content)
  end
end
