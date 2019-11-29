defmodule Giveaway.Changeset.CreateRoom do
  defstruct [:room_name]

  def changeset(room, params \\ %{}) do
    {types, permitted} = types()

    {room, types}
    |> Ecto.Changeset.cast(params, permitted)
    |> Ecto.Changeset.validate_required(:room_name)
  end

  defp types() do
    types = %{room_name: :string}
    permitted = Map.keys(types)

    {types, permitted}
  end
end
