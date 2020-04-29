module SessionsHelper

  # Осуществаяет вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # Запоминает пользователя в постоянном сеансе
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Возвращает текущего вошедшего пользователя (если есть)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #if params[:session][:remember_me] == '0' 
        #  forget(user)
        #end
        @current_user = user
      end
    end
  end

  # Возвращает true, если пользователь зарегистрирован, иначе возвращает false
  def logged_in?
    !current_user.nil?
  end

  # Закрывает постоянный сеанс
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Осуществляет выход текущего пользователя
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
