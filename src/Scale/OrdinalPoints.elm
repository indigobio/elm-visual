module Scale.OrdinalPoints (transform, createTicks, createMapping) where

import Private.Models exposing (Tick, PointValue)
import Dict exposing (Dict)
import Sets exposing (Range)

transform : (Range -> Dict String Float) -> Range -> String -> PointValue
transform mapping range s =
  let
    value =
      case Dict.get s (mapping range) of
        Just x ->
          x
        Nothing ->
          0
  in
    { value = value, bandWidth = 0 }

createTicks : (Range -> Dict String Float) -> Range -> List Tick
createTicks mapping range =
  List.map (\x -> {position = snd x, label = fst x}) (Dict.toList (mapping range))

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L39
createMapping : List String -> Int -> Range -> Dict String Float
createMapping domain padding range =
  let
    start = fst range
    stop = snd range
    step = calculateStep domain padding start stop
    adjustedStart = adjustStart domain padding start step
  in
    buildMapping adjustedStart step domain Dict.empty

calculateStep : List String -> Int -> Float -> Float -> Float
calculateStep domain padding start stop =
  if List.length domain < 2 then
    toFloat <| round <| (start + stop) / 2
  else
    toFloat <| floor <| (stop - start) / toFloat (List.length domain - 1 + padding)

adjustStart : List String -> Int -> Float -> Float -> Float
adjustStart domain padding start step =
  if List.length domain < 2 then
    step
  else
    start + step * (toFloat padding) / 2

buildMapping : Float -> Float -> List String -> Dict String Float -> Dict String Float
buildMapping start step domain dict =
  if List.length domain == 0 then
    dict
  else
    buildMapping (start + step) step (List.drop 1 domain)
      <| Dict.insert (maybeStringToString (List.head domain)) start dict

maybeStringToString : Maybe String -> String
maybeStringToString s =
  case s of
    Just s ->
      s
    Nothing ->
      ""