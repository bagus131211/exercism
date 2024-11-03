defmodule Exercism.PaintByNumber do
  @spec palette_bit_size(non_neg_integer()) :: pos_integer()
  def palette_bit_size(color_count), do:
  1
  |> Stream.iterate(&(&1 + 1))
  |> Enum.find(&(Integer.pow(2, &1) >= color_count))

  @spec empty_picture :: <<>>
  def empty_picture, do: <<>>

  @spec test_picture :: bitstring()
  def test_picture, do: <<0::2, 1::2, 2::2, 3::2>>

  @spec prepend_pixel(bitstring(), non_neg_integer(), non_neg_integer()) :: bitstring()
  def prepend_pixel(picture, color_count, pixel_color_index), do:
  color_count |> palette_bit_size |> (&<<pixel_color_index::size(&1), picture::bitstring>>).()

  @spec get_first_pixel(bitstring(), non_neg_integer()) :: non_neg_integer() | nil
  def get_first_pixel(picture, color_count), do:
  color_count |> palette_bit_size |> (&case picture, do: (<<head::size(&1), _tail::bitstring>> -> head; <<>> -> nil)).()

  @spec drop_first_pixel(bitstring(), non_neg_integer()) :: bitstring()
  def drop_first_pixel(picture, color_count), do:
  color_count |> palette_bit_size |> (&case picture, do: (<<_head::size(&1), tail::bitstring>> -> tail; <<>> -> <<>>)).()

  @spec concat_pictures(bitstring(),bitstring()) :: bitstring()
  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
