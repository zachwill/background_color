div ".container", ->
  div ".hero-unit", ->
    h1 "Hello, colors."
    p ".tagline", -> "Change this element's background and text colors using the form below."

    div ".row.colors", ->
      div ".span4", ->
        label ->
          p "Background"
          input "#new-background", tabindex: 1, placeholder: "#eee", ->

      div ".span4", ->
        label ->
          p "Text"
          input "#new-text", tabindex: 2, placeholder: "#222", ->

      div ".span4.buttons", ->
        button ".btn.add", rel: "twipsy", title: "Change the colors", -> "Update"
        button ".btn.undo", rel: "twipsy", title: "Use previous colors", ->
          span ->
