create domain intgz as integer
    check (value > 0);

create domain intgez as integer
    check (value >= 0);

create domain intg1900 as integer
    check (value >= 1900);

create table nazione (
    nome varchar(100) primary key
);

create table citta (
    id integer primary key,
    nome varchar(100) not null,
    abbitanti intgez not null
    -- v.inclusione citta(id) occorre in cit_naz(citta)
);

create table cit_naz (
    citta integer primary key,
    nazione varchar(100) not null,
    foreign key (citta) references citta(id),
    foreign key (nazione) references nazione(nome)
);

create table companiaaerea (
    nome varchar(100) primary key,
    anno_fondazione intg1900 not null
    -- v.inclusione companiaaerea(nome) occorre in comp_direzione_citta(citta)
);

create table comp_direzione_citta (
    companiaaerea varchar(100) primary key,
    citta integer not null,
    foreign key (companiaaerea) references companiaaerea(nome),
    foreign key (citta) references citta(id)
);

create table aeroporto (
    codice varchar(100) primary key,
    nome varchar(100) not null
    -- v.inclusione aeroporto(codice) occorre in aerop_citta(citta)
);

create table aerop_citta (
    aeroporto varchar(100) primary key,
    citta integer not null,
    foreign key (aeroporto) references aeroporto(codice),
    foreign key (citta) references citta(id)
);

create table volo (
    codice varchar(100) primary key,
    durata_minuti intgz not null
    -- v.inclusione volo(codice) occorre in arrivo(aeroporto)
    -- v.inclusione volo(codice) occorre in partenza(aeroporto)
    -- v.inclusione volo(codice) occorre in volo_comp(companiaaerea)
);

create table volo_comp (
    volo varchar(100) primary key,
    companiaaerea varchar(100) not null,
    foreign key (volo) references volo(codice),
    foreign key (companiaaerea) references companiaaerea(nome)
);

create table arrivo (
    volo varchar(100) primary key,
    aeroporto varchar(100) not null,
    foreign key (volo) references volo(codice),
    foreign key (aeroporto) references aeroporto(codice)
);

create table partenza (
    volo varchar(100) primary key,
    aeroporto varchar(100) not null,
    foreign key (volo) references volo(codice),
    foreign key (aeroporto) references aeroporto(codice)
);