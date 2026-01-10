
-- [Riparazione.Terminata]
-- Per ogni rep: Riparazione rep.is_terminata = True se e solo se rep.dataRiconsegna è valorizzata

-- [Persona.Completezza]
-- Per ogni p:Persona esiste 
--     dir:Direttore tale che (p, dir): is_a_dir  
--     oppure
--     dip:Dipendente tale che (p, dip): is_a_dip
--     oppure
--     prop:Proprietario tale che (p, prop): is_a_prop


-- Aggiungo deferrable alle foreign key per permettere al utente di inserire i dati in ordine casuale.
-- Tutti i controlli vengono eseguiti al commit.
-- Pero bisogna usare una transazione e "set constraints all deferred" per disattivare i controlli immediati.

-- begin;
-- set constraints all deferred:

-- -- insert in ordine misto

-- commit;



begin transaction;

create domain stringa as varchar;

create domain IntGEZ as integer 
    check(value >= 0);

create domain Targa as char(7) 
    check(value ~ '^[A-Z]{2}[0-9]{3}[A-Z]{2}$');

create domain stringa_not_null as  varchar(100) 
    check(value is not null);

create domain cap_not_null as char(5) 
    check(value is not null and value ~ '^[0-9]{5}$');

create domain cf as char(16)
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

create domain telefono as char(10)
    check (value ~ '^[0-9]{10}$');

create type Indirizzo as (
     via stringa_not_null,
     civico stringa_not_null,
     cap cap_not_null
     );




create table nazione (
    nome stringa primary key
);

create table regione (
    id serial primary key,
    nome stringa not null,
    nazione stringa not null,
    unique (nome, nazione),
    foreign key (nazione) 
        references nazione(nome) deferrable -- accorpa reg_naz
);

create table citta (
    id serial primary key,
    nome stringa not null,
    regione integer not null,
    unique (nome, regione),
    foreign key (regione)
        references regione(id) deferrable -- accorpa cit_reg
);

create table persona (
    codicefiscale cf primary key,
    nome stringa not null,
    indirizzo indirizzo not null,
    telefono telefono not null,
    citta integer not null,
    foreign key (citta)
        references citta(id) deferrable
);

create table dirigente (
    persona cf primary key,
    datanascita date not null,
    foreign key (persona)
        references persona(codicefiscale) deferrable
);

create table dipendente (
    persona cf primary key,
    foreign key (persona)
        references persona(codicefiscale) deferrable
    -- v.inclusione dipendente(persona) occore in afferisce(dipendente)
);

create table proprietario (
    persona cf primary key,
    foreign key (persona)
        references persona(codicefiscale) deferrable
);

create table marca (
    nome stringa primary key
);

create table tipoveicolo (
    nome stringa primary key
);

create table modello (
    id serial primary key,
    nome stringa not null,
    marca stringa not null,
    foreign key (marca)
        references marca(nome)  deferrable-- accorpa mod_marc
    -- v.inclusione modello(id) occorre in mod_tipo(modello)
);

create table mod_tipo (
    modello integer not null,
    tipoveicolo stringa not null,
    primary key (modello, tipoveicolo),
    foreign key (modello)
        references modello(id) deferrable,
    foreign key (tipoveicolo)
        references tipoveicolo(nome) deferrable
);

create table veicolo (
    targa Targa primary key,
    anna_immatricolazione IntGEZ not null,
    modello integer not null,
    proprietario cf not null,
    foreign key (proprietario)
        references proprietario(persona) deferrable,  -- accorpa posiede
    foreign key (modello)  
        references modello(id) deferrable -- accorpa veic_mod
);

create table officina (
    id serial primary key,
    nome stringa not null,
    indirizzo indirizzo not null,
    citta integer not null,
    dirigente cf not null,
    inizio_servizio date not null,
    foreign key (citta) 
        references citta(id) deferrable,  -- accorpa officin_cit
    foreign key (dirigente)
        references dirigente(persona) deferrable  -- accorpa dirige
);

create table afferisce (
    dipendente cf not null,
    officina integer not null,
    inizio_servizio date not null,
    primary key (dipendente, officina),
    foreign key (dipendente)
        references dipendente(persona) deferrable,
    foreign key (officina)
        references officina(id) deferrable
);

create table riparazione (
    codice stringa not null,
    accettazione timestamp not null,
    datariconsegna timestamp,
    is_terminata boolean not null,
    veicolo targa not null,
    officina integer not null,
    primary key ( codice, officina),
    check (accettazione < datariconsegna), -- se datariconsegna is null funziona lo stesso il controllo
    check (
        (is_terminata is True and datariconsegna is not null)
        or
        (is_terminata is False and datariconsegna is null)),
    foreign key (officina)
        references officina(id) deferrable,
    foreign key (veicolo)
        references veicolo(targa) deferrable  -- accorpa veic_rip
);


commit;