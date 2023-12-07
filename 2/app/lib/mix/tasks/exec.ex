defmodule Mix.Tasks.Exec do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    App.mojon()
  end
end
