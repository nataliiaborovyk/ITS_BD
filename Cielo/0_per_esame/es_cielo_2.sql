-- 1. Quante sono le compagnie che operano (sia in arrivo che in partenza) 
-- nei diversi aeroporti?
select a.codice, count(distinct comp) as num_comp
from arrpart ap, aeroporto a
where ap.partenza = a.codice or ap.arrivo = a.codice
group by a.codice
order by num_comp  -- posso usare alias perche order by viene eseguito dopo il select

-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ 
-- e hanno una durata di almeno 100 minuti?
select  count(v.codice)
from arrpart ap, volo v
where ap.codice = v.codice
    and ap.comp = v.comp
    and ap.partenza = 'HTR'
    and v.durataminuti >= 100


-- 3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, 
-- per ogni nazione nella quale opera?
select la.nazione, count(distinct a.codice) as num_aeroporti_per_nazione
from arrpart ap, aeroporto a, luogoaeroporto la
where (ap.partenza = a.codice or ap.arrivo = a.codice)
     and a.codice = la.aeroporto
     and ap.comp = 'Apitalia'
group by la.nazione
order by num_aeroporti_per_nazione

-- 4. Qual è la media, il massimo e il minimo della durata dei voli 
-- effettuati dalla compagnia ‘MagicFly’?
select comp as nome_cmpania,
    round(avg(durataminuti)) as durata_media_minuti,
    min(durataminuti) as durata_minima_minuti,
    max(durataminuti) as durata_massima_minuti
from volo 
where comp = 'MagicFly'
group by comp

    -- quali sono i voli con max_durata?
    with stat as (
        select comp as nome_cmpania,
        round(avg(durataminuti)) as durata_media_minuti,
        min(durataminuti) as durata_minima_minuti,
        max(durataminuti) as durata_massima_minuti
        from volo 
        where comp = 'MagicFly'
        group by comp
    )
    select v.codice, v.durataminuti, ap.partenza, ap.arrivo
    from volo v, stat s, arrpart ap
    where v.durataminuti = s.durata_massima_minuti
        and ap.codice = v.codice
        and ap.comp = v.comp


-- 5. Qual è l’anno di fondazione della compagnia più vecchia 
-- che opera in ognuno degli aeroporti?
select min(c.annofondaz)
from aeroporto a, compagnia c, arrpart ap, volo v
where (ap.arrivo = a.codice or ap.partenza = a.codice)
    and ap.codice = v.codice
    and ap.comp = v.comp
    and v.comp = c.nome

-- quale è la compania, con anno di fondazione piu vecchio, in ognuno di aeroporti?
select distinct a.codice, ap.comp, c.annofondaz
from aeroporto a, compagnia c, arrpart ap, volo v
where (ap.arrivo = a.codice or ap.partenza = a.codice)
    and ap.codice = v.codice
    and ap.comp = v.comp
    and v.comp = c.nome
    and c.annofondaz = (
        -- sottoquery correlata perche uso "a" da query esterna
        select min(c1.annofondaz)
        from compagnia c1, arrpart ap1, volo v1
        where (ap1.arrivo = a.codice or ap1.partenza = a.codice)
            and ap1.codice = v1.codice
            and ap1.comp = v1.comp
            and v1.comp = c1.nome
    )
order by c.annofondaz;

-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione 
-- tramite uno o più voli?

-- volo diretto
select la1.nazione, count(distinct la2.nazione) filter (where la1.nazione <> la2.nazione)
from arrpart ap, aeroporto a1, aeroporto a2,
    luogoaeroporto la1, luogoaeroporto la2
where ap.partenza = a1.codice
    and a1. codice = la1.aeroporto
    and ap.arrivo = a2.codice
    and a2.codice = la2.aeroporto
group by la1.nazione 
-- prima creo i gruppi e poi per ogni gruppo facio i calcoli.
-- cosi non escludo la nazione che non ha voli verso altri nazioni


-- 7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?
select ap.partenza, round(avg(v.durataminuti))
from arrpart ap, volo v
where ap.codice = v.codice
    and ap.comp = v.comp
group by ap.partenza


-- 8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie 
-- fondate a partire dal 1950?
select c.nome as nome_compagnia,
     sum(v.durataminuti) as durata_comples_voli
from volo v, compagnia c
where v.comp = c.nome
    and c.annofondaz >= 1950
group by c.nome

-- 9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?
select a.codice
from arrpart ap, aeroporto a
where (ap.arrivo = a.codice or ap.partenza = a.codice)
group by a.codice
having count(distinct ap.comp) = 2
-- se non metto distinct e come se scrivo having count(*) = 2
    -- quindi conto quntita di righe nei gruppi e non compagnie diverse

-- 10. Quali sono le città con almeno due aeroporti?
select la.citta, count(distinct la.aeroporto)
from luogoaeroporto la
group by la.citta
having count(distinct la.aeroporto) >= 2

-- 11. Qual è il nome delle compagnie i cui voli hanno una durata 
-- media maggiore di 6 ore?
select c.nome, round(avg(v.durataminuti)) as durata_media_voli
from compagnia c, volo v
where v.comp = c.nome
group by c.nome
having avg(v.durataminuti) > 360


-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una durata 
-- maggiore di 100 minuti?
select c.nome, min(v.durataminuti) as durata_minima
from compagnia c, volo v
where v.comp = c.nome
group by c.nome
having min(v.durataminuti) > 100;


-- 13 Quali sono gli aeroporti che non hanno i voli?

select a.codice
from aeroporto a
where a.codice not in (
    select distinct a.codice  
    from arrpart ap, aeroporto a  -- ridefinisco "a"
    where (ap.arrivo = a.codice or ap.partenza = a.codice)
    )