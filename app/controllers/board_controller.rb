class BoardController < ApplicationController
  before_action :set_billboard, only: [:show, :edit, :update, :destroy]
  
  def index
    @board = Billboard.all
  end

  def show
  end

  def new 
    @board = Billboard.new
  end

  def create
    @board = Billboard.new(board_params)
    if @board.save
      redirect_to board_path
    else
      render :new
    end

  def edit
  end

  def update
    if @board.update(board_params)
      redirect_to board_path
    else 
      render :edit
    end
  end

  def destroy
    @board.destroy
    redirect_to board_path
end

private 
  def set_board
    @board = Billboard.find(params[:id])
  end

    def board_params
  params.require(:board).permit(:ustop, :eurotop, :top)
    end
  end
end

