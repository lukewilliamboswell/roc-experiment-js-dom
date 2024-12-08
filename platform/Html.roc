module [
    Html,
    translate,
    text,
    div,
    button,
    ul,
    li,
    on_click,
]

import json.Json

Attribute msg := [
    Attr { key : Str, value : Str },
    Event { name : Str, handler : List U8 },
] where msg implements Encoding

to_attrs_events : List (Attribute msg) -> (List { key : Str, value : Str }, List { name : Str, handler : List U8 })
to_attrs_events = \raw_attrs ->
    List.walk raw_attrs ([], []) \(attrs, events), @Attribute attr ->
        when attr is
            Attr inner -> (List.append attrs inner, events)
            Event inner -> (attrs, List.append events inner)

Html state : [
    None,
    Text Str,
    Element
        {
            tag : Str,
            attrs : List { key : Str, value : Str },
            events : List { name : Str, handler : List U8 },
        }
        (List (Html state)),
]

translate : Html child, (parent -> child), (parent, child -> parent) -> Html parent
translate = \elem, parentToChild, childToParent ->
    when elem is
        None ->
            None

        Text str ->
            Text str

        Element { tag, attrs, events } children ->
            Element
                { tag, attrs, events }
                (List.map children \c -> translate c parentToChild childToParent)

text : Str -> Html state
text = \str -> Text str

div : List (Attribute msg), List (Html state) -> Html state where
div = \raw_attrs, children ->
    (attrs, events) = to_attrs_events raw_attrs
    Element { tag: "div", attrs, events } children

button : List { key : Str, value : Str }, List { name : Str, handler : List U8 }, List (Html state) -> Html state
button = \attrs, events, children ->
    Element { tag: "button", attrs, events } children

ul : List { key : Str, value : Str }, List (Html state) -> Html state
ul = \attrs, children ->
    Element { tag: "ul", attrs, events: [] } children

li : List { key : Str, value : Str }, List (Html state) -> Html state
li = \attrs, children ->
    Element { tag: "li", attrs, events: [] } children

on_click : msg -> Attribute msg
on_click = \msg ->
    @Attribute (Event { name: "onclick", handler: Encode.toBytes msg Json.utf8 })
