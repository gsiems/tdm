CREATE OR REPLACE VIEW tdm.sv_datatype
AS
SELECT id,
        has_size,
        has_scale,
        name,
        description
    FROM tdm.st_datatype ;

COMMENT ON VIEW tdm.sv_datatype IS 'View of the st_datatype table' ;
