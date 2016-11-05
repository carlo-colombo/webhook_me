defmodule Mix.Tasks.DockerPush do
  use Mix.Task

  alias WebhookMe.Mixfile
  alias Mix.Tasks.Edib

  def run(_args) do
    Edib.run(["--hex", "--strip"])

    project = Enum.into(Mixfile.project, %{})

    for cmd <- commands(project)  do
      Mix.Shell.IO.cmd(cmd, [])
    end
  end

  defp commands(%{version: version}) do
    [
      "docker tag local/webhook_me:#{version} carlocolombo/webhook_me:latest",
      "docker tag local/webhook_me:#{version} carlocolombo/webhook_me:#{version}",
      "docker push carlocolombo/webhook_me:#{version}",
      "docker push carlocolombo/webhook_me:latest"
    ]
  end
end
