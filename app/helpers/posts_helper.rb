module PostsHelper
  def get_score (likeable_id, likeable_type)
    klass = Object.const_get(likeable_type)
    obj = klass.find_by_id(likeable_id)
    return obj.likes.count
  end

  def find_like (likeable_id, likeable_type)
    klass = Object.const_get(likeable_type)
    obj = klass.find_by_id(likeable_id)

    obj.likes.each do |like|
      if like.user == current_user
        return like
      end
    end
  end


  def user_has_liked_entry (likeable_id, likeable_type)
    klass = Object.const_get(likeable_type)
    obj = klass.find_by_id(likeable_id)

    obj.likes.each do |like|
      if like.user == current_user
        return true
      end
    end
    return false
  end
end
