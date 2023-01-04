class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  before_create :confirm_participant

  after_create_commit do
    update_parent_room
    broadcast_append_to room
  end

  def confirm_participant
    is_participant = Participant.where(user_id: self.user.id, room_id: self.room.id).first
    throw :abort unless is_participant
  end

  def update_parent_room
    room.update(last_message_at: Time.now)
  end
end
