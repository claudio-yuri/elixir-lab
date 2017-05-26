defmodule ImageFinder.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:fetch, source_file, target_directory}, state) do
    content = File.read! source_file
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    Regex.scan(regexp, content)
      |> Enum.map(&List.first/1)
      |> Enum.map(&(fetch_link &1, target_directory))
    {:noreply, state}
  end

  def fetch_link(link, target_directory) do
    GenServer.cast(ImageFinder.Fetcher, {:fetch, link, target_directory})
  end
end
