defmodule Exercism.Frequency do
  @moduledoc """
  Count the frequency of letters in texts using parallel computation.

  Parallelism is about doing things in parallel that can also be done sequentially.
  A common example is counting the frequency of letters.
  Employ parallelism to calculate the total frequency of each letter in a list of texts.
  """

  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

    Example:

      iex(19)> Exercism.Frequency.frequency ["ggh", "hhi"]
      %{"g" => 2, "h" => 3, "i" => 1}

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers \\ 1), do:
    texts
     |> Enum.join
     |> String.downcase
     |> String.replace(~r/[\s!?;,-:.0-9'()\\"]/, "")
     |> String.graphemes
     |> Stream.chunk_every(max(div(length(texts), workers), 1))
     |> Task.async_stream(&frequencies_worker/1, max_concurrency: workers, timeout: 5000)
     |> Enum.reduce(%{}, &merge_maps/2)

  defp frequencies_worker(chars), do: Enum.reduce(chars, %{}, &update/2)

  defp update(char, acc), do: Map.update(acc, char, 1, & &1 + 1)

  defp merge_maps({:ok, result}, acc), do: Map.merge(acc, result, fn _key, val1, val2 -> val1 + val2 end)
end
