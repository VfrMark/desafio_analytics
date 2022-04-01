/* Esse teste garante que a soma a capacidade de manufutra onde o custo_hora=12.25 e a o id_localizacao seja entre 1 e 60
mantenha-se constante */

with
    data as (
       select
            sum(capacidade_manufatura) as capacidade_manufatura
       from {{ ref('dim_localizacao') }}
       where
            custo_hora = '12.25'
            and id_localizacao between '1' and '60'
   )
   , validation as (
       select *
       from data
       where
           quantidade != 240
   )
select *
from validation