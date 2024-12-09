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
    UserClickedDecrement [Left, Middle, Right],
    UserClickedIncrement [Left, Middle, Right],
]

update : Model, List U8 -> Action Model
update = \model, raw ->
    when decodeEvent raw is
        UserClickedDecrement Left -> model |> &left (Counter.update model.left Decrement) |> Action.update
        UserClickedDecrement Middle -> model |> &middle (Counter.update model.middle Decrement) |> Action.update
        UserClickedDecrement Right -> model |> &right (Counter.update model.right Decrement) |> Action.update
        UserClickedIncrement Left -> model |> &left (Counter.update model.left Increment) |> Action.update
        UserClickedIncrement Middle -> model |> &middle (Counter.update model.middle Increment) |> Action.update
        UserClickedIncrement Right -> model |> &right (Counter.update model.right Increment) |> Action.update

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
        UserClickedIncrement Left -> [1]
        UserClickedIncrement Right -> [2]
        UserClickedIncrement Middle -> [3]
        UserClickedDecrement Left -> [4]
        UserClickedDecrement Right -> [5]
        UserClickedDecrement Middle -> [6]

decodeEvent : List U8 -> Event
decodeEvent = \raw ->
    when raw is
        [1] -> UserClickedIncrement Left
        [2] -> UserClickedIncrement Right
        [3] -> UserClickedIncrement Middle
        [4] -> UserClickedDecrement Left
        [5] -> UserClickedDecrement Right
        [6] -> UserClickedDecrement Middle
        _ -> crash "unreachable - invalid event encoding"
