module Plot.Scale exposing (LinearScale, OrdinalScale, linear, ordinalBands)

import Private.Extras.Interval as Interval exposing (Interval)
import Private.Scale exposing (Scale)
import Private.Scale.Linear as LinearScaleMethods
import Private.Scale.OrdinalBands as OrdinalBands


type alias LinearScale =
    Scale Interval Float


type alias OrdinalScale =
    Scale (List String) String


linear : ( Float, Float ) -> ( Float, Float ) -> Int -> LinearScale
linear domain range numTicks =
    { domain = Interval.createFromTuple domain
    , range = Interval.createFromTuple range
    , interpolate = LinearScaleMethods.interpolate
    , uninterpolate = LinearScaleMethods.uninterpolate
    , createTicks = LinearScaleMethods.createTicks numTicks
    , inDomain = LinearScaleMethods.inDomain
    }


ordinalBands : List String -> ( Float, Float ) -> Float -> Float -> OrdinalScale
ordinalBands domain range padding outerPadding =
    let
        mapping =
            OrdinalBands.createMapping padding outerPadding
    in
    { domain = domain
    , range = Interval.createFromTuple range
    , interpolate = OrdinalBands.interpolate mapping
    , uninterpolate = OrdinalBands.uninterpolate mapping
    , createTicks = OrdinalBands.createTicks mapping
    , inDomain = OrdinalBands.inDomain
    }
