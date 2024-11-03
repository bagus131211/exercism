defmodule Exercism.RPNCalculationInspection do

  def start_reliability_check(calculator, input), do:
    %{input: input, pid: spawn_link(fn -> calculator.(input) end)}

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    trap = Process.flag(:trap_exit, true)
    inputs
    |> Enum.map(&start_reliability_check(calculator, &1))
    |> Enum.reduce(%{}, &await_reliability_check_result/2)
    |> tap(fn _ -> Process.flag(:trap_exit, trap) end)
  end

  def correctness_check(calculator, inputs), do:
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Task.await_many(100)
end
