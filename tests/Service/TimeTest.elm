module Service.TimeTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Service.Time exposing (..)
import Test exposing (..)
import Time exposing (millisToPosix, utc)


suite : Test
suite =
    describe "toReadable"
        [ test "can format to string" <|
            \_ ->
                let
                    actual =
                        toReaadble utc <| millisToPosix 1556964000000
                in
                Expect.equal "2019-05-04 10:00:00" actual
        , test "can format to string hours" <|
            \_ ->
                let
                    actual =
                        toReaadbleHours utc <| millisToPosix 1556964000000
                in
                Expect.equal "10:00:00" actual
        ]
