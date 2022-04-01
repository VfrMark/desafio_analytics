/* Esse teste garante que a soma de quantidade da "fact_inventario" entre 2008/03/31 ate 2014/08/12 não mude enquanto 
a fk_localizao = '954f56bf1ce1b8ef97b2be04d3698cef' */

with
    data as (
       select
            sum(quantidade) as quantidade
       from {{ ref('fact_inventario') }}
       where
            FK_localizacao = '954f56bf1ce1b8ef97b2be04d3698cef'
            and data_chegada between '2014-08-12' and '2008-03-31'
   )
   , validation as (
       select *
       from data
       where
           quantidade != 72.899
   )
select *
from validation