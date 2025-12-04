-- Persona
insert into Persona (id, nome, cognome, posizione, stipendio)
    values (1, 'Alice', 'Rossi', 'Ricercatore', 2000);

insert into Persona (id, nome, cognome, posizione, stipendio)
    values (2, 'Biagio', 'Rossi', 'Professore Associato', 3500);

insert into Persona (id, nome, cognome, posizione, stipendio)
    values (3, 'Carlo', 'Carlino', 'Ricercatore', 2000);

insert into Persona (id, nome, cognome, posizione, stipendio)
    values (4, 'Carlo', 'Valensi', 'Professore Ordinario', 5000);

insert into Persona (id, nome, cognome, posizione, stipendio)
    values (5, 'Mario', 'Verdi', 'Ricercatore', 2000);

insert into Persona (id, nome, cognome, posizione, stipendio)
    values (6, 'Anna', 'Vile', 'Professore Associato', 4000);


--Progetto
insert into Progetto (id, nome, inizio, fine, budget)
    values (1, 'Phenix', '10/02/2025', '07/12/2025', 800);

insert into Progetto (id, nome, inizio, fine, budget)
    values (2, 'Armagedon', '07/07/2025', '08/07/2025', 100);


--WP
insert into WP (progetto, id, nome, inizio, fine)
    values (2, 623, 'Iterazione 1', '07/07/2025', '08/07/2025');

insert into WP (progetto, id, nome, inizio, fine)
    values (1, 623, 'Iterazione 1', '02/10/2025', '04/01/2025');

insert into WP (progetto, id, nome, inizio, fine)
    values (1, 624, 'Iterazione 3', '05/01/2025', '06/01/2025');

insert into WP (progetto, id, nome, inizio, fine)
    values (1, 625, 'Iterazione 2', '04/02/2025', '05/01/2025');

--Assenza
insert into Assenza (id, persona, tipo, giorno)
    values (1523, 1, 'Malattia', '04/07/2025');

-- insert into Assenza (id, persona, tipo, giorno)
--     values (1341, 1, 'Malattia', '23/05/2025');

insert into Assenza (id, persona, tipo, giorno)
    values (1547, 1, 'Malattia', '05/07/2025');

insert into Assenza (id, persona, tipo, giorno)
    values (1345, 1, 'Chiusura Universitaria', '01/01/2025');

insert into Assenza (id, persona, tipo, giorno)
    values (5342, 2, 'Chiusura Universitaria', '01/01/2025');

insert into Assenza (id, persona, tipo, giorno)
    values (1543, 3, 'Chiusura Universitaria', '01/01/2025');


--AttivitaNonProgettuale
insert into AttivitaNonProgettuale (id, persona, tipo, giorno, oreDurata)
    values (1341, 1, 'Didattica', '07/07/2025', 8);

insert into AttivitaNonProgettuale (id, persona, tipo, giorno, oreDurata)
    values (1344, 2, 'Didattica', '08/07/2025', 8);

insert into AttivitaNonProgettuale (id, persona, tipo, giorno, oreDurata)
    values (1345, 3, 'Didattica', '09/07/2025', 8);

insert into AttivitaNonProgettuale (id, persona, tipo, giorno, oreDurata)
    values (1346, 2, 'Didattica', '09/07/2025', 8);


--AttivitaProgetto
    values (1543, 3, 'Chiusura Universitaria', '01/01/2025');


--AttivitaNonProgettuale
insert into AttivitaNonProgettuale (id, persona, progetto, wp, giorno, tipo, oredurata)
    values (1341, 1, 'Armagedon', '07/07/2025', 8);