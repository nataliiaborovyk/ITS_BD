-- 1
select distinct cognome
from persone


-- 2
select nome, cognome
from Persona
where posizione = 'Ricercatore';

-- 3 
select nome, cognome
from persona
where posizione = 'Professore Associato' and cognome = V%

-- 4 
select nome, cognome
from persona
where (posizione = 'Professor Associato' or posizione = 'Professore Ordinario') 
    and cognome like  V%;

-- 5
select id, nome
from progetto
where fine < current_date

-- 6
select nome
from progetto
order by inizio ASC

-- 7
select id, nome
from wp
order by nome ASC

-- 8 
select distinct tipo
from Assenza

-- 9
select distinct tipo
from AttivitaProgetto

-- 10
select distinct giorno
from AttivitaNonProgettuale
where tipo = 'Didattica'
order by giorno ASC

