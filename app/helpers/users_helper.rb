module UsersHelper

  def avatar_for(user)
    image_tag("cat_1.jpeg", alt: user.name, class: "avatar")
  end

end
