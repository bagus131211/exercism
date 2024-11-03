defmodule Exercism.SpaceAge do
  @moduledoc """
  Given an age in seconds, calculate how old someone would be on a planet in our Solar System.

  One Earth year equals 365.25 Earth days, or 31,557,600 seconds. If you were told someone was 1,000,000,000 seconds old, their age would be 31.69 Earth-years.

  For the other planets, you have to account for their orbital period in Earth Years:

  Planet	Orbital period in Earth Years
  Mercury	0.2408467
  Venus	0.61519726
  Earth	1.0
  Mars	1.8808158
  Jupiter	11.862615
  Saturn	29.447498
  Uranus	84.016846
  Neptune	164.79132
  """
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @orbital_period %{
    mercury: 0.2408467,
    venus: 0.61519726,
    earth: 1.0,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  }

  @seconds_in_earth 31_557_600

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds), do:
    (case @orbital_period[planet],
      do: (nil -> {:error, "not a planet"};
           period -> {:ok, seconds / (@seconds_in_earth * period) |> Float.round(2)}))
end
