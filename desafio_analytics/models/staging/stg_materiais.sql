with 
    source as (
        select *
        from {{ source('analytics', 'raw_billofmaterials') }}
    )
    , transformed as (
        select
            billofmaterialsid as id_material
            , productassemblyid as id_produto_pai
            , componentid as id_componente
            , bomlevel as bomlevel
            , perassemblyqty as qtd_por_montagem
            , cast(startdate as timestamp) as data_inicio
            , cast(enddate as timestamp) as data_fim
            , cast(modifieddate as timestamp) as data_modificacao
        from source
    )
select *
from transformed