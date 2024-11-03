defmodule Exercism.BridCount do
  def today(list)

  def today([head | _]), do: head

  def today(_), do: nil

  def increment_day_count(list)

  def increment_day_count([head | tail]), do: [head + 1 | tail]

  def increment_day_count(_), do: [1]

  def has_day_without_birds?([]), do: false

  def has_day_without_birds?([0 | _]), do: true

  def has_day_without_birds?([_ | tail]), do: has_day_without_birds?(tail)

  def total(list, acc \\ 0)

  def total([], acc), do: acc

  def total([head | tail], acc), do: total(tail, acc + head)

  def busy_days(list)

  def busy_days([]), do: 0

  def busy_days([head | tail]), do:
  (case head, do: (h when h >= 5 -> 1 + busy_days(tail); _ -> busy_days(tail)))
end
