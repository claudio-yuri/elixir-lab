defmodule ImageFinder.Downloader do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        Process.flag(:trap_exit, true)
        {:ok, %{}}
    end

    @doc """
    Handles a download requests
    Gets the contents of the given url and issues a reply to te requester
    """
    def handle_cast({:get, url, targetdir, reply_to}, state) do
        IO.inspect self()

        # try do
            HTTPotion.get(url).body |> reply(targetdir, reply_to)
        # rescue
            # :conn_failed, _ -> {:EXIT, self(), :conn_failed}
            # e in RuntimeError -> {:EXIT, self(), e}
            # e -> GenServer.cast({:EXIT, self(), :cant_download}
        # end
        {:noreply, state}
    end

    def reply(bytes, targetdir, reply_to) do
        GenServer.cast(reply_to, {:file, bytes, targetdir})
    end    
end