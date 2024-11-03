defmodule Exercism.Year do
  @moduledoc """
  A leap year (in the Gregorian calendar) occurs:

    In every year that is evenly divisible by 4.
    Unless the year is evenly divisible by 100, in which case it's only a leap year if the year is also evenly divisible by 400.
  Some examples:

    1997 was not a leap year as it's not divisible by 4.
    1900 was not a leap year as it's not divisible by 400.
    2000 was a leap year!
  """

  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year), do:
    (case {rem(year, 400), rem(year, 100), rem(year, 4)}, do:
      (
        {0, _, _} -> true
        {_, 0, _} -> false
        {_, _, 0} -> true
        _ -> false
      )
    )
end
