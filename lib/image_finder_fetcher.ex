defmodule ImageFinder.Fetcher do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        {:ok, %{}}
    end

    # callbacks
    def handle_cast({:fetch, url, targetdir}, state) do
        GenServer.cast(ImageFinder.Downloader, {:get, url, targetdir, self})
        {:noreply, state}
    end

    def handle_cast({:file, name, ext, bytes, targetdir}, state) do
        filename = name <> Integer.to_string(:rand.uniform(1000)) <> "." <> ext
        File.write! "#{targetdir}/#{filename}", bytes
        {:noreply, state}
    end        

    # helpers
    def digest(body) do
        :crypto.hash(:md5 , body) |> Base.encode16()
    end
end