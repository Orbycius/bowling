require 'spec_helper'

describe "frames/show" do
  before(:each) do
    @frame = assign(:frame, stub_model(Frame,
      :game_id => 1,
      :ball_1 => 2,
      :ball_2 => 3,
      :ball_3 => 4,
      :points => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
  end
end
