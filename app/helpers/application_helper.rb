module ApplicationHelper

  #Возвращает полный заголовок на основе заголовка страницы.
  def full_title(page_titile = '')
    base_title = "Photo Ocean"
    if page_titile.empty?
      base_title
    else
      page_titile + " | " + base_title
    end
  end

end
