module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import DashboardNavbar exposing (NavbarContent, NavbarContentElem, navbar)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Navbar as Navbar
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block

type alias Model =
  { navbarState : Navbar.State
  }

init : () -> (Model, Cmd Msg)
init _ =
  let
    ( navbarState, navbarCmd ) =
      Navbar.initialState NavbarMsg
  in
    ( { navbarState = navbarState
      }
    , navbarCmd
    )

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

type Msg
  = NavbarMsg Navbar.State

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NavbarMsg state ->
      ({ model | navbarState = state }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Navbar.subscriptions model.navbarState NavbarMsg

widget : String -> String -> Html Msg
widget title text_ =
  Card.config
    [ Card.outlineDark
    , Card.attrs [ class "mt-2 mb-2" ]
    ]
    |> Card.footer [] [ text "This is a small text" ]
    |> Card.block []
      [ Block.titleH5 [] [ text title ]
      , Block.text [] [ text text_ ]
      ]
    |> Card.view

colWidget1 : Int -> Grid.Column Msg
colWidget1 indx =
  Grid.col [ Col.lg3 ]
    [ widget ("colWidget 1") ("This is the element number " ++ String.fromInt indx ++ ".") ]

colWidget2 : Int -> Grid.Column Msg
colWidget2 indx =
  Grid.col [ Col.lg2 ]
    [ widget ("colWidget 2") ("This is the element number " ++ String.fromInt indx ++ ".") ]

colWidget3 : Int -> Grid.Column Msg
colWidget3 indx =
  Grid.col [ Col.lg4 ]
    [ widget ("colWidget 3") ("This is the element number " ++ String.fromInt indx ++ ".") ]

mainContent : Model -> Html Msg
mainContent model =
  Grid.row []
    (List.map
      (\x ->
        case modBy 5 x of
          0 -> colWidget2 x
          2 -> colWidget3 x
          _ -> colWidget1 x
      )
      (List.range 0 12)
    )

view : Model -> Html Msg
view model =
  Grid.containerFluid []
    [ CDN.stylesheet
    , navbar
      NavbarMsg
      model.navbarState
      { title = "Dashboard"
      , link = "#home"
      , elements =
        [ { title = "Home", link = "#home" }
        , { title = "List", link = "#link" }
        ]
      }
    , mainContent model
    ]
