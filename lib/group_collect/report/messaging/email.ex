defmodule GroupCollect.Report.Messaging.Email do
  @moduledoc """
  Formats the emails used in this context.

  This module only prepares the struct. Call GroupCollect.Mailer.deliver_now
  or GroupCollect.Mailer.deliver_later to effectively send the email.
  """

  defstruct [:subject, :body, :to]

  import Bamboo.Email

  @default_sender Application.get_env(:group_collect, GroupCollect.Mailer)[:default_from]

  @doc """
  Send any kind of email to the user.
  """
  def send_generic(%__MODULE__{subject: subject, body: body, to: to}) do
    new_email()
    |> to(to)
    |> from(@default_sender)
    |> subject(subject)
    |> html_body(body)
    |> text_body(body)
  end
end
