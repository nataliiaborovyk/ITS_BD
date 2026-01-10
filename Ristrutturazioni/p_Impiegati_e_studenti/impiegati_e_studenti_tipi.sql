
Create domain Stringa as varchar;

Create domain IntGEZ as integer
    check (value >= 0);

Create domain FloatGEZ as real
    check (value >= 0);

Create domain CodiceFiscale as char(16) 
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

Create type Ruolo as enum ('Segretario', 'Direttore', 'Progettista');
