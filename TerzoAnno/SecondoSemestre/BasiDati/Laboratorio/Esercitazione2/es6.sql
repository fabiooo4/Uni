select *
    from Mostra
    where CURRENT_DATE < fine
    order by inizio, fine;
