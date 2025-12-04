begin transaction;
set constraints all deferred;

create domain PosInteger as Integer 
    check (value >= 0);

create domain StringaM as varchar(100);

create domain CodIATA as char(3);



create table Compagnia (
    nome   StringaM primary key,
    annofondaz   PosInteger
);

create table Aeroporto (
    codice   CodIATA primary key,
    nome   StringaM not null
    -- foreign key (codice) 
    --         references luogoaeroporto(aeroporto)
);

create table LuogoAeroporto (
    aeroporto   CodIATA primary key,
    citta   StringaM not null,
    nazione   StringaM not null,
    foreign key (aeroporto) 
            references aeroporto(codice) deferrable
);

alter table Aeroporto
    add constraint codice_ref_luogoaeroporto_aeroporto
    foreign key (codice) 
            references luogoaeroporto(aeroporto) deferrable;

-- alter table LuogoAeroporto
--     add constraint aeroporto_ref_aeroporto_codice
--     foreign key (aeroporto) 
--         references aeroporto(codice) deferrable;

create table Volo (
    codice   PosInteger not null,
    comp   StringaM not null,
    durataminuti   PosInteger not null,
    primary key (codice, comp),
    foreign key (comp) 
            references compagnia(nome)
    -- foreign key (codice, comp) 
    --         references arrpart(codice, comp)
);

create table ArrPart (
    codice   PosInteger not null,
    comp   StringaM not null,
    arrivo   CodIATA not null,
    partenza   CodIATA not null,
    primary key (codice, comp),
    foreign key (codice, comp) 
            references volo(codice, comp) deferrable,
    foreign key (arrivo) 
            references aeroporto(codice),
    foreign key (partenza) 
            references aeroporto(codice)
);

alter table Volo 
    add constraint codice_comp_ref_arrpart_codice_comp
    foreign key (codice, comp) 
            references arrpart(codice, comp) deferrable;

commit;