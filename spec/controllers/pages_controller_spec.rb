require 'spec_helper'

describe PagesController do
  integrate_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_tag("title", @base_title + " | Home")
    end
    
    describe "microposts" do
      before(:each) do
        @attr = {
          :name => "Example User",
          :email => "user@example.com",
          :password => "foobar",
          :password_confirmation => "foobar"
        }
        @user = User.create(@attr)
        test_sign_in @user
      end
      
      describe "counter" do
        before(:each) do
          @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
        end
      
        it "should count correctly" do
          get :home
          response.should have_tag("span.microposts", /1/)
          @user.microposts.first.destroy
          get :home
          response.should have_tag("span.microposts", /0/)
        end
      
        it "should pluralize correctly" do
          get :home
          response.should have_tag("span.microposts", /micropost\z/i)
          @user.microposts.first.destroy
          get :home
          response.should have_tag("span.microposts", /microposts/i)
        end 
      end
    
      it "should paginate the microposts" do
        31.times do
          Factory(:micropost, :user => @user, :content => "post")
        end
        get :home
        response.should have_tag("div.pagination")
        response.should have_tag("span", "&laquo; Previous")
        response.should have_tag("span", "1")
        response.should have_tag("a[href=?]", "/?page=2", "2")
        response.should have_tag("a[href=?]", "/?page=2", "Next &raquo;")
      end
      
      it "should not show delete links of other users" do
        other_user = User.create!(@attr.merge({:email => "user2@example.com"}))
        mp = Factory(:micropost, :user => other_user, :content => "post")
        get :home
        response.should_not have_tag("a", "delete")
      end
      
      it "should wrap long words" do
        Factory(:micropost, :user => @user, :content => "#{'a' * 40}")
        get :home
        response.should have_tag("span.content", /&#8203/)
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_tag("title", @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_tag("title", @base_title + " | About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_tag("title", @base_title + " | Help")
    end
  end
end