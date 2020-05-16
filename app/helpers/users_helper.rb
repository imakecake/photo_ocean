module UsersHelper

  # Вовращает аватар для указанного пользователя
  def avatar_for(user, options = { size: 190 })
    size = options[:size]
    image_tag("cat_1.jpeg", size: size, alt: user.name, class: "avatar")
  end

end
