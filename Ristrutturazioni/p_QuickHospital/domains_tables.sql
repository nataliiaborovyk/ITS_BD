

begin transaction;

create domain stringa as varchar;

create domain IntGZ as integer 
    check(value > 0);

create domain email as varchar(100)
    check (value ~ '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$');

create domain stringa_not_null as  varchar(100) 
    check(value is not null);

create domain cap_not_null as char(5) 
    check(value is not null and value ~ '^[0-9]{5}$');

create type Indirizzo as (
     via stringa_not_null,
     civico stringa_not_null,
     cap cap_not_null
     );

create domain cf as char(16)
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

create domain telefono as char(10)
    check (value ~ '^[0-9]{10}$');



create table nazione(
   nome stringa primary key
);

create table regione(
    id serial primary key,
    nome stringa not null,
    nazione stringa not null,
    unique (nome, nazione),
    foreign key (nazione)
        references nazione (nome)  deferrable     -- accorpa reg_naz
);

create table citta(
    id serial primary key,
    nome stringa not null,
    regione_id integer not null,
    unique ( nome, regione_id),
    foreign key (regione_id)
        references regione(id)   deferrable      -- accorpa cit_reg
);

create table piano (
    numero intgz primary key
);

create table settore (
    id serial primary key,
    numero  intgz not null,
    piano intgz not null, 
    unique (numero, piano),
    foreign key (piano)
        references piano(numero)   deferrable -- accorpa set_pian
);

create table stanza (
    id serial primary key,
    numero intgz not null,
    settore integer not null,
    unique (numero, settore),
    foreign key (settore)
        references settore(id)  deferrable   -- accorpa st_set
);

create table postoletto (
    id serial primary key,
    numero intgz not null,
    stanza integer not null,
    unique (numero, stanza),
    foreign key (stanza)
        references stanza(id)   deferrable   -- pos_st
);

create table telefonoPaz (
    tel telefono primary key
);

create table specializzazione (
    nome stringa primary key
);

create table persona (
    cf cf primary key,
    nome stringa not null,
    cognome stringa not null,
    data_nascita date not null
);

create table paziente (
    persona cf primary key,
    indirizzo indirizzo not null,
    email email not null,
    is_interno boolean not null,
    citta integer not null,
    unique (email),
    foreign key (citta)
        references citta(id)   deferrable  -- accorpa cit_paz
);

create table medico (
    persona cf primary key,
    specializzazione stringa not null,
    foreign key (specializzazione)
        references specializzazione(nome)  deferrable   -- accorpa primaria
    -- v.inclusione medico(persona) occorre in med_spec(medico)
    -- foreign key (medico, specializzazione)
    --      references med_spec(medico, specializzazione)   deferrable -- ????
);

create table paz_tel (
    paziente cf not null,
    telefono telefono not null,
    primary key (paziente, telefono),
    foreign key (paziente)
        references paziente(persona)  deferrable ,
    foreign key (telefono)
        references telefonopaz(tel)  deferrable 
);

create table ricovero (
    id serial primary key,
    data_ricovero timestamp not null,
    is_finito boolean not null,
    data_dimissione timestamp,
    paziente cf not null,
    postoletto integer not null,
    check (
        (is_finito = True and data_dimissione is not null)
        or 
        (is_finito = False and data_dimissione is null)
    ),
    foreign key (paziente)
        references paziente(persona)  deferrable ,  -- accorpa paz_ric
    foreign key (postoletto)
        references postoletto(id)    deferrable -- accorpa ric_pl
);


create table prestazione (
    id serial primary key,
    descrizione stringa not null,
    medico cf not null,
    specializzazione stringa not null,
    foreign key (medico)
        references medico(persona)  deferrable , -- accorpa med_pres 
    foreign key (specializzazione)
         references specializzazione(nome)   deferrable  -- pres_spec
);

create table prenotazione (
    id serial primary key,
    data_richiesta timestamp not null,
    paziente cf not null,
    prestazione integer not null,
    foreign key (paziente)
         references paziente(persona)  deferrable ,  -- accorpa paz_pren
    foreign key (prestazione)
        references prestazione(id)   deferrable -- accorpa pren_prest
);

create table med_spec (
    medico cf not null,
    specializzazione stringa not null,
    primary key (medico, specializzazione),
    foreign key (medico)
        references medico(persona)  deferrable ,
    foreign key (specializzazione)
        references specializzazione(nome)  deferrable 
);

alter table medico 
    add constraint primaria
    -- v.inclusione medico(persona) occorre in med_spec(medico)
    foreign key (persona, specializzazione)
         references med_spec(medico, specializzazione)   deferrable; -- ????


commit;