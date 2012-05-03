require 'spec_helper'

describe "FriendlyFowardings" do
#  describe "GET /friendly_fowardings" do
#    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get friendly_fowardings_path
#      response.status.should be(200)
#    end
#  end
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test automatically follows the redirect to the signin page.
    fill_in :email,     :with => user.email
    fill_in :password,  :with => user.password
    click_button
    # The test followa the redirect again, this time users/edit.
    response.should render_template('users/edit')
  end
end
