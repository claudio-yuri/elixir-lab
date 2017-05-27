defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    supervise([
      supervisor(ImageFinder.Worker.Supervisor, [ImageFinder.Worker.Supervisor], restart: :permanent),
      supervisor(ImageFinder.Fetcher.Supervisor, [ImageFinder.Fetcher.Supervisor], restart: :permanent),
      supervisor(ImageFinder.Downloader.Supervisor, [ImageFinder.Downloader.Supervisor], restart: :permanent)
    ], strategy: :one_for_one)
  end
end
