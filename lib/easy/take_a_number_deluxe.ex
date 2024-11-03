defmodule Exercism.TakeANumberDeluxe do
  alias Exercism.TakeANumberDeluxe.{State}
  use GenServer

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg), do: GenServer.start_link(__MODULE__, init_arg)

  @spec report_state(pid()) :: State.t()
  def report_state(machine), do: GenServer.call(machine, :report_state)

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine), do: GenServer.call(machine, :queue_new_number)

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil), do:
   GenServer.call(machine, {:serve_next_queued_number, priority_number})

  @spec reset_state(pid()) :: :ok
  def reset_state(machine), do: GenServer.cast(machine, :reset)

  # implementations
  @impl GenServer
  def init(opts), do:
    (case State.new(opts[:min_number], opts[:max_number], opts[:auto_shutdown_timeout] || :infinity), do:
      ({:ok, state} -> {:ok, state, state.auto_shutdown_timeout};
       {:error, error} -> {:stop, error}))

  @impl GenServer
  def handle_call(:report_state, _from, state), do: {:reply, state, state, state.auto_shutdown_timeout}

  @impl GenServer
  def handle_call(:queue_new_number, _from, state), do:
    (case State.queue_new_number(state), do:
      ({:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, new_state.auto_shutdown_timeout};
      {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}))

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    (case State.serve_next_queued_number(state, priority_number), do:
      ({:ok, next_number, new_state} -> {:reply, {:ok, next_number}, new_state, new_state.auto_shutdown_timeout};
       {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}))
  end

  @impl GenServer
  def handle_cast(:reset, state), do:
  (case State.new(state.min_number, state.max_number, state.auto_shutdown_timeout), do:
    ({:ok, new_state} -> {:noreply, new_state, new_state.auto_shutdown_timeout}))

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}
end
