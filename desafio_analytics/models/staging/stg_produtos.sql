with 
    source as (
        select *
        from {{source('analytics', 'raw_product')}}
    )
    
    , transformed as (
        select 
            "productid" as id_produto
            , "name" as nome
            , "productnumber" as numero_produto
            , case 
                when makeflag = false then 'comprado'
                when makeflag = true then 'fabricado interno'
            end as flag_feito
            , case 
                when finishedgoodsflag = false then 'não comercializável'
                when finishedgoodsflag = true then 'comercializável'
            end as flag_produtos_finalizados
            , "color" as cor
            , "safetystocklevel" as estoque_minimo_seguro
            , "reorderpoint" as estoque_minimo_critico
            , "standardcost" as custo_padrao
            , "listprice" as preco_venda
            , "size" as tamanho
            , "sizeunitmeasurecode" as unidade_medida_tamanho
            , "weightunitmeasurecode" as unidade_medida_peso
            , "weight" as peso
            , "daystomanufacture" as dias_manufatura
            , case 
                when productline = 'R' then 'estrada'
                when productline = 'M' then 'montanha'
                when productline = 'T' then 'passeio'
                when productline = 'S' then 'padrão'
            end as linha_produto
            , case
                when class = 'H' then 'alta'
                when class = 'M' then 'média'
                when class = 'L' then 'baixa'
            end as classe
            , case 
                when style = 'W' then 'mulheres'
                when style = 'M' then 'homens'
                when style = 'U' then 'universal'
            end as estilo
            , "productsubcategoryid" as id_subcategoria_produto
            , "productmodelid" as id_modelo_produto
            , "sellstartdate" as data_inicio_venda
            , "sellenddate" as data_fim_venda
            , "discontinueddate" as data_descontinuado
            , "rowguid" as guia_linha
            , "modifieddate" as data_modificacao
        from source
    )


select * from transformed