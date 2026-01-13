
 
-- !!! domanda: id (quando è la primary key o no) bisogna includere sempre ???


--  1   Quali sono il nome, la data di inizio e la data di fine dei WP del progetto 
--      di nome ‘Pegasus’ ?

select wp.id, wp.nome, wp.inizio, wp.fine
from wp, progetto prog
where 
    -- Progetto <-> WP
    prog.id = wp.progetto
    -- condizione
    and prog.nome = 'Pegasus';

    

--  2   Quali sono il nome, il cognome e la posizione degli strutturati 
--      che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?

-- Versione 1    con WP

select distinct pers.id, pers.nome, pers.cognome, pers.posizione
from persona pers,  AttivitaProgetto ap,  WP,  Progetto prog
where   
    -- Persona <-> AttivitaProgetto <-> WP <-> Progetto
    pers.id = ap.persona                                   
        and ap.progetto = wp.progetto and ap.wp = wp.id     
        and wp.progetto = prog.id                           
    -- condizioni                               
    and prog.nome = 'Pegasus'
    order by pers.cognome desc;

 -- Versione 2   senza WP 

select distinct pers.id, pers.nome, pers.cognome, pers.posizione
from persona pers,  AttivitaProgetto ap,  Progetto prog
where   
    -- Persona <-> AttivitaProgetto <-> Progetto
    pers.id = ap.persona                                   
        and ap.progetto =  prog.id                           
    -- condizioni                               
    and prog.nome = 'Pegasus'
    order by pers.cognome desc;  



--  3   Quali sono il nome, il cognome e la posizione degli strutturati 
--      che hanno più di una attività nel progetto ‘Pegasus’ ?

select distinct pers.id, pers.nome, pers.cognome, pers.posizione
from  Persona pers, AttivitaProgetto ap1,  AttivitaProgetto ap2,  Progetto prog
where 
    -- Persona <-> AttivitaProgetto 1 <-> Progetto
    pers.id = ap1.persona            
        and ap1.progetto = prog.id
    -- Persona <-> AttivitaProgetto 2 <-> Progetto
    and pers.id = ap2.persona         
        and ap2.progetto = prog.id
    -- condizioni   
    and prog.nome = 'Pegasus'
    and ap1.persona = ap2.persona   -- non serve ?
    and ap1.id <> ap2.id;,




--  4   Quali sono il nome, il cognome e la posizione dei Professori Ordinari 
--      che hanno fatto almeno una assenza per malattia? 

select distinct pers.id,  pers.nome,  pers.cognome
from Persona pers,  Assenza a
where 
    -- Persona <-> Assenza
    pers.id = a.persona
    -- condizioni
    and a.tipo = 'Malattia'
    and pers.posizione = 'Professore Ordinario';



--   5  Quali sono il nome, il cognome e la posizione dei Professori Ordinari 
--      che hanno fatto più di una assenza per malattia?

select distinct pers.id,  pers.nome,  pers.cognome
from persona pers,  assenza a1,  assenza a2
where 
    -- Persona <-> Assenza1
    pers.id = a1.persona
    -- Persona <-> Assenza2
    and pers.id = a2.persona
    -- condizioni
    and pers.posizione = 'Professore Ordinario'
    and a1.tipo = 'Malattia'
    and a2.tipo = 'Malattia'
    and a1.persona = a2.persona    -- non serve perche tutte due puntano su pers.id ??
    and a1.id <> a2.id;



--  6   Quali sono il nome, il cognome e la posizione dei Ricercatori 
--      che hanno almeno un impegno per didattica?

select distinct pers.id, pers.nome, pers.cognome
from Persona pers,  AttivitaNonProgettuale anp
where
    -- Persone <-> LavoroNonProgettuale
    pers.id = anp.persona
    -- condizioni
    and pers.posizione = 'Ricercatore'
    and anp.tipo = 'Didattica';



--  7   Quali sono il nome, il cognome e la posizione dei Ricercatori 
--      che hanno più di un impegno per didattica?

select distinct pers.id,  pers.nome,  pers.cognome
from Persona pers,  AttivitaNonProgettuale anp1,  AttivitaNonProgettuale anp2
where
    -- Persone <-> LavoroNonProgettuale1
    pers.id = anp1.persona
    -- Persone <-> LavoroNonProgettuale2
    and pers.id = anp2.persona
    -- condizioni
    and pers.posizione = 'Ricercatore'
    and anp1.tipo = 'Didattica'
    and anp2.tipo = 'Didattica'
    and anp1.persona = anp2.persona     -- non serve  ?????
    and anp1.id <> anp2.id



--  8   Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno hanno sia attività progettuali che attività non progettuali?     

select distinct pers.id,  pers.nome,  pers.cognome
from Persona pers,  AttivitaNonProgettuale anp,  AttivitaProgetto ap
where
    -- Persona <-> AttivitaNonProgettuale
    pers.id = anp.persona
    -- Persona <-> AttivitaProgetto
    and pers.id = ap.persona
    -- condizione
    and anp.giorno = ap.giorno



--  9   Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno hanno sia attività progettuali che attività non progettuali? 
--      Si richiede anche di proiettare il giorno, il nome del progetto, 
--      il tipo di attività non progettuali e la durata in ore di entrambe le attività.

select  distinct 
        pers.id,  
        pers.nome,  
        pers.cognome,  
        ap.giorno,  
        prog.nome as prj,  
        ap.oreDurata as h_prj,  
        anp.tipo as att_noprj,  
        anp.oreDurata as h_noprj
from   Persona pers,  AttivitaNonProgettuale anp,  
       AttivitaProgetto ap,  Progetto prog
where
    -- Persona <-> AttivitaNonProgettuale,
    pers.id = anp.persona
    -- Persona <-> AttivitaProgetto <-> Progetto
    and pers.id = ap.persona
        and ap.progetto = prog.id
    -- condizione
    and anp.giorno = ap.giorno



--  10  Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno sono assenti e hanno attività progettuali?   

select distinct pers.id,  pers.nome,  pers.cognome
from Persona pers,  AttivitaProgetto ap,  Assenza a
where 
    -- Persona <-> AttivitaProgetto
    pers.id = ap.persona
    -- Persona <-> Assenza
    and pers.id = a.persona
    -- condizione
    and ap.giorno = a.giorno



--  11  Quali sono il nome e il cognome degli strutturati 
--      che nello stesso giorno sono assenti e hanno attività progettuali? 
--      Si richiede anche di proiettare il giorno, il nome del progetto, 
--      la causa di assenza e la durata in ore della attività progettuale.

select  distinct 
        pers.id,  
        pers.nome,  
        pers.cognome,  
        ap.giorno,  
        a.tipo as causa_ass,  
        prog.nome as progetto,  
        ap.oreDurata as ore_att_prj
from Persona pers,  AttivitaProgetto ap,  Progetto prog,  Assenza a
where
    -- Persona <-> AttivitaProgetto <-> Progetto
    pers.id = ap.persona
        and ap.progetto = prog.id
    -- Persona <-> Assenza
    and pers.id = a.persona
    -- condizione
    and ap.giorno = a.giorno



--  12  Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?

select distinct wp1.nome
from  WP wp1,  WP wp2
where
    -- WP1 <-> WP2
    wp1.progetto <> wp2.progetto
    and wp1.nome = wp2.nome

