module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Element exposing (Element)
import Element exposing (Attribute)

type alias View msg =
    { title : String
    , attrs : List (Attribute msg)
    , body : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , body = Element.text str
    , attrs = []
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , body = Element.map fn view.body
    , attrs = List.map (Element.mapAttribute fn) view.attrs
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body = [Element.layout view.attrs view.body]
    }
