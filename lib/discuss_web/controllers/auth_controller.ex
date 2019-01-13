defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.User
  alias DiscussWeb.Router.Helpers, as: Route

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider} = _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider}
    changeset = User.changeset(%User{}, user_params)

    singin(conn, changeset)
  end

  defp singin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Route.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:info, "Error signing in")
        |> redirect(to: Route.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Discuss.Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Discuss.Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Route.topic_path(conn, :index))
  end
end
