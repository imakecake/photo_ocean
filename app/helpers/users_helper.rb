module UsersHelper

  # Вовращает аватар для указанного пользователя
  def avatar_for(user, options = { size: 190 })
  size = options[:size]
    if user.avatar.attached?
      image_tag(user.display_avatar, size: size, alt: user.name, class: "avatar")
    else
      image_tag("placeholders/user.svg", size: size, alt: user.name, class: "avatar")
    end
  end

end
