-- num_prenot_accettate(d_iniz:DataOra, d_fine:DataOra): Intero >=0

select count(*)
from prenotazione p
where p.stato = 'Accettata'
    and p.data_ora_prenotata between (d_iniz, d_fine)
    

-- num_prenot_rifiutate(d_iniz:DataOra, d_fine:DataOra): Intero >=0

select count(*)
from prenotazione p
where p.stato = 'Rifiutata'
    and p.data_ora_prenotata between (d_iniz, d_fine)


-- num_prenotazioni_ristorante_nel_periodo(
-- ris: Ristorante,  
-- d_iniz : DataOra, 
-- d_fine : DataOra
-- ) : Intero>=0

select count(*)
from ristorante r, prenotazione p
where p.ristorante = r.id
    and r.id = ris.id
    and p.data_ora_prenotata between (d_iniz, d_fine)

select count(*)
from ristorante r
    join prenotatazione p on r.id = p.ristorante
where r.id = ris.id
    and p.data_ora_prenotata between (d_iniz, d_fine)



-- num_prenot_accettate_ristorante_nel_periodo(
-- ris: Ristorante, 
-- d_iniz : DataOra, 
-- d_fine : DataOra
-- ) : Intero>=0

select count(*)
from prenotazione p 
where p.ristorante = ris.id
    and p.stato = 'Accettata'
    and p.data_ora_prenotata between (d_iniz, d_fine)

-- num_prenot_rifiutate_ristorante_nel_periodo(
-- r: Ristorante, 
-- d_iniz : DataOra, 
-- d_fine : DataOra
-- ) : Intero>=0

select count(*)
from prenotazione p 
where p.ristorante = ris.id
    and p.stato = 'Rifiutata'
    and p.data_ora_prenotata between (d_iniz, d_fine)


-- num_prenotazioni_effetuate_dal_cliente_nel_periodo(
-- cl: Cliente, 
-- d_iniz : DataOra, 
-- d_fine : DataOra
-- ) : Intero >=0

select count(*)
from prenotazione p
where p.cliente = cl.email
    and p.data_ora_prenotata between (d_iniz, d_fine)

-- num_prenotazioni_effetuate_da_cliente_nel_periodo_nel_ristorante(
-- cl: Cliente, 
-- ris: Ristorante, 
-- d_iniz : DataOra, 
-- d_fine : DataOra
-- ) : Intero >=0

select count(*)
from prenotazione p 
where p.cliente = cl.email
    and p.ristorante = ris.id
    and p.data_ora_prenotata between (d_iniz, d_fine)
