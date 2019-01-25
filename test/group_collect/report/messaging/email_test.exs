defmodule GroupCollect.Report.Messaging.EmailTest do
  use ExUnit.Case
  use Bamboo.Test
  alias GroupCollect.Report.Messaging.Email

  test "custom email" do
    email =
      Email.send_generic(%Email{
        to: "andrestephano@gmail.com",
        subject: "test subject",
        body: "I'm at body"
      })

    assert email.to == "andrestephano@gmail.com"
    assert email.subject =~ "test subject"
    assert email.html_body =~ "I'm at body"
    assert %Bamboo.Email{} = GroupCollect.Mailer.deliver_now(email)
  end
end
