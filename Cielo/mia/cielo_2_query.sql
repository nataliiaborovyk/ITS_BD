-- 1. Quante sono le compagnie che operano (sia in arrivo che in partenza) 
-- nei diversi aeroporti?

-- versione 1 - almeno un arrivo o una partenza
select a.codice, a.nome, count(distinct ap.comp) as num_companie
from arrpart ap, aeroporto a
where (ap.arrivo = a.codice or ap.partenza = a.codice)
group by a.codice;

-- versione 2 - sia in arrivo che in partenza
select a.codice, a.nome, count(distinct ap1.comp) as num_companie
from arrpart ap1, arrpart ap2, aeroporto a
where ap1.arrivo = a.codice
    and ap2.partenza = a.codice
    and ap1.comp = ap2.comp
group by a.codice;


-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ 
-- e hanno una durata di almeno 100 minuti?

select count(*)
from arrpart ap, volo v
where ap.codice = v.codice
    and ap.comp = v.comp
    and ap.partenza = 'HTR'
    and v.durataminuti >= 100;

-- 3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, 
-- per ogni nazione nella quale opera?

select la.nazione, count(distinct la.aeroporto) as num_aeroporti
from arrpart ap, aeroporto a, luogoaeroporto la
where la.aeroporto = a.codice
    and (a.codice = ap.partenza or a.codice = ap.arrivo)
    and ap.comp = 'Apitalia'
group by la.nazione;


-- 4. Qual è la media, il massimo e il minimo della durata dei voli 
-- effettuati dalla compagnia ‘MagicFly’?

select comp, round(avg(durataminuti)::numeric, 2) as media_durata,
    max(durataminuti) as max_durata, 
    min(durataminuti) as min_durata
from volo
where comp = 'MagicFly'
group by comp;



-- 5. Qual è l’anno di fondazione della compagnia più vecchia 
-- che opera in ognuno degli aeroporti?

    -- versione 1 
select a.codice as codice_aeroporto,
    a.nome as nome_aeroporto,
    min(c.annofondaz) as comp_piu_vechia_anno_fondaz
from compagnia c, volo v, arrpart ap, aeroporto a
where
    -- compagnia <==> volo
    c.nome = v.comp
    -- volo <==> arrpart
    and v.codice = ap.codice
    and v.comp = ap.comp
    -- arrpart <==> aeroporto
    and (ap.arrivo = a.codice or ap.partenza = a.codice)
group by a.codice;


    -- versione 2 con nome di compania piu vechia
select a.codice as codice_aeroporto,
    a.nome as nome_aeroporto,
    c.nome as nome_comp_piu_vechia,
    c.annofondaz as anno_fondaz
from compagnia c, volo v, arrpart ap, aeroporto a
where
    -- compagnia <==> volo
    c.nome = v.comp
    -- volo <==> arrpart
    and v.codice = ap.codice
    and v.comp = ap.comp
    -- arrpart <==> aeroporto
    and (ap.arrivo = a.codice or ap.partenza = a.codice)
    and c.annofondaz = (
                    select min(c1.annofondaz)
                    from compagnia c1, volo v1, arrpart ap1
                    where
                        -- compagnia <==> volo
                        c1.nome = v1.comp
                        -- volo <==> arrpart
                        and v1.codice = ap1.codice
                        and v1.comp = ap1.comp
                        -- arrpart <==> aeroporto
                        and (ap1.arrivo = a.codice or ap1.partenza = a.codice)
                    )
group by a.codice, c.nome;


    -- versione 3 con nome di compania piu vechia
select a.codice as codice_aeroporto,
    a.nome as nome_aeroporto,
    c.nome as nome_comp_piu_vechia,
    c.annofondaz as anno_fondaz
from compagnia c, volo v, arrpart ap, aeroporto a
where
    -- compagnia <==> volo
    c.nome = v.comp
    -- volo <==> arrpart
    and v.codice = ap.codice
    and v.comp = ap.comp
    -- arrpart <==> aeroporto
    and (ap.arrivo = a.codice or ap.partenza = a.codice)
group by a.codice, c.nome
having  c.annofondaz = (
                    -- sottoqueri per asegnare min ann_fond
                    select min(c1.annofondaz)
                    from compagnia c1, volo v1, arrpart ap1
                    where
                        -- compagnia <==> volo
                        c1.nome = v1.comp
                        -- volo <==> arrpart
                        and v1.codice = ap1.codice
                        and v1.comp = ap1.comp
                        -- arrpart <==> aeroporto
                        and (ap1.arrivo = a.codice or ap1.partenza = a.codice)
                    );



-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione 
-- tramite uno o più voli?

-- volo diretto
select la1.nazione as nazione_partenza,
    count(distinct la2.nazione) as num_nazioni_arivo
from luogoaeroporto la1, luogoaeroporto la2, 
	aeroporto a1, aeroporto a2, 
	arrpart ap
