defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApi.Users.User
  alias RealDealApi.Users
  alias RealDealApiWeb.Auth.Guardian
  alias RealDealApi.Accounts
  alias RealDealApi.Accounts.Account
  alias RealDealApiWeb.Auth.Plugs.AuthorizeAccount

  plug AuthorizeAccount when action in [:show, :update, :delete, :sign_out]
  action_fallback RealDealApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = _user} <- Users.create_user_with_account(account, account_params) do
      conn
      |> sign_in(%{
        "email" => account.email,
        "hashed_password" => account_params["hashed_password"]
      })
    end
  end

  def sign_in(conn, %{"email" => email, "hashed_password" => hashed_password}) do
    with {:ok, account, token} <- Guardian.authenticate(email, hashed_password) do
      conn
      |> put_session(:account_id, account.id)
      |> put_status(:ok)
      |> render(:account_token, %{account: account, token: token})
    end
  end

  def refresh_session(conn, _params) do
    old_token = Guardian.Plug.current_token(conn)

    with {:ok, claims} <- Guardian.decode_and_verify(old_token),
         {:ok, account} <- Guardian.resource_from_claims(claims),
         {:ok, _old, {new_token, _new_claims}} = Guardian.refresh(old_token) do
      conn
      |> put_session(:account_id, account.id)
      |> put_status(:ok)
      |> render(:account_token, %{account: account, token: new_token})
    end
  end

  def sign_out(conn, _params) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> clear_session()
    |> put_status(:ok)
    |> render(:account_token, %{account: account, token: nil})
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_full_account(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{
        "current_password" => current_password,
        "account" => account_params
      }) do
    case Guardian.validate_password?(current_password, conn.assigns.account.hashed_password) do
      true ->
        {:ok, %Account{} = account} =
          Accounts.update_account(conn.assigns.account, account_params)

        render(conn, :show, account: account)

      false ->
        {:error, :unauthorized}
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
