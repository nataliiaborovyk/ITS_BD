-- 1. Quanti sono gli strutturati di ogni fascia?

select posizione, count(*)
from persona
group by posizione;


-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?

select count(*) as Quantita
from persona 
where stipendio >= 40000;


-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?

select count(*) as Num_prog_finiti
from progetto
where fine < current_date
    and budget > 50000;


-- 4. Qual è la media, il massimo e il minimo delle ore delle attività 
-- relative al progetto ‘Pegasus’ ?

select pr.nome as nome_prog,
    avg(oreDurata) as media_ore,
    max(oreDurata) as massimo_ore,
    min(oreDurata) as minimo_ore
from progetto pr, AttivitaProgetto ap
where ap.progetto = pr.id
    and pr.nome = 'Pegasus'
group by pr.nome;


-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere 
-- dedicate al progetto ‘Pegasus’ da ogni singolo docente?

select p.id as id_docente, 
    p.nome, 
    p.cognome,
    pr.nome as nome_prog, 
    avg(oreDurata) as media_ore_giorno,
    max(oreDurata) as massimo_ore_giorno,
    min(oreDurata) as minimo_ore_giorno
from AttivitaProgetto ap, progetto pr, persona p
where ap.progetto = pr.id
    and pr.nome = 'Pegasus'
    and ap.persona = p.id
group by p.id, pr.nome; -- o anche pr.id?
-- DOMANDA
-- p.nome e p.cognome devo scrivere nel group by? 
-- p.id è la chiave primaria e definisce in automatico p.nome e p.cognome


-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?

select p.id as id_docente, 
    p.nome,
    p.cognome,
    sum(anp.oreDurata) as tot_ore_didattica
from attivitanonprogettuale anp, persona p
where anp.persona = p.id
    and anp.tipo = 'Didattica'
group by p.id;


-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

select posizione,
    avg(stipendio) as stipendio_medio,
    max(stipendio) as stipendio_max,
    min(stipendio) as stipendio_min
from persona 
where posizione = 'Ricercatore'
group by posizione;


-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, 
-- dei professori associati e dei professori ordinari?

select posizione,
    avg(stipendio) as stipendio_medio,
    max(stipendio) as stipendio_max,
    min(stipendio) as stipendio_min
from persona 
group by posizione;


-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

select p.id as id_docente,
    p.nome as nome_docente,
    p.cognome as cognome_docente,
    ap.progetto as id_progetto,
    pr.nome as nome_progetto,
    sum(oredurata) as ore_dedicate
from attivitaprogetto ap, persona p, progetto pr
where ap.persona = p.id
    and ap.progetto = pr.id
    and p.nome = 'Ginevra'
    and p.cognome = 'Riva'
group by ap.progetto, pr.nome, p.id;


-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?

select pr.id as id_progetto,
    pr.nome as nome_progetto
from attivitaprogetto ap1, attivitaprogetto ap2, progetto pr
where ap1.progetto = pr.id
    and ap2.progetto = pr.id
group by pr.id
having count(distinct ap1.persone) > 2; -- oppure having count(distinct ap2.persone) > 2;

        -- alternativa con 1 tabella attivitaprogetto
        select pr.id as id_progetto,
            pr.nome as nome_progetto
        from attivitaprogetto ap, progetto pr
        where ap.progetto = pr.id
        group by pr.id
        having count(distinct ap.persona) > 2;


-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?

select p.id, 
    p.nome, 
    p.cognome, 
    p.posizione, 
    count(ap.progetto) as num_progetti
from attivitaprogetto ap, persona p
where ap.persona = p.id
    and p.posizione = 'Professore Associato'
group by p.id
having count(distinct ap.progetto) > 1;

