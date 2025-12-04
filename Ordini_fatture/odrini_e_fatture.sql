
CREATE DOMAIN Stringa as varchar;

CREATE DOMAIN InteGEZ as integer
    check (value >= 0);

CREATE DOMAIN FloatGEZ as real
    check (value >= 0);

CREATE DOMAIN Real_0_1 as real
    check (value BETWEEN 0 and 1);

CREATE DOMAIN PartitaIva as char(11)
    check (value ~ '^[0-9]{11}$'); 

CREATE DOMAIN Email as Stringa
    check (value ~* '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$');

CREATE DOMAIN CodiceFiscale as char(16)
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

CREATE DOMAIN Telefono as char(10)
    check (value ~ '^[0-9]{10}$');

 
CREATE TYPE Stato as ENUM
        ('in preparazione', 'inviato', 'da saldare', 'saldato');


CREATE DOMAIN Stringa_not_null as varchar(100)
    check (value is not null);

CREATE DOMAIN CAP_not_null as char(5)
    check (value is not null and value ~ '^[0-9]{5}$');

CREATE TYPE Indirizzo as (
    via Stringa_not_null,
    civico Stringa_not_null,
    cap CAP_not_null
);

create table nazione (
    nome Stringa primary key
);

create table regione (
    nome Stringa not null,
    nazione Stringa not null,
    id integer not null,
    primary key(nome, nazione),
    unique (id),
    foreign key (nazione) 
        references nazione(nome) 
);
 
create table citta (
    nome Stringa not null,
    regione integer not null,
    id integer not null,
    primary key(nome, regione),
    unique (id),
    foreign key (regione)
        references regione(id)
);

create table direttore (
    cf CodiceFiscale primary key,
    nome Stringa not null,
    cognome Stringa not null,
    data_nascita date not null,
    anni_servizio InteGEZ not null,
    citta integer not null,
    foreign key (citta)
        references citta(id)
);

create table dipartimento (
    nome Stringa primary key,
    indirizzo Indirizzo not null,
    direttore CodiceFiscale not null,
    foreign key (direttore)
        references direttore(cf)
);

create table fornitore (
    id integer primary key,
    ragione_sociale Stringa not null,
    partita_iva PartitaIva not null,
    indirizzo Indirizzo not null,
    telefono Telefono not null,
    email Email not null
);

create table ordine (
    id integer primary key,
    data_stipula date not null,
    descrizione Stringa not null,
    imponibile FloatGEZ not null,
    aliquota_iva Real_0_1 not null,
    stato Stato not null,
    dipartimento Stringa not null,
    fornitore integer not null,
    foreign key (dipartimento)
        references dipartimento(nome),
    foreign key (fornitore)
        references fornitore(id)
);


