begin transaction;
set constraints all deferred;

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
    abbitanti intgez not null,
    nazione varchar(100) not null,
    foreign key (nazione) references nazione(nome) deferrable
);

create table companiaaerea (
    nome varchar(100) primary key,
    anno_fondazione intg1900 not null,
    citta integer not null,
    foreign key (citta) references citta(id) deferrable
 );

create table aeroporto (
    codice varchar(100) primary key,
    nome varchar(100) not null,
    citta integer not null,
    foreign key (citta) references citta(id) deferrable
 );

create table volo (
    codice varchar(100) primary key,
    durata_minuti intgz not null,
    aeroporto_arrivo varchar(100) not null,
    aeroporto_partenza varchar(100) not null,
    companiaaerea varchar(100) not null,
    foreign key (aeroporto_arrivo) references aeroporto(codice) deferrable,
    foreign key (aeroporto_partenza) references aeroporto(codice) deferrable,
    foreign key (companiaaerea) references companiaaerea(nome) deferrable
);

commit;
