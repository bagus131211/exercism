defmodule Exercism.BankAccount do
  use GenServer
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.

    Example:

      iex(6)> account = Exercism.BankAccount.open
      #PID<0.160.0>

  """
  @spec open() :: account
  def open, do: ({:ok, pid} = GenServer.start_link(__MODULE__, 0); pid)

  @doc """
  Close the bank account, making it unavailable for further operations.

    Example:

      iex(7)> Exercism.BankAccount.close account
      :ok

  """
  @spec close(account) :: any
  def close(account), do: GenServer.cast(account, :close)

  @doc """
  Get the account's balance.

    Example:

      iex(8)> Exercism.BankAccount.balance account
      {:error, :account_closed}
      iex(2)> Exercism.BankAccount.balance open_account
      0

  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account), do: GenServer.call(account, :balance)

  @doc """
  Add the given amount to the account's balance.

    Example:

      iex(9)> Exercism.BankAccount.deposit account, -100
      {:error, :amount_must_be_positive}
      iex(10)> Exercism.BankAccount.deposit account, 100
      {:error, :account_closed}
      iex(3)> Exercism.BankAccount.deposit open_account, 300000
      :ok
      iex(4)> Exercism.BankAccount.balance open_account
      300000
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(_, amount) when amount < 0, do: {:error, :amount_must_be_positive}

  def deposit(account, amount), do: GenServer.call(account, {:deposit, amount})

  @doc """
  Subtract the given amount from the account's balance.

    Example:

      iex(11)> Exercism.BankAccount.withdraw account, -2000
      {:error, :amount_must_be_positive}
      iex(12)> Exercism.BankAccount.withdraw account, 3000
      {:error, :account_closed}
      iex(5)> Exercism.BankAccount.withdraw open_account, 1_000_000
      {:error, :not_enough_balance}
      iex(6)> Exercism.BankAccount.withdraw open_account, 100_000
      :ok
      iex(7)> Exercism.BankAccount.balance open_account
      200000

  """
  @spec withdraw(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(_, amount) when amount < 0, do: {:error, :amount_must_be_positive}

  def withdraw(account, amount), do: GenServer.call(account, {:withdraw, amount})

  # Implementations

  @impl true
  def init(balance), do: {:ok, %{balance: balance, closed: false}}

  @impl true
  def handle_cast(:close, state), do: {:noreply, %{state | closed: true}}

  @impl true
  def handle_call(_, _from, %{closed: true} = state), do: {:reply, {:error, :account_closed}, state}

  def handle_call(:balance, _from, %{balance: balance} = state), do: {:reply, balance, state}

  def handle_call({:deposit, amount}, _from, %{balance: balance} = state), do: {:reply, :ok, %{state | balance: balance + amount}}

  def handle_call({:withdraw, amount}, _from, %{balance: balance} = state) when balance < amount, do: {:reply, {:error, :not_enough_balance}, state}

  def handle_call({:withdraw, amount}, _from, %{balance: balance} = state), do: {:reply, :ok, %{state | balance: balance - amount}}
end
