
 

--  1   Quali sono il nome, la data di inizio e la data di fine dei WP del progetto 
--      di nome ‘Pegasus’ ?
select p.nome, wp.nome, wp.inizio, wp.fine
from progetto p, wp
where wp.progetto = p.id
    and p.nome = 'Pegasus'
order by wp.inizio asc;

 
--  2   Quali sono il nome, il cognome e la posizione degli strutturati 
--      che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
select p.id, p.nome, p.cognome, count(ap.id) as num_attivita
from persona p, progetto pr, AttivitaProgetto ap
where ap.persona = p.id
    and ap.progetto = pr.id
    and pr.nome = 'Pegasus'
group by p.id;

--  3   Quali sono il nome, il cognome e la posizione degli strutturati 
--      che hanno più di una attività nel progetto ‘Pegasus’ ?
select p.id, p.nome, p.cognome, count(ap.id) as num_attivita
from persona p, progetto pr, attivitaprogetto ap
where ap.persona = p.id
    and ap.progetto = pr.id
    and pr.nome = 'Pegasus'
group by p.id
having count(ap.id)>1;

-- oppure
select distinct 
    p.id, p.nome, p.cognome
from persona p, progetto pr, attivitaprogetto ap1, attivitaprogetto ap2
where ap1.persona = p.id
    and ap2.persona = p.id
    and ap1.progetto = pr.id
    and ap2.progetto = pr.id
    and pr.nome = 'Pegasus'
    and ap1.id <> ap2.id;

--  4   Quali sono il nome, il cognome e la posizione dei Professori Ordinari 
--      che hanno fatto almeno una assenza per malattia? 
select p.id, p.nome, p.cognome, count(a.id) as num_assenze_per_malattia
from persona p, assenza a
where a.persona = p.id
    and p.posizione = 'Professore Ordinario'
    and a.tipo = 'Malattia'
group by p.id;

-- oppure
select distinct
    p.id, p.nome, p.cognome
from persona p, assenza a
where a.persona = p.id
    and p.posizione = 'Professore Ordinario'
    and a.tipo = 'Malattia';


--   5  Quali sono il nome, il cognome e la posizione dei Professori Ordinari 
--      che hanno fatto più di una assenza per malattia?
select p.id, p.nome, p.cognome, count(a.id) as num_assenze_per_malattia
from persona p, assenza a
where a.persona = p.id
    and p.posizione = 'Professore Ordinario'
    and a.tipo = 'Malattia'
group by p.id
having count(a.id)>1;

-- oppure
select distinct
    p.id, p.nome, p.cognome
from persona p, assenza a1, assenza a2
where a1.persona = p.id
    and a2.persona = p.id
    and p.posizione = 'Professore Ordinario'
    and a1.id <> a2.id;

--  6   Quali sono il nome, il cognome e la posizione dei Ricercatori 
--      che hanno almeno un impegno per didattica?
select p.id, p.nome, p.cognome, p.posizione, count(anp.id) as num_impegni
from persona p, attivitanonprogettuale anp
where anp.persona = p.id
    and p.posizione = 'Ricercatore'
    and anp.tipo = 'Didattica'
group by p.id;

-- oppure
select distinct
    p.id, p.nome, p.cognome, p.posizione
from persona p, attivitanonprogettuale anp
where anp.persona = p.id
    and anp.tipo = 'Didattica'
    and p.posizione = 'Ricercatore';



--  7   Quali sono il nome, il cognome e la posizione dei Ricercatori 
--      che hanno più di un impegno per didattica?
select p.id, p.nome, p.cognome, p.posizione, count(anp.id) as num_attivita
from persona p, attivitanonprogettuale anp  
where anp.persona = p.id
    and p.posizione = 'Ricercatore'
    and anp.tipo = 'Didattica'
group by p.id
having count(anp.id) > 1;

-- oppure
select distinct
    p.id, p.nome, p.cognome, p.posizione
from persona p, attivitanonprogettuale anp1, attivitanonprogettuale anp2
where anp1.persona = p.id
    and anp2.persona = p.id
    and p.posizione = 'Ricercatore'
    and anp1.tipo = 'Didattica'
    and anp2.tipo = 'Didattica'
    and anp1.id <> anp2.id;


--  8   Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno hanno sia attività progettuali che attività non progettuali?     
select p.id, p.nome, p.cognome, p.posizione
from persona p, attivitaprogetto ap, attivitanonprogettuale anp
where ap.persona = p.id
    and anp.persona = p.id
    and ap.giorno = anp.giorno;


--  9   Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno hanno sia attività progettuali che attività non progettuali? 
--      Si richiede anche di proiettare il giorno, il nome del progetto, 
--      il tipo di attività non progettuali e la durata in ore di entrambe le attività.
select p.id, p.nome, p.cognome, ap.giorno, 
    pr.nome as nome_progetto,
    ap.oreDurata as durata_att_progettuale,
    anp.tipo as tipo_attivita_non_progettuale, 
    anp.oreDurata as durata_att_non_progettuale
from persona p, attivitanonprogettuale anp, attivitaprogetto ap, progetto pr
where anp.persona = p.id
    and ap.persona = p.id
    and ap.progetto = pr.id
    and anp.giorno = ap.giorno;


--  10  Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno sono assenti e hanno attività progettuali?   
select p.id, p.nome, p.cognome, ap.giorno
from persona p, attivitaprogetto ap, assenza a
where ap.persona = p.id
    and a.persona = p.id
    and ap.giorno = a.giorno;


--  11  Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno sono assenti e hanno attività progettuali? 
--      Si richiede anche di proiettare il giorno, il nome del progetto, 
--      la causa di assenza e la durata in ore della attività progettuale.
select p.id, p.nome, p.cognome, ap.giorno,
    pr.nome as nome_prog,
    ap.oredurata as durata_attivita_prog,
    a.tipo as causa_assenza    
from persona p, attivitaprogetto ap, assenza a, progetto pr
where ap.persona = p.id
    and a.persona = p.id
    and ap.giorno = a.giorno
    and ap.progetto = pr.id;



--  12  Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
select wp1.nome, wp1.id as id_wp1, wp2.id as id_wp2, pr1.nome as nome_prog_wp1, pr2.nome as nome_prog_wp2
from wp wp1, wp wp2, progetto pr1, progetto pr2
where wp1.nome = wp2.nome 
    and wp1.progetto = pr1.id
    and wp2.progetto = pr2.id
    and pr1.id <> pr2.id

