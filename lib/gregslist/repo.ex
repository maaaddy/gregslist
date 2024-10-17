defmodule Gregslist.Repo do
  use Ecto.Repo,
    otp_app: :gregslist,
    adapter: Ecto.Adapters.SQLite3
end
