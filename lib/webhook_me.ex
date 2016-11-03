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

  def start(_,[:prod]) do
    base_address = Application.get_env(:webhook_me, :base_address)
    token = Application.get_env(:nadia, :token)
    hook = "#{base_address}/#{token}/hook"
    TelegramBot.Utils.set_webhook(hook, &TelegramHook.entry_point/1)
  end

  def start(_,[:dev]) do
    Logger.info("Setting up polling")
    TelegramBot.Utils.polling(&TelegramHook.entry_point/1)
    {:ok, self}
  end
end
