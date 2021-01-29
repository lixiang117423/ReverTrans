# 提交成功显示
observeEvent(input$submit_qpcr, { 
  if (input$submit_qpcr>0) {
    sendSweetAlert(
      session = session,
      title = "提交成功!",
      text = "数据上传成功，参数设置正确",
      type = "success")
  }
})
# 导入数据
# 运行正常20210111
user_data_qpcr <- reactive({
  table_in_test <- data.table::fread(input$data_input_qpcr$datapath, encoding = 'UTF-8')

  table_in_test <<- table_in_test
})

# 下载示例数据
# 运行正常20210111
output$download_demo_data_qpcr <- downloadHandler(
  filename = '示例数据.csv',
  content = function(file){
    file.copy('./demo_data/示例数据.csv',file)
  }
)



# 展示统计分析结果
output$taboutput <- renderDataTable(df_table_qpcr(),
                                               options = list(
                                                 pageLength = 15
                                               ))

df_table_qpcr <- eventReactive(input$submit_qpcr,{
  if (input$submit_qpcr > 0) {
    df <- user_data_qpcr()
    df$所需RNA体积 = input$weight*1000/df$RNA浓度
    df$所需RNA体积 = round(df$所需RNA体积, 2)
    df$反转Mix体积 = input$weight/1*4
    df$gDNARemover体积 = input$weight/1*1
    df$ddH2O体积 = 20*input$weight - df$所需RNA体积 - df$反转Mix体积 - df$gDNARemover体积
    df$ddH2O体积 = round(df$ddH2O体积, 2)
    
    res <- df

    # 保存分析结果
    write.csv(res, file = './results/rest_tab.csv',row.names = FALSE)
    write.table(res, file = './results/rest_tab.txt',row.names = FALSE)
    xlsx::write.xlsx(res, file = './results/rest_tab.xlsx',row.names = FALSE)
    # 保存分析结果结束
  }
  res # 返回要展示的结果
})







# 下载分析结果
# 运行正常20210111
output$table_download <- downloadHandler(
  filename <- function(){
    paste(stringr::str_sub(input$data_input_qpcr$name,
                           1,
                           (nchar(input$data_input_qpcr$name) - 4)),
          '_统计分析结果',input$qpcr_stat_res_filetype,sep = ''
    )
  },
  content <- function(file){
    if (input$qpcr_stat_res_filetype == '.csv') {
      file.copy('./results/rest_tab.csv',file)
    }else if (input$qpcr_stat_res_filetype == '.txt') {
      file.copy('./results/rest_tab.txt',file)
    }else{
      #return(NULL)
      file.copy('./results/rest_tab.xlsx',file)
    }
  }
)