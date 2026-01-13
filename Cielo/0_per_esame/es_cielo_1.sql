


--  1    Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?
select codice, comp, durataminuti  -- distinct non serve perche ogni riga rapresenta un volo
from volo
where durataminuti > 180;

--  2    Quali sono le compagnie che hanno voli che superano le 3 ore?
select distinct  -- serve distinct perche compagnia puo avere piu voli
    comp
from volo
where durataminuti > 180;


--  3   Quali sono i voli (codice e nome della compagnia) 
--      che partono dall’aeroporto con codice ‘CIA’ ?
select v.codice, v.comp, ap.partenza, ap.arrivo
from volo v, arrpart ap
where v.codice = ap.codice
    and v.comp = ap.comp
    and ap.partenza = 'CIA';


--  4   Quali sono le compagnie 
--      che hanno voli che arrivano all’aeroporto con codice ‘FCO’ ?
select distinct comp
from arrpart
where arrivo = 'FCO';


--  5   Quali sono i voli (codice e nome della compagnia) 
--      che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’ ?
select v.codice, v.comp, v.durataminuti
from volo v, arrpart ap
where v.comp = ap.comp
    and v.codice = ap.codice
    and ap.partenza = 'FCO'
    and ap.arrivo = 'JFK';


--  6   Quali sono le compagnie 
--      che hanno voli che partono dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’ ?
select distinct
    comp
from arrpart
where partenza = 'FCO'
    and arrivo = 'JFK';


--  7   Quali sono i nomi delle compagnie 
--      che hanno voli diretti dalla città di ‘Roma’ alla città di ‘New York’ ?
select distinct ap.comp
from arrpart ap, 
    aeroporto a1, aeroporto a2,
    luogoaeroporto la1, luogoaeroporto la2
where ap.arrivo = a1.codice
    and ap.partenza = a2.codice
    and a1.codice = la1.aeroporto
    and a2.codice = la2.aeroporto
    and la1.citta = 'New York'
    and la2.citta = 'Roma'


--  8    Quali sono gli aeroporti (con codice IATA, nome e luogo) 
--      nei quali partono voli della compagnia di nome ‘MagicFly’ ?
select distinct
     a.codice, a.nome, la.citta, la.nazione
from arrpart ap, aeroporto a, luogoaeroporto la
where ap.partenza = a.codice
    and a.codice = la.aeroporto
    and ap.comp = 'MagicFly'



--  9   Quali sono i voli 
--      che partono da un qualunque aeroporto della città di ‘Roma’ e
--      atterrano ad un qualunque aeroporto della città di ‘New York’ ? 
--      Restituire: codice del volo, nome della compagnia, e aeroporti di partenza e arrivo.
select ap.codice, ap.comp as compagnia, 
    a1.codice as aeroporto_partenza,
    a2.codice as aeroporto_arrivo
from arrpart ap, 
    aeroporto a1, aeroporto a2,
    luogoaeroporto la1, luogoaeroporto la2
where ap.partenza = a1.codice
    and a1.codice = la1.aeroporto
    and ap.arrivo = a2.codice
    and a2.codice = la2.aeroporto
    and la1.citta = 'Roma'
    and la2.citta = 'New York'
order by ap.codice


--  10  Quali sono i possibili piani di volo con esattamente un cambio 
--      (utilizzando solo voli della stessa compagnia) da un qualunque aeroporto della città di ‘Roma’ 
--      ad un qualunque aeroporto della città di ‘New York’ ? 
--      Restituire: nome della compagnia, codici dei voli, e aeroporti di partenza, scalo e arrivo.
select ap1.comp as nome_compagnia,
    ap1.codice as codice_volo_1,
    ap2.codice as codice_volo_2,
    (v1.durataminuti + v2.durataminuti) as durata_totale,
    ap1.partenza as aeroporto_partenza,
    ap1.arrivo as aeroporto_scalo,
    ap2.arrivo as aeroporto_arrivo
from arrpart ap1, arrpart ap2,
    aeroporto a1, aeroporto a2,
    luogoaeroporto la1, luogoaeroporto la2, 
    volo v1, volo v2
where ap1.partenza = a1.codice
    and a1.codice = la1.aeroporto
    and la1.citta = 'Roma'
    and ap1.codice = v1.codice
    and ap1.comp = v1.comp

    and ap2.arrivo = a2.codice
    and a2.codice = la2.aeroporto 
    and la2.citta = 'New York'
    and ap2.codice = v2.codice
    and ap2.comp = v2.comp

    and ap1.arrivo = ap2.partenza
    and ap1.comp = ap2.comp



--  11  Quali sono le compagnie 
--      che hanno voli che partono dall’aeroporto ‘FCO’, atterrano all’aeroporto ‘JFK’, 
--      e di cui si conosce l’anno di fondazione?

select distinct c.nome
from arrpart ap, volo v, compagnia c
where ap.codice = v.codice
    and ap.comp = v.comp
    and v.comp = c.nome
    and ap.partenza = 'FCO'
    and ap.arrivo = 'JFK'
    and c.annofondaz is not null