where -- luogoaeroporto 1 <==> aeroporto 1
    la1.aeroporto = a1.codice
    -- aeroporto 1 <==> arrpart partenza
    and a1.codice = ap.partenza 
        -- arrpart arrivo <==> aeroporto 2
    and ap.arrivo = a2.codice
    -- aeroporto 2 <==> luogoaeroporto 2 
    and a2.codice = la2.aeroporto
    and la1.nazione <> la2.nazione
group by la1.nazione;

-- versione con filter per rapresentera anche i voli interni
select la1.nazione as nazione_partenza,
    count(distinct la2.nazione) 
    filter (where la1.nazione <> la2.nazione)
from luogoaeroporto la1, luogoaeroporto la2, 
	aeroporto a1, aeroporto a2, 
	arrpart ap
where -- luogoaeroporto 1 <==> aeroporto 1
    la1.aeroporto = a1.codice
    -- aeroporto 1 <==> arrpart partenza
    and a1.codice = ap.partenza 
        -- arrpart arrivo <==> aeroporto 2
    and ap.arrivo = a2.codice
    -- aeroporto 2 <==> luogoaeroporto 2 
    and a2.codice = la2.aeroporto
group by la1.nazione;



-- versione un volo diretto o un scalo
select t.nazione_partenza, count(distinct nazione_arrivo)
from (
    -- volo diretto
    select la1.nazione as nazione_partenza,
        la2.nazione as nazione_arrivo
    from arrpart ap1, arrpart ap2, aeroporto a1, aeroporto a2, 
        luogoaeroporto la1, luogoaeroporto la2
    where la1.aeroporto = a1.codice
        and  a1.codice = ap1.partenza
        and a2.codice = ap1.arrivo 
        and a2.codice = la2.aeroporto
        and la2.nazione <> la1.nazione
    group by la1.nazione, la2.nazione

union

    -- un solo scalo
    select la1.nazione as nazione_partenza,
        la3.nazione as nazione_arrivo
    from arrpart ap1, arrpart ap2, aeroporto a1, aeroporto a2, aeroporto a3, 
        luogoaeroporto la1, luogoaeroporto la2, luogoaeroporto la3
    where la1.aeroporto = a1.codice

        and a1.codice = ap1.partenza
        and a2.codice = ap1.arrivo 
        and a2.codice = la2.aeroporto

        and a2.codice = ap2.partenza
        and ap2.arrivo = a3.aeroporto
        and a3.aeroporto = la3.aeroporto

        and la3.nazione <> la1.nazione
    group by la1.nazione, la3.nazione
) as t
group by t.nazione_partenza;


-- 7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?

select a.codice as codice_aerop,
    a.nome as aerop_partenza,
    round(avg(durataminuti)::numeric,2) as durata_volo_media
from volo v, arrpart ap, aeroporto a
where v.codice = ap.codice
    and v.comp = ap.comp
    and ap.partenza = a.codice
group by a.codice;


-- 8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie 
-- fondate a partire dal 1950?

select c.nome as nome_comp,
    sum(v.durataminuti) as tot_durata_voli
from volo v, compagnia c
where v.comp = c.nome
    and c.annofondaz >= 1950
group by c.nome;


-- 9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?

select a.codice, a.nome
from aeroporto a, arrpart ap
where a.codice = ap.partenza or a.codice = ap.arrivo
group by a.codice
having count(distinct ap.comp) = 2; 


-- 10. Quali sono le città con almeno due aeroporti?

select la.citta
from luogoaeroporto la
group by la.citta
having count(la.aeroporto) >= 2;  -- oppure having count(*) >= 2 


-- 11. Qual è il nome delle compagnie i cui voli hanno una durata 
-- media maggiore di 6 ore?

select v.comp
from volo v
group by v.comp
having avg(durataminuti) > 360;


-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una durata 
-- maggiore di 100 minuti?

select comp
from volo
group by comp
having min(durataminuti) > 100;


-- 13 Quali sono gli aeroporti che non hanno i voli?

-- versione 1
select a.codice
from aeroporto a
except
select a.codice, a.nome
from arrpart ap, aeroporto a
where ap.partenza = a.codice or ap.arrivo = a.codice;


-- versione 2      
select codice
from aeroporto
where codice not in (           -- not in (lista dei valori) o (select.. from..)
                select partenza
                from arrpart
                union
                select arrivo 
                from arrpart
            );

-- versione 3      
select a.codice
from aeroporto a
where NOT EXISTS (
               select 1  -- non importa cosa c'è scritto, basta che  esiste una enupla
               from arrpart ap
               where ap.partenza = a.codice or ap.arrivo = a.codice
            );

-- versione 4
with AsV as (
    select ap.partenza as codie_aerop
    from arrpart ap
    union
    select ap.arrivo -- non serve, viene aggiunto in colonna codice_aerop
    from arrpart ap
)
select distinct a.codice
from aeroporto a, AsV
where a.codice not in (select asv.codice_aerop from asv);