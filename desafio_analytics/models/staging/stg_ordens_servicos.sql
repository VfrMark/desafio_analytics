with 
    source as (
        select *
        from {{ source('analytics', 'raw_workorder') }}
    )
    
    , transformed as (
        select
            "workorderid" as id_ordem_servico
            , "productid" as id_produto
            , "orderqty" as quantidade_ordem
            , "scrappedqty" as quantidade_sucateado
            , "startdate" as data_inicio
            , "enddate" as data_fim
            , "duedate" as data_vencimento
            , coalesce(scrapreasonid, 'não sucateado') as id_razão_sucateado
            , "modifieddate" as data_modificacao
        from source
    )

select * from transformed