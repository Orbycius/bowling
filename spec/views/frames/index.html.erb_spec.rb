require 'spec_helper'

describe "frames/index" do
  before(:each) do
    assign(:frames, [
      stub_model(Frame,
        :game_id => 1,
        :ball_1 => 2,
        :ball_2 => 3,
        :ball_3 => 4,
        :points => 5
      ),
      stub_model(Frame,
        :game_id => 1,
        :ball_1 => 2,
        :ball_2 => 3,
        :ball_3 => 4,
        :points => 5
      )
    ])
  end

  it "renders a list of frames" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
