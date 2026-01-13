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
-- una durata media inferiore alla durata media di tutti i voli in partenza da aeroporti
-- in Italia?


-- 5. Quali sono le città i cui voli in arrivo hanno una durata media che differisce di più
-- di una deviazione standard dalla durata media di tutti i voli? Restituire città e
-- durate medie dei voli in arrivo.


-- 6. Quali sono le nazioni che hanno il maggior numero di città dalle quali partono voli
-- diretti in altre nazioni?