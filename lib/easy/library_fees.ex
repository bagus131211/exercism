defmodule Exercism.LibraryFees do

  @spec datetime_from_string(String.t()) :: NaiveDateTime.t()
  def datetime_from_string(string), do: string |> NaiveDateTime.from_iso8601!

  @spec before_noon?(NaiveDateTime.t()) :: boolean()
  def before_noon?(datetime) when is_struct(datetime, NaiveDateTime), do: datetime.hour < 12

  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime), do:
    checkout_datetime
    |> (&case before_noon?(&1), do: (true -> NaiveDateTime.add(&1, 28, :day); _ -> NaiveDateTime.add(&1, 29, :day))).()
    |> NaiveDateTime.to_date()

  @spec days_late(Date.t(), NaiveDateTime.t()) :: non_neg_integer()
  def days_late(planned_return_date, actual_return_datetime), do:
    actual_return_datetime
    |> NaiveDateTime.to_date
    |> (&Date.diff(&1, planned_return_date)).()
    |> max(0)

  @spec monday?(NaiveDateTime.t() | Date.t()) :: boolean()
  def monday?(datetime), do: datetime |> Calendar.strftime("%A") === "Monday"

  @spec calculate_late_fee(String.t(), String.t(), pos_integer()) :: non_neg_integer()
  def calculate_late_fee(checkout, return, rate), do:
    checkout
    |> datetime_from_string
    |> return_date
    |> days_late(return |> datetime_from_string)
    |> (&case monday?(return |> datetime_from_string), do: (true -> div(&1 * rate, 2); _ -> &1 * rate)).()
end
