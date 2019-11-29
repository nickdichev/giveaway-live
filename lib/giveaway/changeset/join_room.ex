defmodule Giveaway.Changeset.JoinRoom do
  defstruct [:name]

  def changeset(room, params \\ %{}) do
    {types, permitted} = types()

    {room, types}
    |> Ecto.Changeset.cast(params, permitted)
    |> Ecto.Changeset.validate_required(:name)
  end

  defp types() do
    types = %{name: :string}
    permitted = Map.keys(types)

    {types, permitted}
  end
end
