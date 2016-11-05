defmodule WebhookMe.Router.TelegramHook do
  use Maru.Router
  alias WebhookMe.Router.Webhook.V1

  route_param :token do
    namespace :hook do
      post do
        resp = conn.body_params
               |> entry_point
               |> get_resp

        json conn, resp
      end
    end
  end

  @as_markdown [{:parse_mode, "Markdown"}]

  defp dispatch(chat_id, "/start" <> _) do
    Nadia.send_message(chat_id, V1.start_message(chat_id), @as_markdown)
  end

  defp dispatch(chat_id, _) do
    Nadia.send_message(chat_id, "Only supported command is /start")
  end

  def entry_point(%{"message" => %{"chat" => %{"id" => chat_id}, "text" => message}} ) do
    dispatch(chat_id, message)
  end

  defp get_resp({_, resp}), do: resp
  defp get_resp(_), do: %{}
end
