insert into Orario
values (1, 'Arena', 'Verona', 'lunedì', '13:00 CET', '19:00 CET'),
       (2, 'CastelVecchio', 'Verona', 'venerdì', '09:00 CET', '19:00 CET'),
       (3, 'Arena', 'Verona', 'mercoledì', '09:00 CET', '19:00 CET');


select * from Museo;
select * from Mostra;

update Museo
  set nome = 'Arena di Verona'
  where nome = 'Arena';

select * from Museo;
select * from Mostra;
select * from Opera;
select * from Orario;

delete from Museo
  where nome = 'Arena di Verona';

select * from Museo;
select * from Mostra;
select * from Opera;
select * from Orario;
