defmodule Extris.Shapes do
  import Extris.Rotator, only: [rotate: 2]
  @ell [
    [1, 0],
    [1, 0],
    [1, 1]
  ]

  @jay [
    [0, 1],
    [0, 1],
    [1, 1]
  ]

  @ess [
    [0, 1, 1],
    [1, 1, 0]
  ]

  @zee [
    [1, 1, 0],
    [0, 1, 1]
  ]

  @bar [
    [1, 1, 1, 1]
  ]

  @oh [
    [1, 1],
    [1, 1]
  ]

  @shapes %{
    ell: [@ell, rotate(@ell, 90), rotate(@ell, 180), rotate(@ell, 270)],
    jay: [@jay, rotate(@jay, 90), rotate(@jay, 180), rotate(@jay, 270)],
    ess: [@ess, rotate(@ess, 90), rotate(@ess, 180), rotate(@ess, 270)],
    zee: [@zee, rotate(@zee, 90), rotate(@zee, 180), rotate(@zee, 270)],
    bar: [@bar, rotate(@bar, 90), rotate(@bar, 180), rotate(@bar, 270)],
    oh:  [@oh,  rotate(@oh, 90),  rotate(@oh, 180),  rotate(@oh, 270)],
  }

  def shapes, do: @shapes
end
