
-- quanti postoggetti hanno un feedback?

select count(commento)
from postoggetto
where ha_feedback = true


select count(pubblica)
from postoggetto
where ha_feedback = true

select count(distinct pubblica)
from postoggetto
where ha_feedback = true

-- restituire le aste che hanno feedback

select a.postrogetto
from asta a, postoggetto po
where 
    a.postoggetto = po.id
    and po.ha_feedback = true

-- aste e comprasubito che hanno feedback

SELECT 'asta' AS tipo, a.postoggetto AS id
FROM asta a, postoggetto po
WHERE po.id = a.postoggetto
  AND po.ha_feedback = true

UNION ALL

SELECT 'compralosubito' AS tipo, c.postoggetto AS id
FROM compralosubito c, postoggetto po
WHERE po.id = c.postoggetto
  AND po.ha_feedback = true;



-- quali aste e comprasubito hanno voto, ragruppa per voto

select voto, count(*) as appare
from(
    select po.voto
    from asta a, postoggetto po
    where a.postoggetto = po.id
        and po.voto is not null
    
    union all

    select po.voto
    from compralosubito cs, postoggetto po
    where cs.postoggetto = po.id
        and po.voto is not null
) 
group by voto;