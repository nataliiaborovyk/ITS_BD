

begin transaction;
	set constraints all deferred;

insert into utente(username, registrazione)
values
('U02001', current_timestamp),
('U02002', current_timestamp),
('U02003', current_timestamp),
('U02004', current_timestamp),
('U02005', current_timestamp),
('U02006', current_timestamp),
('U02007', current_timestamp),
('U02008', current_timestamp),
('U02009', current_timestamp),
('U02010', current_timestamp),
('U02011', current_timestamp),
('U02012', current_timestamp),
('U02013', current_timestamp),
('U02014', current_timestamp),
('U02015', current_timestamp),
('U02016', current_timestamp),
('U02017', current_timestamp),
('U02018', current_timestamp),
('U02019', current_timestamp),
('U02020', current_timestamp);

insert into privato(utente)
values
('U02001'),
('U02002'),
('U02003'),
('U02004'),
('U02005'),
('U02006'),
('U02007'),
('U02008'),
('U02009'),
('U02010'),
('U02011'),
('U02012'),
('U02013'),
('U02014');

insert into venditoreprof(utente, vetrina)
values

('U02015', 'www.shop-U020015.com'),
('U02016', 'www.shop-U020016.com'),
('U02017', 'www.shop-U020017.com'),
('U02018', 'www.shop-U020018.com'),
('U02019', 'www.shop-U020019.com'),
('U02020', 'www.shop-U020020.com');

commit;


begin transaction;
	set constraints all deferred;


insert into postoggetto(id, pubblica, descrizione, pubblicazione, categoria)
values
(02001, 'U02001', 'Ficus alto 2m', current_timestamp, 'Giardinaggio'),
(02002, 'U02001', 'Palma datteri 1m', current_timestamp, 'Giardinaggio'),
(02003, 'U02002', 'Poltrona-letto, perfette condizioni', current_timestamp, 'Arredamento'),
(02004, 'U02002', 'Tappetto, persiano finto', current_timestamp, 'Arredamento'),
(02005, 'U02002', 'Sedie da pranzo, 6 pezzi', current_timestamp, 'Arredamento'),
(02006, 'U02003', 'Comodino Bambu Ikea', current_timestamp, 'Arredamento'),
(02007, 'U02004', 'Barbecue, buono stato', current_timestamp, 'Giardinaggio'),
(02008, 'U02004', 'Accessori per barbecue', current_timestamp, 'Giardinaggio'),
(02009, 'U02005', 'Pala da neve', current_timestamp, 'Giardinaggio'),
(02010, 'U02006', 'Ombrellone a palo laterale', current_timestamp, 'Giardinaggio'),
(02011, 'U02006', 'Lettino da sole, pieghevole', current_timestamp, 'Giardinaggio'),
(02012, 'U02006', 'Dondolo 3 posti', current_timestamp, 'Giardinaggio'),
(02013, 'U02007', 'TV anni 50', current_timestamp, 'Arredamento'),
(02014, 'U02007', 'Ventilatore, mai usato', current_timestamp, 'Elettronica'),
(02015, 'U02007', 'Mazza da baseball', current_timestamp, 'Casa e giardino'),
(02016, 'U02008', 'Smartphone ZX Ultra, scermo rotto', current_timestamp, 'Elettronica'),
(02017, 'U02008', 'Laptop Pro 14" 16GB/1TB', current_timestamp, 'Laptop'),
(02018, 'U02009', 'Quadro, paesaggio', current_timestamp, 'Arredamento')
(02019, 'U02009', 'Quadro, astratto, attore sconosciuto', current_timestamp, 'Arredamento'),
(02020, 'U02009', 'Quadro, ritratto donna sconosciuta', current_timestamp, 'Arredamento'),
(02021, 'U02010', 'Divano di pelle', current_timestamp, 'Arredamento'),
(02022, 'U02010', 'Frigorifero, Samsung A77YGF', current_timestamp, 'Elettronica'),
(02023, 'U02010', 'Stampante XEROX', current_timestamp, 'Informatica'),
(02024, 'U02010', 'Microfono profesionale', current_timestamp, 'Elettronica'),
(02025, 'U02015', 'Apple MacBook Air 13 M4', current_timestamp, 'Laptop'),
(02026, 'U02015', 'Samsung Galaxy Book5 Intel Core Ultra 7', current_timestamp, 'Laptop'),
(02027, 'U02016', 'TV Sony BRAVIA XR', current_timestamp, 'Elettronica'),
(02028, 'U02017', 'Tagliaerba a batteria', current_timestamp, 'Giardinaggio'),
(02029, 'U02018', 'Finestra in PVC bianco L 60 x H 120 cm', current_timestamp, 'Casa e giardino'),
(02030, 'U02019', 'Albero di natale pino 3m', current_timestamp, 'Casa e giardino'),
(02031, 'U02020', 'RAMNEFJÄLL letto 160x200', current_timestamp, 'Arredamento'),
(02032, 'U02020', 'EKHOLMA divano 4 posti, grigio-marrone', current_timestamp, 'Arredamento');


