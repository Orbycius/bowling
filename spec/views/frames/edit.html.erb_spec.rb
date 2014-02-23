require 'spec_helper'

describe "frames/edit" do
  before(:each) do
    @frame = assign(:frame, stub_model(Frame,
      :game_id => 1,
      :ball_1 => 1,
      :ball_2 => 1,
      :ball_3 => 1,
      :points => 1
    ))
  end

  it "renders the edit frame form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", frame_path(@frame), "post" do
      assert_select "input#frame_game_id[name=?]", "frame[game_id]"
      assert_select "input#frame_ball_1[name=?]", "frame[ball_1]"
      assert_select "input#frame_ball_2[name=?]", "frame[ball_2]"
      assert_select "input#frame_ball_3[name=?]", "frame[ball_3]"
      assert_select "input#frame_points[name=?]", "frame[points]"
    end
  end
end
