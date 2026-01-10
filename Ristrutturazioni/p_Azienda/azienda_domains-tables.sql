create domain string100_not_null as varchar(100)
    check (value is not null);

create domain int_gez_not_null as integer
    check (value is not null and value >= 0);

create type importo as (
    valuta string100_not_null,
    quantitacre int_gez_not_null
);

create domain telefono as char(10)
    check (value ~ '[0-9]{10}'); 

create table Progetto (
    id integer primary key,
    nome varchar(100) not null,
    budget importo not null
);  

create table impiegato (
    id integer primary key,
    nome varchar(100) not null,
    cognome varchar(100) not null,
    data_nascita date not null,
    stipendio importo not null,
    dipartimento_direzione integer,
    dipartimento_afferenza integer
);

create table dipartimento (
    id integer primary key,
    mome varchar(100) not null,
    telefono telefono not null,
    impiegato integer not null,
    foreign key (impiegato) references impiegato(id)
);

alter table impiegato 
    add constraint dipartimento_afferenza
    foreign key (dipartimento_afferenza) references dipartimento(id);

alter table impiegato 
    add constraint dipartimento_direzione
    foreign key (dipartimento_direzione) references dipartimento(id);
    
create table afferenza (
    dipartimento integer primary key,
    impiegato integer,
    foreign key (dipartimento) references dipartimento(id),
    foreign key (impiegato) references impiegato(id)
);



create table imp_prog (
    impiegato integer not null,
    progetto integer not null,
    foreign key (impiegato) references impiegato(id),
    foreign key (progetto) references progetto(id)
);