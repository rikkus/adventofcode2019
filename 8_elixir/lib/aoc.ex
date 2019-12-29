defmodule Aoc do
  @spec part_one(String.t(), non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  def part_one(pixels, w, h) do
    layer =
      layers(pixels, w, h)
      |> Enum.min_by(fn e -> Enum.count(e, fn n -> n == 0 end) end)

    Enum.count(layer, fn n -> n == 1 end) *
      Enum.count(layer, fn n -> n == 2 end)
  end

  def part_two(pixels, w, h) do
    pix = layers(pixels, w, h)
    |> Enum.reverse()
    |> Enum.reduce(fn layer, image -> combine_images(layer, image) end)

    print(pix, w)
  end

  def combine_images(image1, image2) do
    Enum.zip(image1, image2)
    |> Enum.map(fn {p1, p2} -> combine_pixels(p1, p2) end)
  end

  def combine_pixels(2, x), do: x
  def combine_pixels(1, _), do: 1
  def combine_pixels(0, _), do: 0

  def print(image, w) do
    image
    |> Enum.chunk_every(w)
    |> Enum.map(fn scanline -> IO.puts(Enum.join(scanline)) end)
  end

  def layers(pixels, w, h),
    do:
      pixels
      |> String.split("", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> Enum.chunk_every(w * h)
end
