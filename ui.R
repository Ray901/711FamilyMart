
familyDat <- read.csv("familyShopData.csv")
sevenElevenDat <- read.csv("711ShopData.csv")

shinyUI(
  navbarPage(id = "tabpages","查詢便利商店位置",
             tabPanel("全家地圖",sidebarLayout(
               sidebarPanel(  
                 width=2,
                 conditionalPanel(
                   condition = "input.tabpages == '全家地圖'",
                   selectInput("familyCitySelect", "選取縣市", 
                               choices = unique(substr(familyDat$addr,1,3)),
                               selected = "台北市"
                   ),
                   checkboxGroupInput(
                     "familyFactCheckBox","設施條件",
                     c("WiFi","COFFEE","夯蕃薯","霜淇淋雙口味","霜淇淋單口味","廁所","休憩區","停車場")
                   ),
                   actionButton("familySearch","查詢")
                 )
               ),
               mainPanel(                 
                 htmlOutput("familyShopView")                
               )
              )               
             ),
             tabPanel("711地圖",sidebarLayout(
               sidebarPanel(  
                 width=2,
                 conditionalPanel(
                   condition = "input.tabpages == '711地圖'",
                   selectInput("711CitySelect", "選取縣市", 
                               choices = unique(substr(sevenElevenDat$Address,1,3)),
                               selected = "台北市"
                   ),
                   checkboxGroupInput(
                     "711FactCheckBox","設施條件",
                     c("座位區","停車場","廁所","ATM",
                       "7Wifi","思樂冰","沙拉bar大亨堡","千禧健康小站",
                       "霜淇淋","OpenStore","生鮮蔬果","CityCafe",
                       "刷卡服務","台塑有機蔬菜","黃金玉米","美妝",
                       "無印良品","MisterDonuts甜甜圈")
                   ),
                   actionButton("711Search","查詢")
                 )
               ),
               mainPanel(                 
                 htmlOutput("711ShopView")                
               )
              )               
             )
  )                  
)
