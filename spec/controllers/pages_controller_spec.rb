require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title="Ruby on Rails Tutorial Sample App"
  end
  describe "GET 'home'" do
    describe"when not signed in" do
      before(:each) do
        get :home
      end
      it "should be successful" do
        response.should be_success
      end
      it "should have the right title" do
        response.should have_selector("title", :content => @base_title + " | Home")
      end
    end
    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email), :name => Factory.next(:name))
        other_user.follow!(@user)
      end
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
      describe "right pagination" do
        before(:each) do
       #   @user = test_sign_in(Factory(:user))
          35.times { Factory(:micropost, :user => @user, :content => "test") }
        end
        it "should paginate microposts" do
          get :home
          response.should have_selector("div.pagination")
          response.should have_selector("span.disabled", :content => "Previous")
          response.should have_selector("a", :href => "/?page=2")
          response.should have_selector("a", :href => "/?page=2", :content => "Next")  
        end
      end
      describe "Display delete link" do
        before(:each) do
        #Login a valid user
      #    @user = test_sign_in(Factory(:user))
        #Create another user
          @attr = { :name => "New user", :email => "user@example.com", 
                    :password => "foobar", :password_confirmation => "foobar"}
          @other_user = Factory(:user, @attr)
        end
        describe "failure" do
          before(:each) do
            @other_micropost = Factory(:micropost, :user => @other_user)
            30.times { Factory(:micropost, :user => @other_user) }
          end
          it "should not have a delete link for another user" do
            get :home, :id => @other_user
            response.should_not have_selector('td > a[data-method ="delete"]', :content => "delete")
          end
        end
        describe "success" do
          before(:each) do
            @micropost = Factory(:micropost, :user => @user)
            30.times { Factory(:micropost, :user => @user) }
          end
          it "should have a delete link for a current user" do
            get :home, :id => @user
            response.should have_selector('td > a[data-method="delete"]', :content => "delete")
          end
        end
      end      
    end
  end
  describe "GET 'contact'" do
    it "should be successful" do
      get :contact
      response.should be_success
    end
    it "should have the right title" do
      get :contact
      response.should have_selector("title", :content => @base_title + " | Contact")
    end     
  end
  describe "GET 'about'" do
    it "should be successful" do
      get :about
      response.should be_success
    end
    it "should have the right title" do
      get :about
      response.should have_selector("title", :content => @base_title + " | About")
      
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get :help
      response.should be_success
    end
    it "should have the right title" do
      get :help
      response.should have_selector("title", :content => @base_title + " | Help")
    end
  end

end