insert into postoggettousato(postoggetto, condizione, anni_garanzia)
values
(02001, 'Ottimo', 0),
(02002, 'Ottimo', 0),
(02003, 'Discreto', 0),
(02004, 'Discreto', 0),
(02005, 'Buono', 0),
(02006, 'Buono', 0),
(02007, 'Buono', 0),
(02008, 'Buono', 0),
(02009, 'Discreto', 0),
(02010, 'Da sistemare', 0),
(02011, 'Buono' 0),
(02012, 'Buono', 0),
(02013, 'Da sistemare', 0),
(02014, 'Discreto', 0),
(02015, 'Buono', 0),
(02016, 'Da sistemare', 0),
(02017, 'Ottimo', 0),
(02018, 'Discreto', 0),
(02019, 'Buono', 0),
(02020, 'Buono', 0),
(02021, 'Buono', 0),
(02022, 'Buono', 0),
(02023, 'Ottimo',0),
(02024, 'Buono', 0);

insert into postoggettonuovo(postoggetto, pubblica_nuovo, anni_garanzia)
values
(02025, 'U02015', 2),
(02026, 'U02015', 2),
(02027, 'U02016', 3),
(02028, 'U02017', 1),
(02029, 'U02018', 5),
(02030, 'U02019', 1),
(02031, 'U02020', 10),
(02032, 'U02020', 15);


insert into postoggettocompralosubito(postoggetto, prezzo)
values
-- priv
(02001, 50.0),
(02002, 25.0),
(02003, 65.0),
(02004, 29.99),
(02005, 70.0),
(02006, 15.0),
(02008, 15.0),
(02009, 10.0),
(02010, 40.0),
(02011, 30.0),
(02014, 30.0),
(02016, 350.0),
(02022, 237.0),
(02023, 120.0),
(02024, 45.0),
-- vend prof
(02027, 890.00),
(02028, 150.00),
(02029, 120.00),
(02031, 350.00),
(02032, 780.00);


insert into postoggettoasta(postoggetto, prezzo_base, prezzo_bid, scadenza)
values


(02007, 40.00, 5, current_timestamp + interval '5 day'),
(02012, 50.00, 3, current_timestamp + interval '7 day'),
(02013, 30.00, 5, current_timestamp + interval '30 day')
(02015, 300.00, 20, current_timestamp + interval '10 day'),
(02017, 489.00, 25 current_timestamp + interval '14 day'),
(02018, 1790, 50 current_timestamp + interval '20 day'),
(02019, 730, 5, current_timestamp + interval '15 day'),
(02020, 5000, 100, current_timestamp + interval '30 day'),
(02021, 400, 30, current_timestamp + interval '20 day'),
(02025, 1100.00, 5, current_timestamp + interval '14 day'),
(02026, 689.99, 5 current_timestamp + interval '20 day'),
(02030, 50, 5, current_timestamp + interval '10 day');
commit;



-- Asta per la barbecue

insert into bid(codice, istante, asta, privato)
values
(02001, current_timestamp, 02007, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02002, current_timestamp, 02007, 'U02012');

insert into bid(codice, istante, asta, privato)
values
(02003, current_timestamp, 02007, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02004, current_timestamp, 02007, 'U02012');



-- Asta per la TV vecchio


insert into bid(codice, istante, asta, privato)
values
(02001, current_timestamp, 02013, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02002, current_timestamp, 02013, 'U02014');

insert into bid(codice, istante, asta, privato)
values
(02003, current_timestamp, 02013, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02004, current_timestamp, 02013, 'U02012');


-- Asta per la MacBook


insert into bid(codice, istante, asta, privato)
values
(02001, current_timestamp, 02025, 'U02012');

insert into bid(codice, istante, asta, privato)
values
(02002, current_timestamp, 02025, 'U02014');

insert into bid(codice, istante, asta, privato)
values
(02003, current_timestamp, 02025, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02004, current_timestamp, 02025, 'U02012');

insert into bid(codice, istante, asta, privato)
values
(02001, current_timestamp, 02025, 'U02013');

insert into bid(codice, istante, asta, privato)
values
(02002, current_timestamp, 02025, 'U02014');

insert into bid(codice, istante, asta, privato)
values
(02003, current_timestamp, 02025, 'U02011');

insert into bid(codice, istante, asta, privato)
values
(02004, current_timestamp, 02025, 'U02012');