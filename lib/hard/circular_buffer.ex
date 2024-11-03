defmodule Exercism.CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  use GenServer

  @doc """
  Create a new buffer of a given capacity

    ## Example:

      iex(1)> {:ok, buf} = Exercism.CircularBuffer.new 1
      {:ok, #PID<0.149.0>}

      iex(93)> {:ok, buf2} = Exercism.CircularBuffer.new 2
      {:ok, #PID<0.296.0>}

  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) when is_integer(capacity) and capacity > 0, do: GenServer.start_link(__MODULE__, capacity)

  @doc """
  Read the oldest entry in the buffer, fail if it is empty

    ## Example:

      iex(2)> Exercism.CircularBuffer.read buf
      {:error, :empty}

      iex(38)> Exercism.CircularBuffer.read buf
      {:ok, 1}

      iex(88)> Exercism.CircularBuffer.read buf
      {:ok, 1}
      iex(89)> Exercism.CircularBuffer.read buf     # cannot read 2 times
      {:error, :empty}

      iex(97)> Exercism.CircularBuffer.read buf2
      {:ok, 1}
      iex(98)> Exercism.CircularBuffer.read buf2    # read is order by written
      {:ok, 2}

  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer), do: GenServer.call(buffer, :read)

  @doc """
  Write a new item in the buffer, fail if is full

    ## Example:

      iex(35)> Exercism.CircularBuffer.write buf, 1
      :ok

      iex(94)> Exercism.CircularBuffer.write buf2, 1
      :ok

      iex(95)> Exercism.CircularBuffer.write buf2, 2
      :ok

      iex(101)> Exercism.CircularBuffer.write buf, 1
      :ok
      iex(102)> Exercism.CircularBuffer.write buf, 1
      {:error, :full}


      iex(104)> Exercism.CircularBuffer.write buf, 1
      :ok
      iex(105)> Exercism.CircularBuffer.read buf
      {:ok, 1}
      iex(106)> Exercism.CircularBuffer.write buf, 2    # read free up space for another write
      :ok
      iex(107)> Exercism.CircularBuffer.read buf
      {:ok, 2}

  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item), do: GenServer.call(buffer, {:write, item})

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full

    ## Example:

      iex(117)> Exercism.CircularBuffer.write buf2, 1
      :ok
      iex(118)> Exercism.CircularBuffer.write buf2, 2
      :ok
      iex(119)> Exercism.CircularBuffer.overwrite buf2, 3
      :ok
      iex(120)> Exercism.CircularBuffer.read buf2
      {:ok, 2}
      iex(121)> Exercism.CircularBuffer.read buf2
      {:ok, 3}

  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item), do: GenServer.call(buffer, {:overwrite, item})

  @doc """
  Clear the buffer

    ## Example:

      iex(122)> Exercism.CircularBuffer.clear buf2
      :ok

  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer), do: GenServer.call(buffer, :clear)

  # Server implementations

  def init(capacity), do: {:ok, %{capacity: capacity, buffer: [], size: 0}}

  def handle_call(:read, _from, %{size: 0} = state), do: {:reply, {:error, :empty}, state}

  def handle_call(:read, _from, %{buffer: [head | tail], size: size} = state), do:
    {:reply, {:ok, head}, %{state | buffer: tail, size: size - 1}}

  def handle_call({:write, item}, _from, %{buffer: buffer, size: size, capacity: capacity} = state), do: (
    if size <= capacity - 1 do
      {:reply, :ok, %{state | buffer: List.insert_at(buffer, length(buffer), item), size: size + 1}}
    else
      {:reply, {:error, :full}, state}
    end
  )

  def handle_call({:overwrite, item}, _from, %{buffer: [_head | tail], size: size, capacity: capacity} = state), do: (
    if size <= capacity - 1 do
      handle_call({:write, item}, self(), state)
    else
      {:reply, :ok, %{state | buffer: tail ++ [item]}}
    end
  )

  def handle_call(:clear, _from, state), do: {:reply, :ok, %{state | buffer: [], size: 0}}
end
