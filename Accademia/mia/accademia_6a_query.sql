-- 1. Quanti sono gli strutturati di ogni fascia?

select posizione, count(id)
from Persona
group by posizione;


-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?

select count(*)
from Persona
where stipendio >= 40000;


-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?

select count(*)
from Progetto
where fine < current_date
    and budget > 50000;


-- 4. Qual è la media, il massimo e il minimo 
-- delle ore delle attività relative al progetto ‘Pegasus’ ?

select avg(ap.oreDurata) as media, 
    min(ap.oreDurata) as minimo,
    max(ap.oreDurata) as massimo
from AttivitaProgetto ap, Progetto prog
where ap.progetto = prog.id
    and prog.nome = 'Pegasus';


-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere 
-- dedicate al progetto ‘Pegasus’ da ogni singolo docente?

select pers.id as id_persona,
        pers.nome,
        pers.cognome,
        avg(ap.oreDurata) as media,
        min(ap.oreDurata) as minimo,
        max(ap.oreDurata) as massimo
from AttivitaProgetto ap, Progetto prog, Persona pers
where 
    -- AttivitaProgetto <-> Progetto
    ap.progetto = prog.id
    and prog.nome = 'Pegasus'
    -- AttivitaProgetto <-> Persona
    and ap.persona = pers.id
group by pers.id;


-- 6. Qual è il numero totale di ore dedicate 
-- alla didattica da ogni docente?

select pers.id as id_persona,
        pers.nome,
        pers.cognome,
        sum(anp.oreDurata) as ore_didattica
from AttivitaNonProgettuale anp, Persona pers
where anp.persona = pers.id
    and anp.tipo = 'Didattica'
group by pers.id;


-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

select avg(stipendio) as media, 
        min(stipendio) as minimo,
        max(stipendio) as massimo
from Persona
where posizione = 'Ricercatore'


-- 8. Quali sono le medie, i massimi e i minimi degli stipendi 
-- dei ricercatori, dei professori associati e dei professori ordinari?

select  posizione, 
        avg(stipendio) as media, 
        min(stipendio) as minimo, 
        max(stipendio) as massimo
from Persona
group by posizione;


-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

select prog.id as id_progetto,
        prog.nome as progetto,
        sum(ap.oreDurata)
from AttivitaProgetto ap, Persona pers, Progetto prog
where 
    -- AttivitaProgetto <-> Persona
    ap.persona = pers.id
    and pers.nome = 'Ginevra'
    and pers.cognome = 'Riva'
    -- AttivitaProgetto <-> Progetto
    and ap.progetto = prog.id
group by prog.id


-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?

select  prog.id as id_progetto,
        prog.nome as progetto
from    AttivitaProgetto ap1, AttivitaProgetto ap2,  
        Progetto prog
where
    -- AttivitaProgetto ap1 <-> Progetto
    ap1.progetto = prog.id
    -- AttivitaProgetto ap1 <-> Progetto
    and ap2.progetto = prog.id
    -- condizioni
    and ap1.persona <> ap2.persona
group by prog id
    

-- 11. Quali sono i professori associati 
-- che hanno lavorato su più di un progetto?

select  pers.id, pers.nome, pers.cognome
from AttivitaProgetto ap1, AttivitaProgetto ap2, Persona pers
where 
    -- AttivitaProgetto ap1 <-> Persona
    ap1.persona = pers.id
    -- AttivitaProgetto ap2 <-> Persona
    and ap2.persona = pers.id
    -- condizioni
    and pers.posizione = 'Professore Associato'
    and ap1.progetto <> ap2.progetto
group by pers.id
