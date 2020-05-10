class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com' # адрес от которого будут приходить письма?
  layout 'mailer' # макет шаблона
end
