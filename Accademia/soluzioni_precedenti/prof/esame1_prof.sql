-- 1. Elencare tutti i progetti la cui fine è successiva al
-- 2023-12-31. [2 punti]


select *
from progetto
where fine > '2023-12-31';


-- 2. Contare il numero totale di persone per ciascuna posizione
-- (Ricercatore, Professore Associato, Professore Ordinario).
select posizione, count(*) as num_persone
from persona
group by posizione;


-- 3. Restituire gli id e i nomi delle persone che hanno almeno
-- un giorno di assenza per "Malattia".
select distinct p.id, p.nome, p.cognome
from assenza a, persona p
where a.persona = p.id
	and a.tipo = 'Malattia';

-- alternativa con JOIN esplicito
select distinct p.id, p.nome, p.cognome
from assenza a join persona p
	on a.persona = p.id
where a.tipo = 'Malattia';


-- 4. 
select tipo, count(*) as num_assenze
from assenza
group by tipo;


-- 5. 
select max(stipendio)
from persona
where posizione = 'Professore Ordinario';

-- alternativa inefficiente
select stipendio
from persona 
where posizione = 'Professore Ordinario'
order by stipendio desc
limit 1;


-- 6. Quali sono le attività e le ore spese dalla persona con id 0
-- nelle attività del progetto con id 1, ordinate in ordine
-- decrescente. Per ogni attività, restituire l’id, il tipo e il
-- numero di ore.

select id, tipo, oredurata
from attivitaprogetto
where persona = 0
	and progetto = 1
order by oredurata;


-- 7. Quanti sono i giorni di assenza per tipo e per persona. Per
-- ogni persona e tipo di assenza, restituire nome, cognome,
-- tipo assenza e giorni totali.
select p.id, p.nome, p.cognome, a.tipo as tipoassenza, count(*)
from assenza a, persona p
where a.persona = p.id
group by p.cognome, a.tipo






