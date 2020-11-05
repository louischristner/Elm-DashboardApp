module DashboardNavbar exposing (NavbarContent, NavbarContentElem, navbar)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Navbar as Navbar

type alias NavbarContentElem =
  { title : String
  , link : String
  }

type alias NavbarContent =
    { title : String
    , link : String
    , elements : List NavbarContentElem
    }

navbar : (Navbar.State -> msg) -> Navbar.State -> NavbarContent -> Html msg
navbar navbarMsg state content =
  Navbar.config navbarMsg
    |> Navbar.withAnimation
    |> Navbar.brand [ href "#home" ] [ text content.title ]
    |> Navbar.items
      (List.map
        (\x -> Navbar.itemLink [ href x.link ] [ text x.title ])
        content.elements
      )
    |> Navbar.view state
