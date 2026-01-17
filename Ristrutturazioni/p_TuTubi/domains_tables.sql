begin transaction;

create type tipo as enum('Pubblico', 'Privato');

create domain stringa as varchar;

create domain voto as numeric 
    check (value between 0 and 5);

create domain intgz as integer
    check (value > 0);





create table categoria (
    nome stringa primary key
);

create table tag (
    nome stringa primary key
);

create table utente (
    nome stringa primary key,
    istante_iscrizine timestamp not null
);

create table video (
    nome_file stringa primary key,
    titolo stringa not null,
    durata_minuti intgz not null,
    descrizione stringa not null,
    censurato boolean not null,
    motivo_censura stringa,

    utente stringa not null,  -- accorpa pubblica
    categoria stringa not null,  -- accorpa vid_cat
    video_padre stringa not null,  -- accorpa gererchia_risposte
    check (video_padre <> nome_file),
    foreign key (utente) references utente(nome),
    foreign key (categoria) references categoria(nome)
    -- v.inclusione video(nome_file) occorre in vid_tag(video)
);

alter table video add foreign key (video_padre) references video(nome_file);

create table vid_tag (
    video stringa not null,
    tag stringa not null,
    primary key (video, tag),
    foreign key (video) references video(nome_file),
    foreign key (tag) references tag(nome)
);

create table playlist (
    id serial primary key,
    nome stringa not null, 
    utente stringa not null,  -- accorpa proprietario
    unique (nome, utente),
    istante timestamp not null,
    tipo tipo not null,
    foreign key (utente) references utente(nome)
);

create table posizione(
    id serial primary key,
    ordine intgz not null,
    playlist integer not null,  -- accorpa p_pos
    unique (ordine, playlist),
    foreign key (playlist) references playlist(id)
);

create table valutazione (
    utente stringa not null,
    video stringa not null,
    primary key (utente, video),
    foreign key (utente) references utente(nome),
    foreign key (video) references video(nome_file)
);

create table cronologia_vis (
    id serial primary key,
     istante timestamp not null,
     utente stringa not null, -- accorpa visualizza
     video stringa not null,  -- accorpa cr_vid
     foreign key (utente) references utente(nome),
     foreign key (video) references video(nome_file)
);

create table commento (
    id serial primary key,
    testo stringa not null,
    istante timestamp not null,
    cron_vis integer not null,  -- accorpa cr_com
    foreign key (cron_vis) references cronologia_vis(id)
);

commit;