class ShareNotificationMailer < ApplicationMailer

  def create_notification(object, recipient_email, sender_email)
    @object = object
    @recipient_email = recipient_email
    @sender_email = sender_email
    @object_count = object.class.count

    mail(to: @recipient_email,
         subject: "A new post for #{object.class} has been shared ")
  end
end
