

-- categorie

insert into categoria(nome, super)
values
('Elettronica', NULL),
('Informatica', 'Elettronica'),
('Laptop', 'Informatica'),
('Casa e giardino', NULL),
('Arredamento', 'Casa e giardino'),
('Giardinaggio', 'Casa e giardino');


begin transaction;
	set constraints all deferred;

insert into utente(username, registrazione)
values
('U99001', current_timestamp),
('U99002', current_timestamp),
('U99003', current_timestamp),
('U99004', current_timestamp);

insert into privato(utente)
values
('U99001'),
('U99002');

insert into venditoreprof(utente, vetrina)
values
('U99003', 'www.example.u3.com'),
('U99004', 'www.mystore.u4.it');

commit;


insert into metodopagamento(nome)
values
('Carta'),
('Bonifico'),
('PayPal');

begin transaction;
	set constraints all deferred;


insert into postoggetto(id, pubblica, descrizione, pubblicazione, categoria)
values
(99001, 'U99004', 'IKEA Kallax 4x4', current_timestamp, 'Arredamento'),
(99002, 'U99003', 'Apple MacBook Pro M4 12 core', current_timestamp, 'Laptop'),
(99003, 'U99002', 'Zappa deluxe', current_timestamp, 'Giardinaggio'),
(99004, 'U99002', 'Annaffiatoio deluxe', current_timestamp, 'Giardinaggio'),
(99005, 'U99002', 'Rastrello semi-nuovo', current_timestamp, 'Giardinaggio'),
(99006, 'U99004', 'Comodino Stockholm', current_timestamp, 'Arredamento');


insert into postoggettousato(postoggetto, condizione, anni_garanzia)
values
(99003, 'Ottimo', 0),
(99004, 'Ottimo', 0),
(99005, 'Buono', 0),
(99006, 'Discreto', 1);

insert into postoggettonuovo(postoggetto, pubblica_nuovo, anni_garanzia)
values
(99001, 'U99004', 2),
(99002, 'U99003', 5);


insert into postoggettocompralosubito(postoggetto, prezzo)
values
(99005, 10),
(99002, 2499.99),
(99001, 174.00);


insert into postoggettoasta(postoggetto, prezzo_base, prezzo_bid, scadenza)
values
(99003, 5.00, 1, current_timestamp + interval '7 day'),
(99004, 1.00, 0.5, current_timestamp + interval '4 day'),
(99006, 10.00, 2.00, current_timestamp + interval '3 day');

commit;


begin transaction;
	set constraints all deferred;

insert into utente(username, registrazione)
values
('U99005', current_timestamp);

insert into privato(utente)
values
('U99005');

commit;

-- Asta per la zappa

insert into bid(codice, istante, asta, privato)
values
(99001, current_timestamp, 99003, 'U99001');

insert into bid(codice, istante, asta, privato)
values
(99002, current_timestamp, 99003, 'U99005');

insert into bid(codice, istante, asta, privato)
values
(99003, current_timestamp, 99003, 'U99001');

insert into bid(codice, istante, asta, privato)
values
(99004, current_timestamp, 99003, 'U99005');

insert into bid(codice, istante, asta, privato)
values
(99005, current_timestamp, 99003, 'U99001');

insert into bid(codice, istante, asta, privato)
values
(99006, current_timestamp, 99003, 'U99005');

insert into bid(codice, istante, asta, privato)
values
(99007, current_timestamp, 99003, 'U99001');

insert into bid(codice, istante, asta, privato)
values
(99008, current_timestamp, 99003, 'U99001');


insert into bid(codice, istante, asta, privato)
values
(99009, current_timestamp, 99004, 'U99001');

insert into bid(codice, istante, asta, privato)
values
(99010, current_timestamp, 99004, 'U99005');



