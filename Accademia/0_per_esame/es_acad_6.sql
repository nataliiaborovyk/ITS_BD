-- 1. Quanti sono gli strutturati di ogni fascia?
select p.posizione, count(p.id)
from persona p1
group by p.posizione;

-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?
select count(*) as num_strutturati
from persona
where stipendio >= 40000;

-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?
select count(*)
from progetto
where fine < current_date
    and budget > 50000;

-- 4. Qual è la media, il massimo e il minimo delle ore delle attività 
-- relative al progetto ‘Pegasus’ ?
select avg(ap.oreDurata) as media, 
    max(ap.oreDurata) as massimo,
    min(ap.oreDurata) as minimo
from progetto p, attivitaprogetto ap
where ap.progetto = pr.id   
    and pr.nome = 'Pegasus';

-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere 
-- dedicate al progetto ‘Pegasus’ da ogni singolo docente?
select p.id, p.nome, p.cognome,
    avg(ap.oreDurata) as media, 
    max(ap.oreDurata) as massimo,
    min(ap.oreDurata) as minimo
from progetto p, attivitaprogetto ap, persona p
where ap.progetto = pr.id   
    and pr.nome = 'Pegasus'
group by p.id;

-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?
select p.id, p.nome, p.cognome, sum(anp.oreDurata)
from persona p, attivitanonprogettuale anp
where anp.persona = p.id
    anp.tipo = 'Didattica'
group by p.id;

-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?
select avg(stipendio), max(stipendio), min(stipendio)
from persona 
where posizione = 'Ricercatore';

-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, 
-- dei professori associati e dei professori ordinari?
select posizione, avg(stipendio), max(stipendio), min(stipendio)
from persona 
group by posizione;

-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?
select sum(ap.oreDurata)
from persona p, attivitaprogetto ap
where p.nome = 'Ginevra'
    and p.cognome = 'Riva'
    and ap.persona = p.id
group by ap.id


-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?
select pr.nome
from progetto pr, attivitaprogetto ap
where ap.progetto = pr.id
group by pr.nome
having count(distinct ap.persona) > 2;

-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?

select p.id, p.nome, p.cognome, count(distinct ap.id)
from persona p, attivitaprogetto ap
where ap.persona = p.id
    and p.posizione = 'Professore Associato'
group by p.id
having count(distinct ap.id) >1
