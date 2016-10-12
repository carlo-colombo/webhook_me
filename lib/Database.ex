use Amnesia

defmodule DBA do
  def install do
    Amnesia.Schema.create
    Amnesia.start
    DB.create()
    DB.wait
  end
  def install_disk do
    Amnesia.Schema.create
    Amnesia.start
    DB.create(disk: [node])
    DB.wait
  end
  def uninstall do
    Amnesia.start
    DB.destroy
    Amnesia.stop
    Amnesia.Schema.destroy
  end
end

defdatabase DB do
  deftable WebHook, [:chat_id, :counter, :disabled], type: :set do
    #    @type t :: %Message{user_id: integer, content: String.t}

    def new(chat_id) do
      %WebHook{chat_id: chat_id, counter: 0, disabled: false}
      |> WebHook.write!

      Hashids.encode(hashid, chat_id)
    end

    def find(id) do
      {:ok, [chat_id]} = Hashids.decode(hashid, id)
      WebHook.read(chat_id)
    end

    def hashid do
      Hashids.new([
        salt: "123",
        min_len: 4,
      ])
    end
  end
end
