class Admin::PlayersController < Admin::BaseController
  def index
    @players = Player.paginate(:page => params[:page]).order("created_at DESC")
  end

  def new
    @player = Player.new
  end

  def edit
    @player = Player.find params[:id]
  end

  def update
    @player = Player.find params[:id]
    if @player.update_attributes params.require(:player).permit(:name)
      flash.notice = "Player successfully updated"
      redirect_to admin_players_path
    else
      flash.alert = @player.errors.full_messages.join(', ')
      render :edit
    end
  end

  def create
    @player = Player.new params.require(:player).permit(:name)
    if @player.save
      flash.notice = "Player successfully created"
      redirect_to admin_players_path
    else
      flash.alert = @player.errors.full_messages.join(', ')
      render :new
    end
  end

  def destroy
    @player = Player.find params[:id]
    if @player.destroy
      flash.notice = "Player successfully deleted"
      redirect_to admin_players_path
    else
      flash.alert = "There was an error deleting your player"
      redirect_to admin_players_path
    end
  end
end