# disponibilizar dados post -----------------------------------------------
require(RPostgreSQL)
require(dplyr)
drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, 
  dbname = "IQA",
  host = "localhost", 
  port = 5432,
  user = "postgres", 
  password = "bacia")

dbGetQuery(con,"SELECT * FROM ndagua") %>% 
  select(bacia, monit, data, epoca, class, rio, munic, od, dbo, cf, ph, ct, st, clod, cldbo, clcf, clst, clph, clct) %>% 
  mutate(id = stringr::word(monit ,1))  %>% 
  select(id, bacia:clct) %>% 
  write.csv(., file = "monitoramento.csv", sep = ",")
