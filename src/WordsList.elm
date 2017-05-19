module WordsList exposing (..)

import Html exposing (Html, div, h1, button, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    List String


init : ( Model, Cmd Msg )
init =
    ( [], getWordsList () )



-- UPDATE


type Msg
    = NextWord
    | WordsList (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextWord ->
            ( List.tail model
                |> Maybe.withDefault []
            , Cmd.none
            )

        WordsList (Ok wordsList) ->
            ( wordsList, Cmd.none )

        WordsList (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ List.head model
                |> Maybe.withDefault "END OF LIST"
                |> text
            ]
        , button [ onClick NextWord ] [ text "Next word!" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getWordsList : () -> Cmd Msg
getWordsList () =
    let
        url =
            "/data/words.json"

        request =
            Http.get url decodeWordsList
    in
        Http.send WordsList request


decodeWordsList : Decode.Decoder (List String)
decodeWordsList =
    Decode.list Decode.string
