class FramesController < ApplicationController

  # GET /frames/new
  # GET /frames/new.json
  def new
    @game = Game.find(params[:game_id])
  end

  # POST /frames
  # POST /frames.json
  def create
    game = Game.find(params[:game_id])

    ball_1 = params[:ball_1].empty? ? nil : params[:ball_1]
    ball_2 = params[:ball_2].empty? ? nil : params[:ball_2]
    ball_3 = params[:ball_3]
    @frame = game.frames.create(:ball_1 => ball_1, :ball_2 => ball_2, :ball_3 => ball_3, :number_frame => game.current_frame+1)    
    if @frame.errors.any?
      flash[:errors] = @frame.errors.full_messages
    else
      game.add_frame
      game.reload
      @frame.calculate_points
    end
      if game.finished?
        redirect_to game_path(game), notice: 'Game was successfully created.'
      else  
        redirect_to new_frame_path(game), notice: 'Game was successfully created.' 
      end      
  end
end
