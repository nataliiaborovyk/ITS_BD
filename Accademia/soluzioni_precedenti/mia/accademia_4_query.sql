-- 1
select distinct cognome
from Persona
where True;

-- 2
select nome, cognome
from Persona
where posizione = 'Ricercatore';

-- 3
select nome, cognome
from Persona
where posizione = 'Professore Associato' and cognome like 'V%';

-- 4
select nome, cognome
from Persona 
where (posizione = 'Professore Associato' or posizione = 'Professore Ordinario') 
    and cognome like 'V%';
--where posizione != 'Ricercatore' and cognome like 'V%';
--where not posizione = 'Ricercatore' and cognome like 'V%';
--where posizione IN ('Professore Associato', 'Professore Ordinario') and cognome like 'V%';
 
-- 5
select id, nome
from Progetto
where fine <= current_date;

-- 6
select nome
from Progetto
order by inizio ASC;

-- 7
select nome
from WP
order by nome ASC;

-- 8
select distinct tipo
from Assenza
where True;

-- 9
select distinct tipo
from AttivitaProgetto
where True;

-- 10
select distinct giorno
from AttivitaNonProgettuale
where tipo = 'Didattica'
order by giorno ASC;

--11
select nomi, cognome
from Assenza a, Prsone p
where a.persone = p.id