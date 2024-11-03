defmodule Exercism.ScaleGenerator do
  @moduledoc """
  Instructions
  Chromatic Scales
  Scales in Western music are based on the chromatic (12-note) scale. This scale can be expressed as the following group of pitches:

    A, A♯, B, C, C♯, D, D♯, E, F, F♯, G, G♯

  A given sharp note (indicated by a ♯) can also be expressed as the flat of the note above it (indicated by a ♭) so the
  chromatic scale can also be written like this:

    A, B♭, B, C, D♭, D, E♭, E, F, G♭, G, A♭

  The major and minor scale and modes are subsets of this twelve-pitch collection. They have seven pitches, and are called diatonic scales. The collection of notes in these scales is written with either sharps or flats, depending on the tonic (starting note). Here is a table indicating whether the flat expression or sharp expression of the scale would be used for a given tonic:

  Key Signature	Major	Minor
    Natural	C	a
    Sharp	G, D, A, E, B, F♯	e, b, f♯, c♯, g♯, d♯
    Flat	F, B♭, E♭, A♭, D♭, G♭	d, g, c, f, b♭, e♭
  Note that by common music theory convention the natural notes "C" and "a" follow the sharps scale when ascending and
  the flats scale when descending. For the scope of this exercise the scale is only ascending.

  Task
    Given a tonic, generate the 12 note chromatic scale starting with the tonic.

    Shift the base scale appropriately so that all 12 notes are returned starting with the given tonic.
    For the given tonic, determine if the scale is to be returned with flats or sharps.
    Return all notes in uppercase letters (except for the b for flats) irrespective of the casing of the given tonic.
  Diatonic Scales
    The diatonic scales, and all other scales that derive from the chromatic scale, are built upon intervals.
    An interval is the space between two pitches.

  The simplest interval is between two adjacent notes, and is called a "half step",
  or "minor second" (sometimes written as a lower-case "m").
  The interval between two notes that have an interceding note is called a "whole step" or "major second" (written as an upper-case "M").
  The diatonic scales are built using only these two intervals between adjacent notes.

  Non-diatonic scales can contain other intervals. An "augmented second" interval, written "A",
  has two interceding notes (e.g., from A to C or D♭ to E) or a "whole step" plus a "half step".
  There are also smaller and larger intervals, but they will not figure into this exercise.

  Task
    Given a tonic and a set of intervals, generate the musical scale starting with the tonic and following the specified interval pattern.

  This is similar to generating chromatic scales except that instead of returning 12 notes, you will return N+1 notes for N intervals.
  The first note is always the given tonic. Then, for each interval in the pattern,
  the next note is determined by starting from the previous note and skipping the number of notes indicated by the interval.

  For example, starting with G and using the seven intervals MMmMMMm, there would be the following eight notes:

    Note	Reason
    G	    Tonic
    A	    M       indicates a whole step from G, skipping G♯
    B	    M       indicates a whole step from A, skipping A♯
    C	    m       indicates a half step from B, skipping nothing
    D	    M       indicates a whole step from C, skipping C♯
    E	    M       indicates a whole step from D, skipping D♯
    F♯	  M       indicates a whole step from E, skipping F
    G	    m       indicates a half step from F♯, skipping nothing

  """
  @step %{m: 1, M: 2, A: 3}

  @chromatic_scale ~w(C C# D D# E F F# G G# A A# B)

  @flat_chromatic_scale ~w(C Db D Eb E F Gb G Ab A Bb B)

  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F

      Example:

        iex(74)> Exercism.ScaleGenerator.step ~w(C C# D D# E F F# G G# A A# B), "C", "m"
        "C#"
        iex(75)> Exercism.ScaleGenerator.step ~w(C C# D D# E F F# G G# A A# B), "G#", "A"
        "B"

  """
  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) :: String.t()
  def step(scale, tonic, step), do:
    scale
      |> Enum.at(scale
          |> Enum.find_index(& &1 == tonic)
          |> then(& &1 + @step[String.to_atom(step)]))

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)

      Example:

        iex(72)> Exercism.ScaleGenerator.chromatic_scale "f#"
        ["F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#"]
        iex(73)> Exercism.ScaleGenerator.chromatic_scale "b"
        ["B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic \\ "C"), do:
    (idx = @chromatic_scale |> Enum.find_index(& &1 == String.upcase(tonic)); Enum.drop(@chromatic_scale, idx) ++ Enum.take(@chromatic_scale, idx + 1))

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)

      Example:

        iex(70)> Exercism.ScaleGenerator.flat_chromatic_scale "Gb"
        ["Gb", "G", "Ab", "A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb"]
        iex(71)> Exercism.ScaleGenerator.flat_chromatic_scale
        ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B", "C"]

  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic \\ "C"), do:
    (idx = @flat_chromatic_scale |> Enum.find_index(& &1 == tonic); Enum.drop(@flat_chromatic_scale, idx) ++ Enum.take(@flat_chromatic_scale, idx + 1))

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.

      Example:

        iex(68)> Exercism.ScaleGenerator.find_chromatic_scale "d"
        ["D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B", "C", "Db", "D"]
        iex(69)> Exercism.ScaleGenerator.find_chromatic_scale "F"
        ["F", "Gb", "G", "Ab", "A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F"]

  """
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def find_chromatic_scale(tonic), do:
    (cond do:
      (
        tonic in ~w(F d g c f) or String.ends_with?(tonic, "b") ->
          flat_chromatic_scale(tonic |> String.first |> String.upcase |> Kernel.<>(String.slice(tonic, 1..-1//1)))
        true ->
          chromatic_scale(tonic)
      )
    )

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C

      Example:

          iex(65)> Exercism.ScaleGenerator.scale "C", "MMmMMMm"
          ["C", "D", "E", "F", "G", "A", "B", "C"]
          iex(66)> Exercism.ScaleGenerator.scale "G", "MMmMMMm"
          ["G", "A", "B", "C", "D", "E", "F#", "G"]
          iex(67)> Exercism.ScaleGenerator.scale "F", "MMmMMMm"
          ["F", "G", "A", "Bb", "C", "D", "E", "F"]

  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())
  def scale(tonic, pattern) do
    scale = find_chromatic_scale(tonic)
    pattern |> String.graphemes |> Enum.map_reduce(upcase_cond(tonic), fn p, current_tonic ->
      next_note = step(scale, current_tonic, p)
      {next_note, next_note}
    end)
    |> elem(0)
    |> then(& [upcase_cond(tonic) | &1])
  end

  defp upcase_cond(tonic), do:
    (
      case String.ends_with?(tonic, "b"), do:
        (
          true -> tonic |> String.first |> String.upcase |> Kernel.<>(String.slice(tonic, 1..-1//1))
          _ -> tonic |> String.upcase
        )
    )
end
