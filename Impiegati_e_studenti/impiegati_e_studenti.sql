
Create domain Stringa as varchar;

Create domain IntGEZ as integer
    check (value >= 0);

Create domain FloatGEZ as real
    check (value >= 0);

Create domain CodiceFiscale as char(16) 
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

Create type Ruolo as enum ('Segretario', 'Direttore', 'Progettista');

Create table Persona (
    cf CodiceFiscale primary key,
    nome Stringa not null,
    cognome Stringa not null,
    data_nascita date not null,
    is_uomo boolean not null,
    is_donna boolean not null,
    maternita IntGEZ,
    check (is_donna or is_uomo),
    check (is_donna = (maternita is not null))
);

Create table PosizioneMilitare (
    nome Stringa primary key
);

Create table pos_uomo (
    persona CodiceFiscale primary key,
    posizione_militare Stringa,
    foreign key (persona)
        references persona(cf),
    foreign key (posizione_militare)
        references PosizioneMilitare(nome)
);

Create table Studente (
    persona CodiceFiscale primary key,
    matricola IntGEZ not null,
    unique (matricola),
    foreign key (persona)
        references persona(cf)
);

Create table Impiegato (
    persona CodiceFiscale primary key,
    stipendio FloatGEZ not null,
    ruolo Ruolo not null,
    foreign key (persona)
        references persona(cf)
);

Create table Progetto (
    id integer primary key,
    nome Stringa not null,
    impiegato CodiceFiscale not null,
    foreign key (impiegato)
        references impiegato(persona)
);

