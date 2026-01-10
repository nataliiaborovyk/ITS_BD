create domain Stringa as varchar;

create domain Voto as integer
	check (value BETWEEN 0 and 5);

create domain IntGE2 as integer
	check (value >= 2);

create domain URL as varchar
	check (value ~ '...');

create domain RealGEZ as real 
	check (value >= 0);

create domain RealGZ as real 
	check (value > 0);

create domain IntGEZ as integer 
	check (value >= 0);

create type Condizione as enum
	('Ottimo', 'Buono', 'Discreto', 'Da sistemare');

create type Popolarita as enum
	('Bassa', 'Media', 'Alta');