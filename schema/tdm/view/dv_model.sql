CREATE OR REPLACE VIEW tdm.dv_model
AS
SELECT dm.id,
        dm.name,
        dm.description,
        dm.db_engine_id,
        sde.name AS db_engine_name,
        dm.update_strategy_id,
        sus.name AS update_strategy_name,
        dm.created_by,
        dm.created_dt,
        dm.updated_by,
        dm.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_model dm
    LEFT JOIN tdm.st_db_engine sde
        ON ( sde.id = dm.db_engine_id )
    LEFT JOIN tdm.st_update_strategy sus
        ON ( sus.id = dm.update_strategy_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = dm.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = dm.updated_by ) ;

COMMENT ON VIEW tdm.dv_model IS 'Expanded view of the dt_model table' ;
