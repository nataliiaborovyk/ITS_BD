-- 1. Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati?
select avg(stipendio) as media,
    stddev_samp(stipendio) as deviazione_standart
from persona
group by posizione

-- 2. Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media della loro categoria?
with media_stip_ric as (
    select avg(stipendio) as media
    from persona
    where posizione = 'Ricercatore'
)
select p.id, p.nome, p.cognome, p.posizione, p.stipendio
from persona p, media_stip_ric msr
where p.posizione = 'Ricercatore'
    and p.stipendio > msr.media


-- 3. Per ogni categoria di strutturati quante sono le persone con uno stipendio che
-- differisce di al massimo una deviazione standard dalla media della loro categoria?

-- quante persone?
    -- per ogni posizione
-- (media_pos - stipendio ) <= dev_st

-- media_pos
select p.posizione, round(avg(p.stipendio)) as media_pos
from persona p
group by p.posizione

-- dev_st
select p.posizione, stddev_samp(stipendio) as deviazione_standart
from persona p
group by p.posizione


with 
media_std as (
    select p.posizione, 
        avg(p.stipendio) as media_pos, 
        stddev_samp(stipendio) as deviazione_standard
    from persona p
    group by p.posizione
)
select p.posizione, count(*) as num
from persona p, media_std m
where p.posizione = m.posizione
    and abs(m.media_pos - p.stipendio) <= m.deviazione_standard
group by p.posizione



-- 4. Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività
-- progettuali? Restituire tutti i loro dati e il numero di ore lavorate.



-- 5. Quali sono i progetti la cui durata è superiore alla media delle durate di tutti i
-- progetti? Restituire nome dei progetti e loro durata in giorni.


-- 6. Quali sono i progetti terminati in data odierna che hanno avuto attività di tipo
-- “Dimostrazione”? Restituire nome di ogni progetto e il numero complessivo delle
-- ore dedicate a tali attività nel progetto.


-- 7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del nu-
-- mero di assenze medio per malattia dei professori associati? Restituire id, nome e
-- cognome del professore e il numero di giorni di assenza per malattia.