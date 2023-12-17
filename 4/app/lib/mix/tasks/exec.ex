defmodule Mix.Tasks.Exec do
  use Mix.Task

  def run(args) do
    App.main(args)
  end
end
