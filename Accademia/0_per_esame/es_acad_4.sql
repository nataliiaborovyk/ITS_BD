-- 1. Quali sono i cognomi distinti di tutti gli strutturati?
select distinct 
    p.nome, p.cognome
from persona p
order by p.id asc;
-- oppure
select p.id, p.nome, p.cognome   -- non serve distinct perche id gia garantisce unicita
from persona p
order by p.id asc;


-- 2. Quali sono i Ricercatori (con nome e cognome)?
select  distinct 
     p.nome, p.cognome
from persona p
where p.posizione = 'Ricercatore'
order by p.cognome;
-- oppure
select  
     p.id, p.nome, p.cognome
from persona p
where p.posizione = 'Ricercatore'
order by p.cognome;

-- 3. Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’ ?
select  
     p.id, p.nome, p.cognome
from persona p
where p.cognome like 'V%'
    and p.posizione = 'Professore Associato'
order by p.cognome asc;

-- 4. Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’ ?
select 
     p.id, p.nome, p.cognome
from persona p
where (p.posizione = 'Professore Associato' or p.posizione = 'Professore Ordinario')
    and p.cognome like 'V%';


-- 5. Quali sono i Progetti già terminati alla data odierna?
select pr.id, pr.nome
from progetto pr
where pr.fine <= current_date;

-- 6. Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?
select pr.id, pr.nome, pr.inizio
from progetto pr
order by pr.inizio ASC;

-- 7. Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
select 
    wp.progetto as id_progetto,
    wp.id as id_wp,
    pr.nome as nome_progetto,
    wp.nome as nome_wp
from wp, progetto pr
where wp.progetto = pr.id
order by 
    pr.nome asc,
    wp.nome asc;

-- 8. Quali sono (distinte) le cause di assenza di tutti gli strutturati?
select distinct a.tipo
from assenza a;
-- oppure
select 
    a.tipo as tipo_malatia,
    count(distinct a.persona) as num_persone
from assenza a
group by a.tipo;


-- 9. Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?
select distinct 
    ap.tipo
from LavoroProgetto ap;
-- oppure
select 
    ap.tipo as tipologia_attivita,
    count(distinct ap.persona) as num_persone
from AttivitaProgetto ap
group by ap.tipo;

-- 10. Quali sono i giorni distinti nei quali del personale ha effettuato
-- attività non progettuali di tipo ‘Didattica’ ? Dare il risultato in ordine crescente.
select distinct
    anp.giorno
from AttivitaNonProgettuale anp
where anp.tipo = 'Didattica'
order by anp.giorno asc;

