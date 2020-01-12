defmodule Giveaway.Changeset.CreateRoom do
  defstruct [:room_name, :admin_password, :admin_password_confirmation]

  @format_error "Room name may only contain alphanumeric characters and underscore."

  def changeset(room, params \\ %{}) do
    {types, permitted} = types()

    {room, types}
    |> Ecto.Changeset.cast(params, permitted)
    |> Ecto.Changeset.validate_required(required())
    |> Ecto.Changeset.validate_confirmation(:admin_password,
      message: "does not match password",
      required: true
    )
    |> Ecto.Changeset.validate_format(:room_name, ~r/^[a-zA-Z0-9_]+$/, message: @format_error)
  end

  defp required(), do: %__MODULE__{} |> Map.from_struct() |> Map.keys()

  defp types() do
    types = %{
      room_name: :string,
      admin_password: :string,
      admin_password_confirmation: :string
    }

    permitted = Map.keys(types)

    {types, permitted}
  end
end
