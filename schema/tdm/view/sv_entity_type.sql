CREATE OR REPLACE VIEW tdm.sv_entity_type
AS
SELECT id,
        table_prefix,
        name,
        description
    FROM tdm.st_entity_type ;

COMMENT ON VIEW tdm.sv_entity_type IS 'View of the st_entity_type table' ;
