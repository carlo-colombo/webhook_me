defmodule TelegramBot.Utils do

  @doc """
  Convert a map with string as key to a map using atom as key. If the atom 
  does not already exists raise an exception

  iex> TelegramBot.Utils.to_atom_map(%{})
  %{}

  iex> TelegramBot.Utils.to_atom_map(%{"non_existing_key_1238i" => 4})
  ** (ArgumentError) argument error

  iex> :a_key_1234
  iex> TelegramBot.Utils.to_atom_map(%{"a_key_1234" => 4})
  %{a_key_1234: 4}

  """
  def to_atom_map(map) do
    for {key, val} <- map, into: %{} do
      {String.to_existing_atom(key), val}
    end
  end

  def polling(offset \\ 0, dispatch) do
    try do
      {:ok, updates } = Nadia.get_updates([{:offset, offset}])
      update_id = for update <- updates do
        dispatch.(update)
        update.update_id
      end |> List.last

      offset = if update_id == nil do
        offset
      else
        update_id + 1
      end

      :timer.sleep(2000)
      spawn(fn  -> polling(offset, dispatch) end)
    catch _->nil end
  end
end