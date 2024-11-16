defmodule GregslistWeb.UserProfileLive.Index do
  use GregslistWeb, :live_view

  alias Gregslist.Accounts

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, assign(socket, user: user, editing_about_me: false)}
  end

  def handle_event("edit_about_me", _, socket) do
    {:noreply, assign(socket, editing_about_me: true)}
  end

  def handle_event("save_about_me", %{"about_me" => about_me}, socket) do
    user = socket.assigns.current_user

    case Accounts.update_about_me(user, %{"about_me" => about_me}) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(user: user, editing_about_me: false)
         |> put_flash(:info, "Your About Me has been updated!")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was an error updating your About Me.")
         |> assign(user: user, editing_about_me: true)}
    end
  end

  def handle_event("cancel_edit", _, socket) do
    {:noreply, assign(socket, editing_about_me: false)}
  end
end
