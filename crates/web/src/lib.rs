#![no_std]

// use roc_std::RocList;
// use std::collections::HashMap;
use wasm_bindgen::prelude::*;

mod console;
mod model;
mod pdom;

#[wasm_bindgen]
pub fn run() {
    console::log("INFO: STARTING APP...");

    let boxed_model = roc::roc_init();
    let roc_html = roc::roc_render(boxed_model);

    assert_eq!(
        roc_html.discriminant(),
        roc::glue::DiscriminantHtml::Element
    );

    console::log("HELLO");
}
