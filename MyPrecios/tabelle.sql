Create domain Stringa as varchar;

Create domain IntGEZ as integer check (value>= 0);

Create domain RealGEZ as real check (value>=0);

create table nazione (
    nome stringa primary key
);

create table regione (
    id serial primary key,
    nome stringa not null,
    nazione stringa not null,
    unique (nome, nazione),
    foreign key (nazione) 
        references nazione(nome)
);

create table citta (
    id serial primary key,
    nome stringa not null,
    regione integer not null,
    unique (nome, regione),
    foreign key (regione)
        references regione(id)
);

create table autore (
    id serial primary key,
    nome_d_arte stringa not null,
    data_nascita date not null,
    data_morte date,
    citta integer not null,
    foreign key (citta)
        references citta(id)
);


-- versione 1 con tabella tecnica

        create table categoria (
            nome stringa primary key
        );

        create table tecnica (
            nome stringa primary key, 
            categoria stringa not null,
            foreign key (categoria)
                references categoria(nome)
        );

        create table opera (
            id serial primary key,
            nome stringa not null,
            anno_ralizzazione date not null,
            autore integer not null,
            unique (nome, autore),
            foreign key (autore)
                references autore(id)
        );

-- versione 2 senza tab tecnica

create table categoria (
    nome stringa primary key
);

create table opera (
    id serial primary key,
    nome stringa not null,
    anno_ralizzazione date not null,
    autore integer not null,
    tecnica stringa,
    unique (nome, autore),
    foreign key (autore)
        references autore(id)
);

create table correnteArtistica (
    nome stringa primary key
);

create table op_cor (
    opera integer not null,
    correnteArt stringa not null,
    primary key (opera, correnteArt),
    foreign key (opera)
        references opera(id),
    foreign key (correnteArt)
        references correnteArtistica(nome)
);

create table esposizione (
    id serial primary key,
    nome stringa not null,
    data_iniz timestamp not null
);

create table esposizionePermanente (
    esposizione integer primary key,
    foreign key (esposizione)
        references esposizione(id)
);

create table esposizioneTemporanea (
    esposizione integer primary key,
    tema stringa not null,
    data_fine timestamp not null,
    prezzo_di_accesso RealGEZ not null,
    foreign key (esposizione)
        references esposizione(id)
);

create table partecipa (
    id serial primary key,
    data_iniz date not null,
    data_fine date,
    opera integer not null,
    esposizione integer not null,
    foreign key (opera)
        references opera(id),
    foreign key (esposizione)
        references esposizione(id)
);

create table tariffa (
    nome stringa primary key,
    prezzo_base RealGEZ not null
);

create table biglietto (
    id serial primary key,
    istante_vendita timestamp not null,
    data_validita date not null,
    tariffa stringa not null,
    foreign key (tariffa)
        references tariffa(nome)
);

create table bigliettoStandart (
    biglietto integer primary key,
    foreign key (biglietto)
        references biglietto(id)
);

create table bigliettoExtended (
    biglietto integer primary key,
    foreign key (biglietto)
        references biglietto(id)
    -- v.inclusione BigliettoExtended(biglietto) occorre in be_est(bigliettoExt)
);

create table be_est (
    esposizioneTemp integer not null,
    bigliettoExt integer not null,
    foreign key (esposizioneTemp)
        references esposizioneTemporanea(esposizione),
    foreign key (bigliettoExt)
        references bigliettoExtended(biglietto)
);
