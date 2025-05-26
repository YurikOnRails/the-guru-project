class Admin::BadgesController < Admin::BaseController
  before_action :set_badge, only: %i[show edit update destroy]

  def index
    @badges = Badge.order(:name)
  end

  def show; end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)

    if @badge.save
      redirect_to admin_badge_path(@badge), notice: 'Бейдж успешно создан'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @badge.update(badge_params)
      redirect_to admin_badge_path(@badge), notice: 'Бейдж успешно обновлен'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @badge.destroy
    redirect_to admin_badges_path, notice: 'Бейдж успешно удален'
  end

  private

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def badge_params
    params.require(:badge).permit(:name, :image_url, :rule_type, :rule_value)
  end
end 