with 
    source as (
        select *
        from {{ source('analytics', 'raw_workorderrouting') }}
    )
    , transformed as (
        select
            "workorderid" as id_ordem_servico
            , "productid" as id_produto
            , "locationid" as id_localizacao
            , "operationsequence" as sequencia_operacao
            , "actualresourcehrs" as horas_fabricacao
            , "plannedcost" as custo_estimado
            , "actualcost" as custo_real
            , cast(scheduledstartdate as timestamp) as data_planejada_inicio_fabricacao
            , cast(scheduledenddate as timestamp) as data_planejada_fim_fabricacao
            , cast(actualstartdate as timestamp) as data_inicio_real
            , cast(actualenddate as timestamp) as data_fim_real
            , cast(modifieddate as timestamp) as data_modificacao
        from source
    )
select *
from transformed
