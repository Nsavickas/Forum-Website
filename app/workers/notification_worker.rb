class NotificationWorker
  include Sidekiq::Worker
  #sidekiq_options queue: :high_priority, retry: 5, backtrace: true
  
  def perform(notifiable_id, notifiable_type, prefix)
    title="New #{prefix}-#{notifiable_type}"
    
    if title == 'New Post-Like' || 'New Comment-Like'
      like = Like.find(notifiable_id)
      receiving_user = like.likeable.user
       
    elsif title == 'New Post-Comment'
      comment = Comment.find(notifiable_id)
      receiving_user = comment.post.user
          
    elsif title == 'New Request-Friendship'
      friendship = Friendship.find(notifiable_id)
      receiving_user = friendship.friended
      
    elsif title == 'New Accept-Friendship'
      friendship = Friendship.find(notifiable_id)
      receiving_user = friendship.friender
    end
    
    receiving_user.notifications.create(title: title, user_id: receiving_user.id, 
      notifiable_id: notifiable_id, notifiable_type: notifiable_type)
  end
end