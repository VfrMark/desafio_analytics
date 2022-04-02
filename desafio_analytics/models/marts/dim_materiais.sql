with
    stg_materiais as (
        select *
        from {{ ref('stg_materiais') }}
    )
    , stg_materiais_with_sk as (
        select 
            {{ 
                dbt_utils.surrogate_key(['id_material', 'data_modificacao']) 
            }} as sk_material
            , {{ 
                dbt_utils.surrogate_key(['id_produto_pai', 'data_modificacao']) 
            }} as sk_produto_pai
            , {{ 
                dbt_utils.surrogate_key(['id_componente', 'data_modificacao']) 
            }} as sk_componente
            , *
        from stg_materiais
    )   
    , transformed as (
        select
            stg_materiais_with_sk.sk_material
            , stg_materiais_with_sk.sk_produto_pai
            , stg_materiais_with_sk.sk_componente
            , stg_materiais_with_sk.id_material
            , stg_materiais_with_sk.id_produto_pai
            , stg_materiais_with_sk.id_componente
            , stg_materiais_with_sk.bomlevel
            , stg_materiais_with_sk.qtd_por_montagem
            , stg_materiais_with_sk.data_inicio
            , stg_materiais_with_sk.data_fim
            , stg_materiais_with_sk.data_modificacao
        from stg_materiais_with_sk
        left join {{ ref('dim_produtos')}} 
            on stg_materiais_with_sk.sk_produto_pai = dim_produtos.sk_produtos
            and stg_materiais_with_sk.sk_componente = dim_produtos.sk_produtos
    )
select * 
from transformed