defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: grid }
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index
    %Identicon.Image{image | grid: grid }
  end

  def mirror_row(row) do
    [first, second, _last] = row
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _rest]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  def hash_string(input) do
    hash = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hash}
  end
end
