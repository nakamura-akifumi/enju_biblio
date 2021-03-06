require 'spec_helper'

describe "realizes/edit" do
  fixtures :realize_types

  before(:each) do
    @realize = assign(:realize, stub_model(Realize,
      :expression_id => 1,
      :patron_id => 1
    ))
    @realize_types = RealizeType.all
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders the edit realize form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => realizes_path(@realize), :method => "post" do
      assert_select "input#realize_expression_id", :name => "realize[expression_id]"
      assert_select "input#realize_patron_id", :name => "realize[patron_id]"
    end
  end
end
