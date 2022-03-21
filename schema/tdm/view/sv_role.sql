CREATE OR REPLACE VIEW tdm.sv_role
AS
SELECT id,
        name,
        description
    FROM tdm.st_role ;

COMMENT ON VIEW tdm.sv_role IS 'View of the st_role table' ;
