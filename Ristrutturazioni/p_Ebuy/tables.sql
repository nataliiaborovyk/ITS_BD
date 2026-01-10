

create table categoria (
	nome stringa primary key,
	super stringa,
	check (nome <> super)
);

alter table categoria add constraint gerarchia 
	foreign key (super)
		references categoria(nome);

-- WITH RECURSIVE


create table utente (
	username stringa primary key,
	registrazione timestamp
);

alter table utente
alter column registrazione
set default current_timestamp;


create table privato (
	utente stringa primary key,
	foreign key (utente)
		references utente(username)
);

create table venditoreprof (
	utente stringa primary key,
	vetrina URL not null,
	unique(vetrina),
	foreign key (utente)
		references utente(username)
);

-- [V.Utente.compl] e [V.Utente.disj] non ancora implementati


create table postoggetto (
	id serial primary key,
	pubblica stringa not null,
	descrizione stringa not null,
	pubblicazione timestamp not null,
	ha_feedback boolean not null,
	voto Voto,
	commento stringa,
	istante_feedback timestamp,
	categoria stringa not null,
	check(istante_feedback is null or istante_feedback < pubblicazione)
	-- vincoli di ennupla per modellare [V.PostOggetto.feedback]
	check(
		(ha_feedback = true)
		=
		(voto is not null and istante_feedback is not null)
		),
	-- se c'è il commento allora ha_feedback è true
	check (commento is null OR ha_feedback=true),
	foreign key (categoria)
		references categoria(nome),

	-- v.incl. (id) occorre in met_post(postoggetto)

	foreign key (pubblica)
		references utente(username)
);


create table postoggettonuovo (
	postoggetto integer primary key,
	pubblica_nuovo stringa not null,
	anni_garanzia IntGE1 not null,

	foreign key (pubblica_nuovo) 
		references venditoreprof(utente),

	-- implementa [V.PostOggettoNuovo.pubblica.isa]
	foreign key (postoggetto, pubblica_nuovo)
		references postoggetto(id, pubblica)
);

create table metodopagamento (
	nome stringa primary key
);

create table met_post (
	postoggetto integer not null,
	metodo stringa not null,
	primary key (postoggetto, metodo),
	foreign key (postoggetto)
		references postoggetto(id),
	foreign key (metodo)
		references metodopagamento(nome)
);




-- compito per casa



-- valori default per comodita
alter table postoggetto
	alter column pubblicazione
	set default current_timestamp;

alter table postoggetto
	alter column ha_feedback
	set default false;

-- serve per far funzionare [V.PostOggettoNuovo.pubblica.isa]
alter table postoggetto              
	add constraint unique_id_pubblica unique (id, pubblica); -- chiave non minimale

-- è ridondante
alter table postoggettonuovo
	add constraint fk_postoggetto_id foreign key (postoggetto)
		references postoggetto(id);                           




create table postoggettousato (
	postoggetto integer primary key,
	condizione condizione not null,
	anni_garanzia intgez not null,
	foreign key (postoggetto)
		references postoggetto(id)
);

create table asta (
	postoggetto integer primary key,
	prezzo_bid realgz not null,
	prezzo realgez not null,
	scadenza timestamp not null,
	foreign key (postoggetto)
		references postoggetto(id)
);

create table bid (
	id serial primary key,
	istante timestamp not null default current_timestamp,
	asta_bid integer not null,
	unique (istante, asta_bid),
	bid_ut stringa not null,
	foreign key (asta_bid)
		references asta(postoggetto),
	foreign key (bid_ut) 
		references privato(utente)
);

create table compralosubito (
	postoggetto integer primary key,
	prezzo realgz not null,
	acquirente stringa,
	istante_acquirente timestamp,
	check 	(acquirente is not null and istante_acquirente is not null)
			OR
			(acquirente is null and istante_acquirente is null),
			-- (acquirente is null) = (istante_acquirente is null)
	foreign key (postoggetto)
		references postoggetto(id),
	foreign key (acquirente)
		references privato(utente)
);


--   nel caso se "acquirente" non è accorpato

-- create table acquirente (
-- 	compralosubito integer not null,
-- 	privato stringa not null,
-- 	istante timestamp not null,
-- 	primary key (compralosubito),
-- 	foreign key (comptalosubito)
-- 		references compralosubito(postoggetto),
-- 	foreign key (privato)
-- 		references privato(utente)
-- );










