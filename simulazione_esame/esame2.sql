-- 1. Quali sono le persone con stipendio di al massimo 40000
-- euro [2 punti]
select p.id, p.nome, p.cognome
from persona p
where p.sttipendio <= 40000;

-- 2. Quali sono i ricercatori che lavorano ad almeno un
-- progetto e hanno uno stipendio di al massimo 40000 [2
-- punti]
select p.id, p.nome, p.cognome
from persona p, attivitaprogetto ap
where ap.persona = p.id
    and p.stipendio <= 40000
    and p.posizione = 'Ricercatore';

-- 3. Qual è il budget totale dei progetti nel db [2 punti]
select sum(budget)
from progetto p;


-- 4. Qual è il budget totale dei progetti a cui lavora ogni
-- persona. Per ogni persona restituire nome, cognome e
-- budget totale dei progetti nei quali è coinvolto. [3 punti]
select p.id, p.nome, p.cognome, sum(pr.budget)
from attivitaprogetto ap, progetto pr, persona p
where ap.progetto = pr.id
    and ap.persona = p.id
group by p.id;

-- 5. Qual è il numero di progetti a cui partecipa ogni
-- professore ordinario. Per ogni professore ordinario,
-- restituire nome, cognome, numero di progetti nei quali è
-- coinvolto [3 punti]
select p.id, p.nome, p.cognome, count(distinct ap.progetto)
from persona p, attivitaprogetto ap
where ap.persona = p.id 
    and p.posizione = 'Professore Ordinario'
group by p.id;

-- 6. Qual è il numero di assenze per malattia di ogni
-- professore associato. Per ogni professore associato,
-- restituire nume, cognome e numero di assenze per
-- malattia [3 punti]
select p.id, p.nome, p.cognome, count(a.id)
from persona p, assenzza a
where a.persona = p.id
    and a.tipo = 'Malattia'
    and p.posizione = 'Professore Associato';

-- 7. Qual è il numero totale di ore, per ogni persona, dedicate
-- al progetto con id ‘5’. Per ogni persona che lavora al
-- progetto, restituire nome, cognome e numero di ore totali
-- dedicate ad attività progettuali relative al progetto [4
select p.id, p.nome, p.cognome, sum(ap.oredurata)
from persona p, attivitaprogetto ap
where ap.persona = p.id
    and ap.progetto = 5
group by p.id;


-- 8. Qual è il numero medio di ore delle attività progettuali
-- svolte da ogni persona. Per ogni persona, restituire nome,
-- cognome e numero medio di ore delle sue attività
-- progettuali (in qualsivoglia progetto) [3 punti]
select p.id, p.nome, p.cognome, avg(ap.oredurata)
from persona p, attivitaprogetto ap
where ap.persona = p.id
group by p.id;

-- 9. Qual è il numero totale di ore, per ogni persona, dedicate
-- alla didattica. Per ogni persona che ha svolto attività
-- didattica, restituire nome, cognome e numero di ore totali
-- dedicate alla didattica [4 punti]
select p.id, p.nome, p.cognome, sum(anp.oredurata)
from attivitanonprogettuale anp, persona p
where anp.persona = p.id
    and anp.tipo = 'Didattica'
group by p.id;

-- 10. Quali sono le persone che hanno svolto attività nel WP
-- di id ‘5’ del progetto con id ‘3’. Per ogni persona, restituire
-- il numero totale di ore svolte in attività progettuali per il
-- WP in questione [4 punti]
select p.id, p.nome, p.cognome, sum(ap.oredurata) 
from attivitaprogetto ap, wp, persona p
where ap.progetto = wp.progetto
    and ap.persona = p.id
    and ap.wp = wp.id
    and wp.id = 5
    and ap.progetto = 3
group by p.id;
