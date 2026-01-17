create domain tipo as enum('Pubblico', 'Privato');

create domain stringa as varchar;

create domain voto as numeric 
    check (value between 0 and 5);

create domain intgz as integer
    check (value > 0);

