#http://www.daviddurman.com/flexi-color-picker/#

#https://vis4.net/blog/posts/mastering-multi-hued-color-scales/
#https://vis4.net/labs/multihue/#colors=lightyellow,lightpink,green,cadetblue|steps=8|bez=1|coL=1

require(shiny)
require(magrittr)

tags %$%
  html(
    "<head>" %>% HTML
     ,link(href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css", rel="stylesheet")
     , script(src = "//code.jquery.com/jquery-1.11.0.min.js")
     , script(src = "http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js")
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
          ,div( class = "col-md-1"
            #,strong( "Scheme" )
            ,div( class = "btn-group" 
              ,button(
                type = "button"
                , id = "scheme_selection"
                , class="btn btn-default dropdown-toggle"
                , "data-toggle"="dropdown"
                , "Monochromatic"
                , span( class="caret" )
              )
              ,ul( class="dropdown-menu", role="menu", id = "scheme_buttons"
                , li( a(href="#","Monochromatic") )
                , li( a(href="#","Contrast" ) )
                , li( a(href="#","Triade" ) )
                , li( a(href="#","Tetrade" ) )
                , li( a(href="#","Analogic" ) )
              )
              , button(
                id="add-complement"
                , type="button"
                , "data-toggle"="button"
                , class="btn hide"
                , "Add Complement"
              )
            )
            ,"Steps"
            ,input( id="steps", checked="checked", type="number", value="9", style="width: 40px;")
          )
        )
        ,div( id = "chart_row", class = "row"
          #
        )
      )
      ,script(
        '
              d3.selectAll("#scheme_buttons li a").on("click",function(){
                var selText = $(this).text();
               $(this).parents(".btn-group").find(".dropdown-toggle").html(selText+" <span class=\'caret\'></span>");
              })
              var scheme = new ColorScheme;
              ColorPicker(
                document.getElementById("slide"),
                document.getElementById("picker"),
                function(hex, hsv, rgb) {
                  document.getElementById("color_row").style.backgroundColor = hex;
                  var bezInterpolator = chroma.interpolate.bezier(
                      scheme.from_hex( hex.replace("#", "") )
                      .scheme(d3.select("#scheme_selection").text().toLowerCase().replace(/[ \\t\\r\\n]+/g,""))
                      .colors().map(function(col){return "#" + col})
                  )
                  var scale = chroma.scale(bezInterpolator)
                                .domain([0,+d3.select("#steps")[0][0].value],d3.select("#steps")[0][0].value)
                                .correctLightness(true);
                  console.log(d3.range(0,d3.select("#steps")[0][0].value,1).map(function(d){return scale(d).hex()}));
                });
        ' %>% HTML
      )
   )
  ) %T>%
  assign("page",.,pos=globalenv()) %>%
  capture.output %>%
  paste0(collapse = "\n") %>%
  cat(file="index.html")