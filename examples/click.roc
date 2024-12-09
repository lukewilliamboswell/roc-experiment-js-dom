app [Model, init, update, render] {
    web: platform "../platform/main.roc",
}

import web.Html exposing [Html, div, style]
import web.Action exposing [Action]
import Counter { encodeEvent } exposing [Counter]

Model : {
    left : Counter,
    middle : Counter,
    right : Counter,
}

init : {} -> Model
init = \{} -> {
    left: Counter.init -10,
    middle: Counter.init 0,
    right: Counter.init 10,
}

Event : [
    ClickedCounterDecrement [Left, Middle, Right],
    ClickedCounterIncrement [Left, Middle, Right],
]

update : Model, List U8 -> Action Model
update = \model, raw ->
    when decodeEvent raw is
        ClickedCounterDecrement Left -> model |> &left (Counter.update model.left Decrement) |> Action.update
        ClickedCounterDecrement Middle -> model |> &middle (Counter.update model.middle Decrement) |> Action.update
        ClickedCounterDecrement Right -> model |> &right (Counter.update model.right Decrement) |> Action.update
        ClickedCounterIncrement Left -> model |> &left (Counter.update model.left Increment) |> Action.update
        ClickedCounterIncrement Middle -> model |> &middle (Counter.update model.middle Increment) |> Action.update
        ClickedCounterIncrement Right -> model |> &right (Counter.update model.right Increment) |> Action.update

render : Model -> Html Model
render = \model ->

    left = Html.translate (Counter.render model.left Left) .left &left
    middle = Html.translate (Counter.render model.middle Middle) .middle &middle
    right = Html.translate (Counter.render model.right Right) .right &right

    div
        [style "display: flex; justify-content: space-around; padding: 20px;"]
        [left, middle, right]

encodeEvent : Event -> List U8
encodeEvent = \event ->
    when event is
        ClickedCounterIncrement Left -> [1]
        ClickedCounterIncrement Right -> [2]
        ClickedCounterIncrement Middle -> [3]
        ClickedCounterDecrement Left -> [4]
        ClickedCounterDecrement Right -> [5]
        ClickedCounterDecrement Middle -> [6]

decodeEvent : List U8 -> Event
decodeEvent = \raw ->
    when raw is
        [1] -> ClickedCounterIncrement Left
        [2] -> ClickedCounterIncrement Right
        [3] -> ClickedCounterIncrement Middle
        [4] -> ClickedCounterDecrement Left
        [5] -> ClickedCounterDecrement Right
        [6] -> ClickedCounterDecrement Middle
        _ -> crash "unreachable - invalid event encoding"
