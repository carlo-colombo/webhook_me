defmodule WebhookMe.Router do
  use Maru.Router

  @coder Hashids.new([
                     salt: "that's the salt",
                     min_len: 10
                   ])

    def encode(chat_id), do: Hashids.encode(@coder, chat_id)

    namespace :wh do
      route_param :hashids do
        params do
          requires :message, type: String
        end
        get do
          json conn, send_message(params)
        end
      end
    end

    def send_message(params) do
      hashids = params[:hashids]
      {:ok, [chat_id]} = Hashids.decode(@coder, hashids)
      {:ok, res} = Nadia.send_message(chat_id, params[:message] )
      res
    end

    # route_param :token do
    #   namespace :hook do
    #   #start
    #   end
    # end

    # def polling(offset \\ 0) do
    #   try do
    #     {:ok, updates } = Nadia.get_updates([{:offset, offset}])
    #     update_id = for update <- updates do
    #       entry_point(update)
    #       update.update_id
    #     end |> List.last

    #     offset = if update_id == nil do
    #       offset
    #     else
    #       update_id + 1
    #     end

    #     :timer.sleep(2000)
    #     spawn(fn  -> polling(offset) end)
    #   catch _->nil end
    # end
end
