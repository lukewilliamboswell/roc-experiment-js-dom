platform ""
    requires { Model } {
        init : {} -> Model,
        update : Model, List U8 -> Action.Action Model,
        render : Model -> Html.Html Model,
    }
    exposes [Html, Action]
    packages {
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.11.0/z45Wzc-J39TLNweQUoLw3IGZtkQiEN3lTBv3BXErRjQ.tar.br",
    }
    imports []
    provides [init_for_host, update_for_host, render_for_host]

import Html
import Html
import Action

init_for_host : I32 -> Box Model
init_for_host = \_ -> Box.box(init({}))

update_for_host : Box Model, List U8 -> Action.Action (Box Model)
update_for_host = \boxed_model, payload ->
    Action.map(update(Box.unbox(boxed_model), payload), Box.box)

render_for_host : Box Model -> Html.Html Model
render_for_host = \boxed_model -> render(Box.unbox(boxed_model))
