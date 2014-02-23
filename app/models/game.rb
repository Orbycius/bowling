class Game < ActiveRecord::Base

  FRAMES = 10
  attr_accessible :current_frame
  has_many :frames, :dependent => :destroy
  
  def finished?
    current_frame == FRAMES
  end
  
  def is_last_frame?
    current_frame == FRAMES - 1 
  end
  
  def next_frame
    self.finished? ? false : self.frames.count + 1
  end
  
  def add_frame
    self.current_frame += 1
    self.save
  end
  
  def results
    balls = []
    total = 0
    frames.each_with_index do |frame, i|
      total += frame.score
      last_frame = frame.is_last_frame? ? true : false
      balls << {:last_frame => last_frame, :points => total, :ball_1 => frame.ball_1, :ball_2 => frame.ball_2, :ball_3 => frame.ball_3, :strike => frame.strike?, :spare => frame.spare?}
    end
    return balls
  end
end
