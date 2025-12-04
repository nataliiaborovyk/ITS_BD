
select *
from assenza, persona

select *
from persona p, assenza a, assenza a2
where p.id = a.persona and p.id = a2.persona
	and a.id <> a2.id

select distinct p.id, p.nome, p.cognome
from persona p, assenza a, assenza a2
where p.id = a.persona and p.id = a2.persona
	and a.id <> a2.id


select p.id, p.nome, p.cognome
from persona p, assenza a, assenza a2
where p.id = a.persona and p.id = a2.persona
group by p.id, p.nome, p.cognome
having count(*) > 2    -- * numero di righe in ogni gruppo