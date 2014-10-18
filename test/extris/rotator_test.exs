defmodule Extris.RotatorTest do
  use ExUnit.Case

  @ell [
    [1, 0],
    [1, 0],
    [1, 1]
  ]

  @ell_90 [
    [1, 1, 1],
    [1, 0, 0]
  ]

  @ell_180 [
    [1, 1],
    [0, 1],
    [0, 1]
  ]

  @ell_270 [
    [0, 0, 1],
    [1, 1, 1]
  ]

  test "rotating ells" do
    assert rotate(@ell, 90) == @ell_90
    assert rotate(@ell, 180) == @ell_180
    assert rotate(@ell, 270) == @ell_270
    assert rotate(@ell, 360) == @ell
  end

  def rotate(piece, amount) do
    Extris.Rotator.rotate(piece, amount)
  end
end
