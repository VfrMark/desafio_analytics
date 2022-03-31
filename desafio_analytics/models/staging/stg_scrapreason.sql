with
    source as (
        select 
            scrapreasonid as id_razaosucateamento
            , name as motivo_sucateamento
            , modifieddate as data_modificacao
        from {{source('analytics','raw_scrapreason')}}
    )

select * from source