select
    avg(orarioChiusura::time) - avg(orarioApertura::time) as mediaApertura
    from Orario
        join Museo on (Orario.museo = Museo.nome and Orario.città = Museo.città)
    where Museo.nome = 'Arena'
        and Museo.città = 'Verona'
        and Orario.giorno <> Museo.giornoChiusura;
