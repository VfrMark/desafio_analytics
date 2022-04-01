/* Esse teste garante que o número de motivos de sucateamentos no dia 30/04/2008 seja igual ao número de 
ids de sucateamento entre 1 e 16, como está na tabela raw. */

with
    data as (
       select
            count(motivo_sucateamento) as nome
       from {{ ref('dim_sucateado') }}
       where
            data_modificacao = '2008-04-30'
            and id_sucateamento between '1' and '16'
   )
   , validation as (
       select *
       from data
       where
           nome != 16
   )
select *
from validation