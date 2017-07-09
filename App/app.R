library(shiny)
library(png)
library(lsa)
server <- shinyServer(function(input, output) {
  output$files <- renderTable(input$files)
   files <- reactive({
    files <- input$files
    files$datapath <- gsub("\\\\", "/", files$datapath)
    files
  })
  
  
  output$images <- renderUI({
    if(is.null(input$files)) return(NULL)
    image_output_list <- 
      lapply(1:nrow(files()),
             function(i)
             {
               imagename = paste0("image", i)
               imageOutput(imagename)
             })
    
    do.call(tagList, image_output_list)
  })
  
  observe({
    if(is.null(input$files)) return(NULL)
    for (i in 1:nrow(files()))
    {
      print(i)
      local({
        my_i <- i
        imagename = paste0("image", my_i)
        print(imagename)
        x<-files()$datapath[my_i]
        write.table(x, file = "/home/secret95/Desktop/image_search_engine/query.csv", sep = ",", col.names = FALSE,row.names = FALSE,na="NA")
        path<-read.csv('/home/secret95/Desktop/image_search_engine/query.csv',header=FALSE)
        path<-as.character(path$V1)
        dest<-'/home/secret95/Desktop/image_search_engine/'
        file.copy(path,dest)
        query_img<-readPNG(path)
        r<-as.data.frame(raster(query_img[,,1]), row.names=NULL, optional=FALSE)
        g<-as.data.frame(raster(query_img[,,2]), row.names=NULL, optional=FALSE)
        b<-as.data.frame(raster(query_img[,,3]), row.names=NULL, optional=FALSE)
        r_mean=sapply(r,mean)
        g_mean=sapply(g,mean)
        b_mean=sapply(b,mean)
        q<-cbind(r_mean,g_mean,b_mean)
        write.table(q, file = "/home/secret95/Desktop/image_search_engine/query_avg.csv", sep = ",", col.names = FALSE,row.names = FALSE,na="NA",append = TRUE)
        
        output[[imagename]] <- 
          renderImage({
            list(src = files()$datapath[my_i],
                 alt = "Image failed to render")
          }, deleteFile = FALSE)
      })
    }
  })
  
})

ui <- shinyUI(fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = 'files', 
                label = 'Upload Query Image',
                multiple = TRUE,
                accept=c('image/png', 'image/jpeg'))
    ),
    mainPanel(
      tableOutput('files'),
      uiOutput('images')
    )
  )
))

shinyApp(ui=ui,server=server)