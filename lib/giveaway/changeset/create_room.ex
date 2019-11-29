defmodule Giveaway.Changeset.CreateRoom do
  defstruct [:room_name]

  @format_error "Room name may only contain alphanumeric characters and underscore."

  def changeset(room, params \\ %{}) do
    {types, permitted} = types()

    {room, types}
    |> Ecto.Changeset.cast(params, permitted)
    |> Ecto.Changeset.validate_required(:room_name)
    |> Ecto.Changeset.validate_format(:room_name, ~r/^[a-zA-Z0-9_]+$/, message: @format_error)
  end

  defp types() do
    types = %{room_name: :string}
    permitted = Map.keys(types)

    {types, permitted}
  end
end
