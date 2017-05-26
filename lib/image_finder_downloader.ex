defmodule ImageFinder.Downloader do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        {:ok, %{}}
    end

    def handle_cast({:get, url, targetdir, reply_to}, state) do
        HTTPotion.get(url).body |> reply(targetdir, reply_to)
        {:noreply, state}
    end

    def reply(bytes, targetdir, reply_to) do
        GenServer.cast(reply_to, {:file, bytes, targetdir})
    end    
end