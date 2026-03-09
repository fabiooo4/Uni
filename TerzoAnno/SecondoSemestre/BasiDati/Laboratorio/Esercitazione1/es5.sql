alter table Museo
    add column sitoInternet char varying(100);

update Museo
    set sitoInternet = 'www.arena.it'
    where nome = 'Arena' and città = 'Verona';

update Museo
    set sitoInternet = 'www.castelvecchio.it'
    where nome = 'CastelVecchio' and città = 'Verona';
