defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    
    # inciar supervisores
    Supervisor.start_child(ImageFinder.Worker.Supervisor, worker(ImageFinder.Worker, [ImageFinder.Worker], id: make_ref)  )
    Supervisor.start_child(ImageFinder.Fetcher.Supervisor, worker(ImageFinder.Fetcher, [ImageFinder.Fetcher], id: make_ref)  )
    Supervisor.start_child(ImageFinder.Downloader.Supervisor, worker(ImageFinder.Downloader, [ImageFinder.Downloader], id: make_ref)  )
    #children = [worker(ImageFinder.Worker, [ImageFinder.Worker]),
    #            worker(ImageFinder.Fetcher, [ImageFinder.Fetcher]),
    #            worker(ImageFinder.Downloader, [ImageFinder.Downloader])
    #          ]

    supervise([], strategy: :one_for_one)
  end
end
