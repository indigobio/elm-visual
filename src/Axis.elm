module Axis where

import Scale exposing (Scale)
import Axis.Axis exposing (Axis)
import Axis.Orient exposing (Orient)
import Svg
import Svg.Attributes exposing (fill, stroke, shapeRendering)

createAxis : Scale -> Orient -> Axis
createAxis scale orient =
  { scale = scale
  , orient = orient
  , boundingBox = { xStart = 0, xEnd = 0, yStart = 0, yEnd = 0 }
  , numTicks = 0
  , innerTickSize = 6
  , outerTickSize = 6
  , axisStyle = [ fill "none", stroke "#000", shapeRendering "crispEdges" ]
  , innerTickStyle = [ fill "none", stroke "#000", shapeRendering "crispEdges" ]
  }

numberOfTicks : Int -> Axis -> Axis
numberOfTicks numTicks axis =
  { axis | numTicks = numTicks }

innerTickSize : Int -> Axis -> Axis
innerTickSize size axis =
  { axis | innerTickSize = size }

outerTickSize : Int -> Axis -> Axis
outerTickSize size axis =
  { axis | outerTickSize = size }

axisStyle : List Svg.Attribute -> Axis -> Axis
axisStyle style axis =
  { axis | axisStyle = style }

innerTickStyle : List Svg.Attribute -> Axis -> Axis
innerTickStyle style axis =
  { axis | innerTickStyle = style }
