defmodule WebHook.Test do
  def start(), do: DBA.install
  def stop(), do: DBA.uninstall
end

ExUnit.start()
