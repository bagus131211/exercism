defmodule Exercism.TakeANumber do
  @spec start :: pid()
  def start, do: spawn(__MODULE__, :loop, [0])

  @spec loop(integer()) :: :ok
  def loop(state) do
    receive do
      {:report_state, sender_pid} ->
        state |> (&send(sender_pid, &1)).() |> loop
      {:take_a_number, sender_pid} ->
        state + 1 |> (&send(sender_pid, &1)).() |> loop
      :stop -> :ok
      _ -> state |> loop
    end
  end
end
