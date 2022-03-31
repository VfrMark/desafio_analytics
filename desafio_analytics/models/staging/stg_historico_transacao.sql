with 
    source as (
        select *
        from {{ source('analytics', 'raw_transactionhistory') }}
    )
    , transformed as (
        select
            "transactionid" as id_transacao
            , "productid" as id_produto
            , cast(transactiondate as date) as data_transacao
            , case 
                when transactiontype = 'W' then 'ordem servico'
                when transactiontype = 'W' then 'ordem venda'
                when transactiontype = 'W' then 'ordem compra'
            end as tipo_transacao
            , "quantity" as qtd_produto
            , "actualcost" as custo_produto
            , cast(modifieddate as date) as data_modificacao
        from source
    )
select *
from transformed