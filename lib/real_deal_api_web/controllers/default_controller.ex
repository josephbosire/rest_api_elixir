defmodule RealDealApiWeb.DefaultController do
  use RealDealApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Hello, we are live -  #{Mix.env()}"})
  end
end
