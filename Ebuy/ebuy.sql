
begin transaction;
set constraints all deferred;

create table categoria (
    nome stringa primary key,
    super stringa,
    check (nome <> super)
);

alter table add foreign key (super)
        references categoria(nome);

