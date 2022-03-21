CREATE OR REPLACE VIEW tdm.dv_attribute
AS
SELECT da.id,
        dm.id AS model_id,
        dm.name AS model_name,
        dn.id AS namespace_id,
        dn.name AS namespace_name,
        da.entity_id,
        de.name AS entity_name,
        da.domain_id,
        dd.name AS domain_name,
        dd.entity_id AS domain_entity_id,
        pde.name AS domain_entity_name,
        dd.datatype_id,
        sd.name AS datatype_name,
        da.range_type_id,
        sr.name AS range_name,
        da.ordinal_order,
        da.is_required,
        da.multiples_allowed,
        da.is_natural_key,
        da.name,
        da.abbreviation,
        da.description,
        da.created_by,
        da.created_dt,
        da.updated_by,
        da.updated_dt,
        cu.username AS created_username,
        cu.full_name AS created_full_name,
        uu.username AS updated_username,
        uu.full_name AS updated_full_name
    FROM tdm.dt_model dm
    INNER JOIN tdm.dt_namespace dn
        ON ( dm.id = dn.model_id )
    INNER JOIN tdm.dt_entity de
        ON ( dn.id = de.namespace_id )
    INNER JOIN tdm.dt_attribute da
        ON ( de.id = da.entity_id )
    INNER JOIN tdm.dt_domain dd
        ON ( dd.id = da.domain_id )
    INNER JOIN tdm.st_range_type sr
        ON ( sr.id = da.range_type_id )
    INNER JOIN tdm.st_datatype sd
        ON ( sd.id = dd.datatype_id )
    LEFT JOIN tdm.dt_entity pde
        ON ( pde.id = dd.entity_id )
    LEFT JOIN tdm.dt_user cu
        ON ( cu.id = da.created_by )
    LEFT JOIN tdm.dt_user uu
        ON ( uu.id = da.updated_by ) ;

COMMENT ON VIEW tdm.dv_attribute IS 'Expanded view of the dt_attribute table' ;
