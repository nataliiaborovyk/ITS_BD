
create domain stringa as varchar;

create domain intgz as integer
	check (value > 0);

create domain latitudine as numeric(9)
	check (value between -90 and 90);

create domain longitudine as numeric(9)
	check (value between -180 and 180);

create domain priorita as integer
	check (value between 1 and 10);

create domain cf as char(16);




create table specie (
	n_scientifico stringa primary key,
	n_comune stringa not null
);

create table areaverde(
	id serial primary key,
	lat latitudine not null,
	lon longitudine not null,
	is_fruibile bool not null,
	is_sensibile bool not null,

	check ( is_sensibile=false or is_fruibile=true) -- "se A allora B" --> NOT A OR B
);

create table soggettoverde(
	id serial primary key,
	data date not null,
	specie stringa not null, -- accorpa l'associazione tra sogg. verde e specie
	foreign key (specie)
		references specie(n_scientifico),
	area integer not null, -- accorpa l'associazione tra sogg. verde e areaverde
	foreign key (area)
		references areaverde(id)
);

create table intervento(
	id serial primary key,
	inizio timestamp not null,
	durata intgz not null,
	priorita priorita not null,
	area integer not null, -- accorpa l'associazione tra intervento e areaverde
	foreign key (area)
		references areaverde(id)
);

create table interventoassegnato(
	id_intervento integer primary key, -- accorpa ia_isa_i (per legge!)
	foreign key (id_intervento) 
		references intervento(id),
	fine timestamp
	-- (id_intervento) occorre in assegna(interventoassegnato)
);

create table operatore(
	cf cf primary key,
	nome stringa not null,
	cognome stringa not null,
	inizio date not null,
	fine date -- se ci fosse il vincolo, avrebbe anche 'check (value is null or value > inizio)'

);

create table assegna (
	interventoassegnato integer not null,
	operatore cf not null,
	istante timestamp not null,

	foreign key (interventoassegnato)
		references interventoassegnato(id_intervento),
	foreign key (operatore)
		references operatore(cf),
	primary key (interventoassegnato, operatore)
);










