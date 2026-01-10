

create table categoria (
	nome stringa primary key,
	super stringa,
	check (nome <> super)
);

alter table categoria add foreign key (super)
		references categoria(nome);

-- WITH RECURSIVE


create table utente (
	username stringa primary key,
	registrazione timestamp
);

create table privato (
	utente stringa primary key,
	foreign key (utente)
		references utente(username) deferrable
);

create table venditoreprof (
	utente stringa primary key,
	vetrina URL not null,
	unique(vetrina),
	foreign key (utente)
		references utente(username) deferrable
);

-- [V.Utente.compl] e [V.Utente.disj] non ancora implementati


create table postoggetto (
	id serial primary key,
	pubblica stringa not null,
	unique(id, pubblica), -- chiave non-minimale, per 
	descrizione stringa not null,
	pubblicazione timestamp not null,
	ha_feedback boolean not null default false,
	voto Voto,
	commento stringa,
	istante_feedback timestamp,
	categoria stringa not null,
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
		references utente(username),
	check (istante_feedback is null or istante_feedback > pubblicazione)
);


create table postoggettonuovo (
	postoggetto integer primary key,
	pubblica_nuovo stringa not null,
	anni_garanzia IntGE2 not null,

	foreign key (pubblica_nuovo) 
		references venditoreprof(utente),


	-- implementa [V.PostOggettoNuovo.pubblica.isa]
	foreign key (postoggetto, pubblica_nuovo)
		references postoggetto(id, pubblica) deferrable
);

create table postoggettousato (
	postoggetto integer primary key,
	condizione condizione not null,
	anni_garanzia intgez not null,
	foreign key (postoggetto)
		references postoggetto(id)
);

-- I vincoli {complete, disjoint} su postoggetto nuovo/usato non sono ancora implementati
-- I vincoli {complete, disjoint} su postoggetto asta/compralosubito non sono ancora implementati

create table metodopagamento (
	nome stringa primary key
);

create table met_post (
	postoggetto integer not null,
	metodo stringa not null,
	primary key (postoggetto, metodo),
	foreign key (postoggetto)
		references postoggetto(id) deferrable,
	foreign key (metodo)
		references metodopagamento(nome)
);


create table postoggettocompralosubito (
	postoggetto integer primary key,
	
	prezzo realgz not null,
	foreign key (postoggetto)
		references postoggetto(id) deferrable,
	acquirente stringa,
	foreign key (acquirente)
		references privato(utente),
	istante_acquisto timestamp,
	check (
		(acquirente is null)
		=
		(istante_acquisto is null)
	)
);

create table postoggettoasta (
	postoggetto integer primary key,
	prezzo_base realgez not null,
	prezzo_bid realgz not null,
	scadenza timestamp not null,

	foreign key (postoggetto)
		references postoggetto(id) deferrable
);

create table bid (
	codice serial primary key,
	istante timestamp not null,
	asta integer not null,
	privato stringa not null,
	foreign key (privato)
		references privato(utente),
	foreign key (asta)
		references postoggettoasta(postoggetto),
	unique(istante, asta) -- implementa {id2}
);











