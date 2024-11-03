defmodule Exercism.RemoteControlCar do
  alias Exercism.RemoteControlCar
  @enforce_keys [:nickname]
  defstruct(
    battery_percentage: 100,
    distance_driven_in_meters: 0,
    nickname: ""
  )

  @type t :: %RemoteControlCar{
    battery_percentage: number(),
    distance_driven_in_meters: number(),
    nickname: String.t()
  }

  def new(nickname \\ "none") when is_binary(nickname) and byte_size(nickname) > 0, do:
   %RemoteControlCar{nickname: nickname}

  def display_distance(%RemoteControlCar{} = remote_car), do:
   "#{remote_car.distance_driven_in_meters} meters"

  def display_battery(%RemoteControlCar{battery_percentage: battery} = _remote_car), do:
   "Battery #{if battery === 0, do: "empty", else: "at #{battery}%"}"

  def drive(%RemoteControlCar{battery_percentage: battery} = remote_car)
   when battery === 0, do: remote_car

  def drive(%RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance} = remote_car), do:
   %{remote_car | battery_percentage: battery - 1, distance_driven_in_meters: distance + 20}
end
