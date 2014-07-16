#just an experiment
#by the way, I do not recommend building a website this way

#http://www.daviddurman.com/flexi-color-picker/#

#https://vis4.net/blog/posts/mastering-multi-hued-color-scales/
#https://vis4.net/labs/multihue/#colors=lightyellow,lightpink,green,cadetblue|steps=8|bez=1|coL=1

require(shiny)
require(magrittr)
require(rCharts)

dp <- dPlot(
  y = "y"
  , x = "x"
  , groups = "grp"
  , data = data.frame(
    x = format(as.Date(paste0("2000-",round(runif(1000,1,12)),"-01")),"%b")
    , y = runif(1000,1000,10000)
    , grp = LETTERS[c(rep(1,200),rep(2,200),rep(3,200),rep(4,200),rep(5,200))] 
  )
  , type = "bar"
  , height = 500
  , width = 900
  , xAxis = list( 
    orderRule = sprintf("#![\'%s\']!#",capture.output(cat(format(as.Date(paste0("2000-",1:12,"-01")),"%b"),sep="\',\'")))
   # ,grouporderRule = "grp"#sprintf("#![\'%s\']!#",capture.output(cat(LETTERS[1:5],sep="\',\'")))
  )
  #, yAxis = list( grouporderRule = "grp" )
)# %T>% .$set(facet = list( x = "grp", removeAxes = T ))

