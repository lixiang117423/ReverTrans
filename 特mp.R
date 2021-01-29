df = data.table::fread('./demo_data/示例数据.csv',encoding = 'UTF-8')

df$所需RNA体积 = input$weight*1000/df$RNA浓度
df$反转Mix = input$weight/1*4
df$gDNARemover = input$weight/1*1
df$ddH2O = 20*input$weight - df$所需RNA体 - df$反转Mix - df$gDNARemover
