defmodule ImageFinder.Worker.Supervisor do
    use Supervisor

    def start_link(name) do
        Supervisor.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        # Supervisor.start_child(ImageFinder.Worker.Supervisor, worker(ImageFinder.Worker, [ImageFinder.Worker], id: make_ref)  )

        supervise([worker(ImageFinder.Worker, [ImageFinder.Worker], id: make_ref, restart: :transient)], strategy: :one_for_one)
    end
end