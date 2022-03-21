CREATE OR REPLACE VIEW tdm.dv_entity
AS
SELECT de.id,
        de.model_id,
        dm.name AS model_name,
        de.namespace_id,
        dn.name AS namespace_name,
        de.supertype_entity_id,
        de_st.name AS supertype_entity_name,
        de.name,
        de.abbreviation,
        de.description,
        ste.id AS entity_type_id,
        ste.name AS entity_type_name,
        sht.id AS history_type_id,
        sht.name AS history_type_name,
        de.update_strategy_id,
        sus.name AS update_strategy_name,
        de.created_by,
        de.created_dt,
        de.updated_by,
        de.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_entity de
    JOIN tdm.dt_model dm
        ON ( dm.id = de.model_id )
    LEFT JOIN tdm.dt_namespace dn
        ON ( dn.id = de.namespace_id )
    LEFT JOIN tdm.dt_entity de_st
        ON ( de_st.id = de.supertype_entity_id )
    LEFT JOIN tdm.st_entity_type ste
        ON ( ste.id = de.entity_type_id )
    LEFT JOIN tdm.st_history_type sht
        ON ( sht.id = de.history_type_id )
    LEFT JOIN tdm.st_update_strategy sus
        ON ( sus.id = de.update_strategy_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = de.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = de.updated_by ) ;

COMMENT ON VIEW tdm.dv_entity IS 'Expanded view of the dt_entity table' ;
