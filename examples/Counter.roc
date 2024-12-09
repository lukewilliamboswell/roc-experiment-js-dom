module { encodeEvent } -> [Counter, init, update, render]

import web.Html exposing [Html, button, ul, li, text, style, on_click]

Counter := I64

init : I64 -> Counter
init = @Counter

update : Counter, [Increment, Decrement] -> Counter
update = \@Counter value, action ->
    when action is
        Increment -> @Counter (Num.addWrap value 1)
        Decrement -> @Counter (Num.subWrap value 1)

render : Counter -> Html Counter
render = \@Counter value ->
    ul
        [style "list-style: none; padding: 0; text-align: center;"]
        [
            li [] [
                button
                    [
                        on_click (encodeEvent (UserClickedDecrement Left)),
                        style
                            """
                            background-color: red;
                            color: white;
                            padding: 10px 20px;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            margin: 5px;
                            font-size: 16px;
                            """,
                    ]
                    [text "-"],
            ],
            li
                [style "font-size: 24px; margin: 15px 0; font-weight: bold;"]
                [text (Inspect.toStr value)],
            li [] [
                button
                    [
                        on_click (encodeEvent (UserClickedIncrement Left)),
                        style
                            """
                            background-color: blue;
                            color: white;
                            padding: 10px 20px;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            margin: 5px;
                            font-size: 16px;
                            """,
                    ]
                    [text "+"],
            ],
        ]
