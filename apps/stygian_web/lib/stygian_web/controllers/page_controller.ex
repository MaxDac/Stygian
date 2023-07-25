defmodule StygianWeb.PageController do
  use StygianWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> put_layout(html: {StygianWeb.Layouts, :login})
    |> render(:home)
  end
end
