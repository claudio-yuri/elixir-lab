defmodule ImageFinder.Downloader do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end

    def init(:ok) do
        Process.flag(:trap_exit, true)
        {:ok, %{}}
    end

    def get_pid do
        self()
    end

    @doc """
    Handles a download requests
    Gets the contents of the given url and issues a reply to te requester
    """
    def handle_cast({:get, url, targetdir, reply_to}, state) do
        # try do
            #HTTPotion.get(url).body |> reply(targetdir, reply_to)
        # rescue
            # :conn_failed, _ -> {:EXIT, self(), :conn_failed}
            # e in RuntimeError -> {:EXIT, self(), e}
            # e -> GenServer.cast({:EXIT, self(), :cant_download}
        # end
        # will try to get the image contents 3 times
        # if it fails, will raise an exception
        download(url, targetdir, reply_to, 3)
         
        {:noreply, state}
    end

    @doc """
    Whent the times count reaches 0, we must raise an exception
    """
    defp download(_, _, _, 0) do
        raise {:EXIT, "fallo loco"}
    end
    
    @doc """
    gets the image contents.
    if it fails, will try again
    """
    defp download(url, targetdir, reply_to, times) do
        response = HTTPotion.get(url)
        case HTTPotion.Response.success? response do
            true ->
                reply(response.body, targetdir, reply_to)
            false ->
                download(url, targetdir, reply_to, times - 1)
        end
    end

    @doc """
    Sends the image to the requester
    """
    defp reply(bytes, targetdir, reply_to) do
        GenServer.cast(reply_to, {:file, bytes, targetdir})
    end    
end