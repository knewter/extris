defmodule Extris.ShapesTest do
  use ExUnit.Case
  alias Extris.Shapes

  test "an oh always has a width of 2" do
    for rotation <- 0..3 do
      assert Shapes.width(:oh, rotation) == 2
    end
  end

  test "an ell has a width of 2 or 3" do
    assert Shapes.width(:ell, 0) == 2
    assert Shapes.width(:ell, 1) == 3
    assert Shapes.width(:ell, 2) == 2
    assert Shapes.width(:ell, 3) == 3
  end

  test "an oh always has a height of 2" do
    for rotation <- 0..3 do
      assert Shapes.height(:oh, rotation) == 2
    end
  end

  test "an ell has a height of 2 or 3" do
    assert Shapes.height(:ell, 0) == 3
    assert Shapes.height(:ell, 1) == 2
    assert Shapes.height(:ell, 2) == 3
    assert Shapes.height(:ell, 3) == 2
  end
end
