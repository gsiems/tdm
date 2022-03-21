CREATE OR REPLACE VIEW tdm.dv_user
AS
SELECT du.id,
        du.is_enabled,
        du.is_admin,
        du.username,
        du.full_name,
        du.email_address,
        du.created_by,
        du.created_dt,
        du.updated_by,
        du.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_user du
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = du.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = du.updated_by ) ;

COMMENT ON VIEW tdm.dv_namespace IS 'Expanded view of the dt_user table' ;
