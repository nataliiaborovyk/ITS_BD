
-- 1. Quali sono i voli di durata maggiore della durata media di tutti i voli della stessa
-- compagnia? Restituire il codice del volo, la compagnia e la durata.

        -- solo durata
        select v1.codice, v1.comp, v1.durataminuti
        from volo v1
        where v1.durataminuti > (
            select round(avg(durataminuti)) as durata_media_per_comp
            from volo v2
            where v2.comp = v1.comp
        );

        -- durata media per compania
        select v2.comp, round(avg(durataminuti)) as durata_media_per_comp
        from volo v2
        group by v2.comp;


with medie as (
    select v2.comp as compagnia, round(avg(durataminuti)) as durata_media_per_comp
    from volo v2
    group by v2.comp
)
select v1.codice, v1.comp, v1.durataminuti, medie.durata_media_per_comp
from volo v1, medie
where v1.durataminuti > (
    select round(avg(durataminuti)) as durata_media_per_comp
	from volo v2
    where v2.comp = v1.comp and medie.compagnia = v2.comp
);


-- 2. Quali sono le città che hanno piu” di un aeroporto e dove almeno uno di questi ha
-- un volo operato da “Apitalia”?

-- citta ?
-- con almeno 2 aeroporti
--   dove almeno uno di aeroporti ha volo da 'Apitalia'

select la.citta
from arrpart ap, luogoaeroporto la
where ap.partenza = la.aeroporto or ap.arrivo = la.aeroporto
	and ap.comp = 'Apitalia'
group by la.citta
having count(distinct la.aeroporto) > 1;


-- 3. Quali sono le coppie di aeroporti (A, B) tali che esistono voli tra A e B ed il numero
-- di voli da A a B è uguale al numero di voli da B ad A?

with
num_A_B as (
    select ap1.partenza, ap1.arrivo, count(*) as num_a_b
    from arrpart ap1
    group by ap1.partenza, ap1.arrivo
)
select ap2.partenza, ap2.arrivo, count(*) as num_voli
from num_A_B n, arrpart ap2
where ap2.arrivo = n.partenza
    and ap2.partenza = n.arrivo
group by ap2.partenza, ap2.arrivo,  n.num_a_b
having count(*) = n.num_a_b;



-- 4. Quali sono le compagnie che hanno voli con durata media maggiore della durata
-- media di tutte le compagnie?

-- compania ?
-- media per comp
-- media tot

with 
m_tot as (
    select round(avg(v1.durataminuti)) as media_tot
    from volo v1
)
select v2.comp, round(avg(v2.durataminuti))
from volo v2, m_tot mt
group by v2.comp, mt.media_tot
having round(avg(v2.durataminuti)) > mt.media_tot;



-- 5. Quali sono gli aeroporti da cui partono voli per almeno 2 nazioni diverse?

select ap1.codice, v1.codice as v1, v2.codice as v2, la1.nazione, la2.nazione
from arrpart v1, aeroporto ap1, luogoaeroporto la1, arrpart v2, luogoaeroporto la2
where
    v1.partenza = ap1.codice
    and v2.partenza = ap1.codice
    and v1.arrivo = la1.aeroporto
    and v2.arrivo = la2.aeroporto
    and la1.nazione <> la2.nazione;




-- aeroporti partenza?
-- tali che aeroporti arrivo in almeno 2 nazioni diversi

-- versione a
select la1.aeroporto, count(distinct la2.nazione) as num_naz_arriv_diverse
from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
where ap.partenza = la1.aeroporto
    and ap.arrivo = la2.aeroporto
group by la1.aeroporto
having count(distinct la2.nazione) >= 2;

-- versione b
select ap.partenza, count(distinct la2.nazione) as num_naz_arriv_diverse
from arrpart ap
    join luogoaeroporto la2
        on ap.arrivo = la2.aeroporto
group by ap.partenza
having count(distinct la2.nazione) >= 2;

-- versione c
from arrpart v1, aeroporto ap1, luogoaeroporto la1, arrpart v2, luogoaeroporto la2
where
    v1.partenza = ap1.codice
    and v2.partenza = ap1.codice
    and v1.arrivo = la1.aeroporto
    and v2.arrivo = la2.aeroporto
    and la1.nazione <> la2.nazione;


-- versione d
select la1.aeroporto, count(distinct la2.nazione)
from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
where ap.partenza = la1.aeroporto
    and ap.arrivo = la2.aeroporto
	and la1.nazione <> la2.nazione  -- condizione in piu, nazione partenza e arrivo diversi
group by la1.aeroporto
having count(distinct la2.nazione) >= 2;


-- 6. Quali sono i voli che partono dalle città con un unico aeroporto? 
-- Restituire codice dei voli, compagnie, e gli aeroporti di partenza e di arrivo.

-- voli ?
-- da cita con unico aeroporto


        -- citta con unico aeroporto
        select la.citta
        from luogoaeroporto la
        where not exists (
            select 1
            from luogoaeroporto la1
            where la.citta = la1.citta
                and la.aeroporto <> la1.aeroporto
        );

