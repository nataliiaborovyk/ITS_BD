
begin transaction;
set constraints all deferred;

create domain PosInteger as Integer 
    check (value >= 0);

create domain StringaM as varchar(100);

create domain CodIATA as char(3);



create table compagnia (
    nome StringaM primary key,
    annofondaz PosInteger
);

create table aeroporto (
    codice CodIATA primary key,
    nome StringaM not null
);

create table luogoaeroporto (
    aeroporto CodIATA primary key,
    citta StringaM not null,
    nazione StringaM not null,
    foreign key (aeroporto) references aeroporto(codice) deferrable
);

alter table aeroporto
    add constraint codice_ref_luogoaeroporto_aeroporto
    foreign key (codice) references luogoaeroporto(aeroporto) deferrable;


create table volo (
    codice PosInteger not null,
    comp StringaM not null,
    durataminuti PosInteger not null,
    primary key (codice, comp),
    foreign key (comp) references compagnia(nome)
    -- foreign key (codice, comp) references arrpart(codice, comp)
);

create table arrpart (
    codice PosInteger not null,
    comp StringaM not null,
    arrivo CodIATA not null,
    partenza CodIATA not null,
    primary key (codice, comp),
    foreign key (codice, comp) references volo(codice, comp) deferrable,
    foreign key (arrivo) references aeroporto(codice),
    foreign key (partenza) references aeroporto(codice)
);

alter table volo 
    add constraint codice_comp_ref_arrpart_codice_comp
    foreign key (codice, comp) references arrpart(codice, comp) deferrable;

commit;



--  QUERY


--  1    Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?

select  codice as codice_volo,  
        comp as compagnia
from Volo 
where durataminuti > 180



--  2    Quali sono le compagnie che hanno voli che superano le 3 ore?

select distinct comp as compagnia
from Volo 
where durataminuti > 180



--  3   Quali sono i voli (codice e nome della compagnia) 
--      che partono dall’aeroporto con codice ‘CIA’ ?

select  v.codice as codice_volo,  
        v.comp as compagnia
from Volo v, ArrPart ap
where 
    -- Volo <-> ArrPart
    v.codice = ap.codice and v.comp = ap.comp
    and ap.partenza = 'CIA'



--  4   Quali sono le compagnie 
--      che hanno voli che arrivano all’aeroporto con codice ‘FCO’ ?

select distinct comp as compagnia
from ArrPart
where arrivo = 'FCO'



--  5   Quali sono i voli (codice e nome della compagnia) 
--      che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’ ?

select  distinct 
        codice as codice_volo,  
        comp as compagnia
from ArrPart 
where 
    partenza = 'FCO'
    and arrivo = 'JFK'



--  6   Quali sono le compagnie 
--      che hanno voli che partono dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’ ?

select distinct comp as compagnia
from ArrPart
where 
    partenza = 'FCO'
    and arrivo = 'JFK'



--  7   Quali sono i nomi delle compagnie 
--      che hanno voli diretti dalla città di ‘Roma’ alla città di ‘New York’ ?

select distinct ap.comp as compagnia
From ArrPart ap,  Aeroporto a1,  LuogoAeroporto la1,  
                  Aeroporto a2,  LuogoAeroporto la2
where
    -- ArrPart <-> Aeroporto a1 <-> LuogoAeroporto la1
    ap.partenza = a1.codice
    and a1.codice = la1.aeroporto
    and la1.citta = 'Roma'
    -- ArrPart <-> Aeroporto a2 <-> LuogoAeroporto la2
    and ap.arrivo = a2.codice
    and a2.codice = la2.aeroporto
    and la2.citta = 'New York'



--  8    Quali sono gli aeroporti (con codice IATA, nome e luogo) 
--      nei quali partono voli della compagnia di nome ‘MagicFly’ ?

select distinct 
        a.codice as codiceiata,  
        a.nome,  la.citta,  la.nazione
from ArrPart ap,  Aeroporto a, LuogoAeroporto la
where 
    -- ArrPart <-> Aeroporto <-> LuogoAeroporto
    ap.partenza = a.codice
    and a.codice = la.aeroporto
    and ap.comp = 'MagicFly'



--  9   Quali sono i voli 
--      che partono da un qualunque aeroporto della città di ‘Roma’ e
--      atterrano ad un qualunque aeroporto della città di ‘New York’ ? 
--      Restituire: codice del volo, nome della compagnia, e aeroporti di partenza e arrivo.

select  distinct
        ap.codice as codice_volo,  
        ap.comp as compagnia,  
        ap.partenza,  ap.arrivo
from ArrPart ap,  Aeroporto a1,  LuogoAeroporto la1, 
                  Aeroporto a2,  LuogoAeroporto la2
where 
    -- ArrPart <-> Aeroporto a1 <-> LuogoAeroporto la1
    ap.partenza = a1.codice 
    and a1.codice = la1.aeroporto
    and la1.citta = 'Roma'
    and
    -- ArrPart <-> Aeroporto a2 <-> LuogoAeroporto la2
    ap.arrivo = a2.codice
    and a2.codice = la2.aeroporto
    and la2.citta = 'New York'



--  10  Quali sono i possibili piani di volo con esattamente un cambio 
--      (utilizzando solo voli della stessa compagnia) da un qualunque aeroporto della città di ‘Roma’ 
--      ad un qualunque aeroporto della città di ‘New York’ ? 
--      Restituire: nome della compagnia, codici dei voli, e aeroporti di partenza, scalo e arrivo.

select  distinct
        ap1.comp as compagnia,  
        ap1.codice as codice_volo_1,  
        ap1.partenza,  
        ap1.arrivo as scalo,  
        ap2.codice as codice_volo_2, 
        ap2.arrivo
from    ArrPart ap1,  Aeroporto a1,  LuogoAeroporto la1,
        ArrPart ap2,  Aeroporto a2,  LuogoAeroporto la2
where   
    -- ArrPart ap1 <-> Aeroporto a1 <-> LuogoAeroporto la1
    ap1.partenza = a1.codice
    and a1.codice = la1.aeroporto
    and la1.citta = 'Roma'
    -- AppRart ap2 <-> Aeroporto a2 <-> LuogoAeroporto la2
    and ap2.arrivo = a2.codice
    and a2.codice = la2.aeroporto
    and la2.citta = 'New York'
    -- condizioni
    and ap1.arrivo = ap2.partenza
    and ap1.comp = ap2.comp



--  11  Quali sono le compagnie 
--      che hanno voli che partono dall’aeroporto ‘FCO’, atterrano all’aeroporto ‘JFK’, 
--      e di cui si conosce l’anno di fondazione?

select distinct ap.comp as compagnia
from ArrPart ap,  Volo v,  Compagnia c
where 
    -- ArrPart <-> Volo <-> Compania 
    ap.codice = v.codice and ap.comp = v.comp       
    and v.comp = c.nome    
    -- condizioni                         
    and ap.partenza = 'FCO'
    and ap.arrivo = 'JFK'
    and c.annofondaz is not null
