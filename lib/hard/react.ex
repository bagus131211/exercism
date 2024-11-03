defmodule Exercism.React do
  use GenServer

  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system

    ## Example:

      iex(2)> {:ok, cells} = Exercism.React.new([{:input, "input", 10}])
      {:ok, #PID<0.158.0>}

      {:ok, cells2} = Exercism.React.new([{:input, "input", 1}, {:output, "output", ["input"], fn a -> a + 1 end}])
      {:ok, #PID<0.251.0>}

      iex(21)> {:ok, cells3} = Exercism.React.new([{:input, "true", true}, {:input, "value", "value"}, {:output, "output", ["true", "value"],
      fn a, b -> if(a, do: b, else: "failure") end}])
      {:ok, #PID<0.252.0>}

      iex(23)> {:ok, cells4} = Exercism.React.new([{:input, "one", 1}, {:input, "two", 2}, {:output, "output", ["one", "two"],
      fn a, b -> a + b * 10 end}])
      {:ok, #PID<0.253.0>}

      {:ok, cells5} = Exercism.React.new([{:input, "input", 1}, {:output, "output", ["input"], fn a -> a + 1 end}])
      {:ok, #PID<0.254.0>}

      iex(33)> {:ok, cells6} = Exercism.React.new([{:input, "input", 1}, {:output, "times_two", ["input"], fn a -> a * 2 end}, {:output, "times_thirty",
      ["input"], fn a -> a * 30 end}, {:output, "output", ["times_two", "times_thirty"], fn a, b -> a + b end}])
      {:ok, #PID<0.271.0>}

      iex(75)> {:ok, cells7} = Exercism.React.new([{:input, "input", 1}, {:output, "output", ["input"], fn a  -> a + 1 end}])
      {:ok, #PID<0.402.0>}

      iex(110)> {:ok, cells8} = Exercism.React.new([{:input, "input", 1}, {:output, "output", ["input"], fn a -> if(a < 3, do: 111, else: 333) end}])
      {:ok, #PID<0.420.0>}

  """

  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells), do: GenServer.start_link(__MODULE__, cells)

  @doc """
  Return the value of an input or output cell

    ## Example:

      iex(3)> Exercism.React.get_value(cells, "input")
      10

      iex(20)> Exercism.React.get_value cells2, "output"
      2

      iex(22)> Exercism.React.get_value cells3, "output"
      "value"

      iex(24)> Exercism.React.get_value cells4, "output"
      21

      iex(34)> Exercism.React.get_value cells6, "output"
      32

  """

  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name), do: GenServer.call(cells, {:get_value, cell_name})

  @doc """
  Set the value of an input cell

    ## Example:

      iex(4)> Exercism.React.set_value(cells, "input", 55)
      :ok
      iex(5)> Exercism.React.get_value(cells, "input")
      55

      iex(30)> Exercism.React.set_value cells5, "input", 9
      :ok
      iex(31)> Exercism.React.get_value cells5, "output"
      10

      iex(64)> Exercism.React.set_value cells6, "input", 3
      :ok
      iex(65)> Exercism.React.get_value cells6, "output"
      96

  """

  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value), do: GenServer.cast(cells, {:set_value, cell_name, value})

  @doc """
  Add a callback to an output cell

    ## Example:

      iex(76)> me = self
      #PID<0.392.0>
      iex(77)> Exercism.React.add_callback(cells7, "output", "callback1", fn name, value -> send(me, {:callback, name, value}) end)
      :ok
      iex(78)> Exercism.React.set_value cells7, "input", 3
      :ok
      iex(80)> flush
      {:callback, "output", 4}
      :ok

      iex(112)> Exercism.React.add_callback(cells8, "output", "callback1", fn name, value -> send(me, {:callback, name, value}) end)
      :ok
      iex(113)> Exercism.React.set_value cells8, "input", 2
      :ok
      iex(114)> receive do
      ...(114)> {:callback, _, _} -> raise "Expected no callback"
      ...(114)> after
      ...(114)> 50 -> :ok
      ...(114)> end
      ** (RuntimeError) Expected no callback
          iex:115: (file)
      iex(114)> Exercism.React.set_value cells8, "input", 4
      :ok
      iex(115)> flush
      {:callback, "callback1", 333}
      :ok

  """

  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback), do: GenServer.cast(cells, {:add_callback, cell_name, callback_name, callback})

  @doc """
  Remove a callback from an output cell

    ## Example:

        iex(121)> {:ok, cells7} = Exercism.React.new([{:input, "input", 1}, {:output, "output", ["input"], fn a  -> a + 1 end}])
        {:ok, #PID<0.432.0>}
        iex(122)> me = self
        #PID<0.421.0>
        iex(123)> Exercism.React.add_callback(cells7, "output", "callback1", fn name, value -> send(me, {:callback, name, value}) end)
        :ok
        iex(124)> Exercism.React.add_callback(cells7, "output", "callback2", fn name, value -> send(me, {:callback, name, value}) end)
        :ok
        iex(125)> Exercism.React.remove_callback cells7, "ouput", "callback1"
        :ok
        iex(126)> Exercism.React.remove_callback cells7, "ouput", "callback1"
        :ok
        iex(127)> Exercism.React.remove_callback cells7, "ouput", "callback1"
        :ok
        iex(128)> Exercism.React.set_value cells7, "input", 2
        :ok
        iex(129)> receive do
        ...(129)> {:callback, "callback1", _} ->
        ...(129)> raise "Expected no callback"
        ...(129)> after
        ...(129)> 50 -> :ok
        ...(129)> end
        ** (RuntimeError) Expected no callback
            iex:131: (file)
        iex(129)> flush
        {:callback, "callback2", 3}
        :ok
  """

  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name), do: GenServer.cast(cells, {:remove_callback, cell_name, callback_name})

  # Server Callbacks

  def init(cells), do: {:ok, cells |> init_cells}

  def handle_call({:get_value, cell_name}, _from, state), do: {:reply, state.values[cell_name], state}

  def handle_cast({:set_value, cell_name, new_value}, state), do: {:noreply, update(cell_name, new_value, state)}

  def handle_cast({:add_callback, cell_name, callback_name, callback}, state), do:
    {:noreply, update_in(state[:callbacks][cell_name], fn callbacks ->
      Map.put(callbacks || %{}, callback_name, callback)
    end)}

  def handle_cast({:remove_callback, cell_name, callback_name}, state), do:
    {:noreply, update_in(state[:callbacks][cell_name], fn callbacks ->
      Map.delete(callbacks || %{}, callback_name)
    end)}

  defp init_cells(cells), do:
    cells
      |> Enum.reduce(%{values: %{}, dependencies: %{}, dependents: %{}, callbacks: %{}}, fn
        {:input, name, value}, acc -> acc |> put_in([:values, name], value)
        {:output, name, dependencies, func}, acc ->
          value = func |> apply(dependencies |> Enum.map(&acc.values[&1]))
          acc
            |> put_in([:values, name], value)
            |> put_in([:dependencies, name], {dependencies, func})
            |> update_dependents(name, dependencies)
          end)

  defp update_dependents(state, name, dependencies), do:
    Enum.reduce(dependencies, state, fn dep, acc ->
      dependents = Map.get(acc.dependents, dep, [])
      put_in(acc, [:dependents, dep], [name | dependents])
    end)

  defp update(cell_name, new_value, state), do: propagate(cell_name, put_in(state[:values][cell_name], new_value))

  defp propagate(cell_name, state) do
    dependents = Map.get(state.dependents, cell_name, [])
    new_state = Enum.reduce(dependents, state, fn dependent, acc ->
      case acc[:dependencies][dependent] do
        {dependencies, func} ->
          new_value = func |> apply(dependencies |> Enum.map(&acc.values[&1]))
          if acc[:values][dependent] !== new_value do
            acc |> Map.update!(:values, &Map.put(&1, dependent, new_value))
          else
            acc
          end
        nil ->
          acc
      end
    end)

    # Now, propagate changes for the updated state
    Enum.reduce(dependents, new_state, fn dependent, acc ->
      if acc.values[dependent] !== state.values[dependent] do
        callbacks(dependent, acc[:values][dependent], acc)
        propagate(dependent, acc)
      else
        acc
      end
    end)
  end

  defp callbacks(cell_name, value, state), do:
    (
      if callbacks = state.callbacks[cell_name], do:
      Enum.each(callbacks, fn {name, callback} ->
        callback.(name, value)
      end)
    state
    )
end
