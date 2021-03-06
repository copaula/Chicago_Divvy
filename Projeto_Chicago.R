#Projeto DIVVY DATA
#Este projeto trabalharemos com dados historicos do servi�o de aluguel de bicicletas da
#cidade de CHICAGO ( ride.divvybikes.com/system-data)
# No site KAGGLE encontramos os dados de 2013 e 2017 em arquivos .csv e os tamb�m dados relativos ao clima neste mesmo periodo.


install.packages("data.table")
library(data.table)


chicago_ciclistas<-fread("data\\data_raw",fill=TRUE)

# fun��o order aplicada dentro do data.table

chicago_ciclistas<-chicago_ciclistas[order(tripduration)]

# Excluindo NA's do banco

chicago_ciclistas[!is.na(starttime)]


# Fazendo um corte nos dados
# Fazendo um subset

sexo_masculino<-chicago_ciclistas[gender=="Male"]
View(sexo_masculino)
#viagens acima de 180 segundos

viagem_longa<-chicago_ciclistas[tripduration>180]

# Unindo os dois casos

viagem_longa<-chicago_ciclistas[tripduration>180 & gender=="male"]

# Apenas uma informa��o de usu�rio

apenas_um_id<-chicago_ciclistas[!duplicated(trip_id)]
View(apenas_um_id)

# Apenas uma informa��o de usu�rio por dia

informacao_usuario_dia<- chicago_ciclistas[,c("trip_id","starttime")]

apenas_uma_informacao_dia<-chicago_ciclistas[!duplicated(informacao_usuario_dia)]

#Criando uma vari�vel
## O data.table permite a cria��o de novas vari�veis usando o formato :=,
## que combinado com a fun��o By pode fazer manipula��es interessantes.


chicago_ciclistas[,tempo_viagem:=starttime-stoptime]

# Utilizando o by podemos criar um tempo m�dio por sexo.
# criando a vari�vel media de viagem por sexo e selecionando as 10 primeiras linhas observadas


chicago_ciclistas[,media_viagem_sexo:=mean(tripduration),by=gender][1:10,c("gender","media_viagem_sexo")]

#Trabalhando com resumo de dados (.N)
#resumo de quantas viagens foram feitas entre duas esta��es


chicago_ciclistas[,.N,by=c("from_station_name","to_station_name")]

#Vamos agora em um c�digo vincular o tempo m�dio de viagem e o clima


chicago_ciclistas[,media_viagem_condicao_clima_0_1:=mean(tripduration),
                  by=c("events","gender")][,.N,by=c("events","media_viagem_condicao_clima_0_1","gender")][order(-N)]
