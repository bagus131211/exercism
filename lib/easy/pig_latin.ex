defmodule Exercism.PigLatin do
  @moduledoc """
  Your task is to translate text from English to Pig Latin. The translation is defined using four rules, which look at the pattern of vowels and consonants at the beginning of a word. These rules look at each word's use of vowels and consonants:

  vowels: the letters a, e, i, o, and u
  consonants: the other 21 letters of the English alphabet
  Rule 1
  If a word begins with a vowel, or starts with "xr" or "yt", add an "ay" sound to the end of the word.

  For example:

  "apple" -> "appleay" (starts with vowel)
  "xray" -> "xrayay" (starts with "xr")
  "yttria" -> "yttriaay" (starts with "yt")
  Rule 2
  If a word begins with one or more consonants, first move those consonants to the end of the word and then add an "ay" sound to the end of the word.

  For example:

  "pig" -> "igp" -> "igpay" (starts with single consonant)
  "chair" -> "airch" -> "airchay" (starts with multiple consonants)
  "thrush" -> "ushthr" -> "ushthray" (starts with multiple consonants)
  Rule 3
  If a word starts with zero or more consonants followed by "qu", first move those consonants (if any) and the "qu" part to the end of the word, and then add an "ay" sound to the end of the word.

  For example:

  "quick" -> "ickqu" -> "ickquay" (starts with "qu", no preceding consonants)
  "square" -> "aresqu" -> "aresquay" (starts with one consonant followed by "qu")
  Rule 4
  If a word starts with one or more consonants followed by "y", first move the consonants preceding the "y"to the end of the word, and then add an "ay" sound to the end of the word.

  Some examples:

  "my" -> "ym" -> "ymay" (starts with single consonant followed by "y")
  "rhythm" -> "ythmrh" -> "ythmrhay" (starts with multiple consonants followed by "y")
  """
  @vowel ~w(a i u e o xr yt)

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase), do: phrase |> String.split |> Enum.map(&rule/1) |> Enum.join(" ")

  defp rule(phrase), do:
    (cond do
      start_with_vowel_sound?(phrase) -> phrase <> "ay"
      start_with_consonants_qu?(phrase) -> move_consonants_followed_qu(phrase) <> "ay"
      start_with_consonant_y?(phrase) -> move_consonants_followed_y(phrase) <> "ay"
      true -> move_consonants(phrase) <> "ay"
    end)

  # case 1
  defp start_with_vowel_sound?(phrase), do: phrase |> String.starts_with?(@vowel)

  # case 2
  defp move_consonants(phrase), do: Regex.replace(~r/^([^aiueo]+)(.*)/, phrase, "\\2\\1")

  # case 3
  defp start_with_consonants_qu?(phrase), do: Regex.match?(~r/^[^aiueo]*qu/, phrase)

  defp move_consonants_followed_qu(phrase), do: Regex.replace(~r/^([^aiueo]*qu)(.*)/, phrase, "\\2\\1")

  # case 4
  defp start_with_consonant_y?(phrase), do: Regex.match?(~r/^[^aiueo]+y/, phrase)

  defp move_consonants_followed_y(phrase), do: Regex.replace(~r/^([^aiueo]+)(y.*)/, phrase, "\\2\\1")
end
