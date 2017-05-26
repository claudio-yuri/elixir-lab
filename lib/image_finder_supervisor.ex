defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # inciar supervisores
    # ImageFinder.Worker.Supervisor.start_link
    # ImageFinder.Fetcher.Supervisor.start_link
    # ImageFinder.Downloader.Supervisor.start_link

    #Supervisor.start_child(ImageFinder.Worker.Supervisor, worker(ImageFinder.Worker, [ImageFinder.Worker], id: make_ref)  )
    #Supervisor.start_child(ImageFinder.Fetcher.Supervisor, worker(ImageFinder.Fetcher, [ImageFinder.Fetcher], id: make_ref)  )
    #Supervisor.start_child(ImageFinder.Downloader.Supervisor, worker(ImageFinder.Downloader, [ImageFinder.Downloader], id: make_ref)  )
    #children = [worker(ImageFinder.Worker, [ImageFinder.Worker]),
    #            worker(ImageFinder.Fetcher, [ImageFinder.Fetcher]),
    #            worker(ImageFinder.Downloader, [ImageFinder.Downloader])
    #          ]

    supervise([
      supervisor(ImageFinder.Worker.Supervisor, [ImageFinder.Worker.Supervisor]),
      supervisor(ImageFinder.Fetcher.Supervisor, [ImageFinder.Fetcher.Supervisor]),
      supervisor(ImageFinder.Downloader.Supervisor, [ImageFinder.Downloader.Supervisor])
    ], strategy: :one_for_one)
  end
end
