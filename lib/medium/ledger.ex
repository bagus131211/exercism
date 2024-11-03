defmodule Exercism.Ledger do
  @doc """
  Format the given entries given a currency and locale

    Example:

      iex(23)> res = Exercism.Ledger.format_entries :usd, :nl_NL, [%{amount_in_cents: -1000, date: ~D[2015-01-01], description: "Buy present"}]
      "Datum      | Omschrijving              | Verandering  \n01-01-2015| Buy present               |     $ -10,00 \n"
      iex(24)> IO.puts(res)
      Datum      | Omschrijving              | Verandering
      01-01-2015 | Buy present               |     $ -10,00

      :ok

  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  # correcting the spec
  @spec format_entries(currency, locale, [entry]) :: String.t
  # instead of condition I change it into function guard
  def format_entries(_, locale, []), do: locale |> header

  def format_entries(currency, locale, entries) do
      entries = entries
        |> Enum.sort(fn a, b ->
          cond do
            a.date.day < b.date.day -> true
            a.date.day > b.date.day -> false
            a.description < b.description -> true
            a.description > b.description -> false
            true -> a.amount_in_cents <= b.amount_in_cents
          end
        end)
        |> Enum.map_join("\n", &format_entry(currency, locale, &1))

      (locale |> header) <> entries <> "\n"
    end

  defp format_entry(currency, locale, entry) do
    # separate date setter to function
    date = date(locale, entry.date.day, entry.date.month, entry.date.year)

    # separate number setter to function
    number = number(locale, entry.amount_in_cents)

    # separate amount setter to function
    amount = amount(locale, entry.amount_in_cents, currency, number) |> String.pad_leading(14, " ")

    #separate description settr to function
    description = description(entry.description, String.length(entry.description))

    date <> "|" <> description <> " |" <> amount
  end

  defp header(:en_US), do: "Date       | Description               | Change       \n"

  defp header(:nl_NL), do: "Datum      | Omschrijving              | Verandering  \n"

  defp stringify(number), do: number |> to_string |> String.pad_leading(2, "0")

  defp date(:en_US, day, month, year), do: stringify(month) <> "/" <> stringify(day) <> "/" <> stringify(year) <> " "

  defp date(_, day, month, year), do: stringify(day) <> "-" <> stringify(month) <> "-" <> stringify(year) <> " "

  defp decimal(amount_in_cents), do: amount_in_cents |> abs |> rem(100) |> stringify

  defp number(:en_US, amount_in_cents), do:
   amount_in_cents |> div(100) |> abs |> to_string |> String.replace(~r/(?<=\d)(?=(\d{3})+$)/, ",") |> then(&"#{&1}.#{decimal(amount_in_cents)}")

  defp number(_, amount_in_cents), do:
   amount_in_cents |> div(100) |> abs |> to_string |> String.replace(~r/(?<=\d)(?=(\d{3})+$)/, ".") |> then(&"#{&1},#{decimal(amount_in_cents)}")

  defp amount(:en_US, amount_in_cents, currency, number) when amount_in_cents >= 0, do: "  #{currency(currency)}#{number} "

  defp amount(:en_US, _, currency, number), do: " (#{currency(currency)}#{number})"

  defp amount(_, amount_in_cents, currency, number) when amount_in_cents >= 0, do: " #{currency(currency)} #{number} "

  defp amount(_, _, currency, number), do: " #{currency(currency)} -#{number} "

  defp currency(:eur), do: "€"

  defp currency(:usd), do: "$"

  defp description(description, length) when length > 26, do: " " <> String.slice(description, 0, 22) <> "..."

  defp description(description, _), do: " " <> String.pad_trailing(description, 25, " ")
end
