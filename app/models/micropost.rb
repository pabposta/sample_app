# == Schema Information
# Schema version: 20110601131847
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  attr_reader :characters_left
  
  belongs_to :user
  
  validates_presence_of :content, :user_id
  validates_length_of   :content, :maximum => 140
  
  default_scope :order => 'created_at DESC'
  
  #def self.from_users_followed_by(user)
  #  followed_ids = user.following.map(&:id)
  #  all(:conditions => ["user_id IN (#{followed_ids}) OR user_id = ?", user])
  #end
  
  def characters_left
    140
  end
  
  # Return microposts from the users being followed by the given user.
  named_scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      { :conditions => ["user_id IN (#{followed_ids}) OR user_id = :user_id",
                        { :user_id => user }] }
    end
end
