-- 1. Quanti sono gli strutturati di ogni fascia?

select p.posizione, count(*) as num_strutturati
from persona p
group by p.posizione;


-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?

select p.posizione, count(*)
from persona p
where p.stipendio >= 40000
group by p.posizione;


-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?

select count(*)
from progetto pr
where pr,fine < current_date
where pe.budget > 50000


-- 4. Qual è la media, il massimo e il minimo delle ore delle attività 
-- relative al progetto ‘Pegasus’ ?

select
    pr.nome as nome_progetto,
    round(avg(ap.oredurata)) as media_durata,
    max(ap.oredurata) as max_durata,
    min(ap.oredurata) as min_durata
from progetto pr, attivitaprogetto ap
where ap.progetto = pr.id
    and pr.nome = 'Pegasus'
group by pr.nome

-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere 
-- dedicate al progetto ‘Pegasus’ da ogni singolo docente?

select p.id, p.nome, p.cognome, pr.nome,
    round(avg(ap.oredurata)) as media_durata,
    max(ap.oredurata) as max_durata,
    min(ap.oredurata) as min_durata
from persona p, attivitaprogetto ap, progetto pr
where ap.persona = p.id
    and ap.progetto = pr.id
    and pr.nome = 'Pegasus'
group by p.id, pr.nome

-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?

select p.id, p.nome, p.cognome, sum(anp.oredurata) as tot_ore_didattica
from attivitanonprogettuale anp, persona p
where anp.persona = p.id
    and anp.tipo = 'Didattica'
group by p.id

-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

select 
    round(avg(p.stipendio)) as media_stipendio,
    max(p.stipendio) as max_stipendio,
    min(p.stipendio) as min_stipendio
from persona p
where p.posizione = 'Ricercatore'



-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, 
-- dei professori associati e dei professori ordinari?

select p.posizione,
    round(avg(p.stipendio)) as media_stipendio,
    max(p.stipendio) as max_stipendio,
    min(p.stipendio) as min_stipendio
from persona p
group by p.posizione


-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

select p.id, p.nome, p.cognome, pr.nome, sum(ap.oredurata)
from persona p, attivitaprogetto ap, progetto pr
where ap.persona = p.id
    and ap.progetto = pr.id
    and p.nome = 'Ginevra'
    and p.cognome = 'Riva'
group by p.id, pr.nome;

-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?

select pr.nome, count(distinct ap.persona)
from progetto pr, attivitaprogetto ap
where ap.progetto = pr.id
group by pr.nome
having count(distinct ap.persona) > 2


-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?

select p.id, p.nome, p.cognome, count(distinct ap.progetto) as num_prog
from persona p, attivitaprogetto ap
where ap.persona = p.id
    and p.posizione = 'Professore Associato'
group by p.id
having count(distinct ap.progetto) > 1
