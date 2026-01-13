-- 1. Elencare tutti i progetti la cui fine è successiva al
-- 2023-12-31. [2 punti]
select pr.id, pr.nome
from progrtto p
where p.fine > '2023-12-31';

-- 2. Contare il numero totale di persone per ciascuna posizione
-- (Ricercatore, Professore Associato, Professore Ordinario).
-- [3 punti]
select p.posizione, count(*)
from persona p
group by p.posizione;

-- 3. Restituire gli id e i nomi delle persone che hanno almeno
-- un giorno di assenza per "Malattia". [2 punti]
select distinct p.id, p.nome
from persona p, assenza a
where a.persona = p.id
    and a.tipo = 'Malattia';

-- 4. Per ogni tipo di assenza, restituire il numero complessivo
-- di occorrenze. [3 punti]
select a.tipo, count(*)
from assenza a
group by a.tipo;

-- 5. Calcolare lo stipendio massimo tra tutti i "Professori
-- Ordinari". [2 punti]
select max(p.stipendio)
from persona p
where p.posizione = 'Professore Ordinario';

-- 6. Quali sono le attività e le ore spese dalla persona con id 1
-- nelle attività del progetto con id 4, ordinate in ordine
-- decrescente. Per ogni attività, restituire l’id, il tipo e il
-- numero di ore. [3 punti]
select ap.persona, ap.id, ap.tipo, ap.oredurata
from AttivitaProgetto ap
where ap.persona = 1
    and ap.progetto = 41
order by ap.oredurata desc;


-- 7. Quanti sono i giorni di assenza per tipo e per persona. Per
-- ogni persona e tipo di assenza, restituire nome, cognome,
-- tipo assenza e giorni totali. [4 punti]
select p.id, p.nome, p.cognome, a.tipo, count(*)
from assenza a, persona p
where a.persona = p.id
group by p.id, a.tipo;



-- 8. Restituire tutti i “Professori Ordinari” che hanno lo
-- stipendio massimo. Per ognuno, restituire id, nome e
-- cognome [4 punti]
select p.id, p.nome, p.cognome
from persona p
where p.posizione = 'Professore Ordinario'
    and p.stipendio = (
        select max(p2.stipendio)
        from persona p2
        where p2.posizione = 'Professore Ordinario'
    );

with max_stipendio_table as (
    select max(stipendio) as max_stipendio
    from persona p
    where p.posizione = 'Professore Ordinario')
select * 
from persona p, max_stipendio_table
where p.posizione = 'Professore Ordinario'
    and p.stipendio = max_stipendio_table.max_stipendio;

-- Opzione 2: Query annidata nella WHERE (equivalente alla 1)
select id as persona_id, nome, cognome
from persona
where posizione = 'Professore Ordinario'
  and stipendio = (
    select max(stipendio) as max_stipendio_P0
    from persona
    where posizione = 'Professore Ordinario'
  );

-- Opzione 3: GROUP BY + HAVING (costa più della 2)
select id as persona_id, nome, cognome
from persona
where posizione = 'Professore Ordinario'
group by id, nome, cognome
having stipendio = (
  select max(stipendio) as max_stipendio_P0
  from persona
  where posizione = 'Professore Ordinario'
);

-- Variante vista sopra (con posizione anche nel GROUP BY e confronto con max(stipendio))
select id, nome, cognome, posizione
from persona
group by id, nome, cognome, posizione
having stipendio = max(stipendio)
   and posizione = 'Professore Ordinario';

-- Opzione 4: >= ALL
select id as persona_id, nome, cognome
from persona
where posizione = 'Professore Ordinario'
  and stipendio >= all (
    select stipendio
    from persona
    where posizione = 'Professore Ordinario'
  );

-- Opzione 5: NOT EXISTS
select p.id as persona_id, p.nome, p.cognome
from persona p
where p.posizione = 'Professore Ordinario'
  and not exists (
    select *
    from persona p1
    where p1.posizione = 'Professore Ordinario'
      and p1.stipendio > p.stipendio
  );




-- 9. Restituire la somma totale delle ore relative alle attività
-- progettuali svolte dalla persona con id = 3 e con durata
-- minore o uguale a 3 ore. [3 punti]
select sum(ap.oredurata)
from attivitaprogetto ap
where ap.persona = 3
    and ap.oredurata <= 3;


-- 10. Restituire gli id e i nomi delle persone che non hanno
-- mai avuto assenze di tipo "Chiusura Universitaria" [4
-- punti]
select distinct p.id, p.nome
from persona p, assenza a
where a.persona = p.id
    and a.tipo != 'Chiusura Universitaria';

select *
from persona p
where p.id not in (
    select a.persona
    from assemza a
    where a.tipo = 'Malattia'
);

select p.id, p.nome, p.cognome
from persona

except

select p.id, p.nome, p.cognome
from persona p, assenza a
where a.persona = p.id
    and a.tipo = 'Chiusura Universitaria'


select*
from persona p outer join assenza a
on p.id = a.persona
and a.tipo = 'Chiusura Universitaria'
