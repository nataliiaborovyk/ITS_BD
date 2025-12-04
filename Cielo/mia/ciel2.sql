-- 1 Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi
-- aeroporti?

select a.codice,a.nome, count(*)
from arrpart ap, aeroporto a
where ap.partenza = a.codice or ap.arrivo = a.codice
group by a.codice




-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno
-- 100 minuti?


select count(*)
from arrpart ap, volo v
where ap.codice = v.codice
    and ap.comp = v.comp
    and ap.partenza = 'HTR'
    and v.durataminuti >= 100

-- 3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione
-- nella quale opera?

select count(distinct la.aeroporto)
from arrpart ap, aeroporto a, luogoaeroporto la
where ap.partenza = a.codice or ap.arrivo = a.codice
    and a.codice = la.aeroporto
    and ap.comp = 'Apitalia'
group by la.nazione


-- 4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla
-- compagnia ‘MagicFly’ ?

select round(avg(v.durataminuti)::numeric, 2)
from  volo v
where v.comp = 'MagicFly'

    


-- 5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli
-- aeroporti?


with minAnnifondaz as (
    select min(annofondaz) as m
    from compagnia c1, volo v1
)
select 
from aeroporto a, volo v, compagnia c1, minAnnifondaz ma
where ap.codice = v.codice
    and ap.comp = v.comp
    and v.comp = c.nome

    and c.annofondaz = ma.ma
group by a.codice

-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più
-- voli?

select
from luogoaeroporto la1, aeroporto a1, arrpart ap, aeroporto a2, luogoaeroporto la 2
where -- luogoaeroporto 1 <==> aeroporto 1
    la1.aeroporto = a1.codice
    -- aeroporto 1 <==> arrpart partenza
    and a1.codice = ap.partenza 
        -- arrpart arrivo <==> aeroporto 2
    and ap.arrivo = a2.codice
    -- aeroporto 2 <==> luogoaeroporto 2 
    and a2.codice = la2.aeroporto
    and la1.nazione <> la2.nazione
group by la1.nazione

-- 7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?

select a.nome, avg(v.durataminuti)
from arrpart ap, aeroporto a, volo v
where ap.codice = a.codice
    and ap.comp = v.comp
    and v.comp = c.nome
    and ap.partenza = a.codice 
group by a.codice


-- 8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate
-- a partire dal 1950?

select v.comp, sum(v.durataminuti)
from volo v, compagnie c1
where v.comp = c.nome
    and c.annofondaz >= 1950
group by v.comp

-- 9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?

select
from arrpart ap, aeroporto a1
where ap.codice = a.codice
    and ap.partenza = a.codice or ap.arrivo = a.codice
group by a.codice
having count(distinct ap.comp) = 2

-- 10. Quali sono le città con almeno due aeroporti?

select
from luogoaeroporto
group by citta
having  count(aeroporto) >= 2

-- 11. Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6
-- ore?

select
from volo
group by comp
having avg(durataminuti) >6

-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100
-- minuti?

select
from volo
group by comp
having min(durataminuti) > 100
