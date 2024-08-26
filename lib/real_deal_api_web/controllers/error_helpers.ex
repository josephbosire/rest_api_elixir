defmodule RealDealApiWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  def render_error(conn, status, view) do
    conn
    |> Plug.Conn.put_status(status)
    |> Phoenix.Controller.put_view(json: RealDealApiWeb.ErrorJSON)
    |> Phoenix.Controller.render(view)
    |> Plug.Conn.halt()
  end
end
