defmodule RealDealApiWeb.Auth.Plugs.SetAccount do
  alias RealDealApi.Accounts
  import Plug.Conn
  import RealDealApiWeb.ErrorHelpers, only: [render_error: 3]

  def init(_options) do
  end

  # Checks if session is already loaded and skips validation
  def call(%{assigns: %{account: _account}} = conn, _options), do: conn

  def call(conn, _options) do
    account_id = get_session(conn, :account_id)
    if is_nil(account_id), do: render_error(conn, 401, "401.json")
    account = Accounts.get_account(account_id)

    cond do
      account_id && account -> assign(conn, :account, account)
      true -> assign(conn, :account, nil)
    end
  end
end
