insert into Museo (nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo, sitoInternet)
values
('Uffizi', 'Firenze', 'Piazzale degli Uffizi 6', '055 2388651', 'lunedì', 25, 'www.uffizi.it'),
('Musei Vaticani', 'Roma', 'Viale Vaticano', '06 69884676', 'domenica', 17, 'www.museivaticani.va'),
('Egizio', 'Torino', 'Via Accademia delle Scienze 6', '011 5617776', 'lunedì', 15, 'www.museoegizio.it'),
('Brera', 'Milano', 'Via Brera 28', '02 722631', 'lunedì', 15, 'pinacotecabrera.org'),
('MANN', 'Napoli', 'Piazza Museo 19', '081 4422149', 'martedì', 18, 'www.mannapoli.it'),
('Guggenheim', 'Venezia', 'Dorsoduro 701', '041 2405411', 'martedì', 16, 'www.guggenheim-venice.it'),
('Reale', 'Torino', 'Piazzetta Reale 1', '011 4361455', 'lunedì', 15, 'www.museireali.beniculturali.it'),
('Borghese', 'Roma', 'Piazzale Scipione Borghese 5', '06 8413979', 'lunedì', 13, 'galleriaborghese.beniculturali.it'),
('Capodimonte', 'Napoli', 'Via Miano 2', '081 7499111', 'mercoledì', 12, 'www.museocapodimonte.beniculturali.it'),
('MAMbo', 'Bologna', 'Via Don Giovanni Minzoni 14', '051 6496611', 'lunedì', 6, 'www.mambo-bologna.org');

insert into Opera (nome, cognomeAutore, nomeAutore, museo, città, epoca, anno)
values
('Nascita di Venere', 'Botticelli', 'Sandro', 'Uffizi', 'Firenze', 'Rinascimento', 1485),
('Primavera', 'Botticelli', 'Sandro', 'Uffizi', 'Firenze', 'Rinascimento', 1482),
('Scuola di Atene', 'Sanzio', 'Raffaello', 'Musei Vaticani', 'Roma', 'Rinascimento', 1511),
('Giudizio Universale', 'Buonarroti', 'Michelangelo', 'Musei Vaticani', 'Roma', 'Rinascimento', 1541),
('Statua di Ramesse II', 'Sconosciuto', 'Egizio', 'Egizio', 'Torino', 'Antico Egitto', -1279),
('Sposalizio della Vergine', 'Sanzio', 'Raffaello', 'Brera', 'Milano', 'Rinascimento', 1504),
('Cristo Velato', 'Sanmartino', 'Giuseppe', 'Capodimonte', 'Napoli', 'Barocco', 1753),
('Apollo e Dafne', 'Bernini', 'Gian Lorenzo', 'Borghese', 'Roma', 'Barocco', 1625),
('L''Impero dei Lumi', 'Magritte', 'René', 'Guggenheim', 'Venezia', 'Surrealismo', 1954),
('Toro Farnese', 'Sconosciuto', 'Ellenismo', 'MANN', 'Napoli', 'Classica', -200);

insert into Mostra (titolo, inizio, fine, museo, città, prezzoIntero, prezzoRidotto)
values
('Leonardo e il Disegno', '2026-03-01', '2026-06-01', 'Uffizi', 'Firenze', 18, 10),
('Egitto Invisibile', '2026-04-15', '2026-10-15', 'Egizio', 'Torino', 20, 12),
('Raffaello a Milano', '2026-01-10', '2026-05-10', 'Brera', 'Milano', 15, 8),
('Pompei ed Ercolano', '2026-05-20', '2026-12-20', 'MANN', 'Napoli', 14, null),
('Futurismo Veneziano', '2026-02-01', '2026-04-30', 'Guggenheim', 'Venezia', 12, 6),
('Caravaggio e i suoi', '2026-09-01', '2026-12-31', 'Borghese', 'Roma', 16, 9),
('Pop Art Italiana', '2026-06-15', '2026-09-15', 'MAMbo', 'Bologna', 10, 5),
('I Tesori dei Papi', '2026-03-10', '2026-07-10', 'Musei Vaticani', 'Roma', 22, null),
('Napoli Sotto i Borbone', '2026-01-20', '2026-04-20', 'Capodimonte', 'Napoli', 13, 7),
('Savoia Re d''Italia', '2026-05-01', '2026-08-31', 'Reale', 'Torino', 15, 8);

insert into Orario (progressivo, museo, città, giorno, orarioApertura, orarioChiusura)
values
(4, 'Uffizi', 'Firenze', 'lunedì', '08:15 CET', '18:30 CET'),
(5, 'Musei Vaticani', 'Roma', 'martedì', '09:00 CET', '18:00 CET'),
(6, 'Egizio', 'Torino', 'mercoledì', '09:00 CET', '18:30 CET'),
(7, 'Brera', 'Milano', 'giovedì', '08:30 CET', '19:15 CET'),
(8, 'MANN', 'Napoli', 'venerdì', '09:00 CET', '19:30 CET'),
(9, 'Guggenheim', 'Venezia', 'sabato', '10:00 CET', '18:00 CET'),
(10, 'Borghese', 'Roma', 'domenica', '09:00 CET', '19:00 CET'),
(11, 'MAMbo', 'Bologna', 'lunedì', '10:00 CET', '20:00 CET'),
(12, 'Capodimonte', 'Napoli', 'martedì', '08:30 CET', '19:30 CET'),
(13, 'Reale', 'Torino', 'mercoledì', '09:00 CET', '19:00 CET');

-- Esercizio 1
select nome, giornoChiusura
    from Museo
    where città = 'Verona';

-- Esercizio 2
select titolo || ' nella città di ' || città
    from Mostra
    where titolo like 'R%';

-- Esercizio 3
select titolo, fine - CURRENT_DATE as giorni_rimanenti
    from Mostra
    where CURRENT_DATE < fine;

-- Esercizio 4
select Museo.nome, orarioApertura, orarioChiusura
    from Orario
        join Museo on (Orario.museo = Museo.nome and Orario.città = Museo.città)
    where Orario.giorno = 'martedì'
        and Museo.giornoChiusura != 'martedì';

-- Esercizio 5
select *
    from Mostra
    where prezzoRidotto = null;

select *
    from Mostra
    where prezzoRidotto is null;

-- Esercizio 6
select *
    from Mostra
    where CURRENT_DATE < fine
    order by inizio, fine;

-- Esercizio 7
select count(*) as giorniApertura
    from Orario
        join Museo on (Orario.museo = Museo.nome and Orario.città = Museo.città)
    where Museo.nome = 'Arena'
        and Museo.città = 'Verona'
        and Orario.giorno <> Museo.giornoChiusura;

-- Esercizio 8
select
    avg(orarioChiusura::time) - avg(orarioApertura::time) as mediaApertura
    from Orario
        join Museo on (Orario.museo = Museo.nome and Orario.città = Museo.città)
    where Museo.nome = 'Arena'
        and Museo.città = 'Verona'
        and Orario.giorno <> Museo.giornoChiusura;

-- Esercizio 9
select Museo.nome, count(distinct Opera.nomeAutore || ' ' || Opera.cognomeAutore) as numAutori
    from Museo
        join Opera on (Opera.museo = Museo.nome and Opera.città = Museo.città)
    group by Museo.nome
