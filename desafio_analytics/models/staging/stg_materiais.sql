with 
    source as (
        select *
        from {{ source('analytics', 'raw_billofmaterials') }}
    )
    , transformed as (
        select
            "billofmaterialsid" as id_material
            , "productassemblyid" as id_produto_pai
            , "componentid" as id_componente
            , "bomlevel" as bomlevel
            , "perassemblyqty" as qtd_por_pontagem
            , cast(startdate as date) as data_inicio
            , cast(enddate as date) as data_fim
            , cast(modifieddate as date) as data_modificacao
        from source
    )
select *
from transformed