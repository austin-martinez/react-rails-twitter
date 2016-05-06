class Tweet < ActiveRecord::Base
  belongs_to :user

  def as_json(options={})
    super(methods: [:name, :gravatar])
  end

  def name
    user.display_name
  end

  def gravatar
    user.gravatar
  end

  def self.stream_for(user_id)
    joins(:user)
    .where('users.id = :user_id OR users.id IN (
      select user_id from followers
      where followed_by = :user_id
      )', user_id: user_id)
    .order(created_at: :desc)
    .all
  end
end
