defmodule ImageFinder.Fetcher.Supervisor do
    use Supervisor

    def start_link(name) do
        Supervisor.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        # Supervisor.start_child(ImageFinder.Fetcher.Supervisor, worker(ImageFinder.Fetcher, [ImageFinder.Fetcher], id: make_ref)  )

        supervise([worker(ImageFinder.Fetcher, [ImageFinder.Fetcher], id: make_ref, restart: :transient)], strategy: :one_for_one)
    end
end