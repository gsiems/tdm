CREATE OR REPLACE VIEW tdm.sv_range
AS
SELECT id,
        name,
        description
    FROM tdm.st_range_type ;

COMMENT ON VIEW tdm.sv_range IS 'View of the st_range_type table' ;
