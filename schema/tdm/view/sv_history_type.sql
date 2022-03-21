CREATE OR REPLACE VIEW tdm.sv_history_type
AS
SELECT id,
        name,
        description
    FROM tdm.st_history_type ;

COMMENT ON VIEW tdm.sv_history_type IS 'View of the st_history_type table' ;
