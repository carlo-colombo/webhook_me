defmodule WebhookMe do
    use Maru.Router
    require Logger
    alias WebhookMe.Router.TelegramHook

    before do
	plug Plug.Logger
	plug Plug.Parsers,
	pass: ["*/*"],
	json_decoder: Poison,
	parsers: [:urlencoded, :json, :multipart]
    end

    mount WebhookMe.Router.Webhook.V1
    mount WebhookMe.Router.TelegramHook

    def start(_,[:test]), do: {:ok, self}

    def start(_,[:dev]) do
	Logger.info("Setting up polling")
	TelegramBot.Utils.polling(&TelegramHook.entry_point/1)
	{:ok, self}
    end
end
