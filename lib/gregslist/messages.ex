defmodule Gregslist.Messages do
  import Ecto.Query, warn: false
  alias Gregslist.Repo
  alias Gregslist.Messages.Message

  def get_messages(sender_id, receiver_id) do
    Repo.all(
      from m in Message,
      where:
        (m.sender_id == ^sender_id and m.receiver_id == ^receiver_id) or
          (m.sender_id == ^receiver_id and m.receiver_id == ^sender_id),
      order_by: [asc: m.timestamp]
    )
  end
  def load_messages(sender_id, receiver_id) do
    from(m in __MODULE__,
      where: (m.sender_id == ^sender_id and m.receiver_id == ^receiver_id) or
             (m.sender_id == ^receiver_id and m.receiver_id == ^sender_id),
      order_by: [asc: m.timestamp]
    )
    |> Repo.all()
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
