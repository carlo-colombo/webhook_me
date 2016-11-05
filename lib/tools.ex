defmodule TelegramBot.Utils do
  require Logger

  @doc """
  Convert a map with string as key to a map using atom as key. If the atom 
  does not already exists raise an exception

  iex> TelegramBot.Utils.to_string_map(%{})
  %{}

  iex> TelegramBot.Utils.to_string_map(%{a_key_1234: 4})
  %{"a_key_1234" => 4}

  iex> TelegramBot.Utils.to_string_map(%{a: %{b: 42}})
  %{"a" => %{"b" => 42}}
  """
  def to_string_map(val) when not is_map(val), do: val
  def to_string_map(map) do
    for key <- Map.keys(map), into: %{} do
      {Atom.to_string(key), to_string_map(Map.get(map, key))}
    end
  end

  def polling(offset \\ 0, dispatch) do
    try do
      {:ok, updates } = Nadia.get_updates([{:offset, offset}])
      offset = Enum.reduce(updates, offset, fn (update, _) ->
        update
        |> to_string_map
        |> dispatch.()

        update.update_id + 1
      end)

      :timer.sleep(2000)

      spawn(fn  -> polling(offset, dispatch) end)
    catch _->nil end
  end

  def set_webhook(hook, dispatch_fallback \\ fn -> nil end) do
    case Nadia.set_webhook([{:url, hook}]) do
      {:error, error} ->
        Nadia.set_webhook([{:url, ""}])
        Logger.warn "Cannot set up webhook #{hook}: #{error.reason}, removing actual webhook - setting up a polling"
        polling(dispatch_fallback)
      resp ->
        Logger.debug "Set up webhook #{hook}: #{inspect(resp)}"
    end
    {:ok, self}
  end
end
