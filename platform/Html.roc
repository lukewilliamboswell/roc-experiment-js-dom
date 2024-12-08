module [
    Html,
    translate,
    none,
    text,
    div,
    button,
    ul,
    li,
    style,
    on_click,
]

Attribute msg := [
    Attr { key : Str, value : Str },
    Event { name : Str, handler : List U8 },
]

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

none : Html state
none = None

text : Str -> Html state
text = \str -> Text str

div : List (Attribute msg), List (Html state) -> Html state
div = \raw_attrs, children ->
    (attrs, events) = to_attrs_events raw_attrs
    Element { tag: "div", attrs, events } children

button : List (Attribute msg), List (Html state) -> Html state
button = \raw_attrs, children ->
    (attrs, events) = to_attrs_events raw_attrs
    Element { tag: "button", attrs, events } children

ul : List (Attribute msg), List (Html state) -> Html state
ul = \raw_attrs, children ->
    (attrs, events) = to_attrs_events raw_attrs
    Element { tag: "ul", attrs, events } children

li : List (Attribute msg), List (Html state) -> Html state
li = \raw_attrs, children ->
    (attrs, events) = to_attrs_events raw_attrs
    Element { tag: "li", attrs, events } children

on_click : List U8 -> Attribute msg
on_click = \handler ->
    @Attribute (Event { name: "onclick", handler })

style : Str -> Attribute msg
style = \value ->
    @Attribute (Attr { key: "style", value })
