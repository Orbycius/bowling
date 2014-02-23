class Frame < ActiveRecord::Base
  
  PINS = 10  
  attr_accessible :ball_1, :ball_2, :ball_3, :points, :number_frame  
  belongs_to :game
  
  validates :ball_1, :numericality => { :greater_or_equal_than => 0, :less_than_or_equal_to => PINS }, :presence => true
  validates :ball_2, :numericality => { :greater_or_equal_than => 0, :less_than_or_equal_to => PINS }, :allow_nil => true
  validates :ball_3, :numericality => { :greater_or_equal_than => 0, :less_than_or_equal_to => PINS }, :allow_nil => true  

  validate :knocked_pins_should_not_exceed_pins  
  validate :if_not_strike_ball_2_should_exist
  validate :third_ball_only_after_strike_or_spare
  validate :third_ball_only_in_last_frame
  
  def get_ball_2
    self.ball_2.nil? ? 0 : self.ball_2
  end
  
  def strike?
      self.ball_1 == PINS
  end
  
  def spare?
    self.strike? == false and self.ball_1 + self.get_ball_2 == PINS
  end
  
  def is_last_frame?
    number_frame == PINS 
  end
  
  def calculate_points
    self.calculate_previous_frame        
    self.calculate_previous_previous_frame    
    if self.number_frame == PINS and (self.strike? or self.spare?)
      self.points = PINS + self.get_ball_2 + (self.strike? ? self.ball_3 : 0)
    else  
      self.points = self.ball_1 + self.get_ball_2 
    end    
    
    self.save
  end
  
  def calculate_previous_frame
    previous_frame = self.previous_frame
    if previous_frame && (previous_frame.strike? or previous_frame.spare?)
      previous_frame.points += self.ball_1 + (previous_frame.strike? ? self.get_ball_2 : 0)
      previous_frame.save
    end
  end
  
  def calculate_previous_previous_frame
    previous_frame = self.previous_frame
    previous_previous_frame = previous_frame.previous_frame if previous_frame
    if previous_previous_frame and previous_frame.strike? and previous_previous_frame.strike?
      previous_previous_frame.points += self.ball_1
      previous_previous_frame.save
    end    
  end
  
  def previous_frame
    game.frames.where(:number_frame => self.number_frame - 1).first
  end
  
  def score
    self.points
  end
  
  protected 
  
  def knocked_pins_should_not_exceed_pins
    return if self.errors.any?
    if self.is_last_frame? == false
      if self.ball_1 + self.get_ball_2 > 10
        errors.add(:wrong_pins_knocked, "Pins knocked by ball1 and ball2 could not exceed the total amount of pins")
      end
    end
  end
  
  def if_not_strike_ball_2_should_exist
    return if self.errors.any?
    if self.strike? == false and self.ball_2.nil?
      errors.add(:ball_2, "You need to throw the 2nd ball!")
    end
  end
  
  def third_ball_only_after_strike_or_spare
    return if self.errors.any?
    if self.is_last_frame?
      if self.ball_3 and self.strike? == false and self.spare? == false
        errors.add(:ball_3, "You can not throw the 3rd ball!")      
      end
      if self.ball_3.nil? and (self.strike? or self.spare?)
        errors.add(:ball_3, "You need to throw the 3rd ball!")      
      end
    end
  end
  
  def third_ball_only_in_last_frame
    return if self.errors.any?
    if self.ball_3 and self.is_last_frame? == false
      errors.add(:ball_3, "You can only throw the 3rd ball in the last frame")            
    end
  end
  
end
