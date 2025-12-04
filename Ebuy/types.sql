create domain Stringa as varchar;

create type condizione as enum
    ('Ottimo', 'Buono', 'Discreto', 'Da sistemare');

create type Popolarita as enum
    ('Bassa', 'Media', 'Alta');

create domain URL as varchar 
    check (value ~* '^https?://[[:alnum:].-]+(:[0-9]+)?(/.*)?$');

create domain Voto as integer 
    check (value >= 0 and value <= 5);
    -- check (value BETWEEN 0 and 5);

create domain RealGZ as real 
    check (value > 0);

create domain IntGE1 as integer 
    check (value > 1);

create domain RealGEZ as real 
    check (value >= 0);

create domain IntGEZ as integer 
    check (value >= 0);