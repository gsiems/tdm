CREATE OR REPLACE PROCEDURE tdm.namespace_update (
    a_namespace_id in int default null,
    a_name in character varying default null,
    a_schema_name in character varying default null,
    a_description in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure namespace_update updates a namespace

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_namespace_id        | in     | int      | The ID of the namespace to update     |
| a_name                | in     | varchar  | The name of the namespace             |
| a_schema_name         | in     | varchar  | The schema name to use in the database |
| a_description         | in     | varchar  | An optional description of the namespace/it's purpose |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_schema_name character varying ;

BEGIN

    l_name := coalesce ( a_name, initcap ( replace ( a_schema_name, '_', ' ' ) ) ) ;
    l_schema_name := coalesce ( a_schema_name, lower ( replace ( a_name, ' ', '_' ) ) ) ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_namespace
            WHERE name = l_name
                AND id <> a_namespace_id
        ) LOOP

        a_err := 'Namespace not updated - another namespace exists with the same name.' ;
        RETURN ;

    END LOOP ;

    UPDATE tdm.dt_namespace
        SET name = l_name,
            schema_name = l_schema_name,
            description = a_description,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE id = a_namespace_id
            AND ( name IS DISTINCT FROM l_name
                OR schema_name IS DISTINCT FROM l_schema_name
                OR description IS DISTINCT FROM a_description ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Namespace not updated - ' || sqlerrm ;

END ;
$$ ;
