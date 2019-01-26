defmodule GroupCollect.Report.Messaging do
  @moduledoc """
  Handles the message system for the report page

  It send both emails and internal messages
  """
  defstruct [:passenger_id, :media, :subject, :body]

  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.MessageSchema
  alias GroupCollect.Report.MessageLogSchema
  alias GroupCollect.Report.Messaging.Email
  alias GroupCollect.Repo
  import Ecto.Query

  @doc """
  Given a filter_scope for the passengers report it sends messages for all the users
  that matches that criteria.
  """
  def send_batch(filter_scope, %__MODULE__{} = params) do
    from(p in PassengerSchema, join: r in subquery(filter_scope), on: p.id == r.id, select: p)
    |> Repo.all()
    |> Enum.map(&{&1, %{params | passenger_id: &1.id}})
    |> Enum.each(fn {passenger, params} -> __MODULE__.send(passenger, params) end)
  end

  @doc """
  Delivers a message or email to the passenger based on the `media` attribute
  and logs the result.
  """
  def send(passenger, %__MODULE__{media: "email"} = params) do
    deliver(passenger, params)
    log_entry(params)
  end

  def send(passenger, %__MODULE__{media: "internal_message"} = params) do
    # TODO create a transaction
    with {:ok, _} <- deliver(passenger, params),
         {:ok, _} <- log_entry(params) do
      :ok
    end
  end

  @doc """
  Delivers a message or email to the passenger based on the `media` attribute.
  """
  def deliver(passenger, %__MODULE__{media: "email"} = params) do
    email_params = %Email{
      subject: params.subject,
      body: params.body,
      to: passenger.email
    }

    email_params
    |> Email.send_generic()
    |> GroupCollect.Mailer.deliver_now()
  end

  def deliver(_, %__MODULE__{media: "internal_message"} = params) do
    params
    |> Map.from_struct()
    |> MessageSchema.insert_changeset()
    |> Repo.insert()
  end

  @doc """
  Receives a %Messaging{} struct and log that info into the database.
  """
  def log_entry(params) do
    params
    |> Map.from_struct()
    |> MessageLogSchema.insert_changeset()
    |> Repo.insert()
  end
end
