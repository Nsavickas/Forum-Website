module FriendshipsHelper
  #takes an array of Friendships + 'current_user' and returns the 'current_user's' friends
  def getFriends(friendships, user_id)
    friends = []
    friendships.each do |f|
      friends.append(f.getFriend(user_id))
    end
    return friends 
  end

end
