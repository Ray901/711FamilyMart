library(shiny)
library(googleVis)

########################################################

shinyServer(function(input, output , session) { 
  
  getFamilyData <- eventReactive(input$familySearch,{      
    familyDat <- read.csv("familyShopData.csv")
    familyDat <- familyDat[substr(familyDat$addr,1,3)==input$familyCitySelect,]
    familyDat$LatLong <- paste(familyDat$py,familyDat$px,sep=":")
    if (!is.null(input$familyFactCheckBox)) {
      if (length(input$familyFactCheckBox)>1) {
        familyDat <- familyDat[
          which(rowSums(familyDat[,which(names(familyDat) %in% input$familyFactCheckBox)])==length(input$familyFactCheckBox)),]
      } else if (length(input$familyFactCheckBox)==1) {
        familyDat <- familyDat[
          which(familyDat[,which(names(familyDat) %in% input$familyFactCheckBox)]==TRUE),]
      }
    }
    return(familyDat)
  })

  get711Data <- eventReactive(input$'711Search',{      
    sevenElevenDat <- read.csv("711ShopData.csv")
    sevenElevenDat <- sevenElevenDat[substr(sevenElevenDat$Address,1,3)==input$'711CitySelect',]
    sevenElevenDat$LatLong <- paste(round(sevenElevenDat$Y/1000000,digits = 6),round(sevenElevenDat$X/1000000,digits = 6),sep=":")
    if (!is.null(input$'711FactCheckBox')) {
      if (length(input$'711FactCheckBox')>1) {
        sevenElevenDat <- sevenElevenDat[
          which(rowSums(sevenElevenDat[,which(names(sevenElevenDat) %in% input$'711FactCheckBox')])==length(input$'711FactCheckBox')),]
      } else if (length(input$'711FactCheckBox')==1) {
        sevenElevenDat <- sevenElevenDat[
          which(sevenElevenDat[,which(names(sevenElevenDat) %in% input$'711FactCheckBox')]==TRUE),]
      }
      
    }
    return(sevenElevenDat)
  })

  output$familyShopView <- renderGvis({
    gvisMap(getFamilyData(), "LatLong" , "addr", 
            options=list(showTip=TRUE, 
                         showLine=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='terrain', 
                         useMapTypeControl=TRUE))
  })

  output$'711ShopView' <- renderGvis({
    gvisMap(get711Data(), "LatLong" , "Address", 
            options=list(showTip=TRUE, 
                         showLine=TRUE, 
                         enableScrollWheel=TRUE,
                         mapType='terrain', 
                         useMapTypeControl=TRUE))
  })
  
})
