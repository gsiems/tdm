CREATE OR REPLACE VIEW tdm.sv_update_strategy
AS
SELECT id,
        name,
        description
    FROM tdm.st_update_strategy ;

COMMENT ON VIEW tdm.sv_update_strategy IS 'View of the st_update_strategy table' ;