with 
citta_aerop as (
select la.citta
from luogoaeroporto la
where not exists (
    select 1
    from luogoaeroporto la1
    where la.citta = la1.citta
        and la.aeroporto <> la1.aeroporto
)
)
select ap.codice, ap.comp, ap.partenza, ap.arrivo
from arrpart ap, luogoaeroporto la, citta_aerop ca
where ap.partenza = la.aeroporto
    and la.citta = ca.citta;



-- 7. Quali sono gli aeroporti raggiungibili dall’aeroporto “JFK” tramite voli diretti e
-- indiretti?

-- aeroporti di arrivo ?
--  dal aeroporto 'JFK'
--      tramite voli diretti e indiretti

        -- diretti
        select distinct ap.arrivo
        from arrpart ap
        where ap.partenza = 'JFK';

        -- con scalo tutta info
        select distinct
            ap1.codice as volo1,
            ap1.comp as compagnia,
            ap1.partenza as aerop_partenza,
            ap2.codice as volo2,
            ap1.arrivo as aerop_scalo,
            ap2.arrivo as aerop_arrivo
        from arrpart ap1, arrpart ap2
        where ap1.arrivo = ap2.partenza
            and ap1.partenza = 'JFK'
        order by ap1.codice;

        -- con scalo (solo 1)    ???????????
        select distinct
            ap2.arrivo as aerop_raggiungibili 
        from arrpart ap1, arrpart ap2
        where ap1.arrivo = ap2.partenza
            and ap1.partenza = 'JFK';

-- senza join
select distinct t1.aerop_raggiungibili
from (
    select distinct ap.arrivo as aerop_raggiungibili
    from arrpart ap
    where ap.partenza = 'JFK'
union
    select distinct
    ap2.arrivo as aerop_raggiungibili 
    from arrpart ap1, arrpart ap2
    where ap1.arrivo = ap2.partenza
        and ap1.partenza = 'JFK'
) as t1;

-- con join
select distinct t1.aerop_raggiungibili
from (
    select distinct ap.arrivo as aerop_raggiungibili
    from arrpart ap
    where ap.partenza = 'JFK'
union
    select distinct
    ap2.arrivo as aerop_raggiungibili 
    from arrpart ap1
        join arrpart ap2
            on ap1.arrivo = ap2.partenza
            and ap1.partenza = 'JFK'
    where ap1.partenza = 'JFK'
) as t1;


-- 8. Quali sono le città raggiungibili con voli diretti e indiretti partendo da Roma?

        -- diretti
        select distinct la2.citta
        from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
        where ap.partenza = la1.aeroporto 
            and ap.arrivo = la2.aeroporto
            and la1.citta = 'Roma';

        -- diretti info
        select  ap.codice, ap.comp, ap.partenza, la1.citta, ap.arrivo, la2.citta
        from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
        where ap.partenza = la1.aeroporto 
            and ap.arrivo = la2.aeroporto
            and la1.citta = 'Roma';

        -- scalo (1 solo)
        select distinct la2.citta
        from arrpart ap1, arrpart ap2, luogoaeroporto la1, luogoaeroporto la2
        where ap1.partenza = la1.aeroporto
            and ap1.arrivo = ap2.partenza
            and ap2.arrivo = la2.aeroporto
            and la1.citta = 'Roma';

        -- scalo info
        select ap1.codice as volo1,
            ap1.comp as compagnia,
            ap1.partenza as aerop_partenza,
            la1.citta as citta_part,
            ap2.codice as volo2,
            ap1.arrivo as aerop_scalo,
            ap2.arrivo as aerop_arrivo,
            la2.citta as citta_part
        from arrpart ap1, arrpart ap2, luogoaeroporto la1, luogoaeroporto la2
        where ap1.partenza = la1.aeroporto
            and ap1.arrivo = ap2.partenza
            and ap2.arrivo = la2.aeroporto
            and la1.citta = 'Roma';  

--senza join
select distinct t1.citta
from (
    select distinct la2.citta
    from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
    where ap.partenza = la1.aeroporto 
        and ap.arrivo = la2.aeroporto
        and la1.citta = 'Roma'
union
    select distinct la2.citta
    from arrpart ap1, arrpart ap2, luogoaeroporto la1, luogoaeroporto la2
    where ap1.partenza = la1.aeroporto
        and ap1.arrivo = ap2.partenza
        and ap2.arrivo = la2.aeroporto
        and la1.citta = 'Roma'
) as t1;

-- con join
select distinct t1.citta
from (
    select distinct la2.citta
    from arrpart ap
        join luogoaeroporto la1
            on ap.partenza = la1.aeroporto
        join luogoaeroporto la2
            on ap. arrivo = la2.aeroporto
            and la1.citta = 'Roma'
union
    select distinct la2.citta
    from arrpart ap1
        join arrpart ap2
            on ap1.arrivo = ap2.partenza
        join luogoaeroporto la1
            on ap1.partenza = la1.aeroporto
        join luogoaeroporto la2
            on ap2.arrivo = la2.aeroporto
            and la1.citta = 'Roma' 
) as t1;


-- 9. Quali sono le città raggiungibili con esattamente uno scalo intermedio partendo
-- dall’aeroporto “JFK”?

select distinct la2.citta
from arrpart ap1, arrpart ap2, luogoaeroporto la2
where ap1.arrivo = ap2.partenza
    and ap2.arrivo = la2.aeroporto
    and ap1.partenza = 'JFK';