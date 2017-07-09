shinyUI(fluidPage(
  div(titlePanel("Image Search Engine"),style="text-align: center;"),
  helpText("Your Query:"),
    mainPanel(
      div(img(src='0',height=250,width=250),style="text-align: center;"),
      helpText("Search Results:"),
      list(div(img(src='1.png',height=250,width=250),style="text-align: center;"),div(img(src='2.png',height=250,width=250),style="text-align: center;"),div(img(src='3.png',height=250,width=250),style="text-align: center;"),div(img(src='4.png',height=250,width=250),style="text-align: center;"),div(img(src='5.png',height=250,width=250),style="text-align: center;"))
    )
))