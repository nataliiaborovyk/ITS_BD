-- 1 Quante sono le compagnie che operano (sia in partenza che in arrivo) nei diversi aeroporti?
-- 1a Quante sono le compagnie che hanno almeno un volo in partenza o in arrivo, per ogni aeroporto

-- Aeroporto | # compagnie

select a.codice, a.nome, count(distinct comp) 
from aeroporto a, arrpart ap
where ap.partenza = a.codice or ap.arrivo = a.codice
group by a.codice, a.nome;  


-- 2 Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata 
-- di almeno 100 minuti?

select count(*) as numeroVoli
from volo v, arrpart ap
where v.codice = ap.codice
	and ap.partenza = 'HTR'
	and v.durataminuti >= 100;


-- 3 Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione
-- nella quale opera?
select la.nazione, count(distinct aeroporto) as numeroAeroporto
from arrpart ap, luogoaeroporto la
where 
	(ap.partenza = la.aeroporto or ap.arrivo = la.aeroporto) 
	and ap.comp = 'Apitalia'
group by la.nazione;

-- 4 Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla
-- compagnia ‘MagicFly’ ?
select round(avg(durataminuti),2) as media, 
	max(durataminuti) as massimo, 
	min(durataminuti) as minimo
from volo v
where comp = 'MagicFly';


-- 5 Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli
-- aeroporti?
select a.codice, a.nome, min(c.annofondaz) as anno
from aeroporto a, arrpart ap, compagnia c
where (a.codice = ap.arrivo or a.codice = ap.partenza)
and ap.comp = c.nome
group by a.codice, a.nome;


-- 6 Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più
-- voli?
select lp.nazione as nazione, count(distinct la.nazione) as raggiungibili
from arrpart ap, luogoaeroporto lp, luogoaeroporto la
where ap.partenza = lp.aeroporto
	and ap.arrivo = la.aeroporto
	and lp.nazione <> la.nazione
group by lp.nazione;


-- 7 Qual è la durata media dei voli che partono da ognuno degli aeroporti?

select a.codice, a.nome, round(avg(v.durataminuti),2) as mediaDurata
from volo v, arrpart ap, aeroporto a
where ap.codice = v.codice
        and ap.comp = v.comp
        and a.codice = ap.partenza
group by a.codice, a.nome;

-- 8 Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate
-- a partire dal 1950?

select v.comp, sum(durataminuti) as durataTot
from volo v, compagnia c
where v.comp = c.nome
	and c.annofondaz >= 1950
group by v.comp;


-- 9 Quali sono gli aeroporti nei quali operano esattamente due compagnie?
select a.codice, a.nome
from arrpart ar, aeroporto a
where (ar.partenza = a.codice
		or ar.arrivo = a.codice)
group by a.codice, a.nome
having count(distinct ar.comp) = 2;


-- 10 Quali sono le città con almeno due aeroporti?

select citta
from luogoaeroporto
group by citta
having count(*) >= 2;

-- 11 Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6 ore?

select comp
from volo
group by comp
having avg(durataminuti) > 360;


-- 12  Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100 minuti?
select comp
from volo
group by comp
having min(durataminuti) > 100;