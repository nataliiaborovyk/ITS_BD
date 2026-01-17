begin transaction;

create domain stringa as varchar;

create domain intgz as integer check (value > 0);

create domain intgez as integer check (value >= 0);

create domain cf as 
    char(16) 
    check (value ~ '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

create domain stelle as integer
    check (value BETWEEN 3 and 5);

create domain stringa_not_null as 
    varchar(100) check(value is not null);
    -- varchar(100) not null;  posso scrivere cosi?

create domain cap_not_null as
    char(5) check (value is not null and value ~ '^[0-9]{5}$');
    -- char(5) not null
    -- check (value ~ '^[0-9]{5}$');
 
create type indirizzo as (
    via     stringa_not_null,
    civico  stringa_not_null,
    cap      cap_not_null
);

create domain intgez_not_null as
    integer check (value is not null and value >= 0);
    -- integer not null
    -- check (value >= 0);    -- giorno 0 parte la crociera


create domain time_not_null as
    time check (value is not null);
    -- tile not null;

create type giornoOra as (
    giorno  intgez_not_null,
    ora     time_not_null
);

create type giorno as
    enum('Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica');

create type continente as
    enum('Africa', 'America', 'Asia', 'Europa', 'Oceania', 'Antartide');

-- tabelle

create table nazione (
    nome stringa primary key
);


create table regione (
    id serial primary key,
    nome stringa not null,
    nazione stringa not null,
    unique(nome, nazione),    
    foreign key (nazione)
        references nazione(nome)   -- accorpa naz_reg
);

-- create table regione (
--     id serial primary key,
--     nome text not null,
--     nazione text not null references nazione(nome), !!!!!!!!!!!!!!!!
--     unique(nome, nazione),    
-- );


create table citta (
    id serial primary key,
    nome stringa not null,
    regione integer not null,
    unique(nome, regione),
    foreign key (regione)
        references regione(id)    -- accorpa reg_cit
);

create table cliente (
    cf cf primary key,
    nome stringa not null,
    cognome stringa not null,
    data_nascita date not null,
    indirizzo indirizzo not null,
    citta integer not null,
    foreign key (citta)
        references citta(id)      -- accorpa cl_cit
 );

create table nave (
    codice stringa primary key,
    nome stringa not null,
    comfort stelle not null,
    num_posti intgz not null
);

create table itinerario (
    nome stringa primary key
);

create table tipoDestinazione (
    nome stringa primary key
);

create table orario (
    id serial primary key,
    giorno giorno not null,
    ora_inizio time not null,
    ora_fine time not null
    -- v.inclusione orario(id) occorre in or_per(orario)
);

create table periodo (
    id serial primary key,
    data_inizio date not null,
    data_fine date not null
    -- v.inclusione periodo(id) occorre in or_per(orario)
    -- v.inclusione peiodo(id) occorre in per_post(periodo)
);

create table or_per (
    orario integer not null,
    periodo integer not null,
    primary key(orario, periodo),
    foreign key (orario)
        references orario(id),
    foreign key (periodo)
        references periodo(id)
);

create table destinazioneScalo (
    id serial primary key,
    nome stringa not null,
    citta integer not null,
    distanza_da_citta_km intgez not null default 0,
    unique(nome, citta),
    foreign key (citta)
        references citta(id)     -- accorpa cir_dest
    -- v.inclusione destinazionescalo(id) occorrei in dest_tip(destinazioneScalo)
);

create table dest_tip (
    tipoDestinazione stringa not null,
    destinazioneScalo integer not null,
    primary key (tipoDestinazione, destinazioneScalo),
    foreign key (tipoDestinazione)
        references tipoDestinazione(nome),
    foreign key (destinazioneScalo)
        references destinazioneScalo(id)
);

create table postoEscursione (
    id serial primary key,
    nome stringa not null,
    destinazioneScalo integer not null,
    unique (nome, destinazioneScalo),
    descrizione stringa not null,
    foreign key (destinazioneScalo)
        references destinazioneScalo(id)   -- accora dest_post
);

create table per_post (
    periodo integer not null,
    postoEscursione integer not null,
    primary key(periodo, postoEscursione),
    foreign key (periodo)
        references periodo(id),
    foreign key (postoEscursione)
        references postoEscursione(id)
);

create table scalo (
    id serial primary key,
    numero intgez not null, 
    itinerario stringa not null,
    unique (numero, itinerario),
    -- relativo_arrivo giornoOra,
    -- relativa_partenza giornoOra,  -- come posso paragonare il tipo composto?
    -- spezzo giornoora in 2 valori separati per controllare i tipi uguali ma è lungo e scomodo
    rel_arr_giorno intgez,  -- giornoora.giorno
    rel_arr_ora time,       -- giornoora.ora
    rel_part_giorno intgez, -- giornoora.giorno
    rel_part_ora time,      -- giornoora.giorno
    destinazioneScalo integer not null,
    foreign key (itinerario)
        references itinerario(nome),    -- accorpa it_sc
    foreign key (destinazioneScalo)
        references destinazioneScalo(id),
    check (
        (rel_arr_giorno is null and rel_arr_ora is null)
        or 
        (rel_arr_giorno is not null and rel_arr_ora is not null)
    ),
    check (
        (rel_part_giorno is null and rel_part_ora is null)
        or 
        (rel_part_giorno is not null and rel_part_ora is not null)
    ),
    check (
        not (
            rel_arr_giorno is null
            and rel_arr_ora is null
            and rel_part_giorno is null
            and rel_part_ora is null
            )
    ),
    check (
        rel_arr_giorno is null
        or rel_arr_ora is null
        or rel_part_giorno is null
        or rel_part_ora is null 
        -- se tutte 4 non sono null allora deve essere vero che      
        or (
            rel_arr_giorno < rel_part_giorno
            or (
                rel_arr_giorno = rel_part_giorno 
                and rel_arr_ora < rel_part_ora 
            )
        )
    )
);

rag = null anch rao = null


create table crociera (
    codice stringa primary key,
    data_inizio_programmata timestamp not null,
    is_per_famiglie boolean not null,
    adatta_per_bambini boolean,
    nave stringa not null,
    itinerario stringa not null,
    foreign key (nave)
        references nave(codice),      -- accorpa nav_cr
    foreign key (itinerario)
        references itinerario(nome),   -- accorpa cr_it
    -- v.inclusione crociera(codice) occorre in cr_sc(crociera)
    check ((is_per_famiglie = TRUE and adatta_per_bambini is not null)
        or
        (is_per_famiglie = FALSE and adatta_per_bambini is null)
        )
);

create table cr_sc (
    ritardo_arrivo_minuti intgez not null,
    ritardo_partenza_minuti intgez not null,
    scalo integer not null,
    crociera stringa not null,
    primary key (scalo, crociera),
    foreign key (scalo)
        references scalo(id),
    foreign key (crociera)
        references crociera(codice)
);

create table prenotazione (
    id serial primary key,
    istante timestamp not null,
    num_posti intgz not null,
    cliente cf not null,
    crociera stringa not null,
    foreign key (cliente)
        references cliente(cf),       -- accorpa cl_pren
    foreign key (crociera)
        references crociera(codice)   -- accorpa pren_cr
);


commit;

