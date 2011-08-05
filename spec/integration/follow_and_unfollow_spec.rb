require 'spec_helper'

describe "follow and unfollow" do
  
  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @followee = Factory(:user, :email => Factory.next(:email))
  end
  
  describe "follow" do
    
    it "should follow a user" do
      lambda do
        visit user_path(@followee)
        click_button("Follow")
        response.should have_tag("input[value=?]", "Unfollow")
      end.should change(@user.following, :count).by(1)
    end
    
    it "should show the followees microposts" do
      @follower = Factory(:user, :email => Factory.next(:email))
      # create a micropost for the user and log out
      post = Factory(:micropost, :user => @followee)
      visit root_path
      fill_in :micropost_content, :with => post.content
      click_button
      click_link "Sign out"
      # sign in with follower
      integration_sign_in(@follower)
      # follow user
      visit user_path(@user)
      click_button("Follow")
      # check that the user´s micropost is present
      visit root_path
      response.should have_tag("span.content", post.content)
    end
  end
  
  describe "unfollow" do
    
    it "should unfollow a user" do
      visit user_path(@followee)
      click_button("Follow")
      lambda do
        click_button("Unfollow")
        response.should have_tag("input[value=?]", "Follow")
      end.should change(@user.following, :count).by(-1)
    end
    
    it "should not show the unfollowees microposts" do
      @follower = Factory(:user, :email => Factory.next(:email))
      # create a micropost for the user and log out
      post = Factory(:micropost, :user => @followee)
      visit root_path
      fill_in :micropost_content, :with => post.content
      click_button
      click_link "Sign out"
      # sign in with follower
      integration_sign_in(@follower)
      # follow and unfollow user
      visit user_path(@user)
      click_button("Follow")
      click_button("Unfollow")
      # check that the user´s micropost is not present
      visit root_path
      response.should_not have_tag("span.content", post.content)
    end
  end
end
