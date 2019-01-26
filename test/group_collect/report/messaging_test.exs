defmodule GroupCollect.Report.MessagingTest do
  @moduledoc """
  All the tests are based on the csv fixture"
  """
  use GroupCollect.DataCase
  alias GroupCollect.Report.Messaging
  alias GroupCollect.Report.Import
  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.MessageSchema
  alias GroupCollect.Report.MessageLogSchema
  alias GroupCollect.Report.Filter

  @valid_params %Messaging{
    passenger_id: 370,
    media: "email",
    subject: "Subject",
    body: "Body"
  }

  @csv File.read!("test/support/fixtures/files/passenger_statuses.csv")

  setup do
    Import.from_csv(@csv)
  end

  test "log_entry/1 should write to the database" do
    assert {:ok, message} = Messaging.log_entry(@valid_params)
    assert message.media == "email"
    assert message.subject == "Subject"
    assert message.body == "Body"
    assert message.passenger_id == 370
  end

  test "deliver/1 for email media should send the email" do
    passenger = Repo.get(PassengerSchema, 370)

    assert %Bamboo.Email{
             assigns: %{},
             attachments: [],
             bcc: [],
             cc: [],
             from: {nil, "support@group_collect.com"},
             headers: %{},
             html_body: "Body",
             private: %{},
             subject: "Subject",
             text_body: "Body",
             to: [nil: "jeffrustic@gmail.com"]
           } = Messaging.deliver(passenger, @valid_params)
  end

  test "deliver/1 for internal message should write the message to the database" do
    passenger = Repo.get(PassengerSchema, 370)
    passenger_id = passenger.id

    assert {:ok,
            %MessageSchema{
              passenger_id: ^passenger_id,
              subject: "Subject",
              body: "Body"
            }} = Messaging.deliver(passenger, %{@valid_params | media: "internal_message"})
  end

  test "send/1 should send the message and log" do
    passenger = Repo.get(PassengerSchema, 370)

    assert :ok = Messaging.send(passenger, %{@valid_params | media: "internal_message"})

    assert [
             %MessageLogSchema{
               passenger_id: 370,
               subject: "Subject",
               media: "internal_message",
               body: "Body"
             }
           ] = Repo.all(MessageLogSchema)

    assert [
             %MessageSchema{
               passenger_id: 370,
               subject: "Subject",
               body: "Body"
             }
           ] = Repo.all(MessageSchema)
  end

  test "send_batch/1 should send the message to all the users in the filter" do
    scope = Filter.filter(%{"status" => "Cancelled"})
    assert :ok == Messaging.send_batch(scope, %{@valid_params | media: "internal_message"})

    assert [
             %GroupCollect.Report.MessageLogSchema{
               body: "Body",
               media: "internal_message",
               passenger_id: 385,
               subject: "Subject"
             },
             %GroupCollect.Report.MessageLogSchema{
               body: "Body",
               media: "internal_message",
               passenger_id: 374,
               subject: "Subject"
             }
           ] = Repo.all(MessageLogSchema)

    assert [
             %GroupCollect.Report.MessageSchema{
               body: "Body",
               passenger_id: 385,
               subject: "Subject"
             },
             %GroupCollect.Report.MessageSchema{
               body: "Body",
               passenger_id: 374,
               subject: "Subject"
             }
           ] = Repo.all(MessageSchema)
  end
end
