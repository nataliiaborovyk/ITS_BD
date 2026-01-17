begin transaction;

create domain stringa as varchar;

create domain intgz as integer check (value > 0);

create domain intgez as integer check (value >= 0);

create domain voto as integer
    check (value BETWEEN 0 and 5);

create type sesso as
    enum('maschio', 'femmina');

create type giorno as
    enum('Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica');

create type posizione as 
    enum('sotto', 'sopra');


create table nazione(
   nome stringa primary key
);

create table regione(
    id serial primary key,
    nome stringa not null,
    nazione stringa not null,
    unique (nome, nazione),
    foreign key (nazione)
        references nazione (nome)       -- accorpa reg_naz
);

create table citta(
    id serial primary key,
    nome stringa not null,
    regione_id integer not null,
    unique ( nome, regione_id),
    foreign key (regione_id)
        references regione(id)      -- accorpa cit_reg
);

create table Utente(
    id serial primary key,
    nome stringa not null,
    cognome stringa not null,
    sesso sesso not null,
    data_nascita date not null,
    offre_ospitalita boolean not null,
    citta_id integer not null,
    foreign key (citta_id)
        references citta(id)        -- accorpa residenza
);

create table tipostazione(
    nome stringa primary key
);

create table tipoalloggio(
    nome stringa primary key
);

create table  alloggio(
    id serial primary key,
    num_bambini intgez not null,
    num_adulti intgez not null,
    max_ospiti intgez not null,
    citta_id integer not null,
    dist_dal_centro_metri intgz not null,
    utente_id integer not null,
    tipoalloggio stringa not null,
    foreign key (citta_id)
        references citta(id),       -- accorpa cit_al
    foreign key (utente_id)
        references utente(id),       -- accorpa ospitalita
    foreign key (tipoalloggio)
        references tipoalloggio(nome)  -- accorpa al_tip
    -- v.inclusione alloggio(id) occorre in al_st(alloggio_id)
);

create table al_st(
    alloggio_id integer not null,
    tipostazione stringa not null,
    primary key( alloggio_id, tipostazione),
    dist_da_staz_metri intgz not null,
    foreign key (alloggio_id)
        references alloggio(id),
    foreign key (tipostazione)
        references tipostazione(nome)
);

create table giornosettimana(
    giorno_settimana giorno primary key
    -- v.inclusione giornosettimana(giorno_settimana) occore in pc_gs(giornosettimana)
);

create table periodochiusura(
    id serial primary key,
    data_inizio date not null,
    data_fine date not null,
    check (data_inizio < data_fine)
    -- v.inclusione periodochiusura(id) occorre in al_pc(periodochiusura_id)
);

create table pc_gs(
    periodochiusura_id integer not null,
    giornosettimana giorno not null,
    primary key (periodochiusura_id, giornosettimana),
    foreign key (periodochiusura_id)
        references periodochiusura(id),
    foreign key (giornosettimana)
        references giornosettimana(giorno_settimana)
);

create table al_pc(
    alloggio_id integer not null,
    periodochiusura_id integer not null,
    primary key (alloggio_id, periodochiusura_id),
    foreign key (alloggio_id)
        references alloggio(id),
    foreign key (periodochiusura_id)
        references periodochiusura(id)
);

create table tipoletto(
    id serial primary key,
    nome_arredo stringa not null,
    formato_letto stringa not null,
    unique(nome_arredo, formato_letto),
    max_capienza intgz not null,
    condivisibile boolean not null
);

create table camera(
    id serial primary key,
    nome stringa not null,
    alloggio_id integer not null,
    unique (nome, alloggio_id),
    foreign key (alloggio_id)
        references alloggio(id)     -- accorpa al_cam
);

create table letto(
    id serial primary key,
    capienza intgz not null,
    camera_id integer not null,
    tipoletto_id integer not null,
    foreign key (camera_id)
        references camera(id),      -- accorpa cam_let
    foreign key (tipoletto_id)
        references tipoletto(id)        -- accorpa let_tip
);

create table prenotazione(
    id serial primary key,
    data_inizio timestamp not null,
    data_fine timestamp not null,
    organiz_id integer not null,
    foreign key (organiz_id)
        references utente(id),       -- accorpa organizzatore
    -- foreign key (organiz)
    --     references visitatore(utente)
    check (data_inizio < data_fine)
    -- v.inclusione prenotazione(id) occore in visitatore(prenotazione_id)
    -- v.inclusione prenotazione(id) occore in pren_let(prenotazione_id)
);

create table visitatore(
    utente_id integer not null,
    prenotazione_id integer not null,
    primary key (utente_id, prenotazione_id),
    feed_su_visitatore voto,
    feed_su_ospitante voto,
    foreign key (utente_id)
        references utente(id),
    foreign key (prenotazione_id)
        references prenotazione(id)
);

alter table prenotazione
    add foreign key (organiz_id, id)
        references visitatore(utente_id, prenotazione_id)
            -- deferrable initially deferred; -- per default il vincolo viene controllato solo al commit di una futura transazione
            deferrable; -- dovrò scrivere set constraints all deferred in ogni futura transazione per manipolare i dati

create table prenrifiutata(
    prenotazione_id integer primary key,
    istante_rifiuto timestamp not null,
    motivazione stringa not null,
    foreign key (prenotazione_id)
        references prenotazione(id) -- pr_isa_p
);

create table prenaccettata(
    prenotazione_id integer primary key,
    istante_accettazione timestamp not null,
    foreign key (prenotazione_id)
        references prenotazione(id)  -- pa_isa_p
);

create table pren_let(
    prenotazione_id integer not null,
    letto_id integer not null,
    primary key(prenotazione_id, letto_id),
    foreign key (prenotazione_id)
        references prenotazione(id),
    foreign key (letto_id)
        references letto(id)
);

create table sceltaposto(
    id serial primary key,
    posizione posizione,
    confermato boolean not null,
    utente_id integer not null,
    prenotazione_id integer not null,
    letto_id integer not null,
    foreign key (utente_id)
        references utente(id),  -- accorpa ut_sp
    foreign key (prenotazione_id)
        references prenotazione(id),    -- accorpa pren_sp
    foreign key (letto_id)
        references letto(id),       -- accorpa let_sp
 -- [SceltaPosto.coerenza_Prenotazione_Visitatore_Letto_collegati]
 -- Per ogni ut: Utente, sp: SceltaPosto, pren: Prenotazione, let: Letto 
 -- tale che esistono
 -- (ut, sp): ut_sp,  ut Utente 
 -- (pren, sp):pren_sp
 -- (let, sp): let_sp
 -- deve essere vero che 
 -- esistono i link (ut, pren): visitatore e (pren, let): pren_let
    foreign key (utente_id, prenotazione_id)
        references visitatore(utente_id, prenotazione_id), 
    foreign key (prenotazione_id, letto_id)
        references pren_let(prenotazione_id, letto_id)
);


commit;