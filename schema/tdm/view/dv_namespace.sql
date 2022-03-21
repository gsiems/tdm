CREATE OR REPLACE VIEW tdm.dv_namespace
AS
SELECT dn.id,
        dn.name,
        dn.description,
        dn.model_id,
        dm.name AS model_name,
        dn.created_by,
        dn.created_dt,
        dn.updated_by,
        dn.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_namespace dn
    JOIN tdm.dt_model dm
        ON ( dm.id = dn.model_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = dn.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = dn.updated_by ) ;

COMMENT ON VIEW tdm.dv_namespace IS 'Expanded view of the dt_namespace table' ;
