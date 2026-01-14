begin transaction;

create domain stringa as varchar;

create domain latitudine as numeric(9)
	check (value between -90 and 90);

create domain longitudine as numeric(9)
	check (value between -180 and 180);

create domain IntGZ as integer
    check (value > 0);

create domain IntGEZ as integer
    check (value >= 0);

Create type Tipo as enum ('Ripetuta', 'Avista', 'Flash');

Create type Esposizione as enum ('N', 'S', 'W', 'E');

create table grado (
    nome stringa primary key,
    valore intgez not null
);

create table falesia (
    nome stringa primary key,
    latitudine latitudine not null,
    longitudine longitudine not null
    -- v.inclusione falesia(nome) occorre set_fal(falesia)
);

create table settore (
    id serial primary key,
    nome stringa not null,
    falesia stringa not null,
    unique (nome, falesia),
    esposizione esposizione not null,
    foreign key (falesia)
        references falesia(nome)
);

create table set_fal (
    falesia stringa not null,
    settore integer not null,
    primary key(falesia, settore),
    foreign key (falesia)
        references falesia(nome),
    foreign key (settore)
        references settore(id)
);

create table persona (
    username stringa primary key
);

create table chiodatore (
    persona stringa primary key,
    foreign key (persona)
        references persona(username)
);

create table arrampicatore (
    persona stringa primary key,
    nome stringa,
    cognome stringa,
    foreign key (persona)
        references persona(username)
);

create table via (
    nome stringa not null,
    settore integer not null,
    primary key (nome, settore),
    lunghezza intgz not null,
    n_spit intgez not null,
    grado stringa not null,
    chiodatore stringa not null,
    foreign key (grado)
        references grado(nome),
    foreign key (chiodatore)
        references chiodatore(persona)
);

create table salita (
    id serial primary key,
    data date not null,
    tipo tipo not null,
    via stringa not null,
    settore integer not null,
    arrampicatore stringa not null,
    foreign key (via, settore)
        references via(nome, settore),
    foreign key (arrampicatore)
        references arrampicatore(persona)
);

create table tentativo (
    id serial primary key,
    note stringa not null,
    salita integer not null,
    foreign key (salita)
        references salita(id)
);


commit;