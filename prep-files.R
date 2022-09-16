library(dplyr)

#full files : https://www.data.gouv.fr/fr/datasets/demandes-de-valeurs-foncieres/
file_name="./valeursfoncieres-2017.txt"
df<-read.csv2(file_name,sep='|')

df %>% 
  filter(Nature.mutation %in% c("Vente"))%>% 
  filter(Type.local %in% c("Maison","Appartement")) %>% 
  filter(Surface.reelle.bati>9) %>% 
  filter(Valeur.fonciere>5000 & Valeur.fonciere<10000000) %>% 
  select(Type.local,Date.mutation,Code.postal,Code.commune,Commune,Surface.reelle.bati,Valeur.fonciere,Nombre.pieces.principales,Surface.terrain) %>% 
  distinct %>%  #dedoublonnage 
  group_by(Type.local,Date.mutation,Code.commune,Code.postal,Commune) %>% 
  summarise(Surface.reelle.bati=sum(Surface.reelle.bati,na.rm=TRUE),
            Valeur.fonciere=max(Valeur.fonciere,na.rm=TRUE),
            nblots=n(),
            Nombre.pieces.principales=sum(Nombre.pieces.principales,na.rm=TRUE),
            Surface.terrain=sum(Surface.terrain,na.rm=TRUE)) %>% 
  ungroup %>% 
  filter(nblots<=3) %>% write.csv2("valeursfoncieres-2017-prep.txt",row.names = FALSE)
