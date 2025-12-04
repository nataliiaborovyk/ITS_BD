

insert into categoria (nome, super) values
    ('Libri', null),
    ('Fantascienza', 'Libri'),
    ('Giochi', null),
    ('Casa', null),
    ('Piante', 'Casa'),
    ('Abigliamento', null),
    ('Scarpe', null),
    ('Elettronica', null),
    ('Elettrodomestici grandi', 'Elettronica'),
    ('Elettrodomestici piccoli', 'Elettronica'),
    ('Computer', 'Elettrodomestici piccoli');

insert into metodopagamento (nome) values
    ('Carta'),
    ('Paypal'),
    ('Bonifico');

insert into utente (username) values
    ('Anna'),
    ('Alice'),
    ('Carlo'),
    ('Biagio'),
    ('Maria');

insert into privato (utente) values
    ('Anna'),
    ('Alice'),
    ('Maria');

insert into venditoreprof (utente, vetrina) values
    ('Carlo', 'https://shop-carlo.com'),
    ('Biagio', 'https://shop-biagio.com');

insert into postoggetto (pubblica, descrizione, categoria) values
    ('Carlo', 'Notebook HP Intel i7', 'Computer'),
    ('Biagio', 'Lavatrice Bocsh 10 kg', 'Elettrodomestici grandi'),
    ('Anna', 'Camicia rossa cotone', 'Abbigliamento'),
    ('Anna', 'Stivali', 'Scarpe'),
    ('Alice', 'Python in 3 giorni', 'Fantascienza'),
    ('Maria', 'Ficus alto 1m', 'Piante');

insert into postoggettonuovo (postoggetto, pubblica_nuovo, anni_garanzia) values
    (1, 'Carlo', 2), -- pc
    (2, 'Biagio', 3); -- lavatrice

insert into postoggettousato (postoggetto, condizione, anni_garanzia) values
    (4, 'Buono', 0),  -- stivali
    (5, 'Discreto', 0), -- libro
    (6, 'Ottimo', 0), -- ficus
    (7, 'Ottimo', 0); -- camicia

insert into met_post (postoggetto, metodo) values   
    (1, 'Carta'),
    (1, 'Paypal'),
    (2, 'Bonifico'),
    (4, 'Carta'),
    (5, 'Paypal'),
    (6, 'Carta'),
    (7, 'Carta');
    
insert into asta (postoggetto, prezzo_bid, prezzo, scadenza) values
    (1, 25.00, 500.00, '2025-11-15 12:00:00'),  -- pc
    (2, 20.00, 200.00, '2025-10-05 21:00:00');  -- lavatrice

insert into compralosubito (postoggetto, prezzo) values
    (4, 30.00), -- Stivali
    (6, 15.00); -- Ficus

update compralosubito
    set acquirente = 'Maria',
        istante_acquirente = current_timestamp
    where postoggetto = 4;

update postoggetto
    set ha_feedback = true,
        voto = 5,
        commento = 'Sono comodi',
        istante_feedback = current_timestamp
    where id = 4;


update compralosubito
    set acquirente = 'Alice',
        istante_acquirente = current_timestamp
    where postoggetto = 6;

update postoggetto
    set ha_feedback = true,
        voto = 4,
        istante_feedback = current_timestamp
    where id = 6;


insert into bid (istante, asta_bid, bid_ut) values
    ('2025-09-25 18:00:00', 1, 'Anna'),
    ('2025-09-25 18:30:00', 1, 'Alice'),
    ('2025-09-26 19:00:00', 2, 'Maria'),
    ('2025-09-26 19:15:00', 2, 'Anna');


-- nuova vendita in asta
insert into postoggetto (pubblica, descrizione, categoria) values
    ('Maria', 'Giacca in pelle', 'Abbigliamento');

insert into postoggettousato (postoggetto, condizione, anni_garanzia) values
    (8, 'Ottimo', 0);

insert into met_post (postoggetto, metodo) values 
    (8, 'Paypal');

insert into asta (postoggetto, prezzo_bid, prezzo, scadenza) values
    (8, 20.00, 150.00, '2025-09-23 21:00:00');  -- giacca

insert into bid (asta_bid, bid_ut) values
    (8, 'Anna');

insert into bid (asta_bid, bid_ut) values
    (8, 'Alice');

insert into bid (asta_bid, bid_ut) values
    (8, 'Anna');

insert into bid (asta_bid, bid_ut) values
    (8, 'Alice');

update postoggetto
    set ha_feedback = true,
    voto = 5,
    commento = 'Molto bella',
    istante_feedback = current_timestamp
    where id = 8;

-- nuova vendita in comralosubito

insert into postoggetto (pubblica, descrizione, categoria) values
    ('Maria', 'Monopoli', 'Giochi');

insert into postoggettousato (postoggetto, condizione, anni_garanzia) values
    (10, 'Buono', 0);

insert into met_post (postoggetto, metodo) values 
    (10, 'Paypal');

insert into compralosubito (postoggetto, prezzo) values
    (10, 315.00); -- monopoli

update compralosubito
    set prezzo = 15.00
    where postoggetto = 10;


