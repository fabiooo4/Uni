select Museo.nome, count(distinct Opera.nomeAutore || ' ' || Opera.cognomeAutore) as numAutori
    from Museo
        join Opera on (Opera.museo = Museo.nome and Opera.città = Museo.città)
    group by Museo.nome
