class SongsController < ApplicationController
  def index
    @song = Song.all
  end

  def show
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      flash[:info] = "Song Saved"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  private
    def song_params
      params.require(:title).permit(:genre)
    end


end
