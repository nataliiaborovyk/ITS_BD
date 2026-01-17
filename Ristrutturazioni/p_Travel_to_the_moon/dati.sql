begin transaction;

INSERT INTO nazione(nome) VALUES
('Italia'),
('Giappone'),
('Egitto');

INSERT INTO regione(nome, nazione) VALUES
('Liguria', 'Italia'),
('Kanto', 'Giappone'),
('Cairo Governatorato', 'Egitto');

INSERT INTO citta(nome, regione) VALUES
('Genova', 1),
('Tokyo', 2),
('Giza', 3);

INSERT INTO cliente(cf, nome, cognome, data_nascita, indirizzo, citta)
VALUES
('RSSMRA80A01H501U', 'Mario', 'Rossi', '1980-01-10',
    ROW('Via Roma', '12A', '16100'), 1),
('VRDLGI93C20H501X', 'Giulia', 'Verdi', '1993-03-20',
    ROW('Corso Italia', '55', '16146'), 1);

INSERT INTO nave(codice, nome, comfort, num_posti)
VALUES
('NAV001', 'LoveBoat', 5, 200);

INSERT INTO itinerario(nome)
VALUES ('Panorami d’Oriente');

INSERT INTO destinazioneScalo(nome, citta, distanza_da_citta_km)
VALUES
('Tokyo Bay', 2, 0),
('Giza Plateau', 3, 0),
('Porto Antico', 1, 0),
('Spiaggia Lontana',1, 25),
('Molo Crociere Genova', 1, 0);

INSERT INTO tipoDestinazione(nome)
VALUES
('Romantica'),
('Divertente'),
('Storica');

INSERT INTO dest_tip (tipoDestinazione, destinazioneScalo) VALUES
    -- Tokyo Bay (1)
    ('Romantica', 1),
    ('Divertente', 1),
    -- Giza Plateau (2)
    ('Storica', 2),
    -- Porto Antico (3)
    ('Storica', 3),
    ('Divertente', 3),
    -- Spiaggia Lontana (4)
    ('Romantica', 4),
    -- Molo Crociere Genova (5)
    ('Divertente', 5);


INSERT INTO postoEscursione(nome, destinazioneScalo, descrizione)
VALUES
('Parco Hamarikyu', 1, 'Giardini tradizionali sul mare'),
('Piramidi di Giza', 2, 'Complesso archeologico unico al mondo'),
('Acquario di Genova', 3, 'Percorso marino storico'),
('Tempio sul Mare', 1, 'Piccolo santuario con vista sulla baia di Tokyo'),
('Sfinge di Giza', 2, 'Statua monumentale con vista sul deserto e sulle piramidi'),
('Botteghe Storiche', 3, 'Piccoli negozi tradizionali nella zona del porto'),
('Belvedere sulla Scogliera', 4, 'Punto panoramico con vista sul mare aperto'),
('Chiosco Tramonto', 4, 'Chiosco sulla spiaggia ideale per aperitivi al tramonto'),
('Passeggiata sul Molo', 5, 'Percorso pedonale lungo il molo con vista sulle navi'),
('Belvedere Porto', 5, 'Terrazza panoramica sul porto e sulla città');

INSERT INTO scalo (
    numero,
    itinerario,
    rel_arr_giorno,
    rel_arr_ora,
    rel_part_giorno,
    rel_part_ora,
    destinazionescalo
) VALUES
    -- Scalo 0: solo partenza
    (0,
     'Panorami d’Oriente',
     NULL,       -- arrivo giorno
     NULL,       -- arrivo ora
     0,          -- partenza giorno
     '18:00',    -- partenza ora
     3
    ),

    -- Scalo 1: arrivo e partenza
    (1,
     'Panorami d’Oriente',
     3,          -- arrivo giorno
     '09:00',    -- arrivo ora
     4,          -- partenza giorno
     '12:00',    -- partenza ora
     1
    ),

    -- Scalo 2: arrivo e partenza
    (2,
     'Panorami d’Oriente',
     6,
     '10:00',
     7,
     '16:00',
     2
    ),

    -- Scalo 3: arrivo e partenza
    (3,
     'Panorami d’Oriente',
     8,
     '09:00',
     8,
     '18:00',
     4
    ),

    -- Scalo 4: solo arrivo
    (4,
     'Panorami d’Oriente',
     10,
     '08:00',
     NULL,
     NULL,
     5
    );


INSERT INTO crociera(codice, data_inizio_programmata, is_per_famiglie,
                     adatta_per_bambini, nave, itinerario)
VALUES
('CR001', '2025-06-01 18:00', FALSE, NULL, 'NAV001', 'Panorami d’Oriente');

INSERT INTO cr_sc (
    ritardo_arrivo_minuti,
    ritardo_partenza_minuti,
    scalo,
    crociera
) VALUES
    -- Scalo 0: Porto Antico (Genova)
    (0, 0, 1, 'CR001'),

    -- Scalo 1: Tokyo Bay
    (10, 5, 2, 'CR001'),

    -- Scalo 2: Giza Plateau
    (0, 0, 3, 'CR001'),

    -- Scalo 3: Spiaggia Lontana
    (0, 30, 4, 'CR001'),

    -- Scalo 4: Molo Crociere Genova (arrivo finale)
    (20, 0, 5, 'CR001');

INSERT INTO prenotazione(istante, num_posti, cliente, crociera)
VALUES
('2025-01-10 10:00', 2, 'RSSMRA80A01H501U', 'CR001'),
('2025-01-12 12:30', 3, 'VRDLGI93C20H501X', 'CR001');

commit;