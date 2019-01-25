defmodule GroupCollect.DBView do
  require Logger
  alias GroupCollect.Repo

  def create_view_from_query(query, view_name) do
    {table_query, term} = Repo.to_sql(:all, query)

    query = """
    CREATE VIEW #{view_name} AS #{table_query}
    """

    try do
      {:ok, Ecto.Adapters.SQL.query!(Repo, query, term)}
    rescue
      e in Postgrex.Error ->
        Logger.warn("create_view_from_query/2 failed. #{e.postgres.message} (#{e.postgres.code})")
        raise e
    end
  end

  def drop_view(view_name) do
    query = """
    DROP VIEW #{view_name}
    """

    try do
      {:ok, Ecto.Adapters.SQL.query!(Repo, query, [])}
    rescue
      e in Postgrex.Error ->
        Logger.warn("create_group_view/0 failed. #{e.postgres.message} (#{e.postgres.code})")
    end
  end
end
