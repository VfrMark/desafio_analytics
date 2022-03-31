with 
    source as (
        select *
        from {{ source('analytics', 'raw_billofmaterials') }}
    )
    , transformed as (
        select
            billofmaterialsid as id_material
            , productassemblyid as id_montagem_poduto
            , componentid as id_componente
            , bomlevel as bomlevel
            , perassemblyqty as nome_grupo_anuncio
            , startdate as data_inicio
            , enddate as data_fim
            , modifieddate as data_modificacao
        from source
    )
select *
from transformed