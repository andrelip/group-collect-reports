defmodule GroupCollect.Report.Messaging do
  defstruct [:passenger_id, :media, :subject, :body]

  alias GroupCollect.Report.PassengerSchema
  alias GroupCollect.Report.MessageSchema
  alias GroupCollect.Report.MessageLogSchema
  alias GroupCollect.Report.Messaging.Email
  alias GroupCollect.Repo
  import Ecto.Query

  def send_batch(filter_scope, %__MODULE__{} = params) do
    from(p in PassengerSchema, join: r in subquery(filter_scope), on: p.id == r.id, select: p)
    |> Repo.all()
    |> Enum.map(&{&1, %{params | passenger_id: &1.id}})
    |> Enum.each(fn {passenger, params} -> __MODULE__.send(passenger, params) end)
  end

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

  def deliver(passenger, %__MODULE__{media: "email"} = params) do
    email_params = %Email{
      subject: params.subject,
      body: params.body,
      to: passenger.email
    }

    Email.send_generic(email_params)
    |> GroupCollect.Mailer.deliver_now()
  end

  def deliver(passenger, %__MODULE__{media: "internal_message"} = params) do
    params
    |> Map.from_struct()
    |> MessageSchema.insert_changeset()
    |> Repo.insert()
  end

  def log_entry(params) do
    params
    |> Map.from_struct()
    |> MessageLogSchema.insert_changeset()
    |> Repo.insert()
  end
end
