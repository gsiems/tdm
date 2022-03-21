CREATE OR REPLACE VIEW tdm.dv_model_user
AS
SELECT dmu.model_id,
        dm.name AS model_name,
        dmu.user_id,
        du.username,
        du.full_name AS user_full_name,
        dmu.role_id,
        sr.name AS role_name,
        dmu.created_by,
        dmu.created_dt,
        dmu.updated_by,
        dmu.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_model_user dmu
    JOIN tdm.dt_model dm
        ON ( dm.id = dmu.model_id )
    JOIN tdm.dt_user du
        ON ( du.id = dmu.user_id )
    JOIN tdm.st_role sr
        ON ( sr.id = dmu.role_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = dm.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = dm.updated_by ) ;

COMMENT ON VIEW tdm.dv_model IS 'Expanded view of the dt_model_user table' ;
