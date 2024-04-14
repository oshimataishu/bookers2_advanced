class GroupMailer < ApplicationMailer
  def send_group_mail(mail_title, mail_body, group_users, group)
    @group = group
    @mail_title = mail_title
    @mail_body = mail_body
    mail bcc: group_users.pluck(:email), subject: mail_title
  end
end
