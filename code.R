#http://www.daviddurman.com/flexi-color-picker/#

#https://vis4.net/blog/posts/mastering-multi-hued-color-scales/

require(shiny)
require(magrittr)

tags %$%
  html(
    "<head>" %>% HTML
     ,link(href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css", rel="stylesheet")
     , script(src = "http://d3js.org/d3.v3.min.js")
     , script(src = "http://dimplejs.org/dist/dimple.v2.0.0.min.js")
     , script(src = "js/colorpicker.js")
     , script(src = "js/chroma.js")
     , script(src = "js/color-scheme.js")
   , "</head>" %>% HTML
   , body(
      div( class = "container"
        ,div ( id = "color_row", class = "row"
          ,div( class = "col-md-3"
            ,div( id = "picker", class= "col-md-10", style = "height:200px")
            ,div( id = "slide", class= "col-md-2", style = "height:200px")
          )
          ,div( class = "col-md-9"
          #  ,
          )
        )
        ,div( id = "chart_row", class = "row"
          #
        )
      )
      ,script(
        '
              var scheme = new ColorScheme;
              ColorPicker(
                document.getElementById("slide"),
                document.getElementById("picker"),
                function(hex, hsv, rgb) {
                  document.getElementById("color_row").style.backgroundColor = hex;
                  console.log(scheme.from_hex( hex.replace("#", "") ).colors() )
                });
        '
      )
   )
  ) %T>%
  assign("page",.,pos=globalenv()) %>%
  capture.output %>%
  paste0(collapse = "\n") %>%
  cat(file="index.html")