defmodule RealDealApiWeb.Auth.Plugs.AuthorizeAccount do
  alias RealDealApi.Accounts
  import RealDealApiWeb.ErrorHelpers, only: [render_error: 3]

  def init(_options) do
  end

  def call(
        %{params: %{"id" => account_id}, assigns: %{account: %{id: current_sesssion_account_id}}} =
          conn,
        _options
      ) do
    account = Accounts.get_account!(account_id)

    if current_sesssion_account_id === account.id do
      conn
    else
      render_error(conn, 403, "forbidden.json")
    end
  end

  # if required parameters are missing and you somehow ended up here then we forbid you from moving forward
  def call(conn, _options), do: render_error(conn, 403, "forbidden.json")
end
