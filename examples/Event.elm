module Event where

import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)
import Debug
import StartApp.Simple as StartApp
import Scale.Scale exposing (Scale)
import Svg exposing (Svg)
import Html.Events exposing (on)
import Json.Decode exposing (object1, (:=), float, Decoder)

main : Signal Svg
main =
  StartApp.start { model = model, view = view, update = update }

type Action = Click Float Float | Wheel Float

type alias Model =
  { points : List { x: Float, y : Float}, xScale : Scale Float, yScale : Scale Float}

model : Model
model =
  { points =
    [ {x = 10, y = 10}
    , {x = 50, y = 50}
    , {x = 100, y = 100}
    , {x = 150, y = 150}
    , {x = 200, y = 200}
    , {x = 250, y = 250}
    , {x = 300, y = 300}
    , {x = 400, y = 400}
    ]
  , xScale = Scale.linear (0, 400) (0, 400) 10
  , yScale = Scale.linear (0, 400) (400, 0) 10
  }

-- update : Plot.Action -> Model -> Model
update action model =
  case action of
    Click xPos yPos ->
      Debug.log "model" { model | points = { x = xPos, y = yPos } :: model.points }
    Wheel delta ->
      let
        d = Debug.log "delta" delta
        newRange = ((fst model.yScale.range + delta), (fst model.yScale.range - delta))
      in
        { model | yScale = Scale.updateRange (Debug.log "new range" newRange) model.yScale }

-- view : Signal.Address Plot.Action -> Model -> Svg
view address model =
  let
    yAxis =
      Axis.createAxis model.yScale Axis.Orient.Left

    xAxis =
      Axis.createAxis model.xScale Axis.Orient.Bottom
  in
    createPlot 400 400
      |> addPoints model.points .x .y model.xScale model.yScale (circle 5 [])
      |> addAxis xAxis
      |> addAxis yAxis
      |> registerOnClick model.xScale model.yScale (\me -> Signal.message address <| Click me.x me.y)
      |> additionalAttributes [on "wheel" wheelDecoder (\event -> Signal.message address (Wheel event.deltaY))]
      |> toSvg

type alias WheelEvent = { deltaY : Float }

wheelDecoder : Decoder WheelEvent
wheelDecoder =
  object1 WheelEvent
    ("deltaY" := float)
