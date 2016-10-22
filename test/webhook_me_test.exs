Code.require_file "./test_helper.exs", __DIR__

use DB
use Amnesia

defmodule WebhookMeTest do
  use ExUnit.Case
  doctest WebhookMe

  test "base test" do
    Amnesia.transaction do
      wh = %WebHook{chat_id: 12,
       counter: 0,
       disabled: false}
      WebHook.write(wh)
    end
  end

  test "creating a new hook return its hashid" do
    Amnesia.transaction do
      assert "LWOL" == WebHook.new(12)
    end
  end

  test "after creating a weebhook is foundable by its hashid" do
    wh = Amnesia.transaction do
      hi = WebHook.new(13)
      WebHook.lookup(hi)
      hi
    end
    IO.inspect wh
  end
end
