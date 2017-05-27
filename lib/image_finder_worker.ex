defmodule ImageFinder.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  Reads each line in streaming mode
  """
  def handle_cast({:fetch, source_file, target_directory}, state) do
    File.stream!(source_file)
        |> Stream.map((&process_line(&1, target_directory)))
        |> Stream.run
    {:noreply, state}
  end

  @doc """
  Makes a request to the fetcher with the file url
  """
  defp fetch_link(link, target_directory) do
    GenServer.cast(ImageFinder.Fetcher, {:fetch, link, target_directory})
  end

  @doc """
  Extracts a list of image urls from the given string
  """
  defp process_line(line, target_directory) do
    Regex.scan(~r/http(s?)\:.*?\.(png|jpg|gif)/, line)
        |> Enum.to_list
        |> List.flatten
        |> Enum.filter(&(String.length(&1)> 10)) #avoids false matches
        |> Enum.map(&(fetch_link &1, target_directory))
  end

  @doc """
  Debug method
  """
  def by_line(file) do
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    File.stream!(file)
        #|> Stream.map(&(IO.inspect(&1)))
        |> Stream.map((&Regex.scan(regexp, &1)))
        |> Enum.to_list
        #|> Enum.map(&(length(&1) > 0))
  end
  @doc """
  Debug method
  """
  def de_una(source_file) do
    content = File.read! source_file
    regexp = ~r/http(s?)\:.*?\.(png|jpg|gif)/
    Regex.scan(regexp, content)
      |> Enum.map(&List.first/1)
      |> IO.puts
  end
end
