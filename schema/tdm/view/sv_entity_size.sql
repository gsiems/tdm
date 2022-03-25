CREATE OR REPLACE VIEW tdm.sv_entity_size
AS
SELECT id,
        name,
        description
    FROM tdm.st_entity_size ;

COMMENT ON VIEW tdm.sv_entity_size IS 'View of the st_entity_size table' ;
