defmodule WebhookMe do
	use Maru.Router
	require Logger

	before do
		plug Plug.Logger
		plug Plug.Parsers,
		pass: ["*/*"],
		json_decoder: Poison,
		parsers: [:urlencoded, :json, :multipart]
	end

	mount WebhookMe.Router.Webhook.V1
	mount WebhookMe.Router.TelegramHook

	def start(_,_) do
		Logger.info("Setting up polling")
		WebhookMe.Router.TelegramHook.polling()
		{:ok, self}
	end
end
