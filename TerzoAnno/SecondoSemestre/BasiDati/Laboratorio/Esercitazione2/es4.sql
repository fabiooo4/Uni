select Museo.nome, orarioApertura, orarioChiusura
    from Orario
        join Museo on (Orario.museo = Museo.nome and Orario.città = Museo.città)
    where Orario.giorno = 'martedì'
        and Museo.giornoChiusura != 'martedì';
