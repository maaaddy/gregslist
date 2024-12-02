defmodule GregslistWeb.ItemHTML do
  use GregslistWeb, :html

  embed_templates "item_html/*"

  @doc """
  Renders a test form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def item_form(assigns)
end
