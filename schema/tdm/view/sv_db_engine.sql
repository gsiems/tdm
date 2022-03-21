CREATE OR REPLACE VIEW tdm.sv_db_engine
AS
SELECT id,
        name,
        description
    FROM tdm.st_db_engine ;

COMMENT ON VIEW tdm.sv_db_engine IS 'View of the st_db_engine table' ;
