library(dplyr)

annee=2021

#full files : https://www.data.gouv.fr/fr/datasets/demandes-de-valeurs-foncieres/
file_name=paste0("./valeursfoncieres-",annee,".txt")
df<-read.csv2(file_name,sep='|') %>% 
  mutate(ID=paste0(Code.departement,Code.commune,Prefixe.de.section,Section,No.plan,Date.mutation)) %>% 
  filter(Nature.mutation %in% c("Vente"))%>% 
  filter(Type.local %in% c("Maison","Appartement")) %>% 
  filter(Surface.reelle.bati>9) %>% 
  filter(Valeur.fonciere>5000 & Valeur.fonciere<10000000) %>% 
  distinct

filtre.lots<-df %>% group_by(ID) %>% summarise(nb.lots=n()) %>% filter(nb.lots<=3)

df %>% 
 select(ID,Type.local,Date.mutation,Code.postal,Code.commune,Commune,Surface.reelle.bati,Valeur.fonciere,Nombre.pieces.principales,Surface.terrain) %>% 
 inner_join(filtre.lots,by="ID")%>% 
 write.csv2(paste0("./valeursfoncieres-prep-",annee,".txt"),row.names = FALSE)
