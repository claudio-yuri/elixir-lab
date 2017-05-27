defmodule ImageFinder.Downloader.Supervisor do
    use Supervisor
    
    def start_link(name) do
        Supervisor.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        # Supervisor.start_child(ImageFinder.Downloader.Supervisor, worker(ImageFinder.Downloader, [ImageFinder.Downloader], id: make_ref)  )
        Process.flag(:trap_exit, true)
        supervise(
            [worker(
                ImageFinder.Downloader, [ImageFinder.Downloader], 
                id: make_ref(),
                restart: :transient
                )], 
            strategy: :one_for_one, 
            maxrestarts: 3)
   end
end