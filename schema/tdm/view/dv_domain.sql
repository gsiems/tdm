CREATE OR REPLACE VIEW tdm.dv_domain
AS
SELECT dd.id,
        dd.size,
        dd.scale,
        dd.name,
        dd.abbreviation,
        dd.default_value,
        dd.description,
        dd.model_id,
        dm.name AS model_name,
        dd.datatype_id,
        sd.name AS datatype_name,
        dd.entity_id AS entity_id,
        de.name AS entity_name,
        dd.range_type_id,
        srt.name AS range_type_name,
        dd.range_values,
        dd.created_by,
        dd.created_dt,
        dd.updated_by,
        dd.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_domain dd
    INNER JOIN tdm.dt_model dm
        ON ( dm.id = dd.model_id )
    INNER JOIN tdm.st_datatype sd
        ON ( sd.id = dd.datatype_id )
    LEFT JOIN tdm.dt_entity de
        ON ( de.id = dd.entity_id )
    INNER JOIN tdm.st_range_type srt
        ON ( srt.id = dd.range_type_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = dd.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = dd.updated_by ) ;

COMMENT ON VIEW tdm.dv_domain IS 'Expanded view of the dt_domain table' ;
