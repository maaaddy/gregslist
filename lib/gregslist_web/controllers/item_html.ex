defmodule GregslistWeb.ItemHTML do
  use GregslistWeb, :html
  use GregslistWeb, :live_view
  alias Gregslist.Galleries
  alias Gregslist.Repo

  embed_templates "item_html/*"

  @doc """
  Renders a test form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user, :map, required: true

  def item_form(assigns)
end
