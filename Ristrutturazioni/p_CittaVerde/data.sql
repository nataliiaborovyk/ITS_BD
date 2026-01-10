INSERT INTO specie (n_scientifico, n_comune) VALUES 
('Quercus robur', 'Farnia'),
('Pinus pinea', 'Pino domestico'),
('Tilia platyphyllos', 'Tiglio nostrano'),
('Acer campestre', 'Acero campestre'),
('Olea europaea', 'Olivo');

INSERT INTO areaverde (lat, lon, is_fruibile, is_sensibile) VALUES 
(41.9028, 12.4964, true, false),   -- Area 1: Roma (Fruibile, Non sensibile)
(45.4642, 9.1900, true, true),     -- Area 2: Milano (Fruibile, Sensibile -> OK)
(43.7696, 11.2558, false, false),  -- Area 3: Firenze (Non fruibile, Non sensibile -> OK)
(40.8518, 14.2681, true, false),   -- Area 4: Napoli
(45.0703, 7.6869, true, true);     -- Area 5: Torino

INSERT INTO soggettoverde (data, specie, area) VALUES 
('2020-01-15', 'Quercus robur', 1),
('2019-03-20', 'Pinus pinea', 1),
('2021-11-05', 'Tilia platyphyllos', 2),
('2018-06-12', 'Acer campestre', 3),
('2022-02-28', 'Olea europaea', 4);

INSERT INTO operatore (cf, nome, cognome, inizio, fine) VALUES 
('RSSMRA80A01H501U', 'Mario', 'Rossi', '2015-01-01', NULL),
('VRDLGI90B02F205Z', 'Luigi', 'Verdi', '2018-05-10', NULL),
('BNCMRA85C43H501T', 'Maria', 'Bianchi', '2020-09-01', NULL),
('FCCGNN75D04G224W', 'Giovanni', 'Facchetti', '2010-03-15', '2022-12-31'),
('RZZANN88E45A123K', 'Anna', 'Rizzo', '2021-06-01', NULL);

INSERT INTO intervento (inizio, durata, priorita, area) VALUES 
('2023-10-01 08:00:00', 120, 8, 1), -- ID 1 (Alta priorità)
('2023-10-02 09:30:00', 60, 5, 1),  -- ID 2
('2023-10-05 08:00:00', 240, 10, 2), -- ID 3 (Massima priorità)
('2023-10-10 14:00:00', 90, 3, 3),  -- ID 4
('2023-10-12 10:00:00', 180, 7, 5); -- ID 5

INSERT INTO interventoassegnato (id_intervento, fine) VALUES 
(1, '2023-10-01 10:00:00'), -- Concluso
(2, '2023-10-02 10:30:00'), -- Concluso
(3, NULL),                  -- Ancora in corso (fine è NULL)
(4, '2023-10-10 15:30:00'), -- Concluso
(5, NULL);                  -- Ancora in corso

INSERT INTO assegna (interventoassegnato, operatore, istante) VALUES 
(1, 'RSSMRA80A01H501U', '2023-10-01 08:00:00'),
(2, 'VRDLGI90B02F205Z', '2023-10-02 09:30:00'),
(3, 'RSSMRA80A01H501U', '2023-10-05 08:00:00'), -- Mario Rossi lavora anche qui
(4, 'BNCMRA85C43H501T', '2023-10-10 14:00:00'),
(5, 'RZZANN88E45A123K', '2023-10-12 10:00:00');

INSERT INTO areaverde (lat, lon, is_fruibile, is_sensibile) VALUES 
(44.4949, 11.3426, true, false); -- Bologna (Parco nuovo, ancora vuoto)

INSERT INTO operatore (cf, nome, cognome, inizio, fine) VALUES 
('NRAMRA95T12H501Q', 'Mauro', 'Neri', '2023-11-01', NULL);

INSERT INTO intervento (inizio, durata, priorita, area) VALUES 
('2023-12-25 08:00:00', 120, 10, 4); -- Emergenza a Napoli, ma nessuno l'ha presa in carico (non lo metto in interventoassegnato)

INSERT INTO intervento (inizio, durata, priorita, area) VALUES 
('2023-11-05 08:00:00', 300, 9, 2), -- ID 7: Grosso intervento a Milano
('2023-11-06 10:00:00', 60, 4, 1);  -- ID 8: Piccolo intervento a Roma

INSERT INTO interventoassegnato (id_intervento, fine) VALUES 
(7, NULL), -- ID 7: Ancora in corso
(8, '2023-11-06 11:00:00'); -- ID 8: Finito

INSERT INTO assegna (interventoassegnato, operatore, istante) VALUES 
(8, 'BNCMRA85C43H501T', '2023-11-06 10:00:00'), -- Maria Bianchi su Intervento 8
(7, 'RSSMRA80A01H501U', '2023-11-05 08:00:00'), -- Mario Rossi su Intervento 7
(7, 'VRDLGI90B02F205Z', '2023-11-05 08:00:00'), -- Luigi Verdi su Intervento 7 (Stesso orario, stesso intervento)
(3, 'FCCGNN75D04G224W', '2023-10-05 09:00:00'), -- Giovanni Facchetti si unisce all'intervento 3 un'ora dopo l'inizio
(5, 'VRDLGI90B02F205Z', '2023-10-12 11:00:00'); -- Luigi Verdi va ad aiutare Anna Rizzo a Torino