dp$setTemplate( afterScript = "
<script>
  function updateChartColors( colors ){
    var dcolors = colors.map(function(col){
      return new dimple.color(col);
    })
    {{chartId}}.forEach(function(cht){
      Object.keys(cht._assignedColors).forEach(function(k,i){
        cht._assignedColors[k] = dcolors[i % dcolors.length];
      })
      cht.defaultColors = dcolors;
      cht.draw();
    })
  }
</script>")

tags %$%
  html(
    "<head>" %>% HTML
     ,link(href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css", rel="stylesheet")
     , script(src = "//code.jquery.com/jquery-1.11.0.min.js")
     , script(src = "http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js")
     , script(src = "http://d3js.org/d3.v3.min.js")
     , script(src = "http://dimplejs.org/dist/dimple.v2.0.0.min.js")
     , script(src = "http://timelyportfolio.github.io/rCharts_dimple/js/d3-grid.js")
     , script(src = "js/colorpicker.js")
     , script(src = "js/chroma.js")
     , script(src = "js/color-scheme.min.js")
   , "</head>" %>% HTML
   , body(
      div( class = "container"
        ,div( class="page-header"
           , h1 ("rCharts + dimple Color Picker"
             , small(
               "built with "
               ,a(
                 href = "http://shiny.rstudio.com/articles/html-tags.html"
                 , target = "_blank"
                 ," Shiny Tags "
               )
             )
           )
        )
        ,div ( id = "color_row", class = "row"
          ,div( class = "col-md-3"
            ,div( id = "picker", class= "col-md-10", style = "height:200px")
            ,div( id = "slide", class= "col-md-2", style = "height:200px")
          )
          ,div( class = "col-md-2"
            ,div ( class = "panel panel-default"
              , div (class = "panel-heading"
                ,h4(
                  a( 
                    href = "http://brianhann.com/color-scheme-js/"
                    , target="_blank"
                    , "color-scheme.js"
                  )
                )
              )
              , div ( class = "panel-body"
                , div ( class = "btn-group-vertical"
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
                  )
                  ,div( class = "btn-group" 
                        ,button(
                          type = "button"
                          , id = "variation_selection"
                          , class="btn btn-default dropdown-toggle"
                          , "data-toggle"="dropdown"
                          , "Default"
                          , span( class="caret" )
                        )
                        ,ul( class="dropdown-menu", role="menu", id = "variation_buttons"
                             , li( a(href="#","Default") )
                             , li( a(href="#","Pastel" ) )
                             , li( a(href="#","Soft" ) )
                             , li( a(href="#","Light" ) )
                             , li( a(href="#","Hard" ) )
                             , li( a(href="#","Pale" ) )
                        )
                   )
                )
              )
            )
          )
          , div ( class = "col-md-2"
            ,div( class="panel panel-default"
              ,div( class = "panel-heading"
                ,h4(
                  a(
                    href = "https://vis4.net/blog/posts/mastering-multi-hued-color-scales"
                    , target="_blank"
                    , "chroma.js"
                  )
                )
              )
              ,div( class = "panel-body"
                #,div( class = "row"
                  ,label( 
                     "Steps"
                    ,input( id="steps", checked="checked", type="number", value="9", style="width: 40px;")
                  )
                #)
                #,div( class = "row"
                  #,div( class = "col-md-11 col-md-offset-1"
                    ,div( class = "checkbox"
                      ,label(
                        input( id="bez", type="checkbox")
                        , "Bezier"
                      )
                    )
                  #)
                #)
                #,div( class = "row"
                  #,div( class = "col-md-11 col-md-offset-1"
                    ,div( class = "checkbox"
                      , label(
                        input( id="coL", type="checkbox")
                        , "Lightness"
                      )
                    )
                  #)
                #)
              )
            )
          )
          ,div(class = "col-md-5", id = "palette"
            #,
          )
        )
        ,div( id = "chart_row", class = "row"
          , div ( class = "col-md-3"
            , "Select a color with the color picker above and then create
             a palette with some nice javascript color libraries."
            , hr()
            , "This site was created entirely in R with rCharts, magrittr, and shiny based on
            an"
            , a(
              href = "https://github.com/danielkrizian/rChartsDygraphs/issues/11"
              , target= "_blank"
              , "idea from Ramnath Vaidyanathan."
            )
            ," On the Javascript side of the world, we used "
            , ul( class="nav nav-pills nav-stacked"
              ,li(
                a(
                  span (class="badge", "1")
                  , href = "http://www.daviddurman.com/flexi-color-picker/"
                  , target = "_blank"
                  ,"flexi-color-picker"
                )
              )
              ,li(
                a(
                  span (class="badge", "2")
                  , href = "https://vis4.net/blog/posts/mastering-multi-hued-color-scales"
                  , target = "_blank"
                  ,"chroma.js"
                )
              )
              ,li(
                a(
                  span (class="badge", "3")
                  , href = "http://brianhann.com/color-scheme-js/"
                  , target = "_blank"
                  ,"color-scheme.js"
                )
              )
              ,li(
                a(
                  span (class="badge", "4")
                  , href = "http://dimplejs.org/"
                  , target = "_blank"
                  ,"dimple.js"
                )
              )
              ,li(
                a(
                  span (class="badge", "5")
                  , href = "http://dimplejs.org/"
                  , target = "_blank"
                  ,"dimple.js"
                )
              )
              ,li(
                a(
                  span (class="badge", "6")
                  , href = "http://getbootstrap.com/"
                  , target = "_blank"
                  ,"bootstrap"
                )
              )
            )
          )
          , div ( class = "col-md-9"
            ,paste0(noquote(capture.output(dp$show("inline"))),collapse="\n") %>% HTML
          )
        )
      )
      
      ,script(
        '
              d3.selectAll("input").on("change",function(){
                updateColors(  );
              });

              d3.selectAll("#scheme_buttons li a").on("click",function(){
                var selText = $(this).text();
               $(this).parents(".btn-group").find(".dropdown-toggle").html(selText+" <span class=\'caret\'></span>");
               updateColors( );
              })

              d3.selectAll("#variation_buttons li a").on("click",function(){
                var selText = $(this).text();
               $(this).parents(".btn-group").find(".dropdown-toggle").html(selText+" <span class=\'caret\'></span>");
               updateColors( );
              })

              ColorPicker(
                document.getElementById("slide"),
                document.getElementById("picker"),
                function(hex, hsv, rgb) {
                  document.getElementById("color_row").style.backgroundColor = chroma.hex(hex).css();
                  d3.selectAll("#slide,#picker").datum([hex,hsv,rgb]);
                  updateColors( );
                });
               
              function updateColors( ) {
                var hex = d3.selectAll("#slide,#picker").datum()[0];
                var hue = d3.selectAll("#slide,#picker").datum()[1].h;

                colors = (new ColorScheme).from_hue( hue ) //chroma.hex(hex).hsv()[0] )
                  //.from_hex( hex.replace("#", "" ).toUpperCase() )
                  .scheme(d3.select("#scheme_selection").text().toLowerCase().replace(/[ \\t\\r\\n]+/g,""))
                  .variation(d3.select("#variation_selection").text().toLowerCase().replace(/[ \\t\\r\\n]+/g,""))
                  .colors().map(function(col){return "#" + col})

                if (d3.select("#scheme_selection").text().toLowerCase().replace(/[ \\t\\r\\n]+/g,"") != "monochromatic")  colors.splice(0,0,hex);

                if (d3.select("#bez").node().checked){
                  if( d3.select("#scheme_selection").text().toLowerCase().replace(/[ \\t\\r\\n]+/g,"") != "monochromatic"){
                    //if not monochromatic then will pick 0,3,4,...,length-1
                      colors = colors.filter(function(col,i){
                        if( (colors.length < 9 && i % 4 < 2 ) || (colors.length >= 9 && i % 4 === 0) ) { //|| i % 4 === 3 ) {
                          return col;
                        }
                      })
                  }
                  colors = chroma.interpolate.bezier( colors )
                }

                var scale = chroma.scale(colors)
                    .domain([0,+d3.select("#steps")[0][0].value],d3.select("#steps")[0][0].value)
                    .correctLightness( d3.select("#coL").node().checked );

                colors = d3.range(0,d3.select("#steps")[0][0].value,1)
                  .map(function(d){return scale(d).hex()});
                  

                var palette = d3.selectAll("#palette").selectAll("div").data(colors);

                palette
                  .enter()
                    .append("div")
                palette
                  .exit().remove();
                
                palette
                  .style("display", "inline-block")
                  .style("width",d3.format(".4%")(1/colors.length))
                  .style("height",d3.select("#picker").style("height"))
                  .style("background",function(d){return d;})

                updateChartColors(colors);
              }
        ' %>% HTML
      )
   )
  ) %T>%
  assign("page",.,pos=globalenv()) %>%
  capture.output %>%
  paste0(collapse = "\n") %>%
  cat(file="index.html")