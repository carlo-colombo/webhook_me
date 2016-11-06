defmodule WebhookMe.Router.Webhook.V1   do
  use Maru.Router

  def coder do
    Hashids.new([salt: Application.get_env(:webhook_me, :hashids_salt),
                min_len: 10])
  end

  @default_message """
  The webhook have been called, see /start for customizing this message
  """

  def encode(chat_id), do: Hashids.encode(coder, chat_id)

  def generate_url(chat_id) do
    base_address = Application.get_env(:webhook_me, :base_address)
    "#{base_address}/v1/wh/#{encode(chat_id)}"
  end

  def start_message(chat_id) do
    hashids = encode(chat_id)
    url = generate_url(chat_id)
    """
    Welcome to *WebhookMe bot*

    This bot allow to setup a webhook that will send a message to this chat.

    webhookId: `#{hashids}`
    baseUrl: `#{url}`

    How to call it

    *GET requests*
    #{url}/get
    Params:
    `message`
    `msg`

    If both are present `message` take precedence over `msg`, if none a default message is sent.

    Eg.
    `GET #{url}/get?message=A%20message`
    `GET #{url}/get?msg=A%20message`

    *POST requests*
    Is also possible to make post request to the following url

    #{url}/post

    The body should be json containing a `message` or `msg` property. Message take precedence over msg.

    Eg.
    ```
    curl -X POST '#{url}/post' --data '{"msg": "a message"}' --header "Content-Type:application/json"
    ```
    """
  end

  version "v1"

  namespace :wh do
    route_param :hashids do
      namespace :get do
        params do
          optional :message, type: String
          optional :msg, type: String
        end
        get do
          json conn, send_message(params)
        end
      end
      namespace :post do
        post do
          body = conn.body_params
          json conn, send_message(params[:hashids], body)
        end
      end
    end
  end


  def send_message(hashids, %{"message" => message}) do
    send_message([hashids: hashids, message: message])
  end
  def send_message(hashids, %{"msg" => message}) do
    send_message([hashids: hashids, message: message])
  end
  def send_message(params) do
    hashids = params[:hashids]
    message = params[:message] || params[:msg] || @default_message

    {:ok, [chat_id]} = Hashids.decode(coder, hashids)
    {:ok, res} = Nadia.send_message(chat_id, message)
    res
  end
end
