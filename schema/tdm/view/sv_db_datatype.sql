CREATE OR REPLACE VIEW tdm.sv_db_datatype
AS
SELECT sdd.id,
        sdd.db_engine_id,
        sde.name AS db_engine_name,
        sdd.datatype_id,
        sd.name AS datatype_name,
        sdd.entity_size_id,
        sts.name AS entity_size_name,
        sdd.name,
        sdd.description
    FROM tdm.st_db_datatype sdd
    JOIN tdm.st_db_engine sde
        ON ( sdd.db_engine_id = sde.id )
    JOIN tdm.st_datatype sd
        ON ( sdd.datatype_id = sd.id )
    JOIN tdm.st_entity_size sts
        ON ( sdd.entity_size_id = sts.id ) ;

COMMENT ON VIEW tdm.sv_db_datatype IS 'View of the st_db_datatype table' ;
