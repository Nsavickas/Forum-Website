module PostsHelper  
  def get_score (likeable_id, likeable_type)
    klass = Object.const_get likeable_type
    @entry = klass.find_by_id(likeable_id)
     
    score = 0
    @entry.likes.each do |like|
      score += 1
    end
    return score
  end
  
  def find_like (likeable_id, likeable_type)
    klass = Object.const_get likeable_type
    @entry = klass.find_by_id(likeable_id)
    
    @entry.likes.each do |like|
      if like.user == current_user
        return like
      end
    end
  end
  
  
  def user_has_liked_entry (likeable_id, likeable_type)
    klass = Object.const_get likeable_type
    @entry = klass.find_by_id(likeable_id)
    
    @entry.likes.each do |like|
      if like.user == current_user
        return true
      end
    end
    return false
  end
end
