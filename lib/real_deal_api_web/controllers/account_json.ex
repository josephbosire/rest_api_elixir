defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account
  alias RealDealApiWeb.UserJSON

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      hashed_password: account.hashed_password,
      user: maybe_add_user_profile(account)
    }
  end

  defp maybe_add_user_profile(%Account{user: %Ecto.Association.NotLoaded{}}), do: nil

  defp maybe_add_user_profile(%Account{} = account) do
    UserJSON.data(account.user)
  end

  def account_token(%{account: account, token: token}) do
    %{
      data: %{
        id: account.id,
        email: account.email,
        token: token
      }
    }
  end
end
