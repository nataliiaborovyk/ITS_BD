-- 1. Qual è la durata media, per ogni compagnia, dei voli che partono da un aeroporto
-- situato in Italia?
select ap.comp,  round(avg(v.durataminuti))
from volo v, arrpart ap, aeroporto a, luogoaeroporto la
where ap.partenza = a.codice
    and a.codice = la.aeroporto
    -- and ap.partenza = la.aeroporto -- salto aeroporto
    and ap.codice = v.codice
    and ap.comp = v.comp
    and la.nazione = 'Italy'
group by ap.comp;



-- 2. Quali sono le compagnie che operano voli con durata media maggiore della durata
-- media di tutti i voli?
with media_tot as (
    select round(avg(durataminuti)) as avg_tot
    from volo
)
select ap.comp, round(avg(v.durataminuti)) as durata_voli_media
from arrpart ap, volo v, media_tot t1
where ap.codice = v.codice
    and ap.comp = v.comp
group by ap.comp, t1.avg_tot
having round(avg(v.durataminuti)) > t1.avg_tot


-- 3. Quali sono le città dove il numero totale di voli in arrivo è maggiore del numero
-- medio dei voli in arrivo per ogni città?
with 
num_voli as (
    select la.citta, count(ap.codice) as num_voli_arrivo
        from volo v, arrpart ap, aeroporto a, luogoaeroporto la
    where ap.arrivo = a.codice
        and a.codice = la.aeroporto
        -- and ap.partenza = la.aeroporto -- salto aeroporto
        and ap.codice = v.codice
        and ap.comp = v.comp
    group by la.citta
), 
avg_tot as (
    select round(avg(num_voli_arrivo), 2) as avg_voli_tot
    from num_voli
)
select t1.citta
from num_voli t1, avg_tot t2
where t1.num_voli_arrivo > t2.avg_voli_tot

-- 4. Quali sono le compagnie aeree che hanno voli in partenza da aeroporti in Italia con
-- una durata media inferiore alla 
-- durata media di tutti i voli in partenza da aeroporti  in Italia?

with durata_media_tot as (
    select round(avg(v.durataminuti)) as media_durata_tot
    from arrpart ap, luogoaeroporto la, volo v
    where ap.partenza = la.aeroporto
        and ap.codice = v.codice
        and ap.comp = v.comp
        and la.nazione = 'Italy'
)
select  ap.comp, round(avg(v.durataminuti)) as media_durata_voli
from arrpart ap, luogoaeroporto la, volo v, durata_media_tot dm
where ap.partenza = la.aeroporto
    and ap.codice = v.codice
    and ap.comp = v.comp
    and la.nazione = 'Italy'
group by ap.comp, dm.media_durata_tot -- non va incluso v.durataminuti 
having round(avg(v.durataminuti)) < dm.media_durata_tot   -- no! perche?


with 
durata_media_tot as (
    select round(avg(v.durataminuti)) as media_durata_tot
    from arrpart ap, luogoaeroporto la, volo v
    where ap.partenza = la.aeroporto
        and ap.codice = v.codice
        and ap.comp = v.comp
        and la.nazione = 'Italy'
),
durata_media_comp as (
    select ap.comp, round(avg(v.durataminuti)) as media_durata_voli
    from arrpart ap, luogoaeroporto la, volo v
    where ap.partenza = la.aeroporto
        and ap.codice = v.codice
        and ap.comp = v.comp
        and la.nazione = 'Italy'
    group by ap.comp
)
select dmc.comp, dmc.media_durata_voli
from durata_media_tot dmt, durata_media_comp dmc
where dmc.media_durata_voli < dmt.media_durata_tot  -- si




-- 5. Quali sono le città 
-- i cui voli in arrivo 
-- hanno una durata media che differisce di più di una deviazione standard 
-- dalla durata media di tutti i voli? 
-- Restituire città e durate medie dei voli in arrivo.
-- mt - m > devst 

with
media_tot as (
select round(avg(v.durataminuti)) as media_tot
from volo v
),
dev_stand as (
select round(stddev(v.durataminuti)) as deviazione_standart
from volo v
)
select la.citta as citta_arrivo, round(avg(v.durataminuti))  as media_durata_voli,
    mt.media_tot as media_tot_voli,
    ds.deviazione_standart 
from arrpart ap, luogoaeroporto la, volo v, media_tot mt, dev_stand ds
where ap.arrivo = la.aeroporto 
    and ap.codice = v.codice
    and ap.comp = v.comp
group by la.citta,  mt.media_tot, ds.deviazione_standart
having mt.media_tot - round(avg(v.durataminuti)) > ds.deviazione_standart



-- 6. Quali sono le nazioni che hanno il maggior numero di città dalle quali partono voli
-- diretti in altre nazioni?


-- num citta a quali arrivano
with 
numero_cit as (
    select la1.nazione, count(distinct la2.citta) filter (where la1.nazione <> la2.nazione) as num_citta
    from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
    where ap.partenza = la1.aeroporto
        and ap.arrivo = la2.aeroporto
        -- and la1.nazione <> la2.nazione
    group by la1.nazione
),
max as (
    select max(num_citta)
    from numero_cit
)
select nc.nazione, nc.num_citta
from numero_cit nc, max m
where nc.num_citta = m.max


-- citta partenza -> arrivo
select ap.codice, la1.nazione as naz_partenza, la2.nazione as naz_arrivo,
    la1.citta as citta_part, la2.citta as citta_arrivo
from arrpart ap, luogoaeroporto la1, luogoaeroporto la2
where ap.partenza = la1.aeroporto
	and ap.arrivo = la2.aeroporto
    