with
    source as(
        select *
        from {{source('analytics','raw_scrapreason')}}
    )
    , transformed as(
        select 
            "scrapreasonid" as id_sucateamento
            , "name" as motivo_sucateamento
            , cast(modifieddate as date) as data_modificacao
        from source
    )
select * 
from transformed
