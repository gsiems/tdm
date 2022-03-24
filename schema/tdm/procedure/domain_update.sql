CREATE OR REPLACE PROCEDURE tdm.domain_update (
    a_domain_id in int default null,
    a_datatype_id in int default null,
    a_size in int default null,
    a_scale in int default null,
    a_name in character varying default null,
    a_abbreviation in character varying default null,
    a_description in character varying default null,
    a_default_value in character varying default null,
    a_range_values in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure domain_update updates a domain

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_domain_id           | in     | int      | The ID of the domain to update        |
| a_datatype_id         | in     | int      | The ID of the datatype for the domain |
| a_size                | in     | int      | The size for the datatype (length for text) |
| a_scale               | in     | int      | The scale for the datatype            |
| a_name                | in     | varchar  | The name of the domain                |
| a_abbreviation        | in     | varchar  | The defauult abbreviation to use when shortening the column name |
| a_description         | in     | varchar  | An optional description of the domain/it's purpose |
| a_default_value       | in     | varchar  | The default value, if any, for the domain |
| a_range_values        | in     | varchar  | The delimited list of allowed values (small fixed set domains only) where the first byte in the string is the delimiter |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_size int ;
    l_scale int ;

BEGIN

    FOR dt IN (
        SELECT id
            FROM tdm.dt_domain
            WHERE name = a_name
                AND id <> a_domain_id
        ) LOOP

        a_err := 'Domain not updated - another domain exists with the same name.' ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_domain
            WHERE id = a_domain_id
                AND entity_id IS NOT NULL
        ) LOOP

        a_err := 'Domain not updated - is an entity-based domain.' ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT dd.id
            FROM tdm.dt_domain dd
            JOIN tdm.st_datatype sd
                ON ( sd.name = dd.name )
            WHERE dd.id = a_domain_id
        ) LOOP

        a_err := 'Domain not updated - is a base domain.' ;
        RETURN ;

    END LOOP ;

    -- Sanity check/adjust the size, scale, length based on datatype
    l_size := a_size ;
    l_scale := a_scale ;

    FOR dt IN (
        SELECT has_size,
                has_scale
            FROM tdm.st_datatype
            WHERE id = a_datatype_id
        ) LOOP

        IF NOT dt.has_size THEN
            l_size := NULL ;
        END IF ;

        IF NOT dt.has_scale THEN
            l_scale := NULL ;
        END IF ;

    END LOOP ;

    UPDATE tdm.dt_domain
        SET datatype_id = a_datatype_id,
            size = l_size,
            scale = l_scale,
            name = a_name,
            abbreviation = a_abbreviation,
            default_value = a_default_value,
            range_values = a_range_values,
            description = a_description,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE id = a_domain_id
            AND entity_id IS NULL
            AND ( datatype_id IS DISTINCT FROM a_datatype_id
                OR size IS DISTINCT FROM a_size
                OR scale IS DISTINCT FROM a_scale
                OR name IS DISTINCT FROM a_name
                OR abbreviation IS DISTINCT FROM a_abbreviation
                OR default_value IS DISTINCT FROM a_default_value
                OR range_values IS DISTINCT FROM a_range_values
                OR description IS DISTINCT FROM a_description ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Domain not updated - ' || sqlerrm ;

END ;
$$ ;
