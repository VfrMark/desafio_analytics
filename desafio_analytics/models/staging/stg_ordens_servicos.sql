with 
    source as (
        select *
        from {{ source('analytics', 'raw_workorder') }}
    )
    , transformed as (
        select
            workorderid as id_ordem_servico
            , productid as id_produto
            , orderqty as quantidade_ordem
            , scrappedqty as quantidade_sucateado
            , cast(startdate as timestamp) as data_inicio
            , cast(enddate as timestamp) as data_fim
            , cast (duedate as timestamp) as data_vencimento
            , scrapreasonid as id_sucateamento
            , cast(modifieddate as timestamp) as data_modificacao
        from source
    )

select * 
from transformed