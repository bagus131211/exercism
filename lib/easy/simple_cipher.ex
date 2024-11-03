defmodule Exercism.SimpleCipher do
  @alphabet Enum.to_list(~c(abcdefghijklmnopqrstuvwxyz))
  @moduledoc """
  Instructions
    Implement a simple shift cipher like Caesar and a more secure substitution cipher.

  Step 1
    "If he had anything confidential to say, he wrote it in cipher, that is, by so changing the order of the letters of the alphabet,
    that not a word could be made out. If anyone wishes to decipher these, and get at their meaning,
    he must substitute the fourth letter of the alphabet, namely D, for A, and so with the others." —Suetonius, Life of Julius Caesar

    Ciphers are very straight-forward algorithms that allow us to render text less readable while still allowing easy deciphering.
    They are vulnerable to many forms of cryptanalysis, but Caesar was lucky that his enemies were not cryptanalysts.

    The Caesar Cipher was used for some messages from Julius Caesar that were sent afield.
    Now Caesar knew that the cipher wasn't very good, but he had one ally in that respect: almost nobody could read well.
    So even being a couple letters off was sufficient so that people couldn't recognize the few words that they did know.

    Your task is to create a simple shift cipher like the Caesar Cipher. This image is a great example of the Caesar Cipher:

    Caesar Cipher

    For example:

      Giving "iamapandabear" as input to the encode function returns the cipher "ldpdsdqgdehdu".
      Obscure enough to keep our message secret in transit.

      When "ldpdsdqgdehdu" is put into the decode function it would return the original "iamapandabear" letting your friend read your
      original message.

  Step 2
    Shift ciphers quickly cease to be useful when the opposition commander figures them out.
    So instead, let's try using a substitution cipher.
    Try amending the code to allow us to specify a key and use that for the shift distance.

    Here's an example:

      Given the key "aaaaaaaaaaaaaaaaaa", encoding the string "iamapandabear" would return the original "iamapandabear".

      Given the key "ddddddddddddddddd", encoding our string "iamapandabear" would return the obscured "ldpdsdqgdehdu"

    In the example above, we've set a = 0 for the key value. So when the plaintext is added to the key,
    we end up with the same message coming out. So "aaaa" is not an ideal key.
    But if we set the key to "dddd", we would get the same thing as the Caesar Cipher.

  Step 3
    The weakest link in any cipher is the human being.
    Let's make your substitution cipher a little more fault tolerant by providing a source of randomness and
    ensuring that the key contains only lowercase letters.

    If someone doesn't submit a key at all, generate a truly random key of at least 100 lowercase characters in length.

  Extensions
    Shift ciphers work by making the text slightly odd, but are vulnerable to frequency analysis. Substitution ciphers help that, but are still very vulnerable when the key is short or if spaces are preserved. Later on you'll see one solution to this problem in the exercise "crypto-square".

    If you want to go farther in this field, the questions begin to be about how we can exchange keys in a secure way. Take a look at Diffie-Hellman on Wikipedia for one of the first implementations of this scheme.
  """

  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, ""), do: encode(plaintext, generate_key(100))

  def encode(plaintext, key), do:
    plaintext
     |> to_charlist
     |> Enum.zip(key |> to_charlist |> Stream.cycle)
     |> Enum.map(&shift/1)
     |> to_string

  defp shift({plain_char, key_char}), do: shift_char(plain_char, key_char - ?a)

  defp shift_char(char, shift) when char in ?a..?z, do: @alphabet |> Enum.at(rem((char - ?a) + shift, 26))

  defp shift_char(char, _shift), do: <<char>>

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key), do:
    ciphertext
     |> to_charlist
     |> Enum.zip(key |> to_charlist |> Stream.cycle)
     |> Enum.map(&shift_backward/1)
     |> to_string

  defp shift_backward({cipher_char, key_char}), do: shift_char(cipher_char, -(key_char - ?a))

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length), do: (for _ <- 1..length, do: Enum.random(@alphabet)) |> to_string
end
