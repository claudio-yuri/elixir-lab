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
        #HTTPotion.get(url).body |> save(targetdir)
        GenServer.cast(ImageFinder.Downloader, {:get, url, targetdir, self})
        {:noreply, state}
    end

    def handle_cast({:file, bytes, targetdir}, state) do
        save(bytes, targetdir)
        {:noreply, state}
    end        

    # helpers
    def digest(body) do
        :crypto.hash(:md5 , body) |> Base.encode16()
    end

    def save(body, directory) do
        pepe = :rand.uniform(1000)
        File.write! "#{directory}/#{pepe}", body
    end
end