defmodule WebhookMe.Router.Webhook.V1   do
  use Maru.Router

  @coder Hashids.new([
                     salt: "that's the salt",
                     min_len: 10
                   ])
    @default_message """
    The webhook have been called, see /start for customizing this message
    """

    def encode(chat_id), do: Hashids.encode(@coder, chat_id)

    def generate_url(chat_id) do
      base_address = Application.get_env(:webhook_me, :base_address)
      "#{base_address}/v1/wh/#{encode(chat_id)}?message=Test%20WebhookMe"
    end

    version "v1"

    namespace :wh do
      route_param :hashids do
        params do
          optional :message, type: String
          optional :msg, type: String
          exactly_one_of [:message, :msg]
        end
        get do
          json conn, send_message(params)
        end
      end
    end

    def send_message(params) do
      hashids = params[:hashids]
      message = params[:message] || params[:msg] || @default_message

      {:ok, [chat_id]} = Hashids.decode(@coder, hashids)
      {:ok, res} = Nadia.send_message(chat_id, message)
      res
    end
end
