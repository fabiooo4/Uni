select titolo, fine - CURRENT_DATE as giorni_rimanenti
    from Mostra
    where CURRENT_DATE < fine;
