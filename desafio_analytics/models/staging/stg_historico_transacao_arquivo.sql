with 
    source as (
        select *
        from {{ source('analytics', 'raw_transactionhistoryarchive') }}
    )
    , transformed as (
        select
            transactionid as id_transacao
            , productid as id_produto
            , cast(transactiondate as timestamp) as data_transacao
            , case 
                when transactiontype = 'W' then 'ordem servico'
                when transactiontype = 'S' then 'ordem venda'
                when transactiontype = 'P' then 'ordem compra'
            end as tipo_transacao
            , quantity as qtd_produto
            , actualcost as custo_produto
            , cast(modifieddate as timestamp) as data_modificacao
        from source
    )
select *
from transformed