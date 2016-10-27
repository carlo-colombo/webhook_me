defmodule WebhookMe.Router.TelegramHook do
	use Maru.Router
	alias WebhookMe.Router.Webhook.V1

	# route_param :token do
	# 	namespace :hook do
	# 		post do
	# 			conn.body_params
	# 			|> entry_point
	# 			|> get_resp()

	# json(conn, %{})
	# 		end
	# 	end
	# end

	defp get_resp({_, resp}), do: resp
	defp get_resp(t), do: %{}

	def entry_point(%{"message" => %{"chat" => %{"id" => chat_id}, "text" => text }} ) do
		Nadia.send_message(chat_id, V1.generate_url(chat_id))
	end
	def entry_point(%{message: %{chat: %{id: chat_id}, text: text }} ) do
		Nadia.send_message(chat_id, V1.generate_url(chat_id))
	end


	def polling(offset \\ 0) do
		try do
			{:ok, updates } = Nadia.get_updates([{:offset, offset}])
			update_id = for update <- updates do
				entry_point(update)
				update.update_id
			end |> List.last

			offset = if update_id == nil do
				offset
			else
				update_id + 1
			end

			:timer.sleep(2000)
			spawn(fn  -> polling(offset) end)
		catch _->nil end
	end
end
