CREATE OR REPLACE PROCEDURE tdm.namespace_insert (
    a_namespace_id inout int default null,
    a_model_id in int default null,
    a_name in character varying default null,
    a_schema_name in character varying default null,
    a_description in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure namespace_insert inserts a namespace

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_namespace_id        | in     | int      | The ID of the namespace to insert     |
| a_model_id            | in     | int      | The ID of the model that the namespace belongs to |
| a_name                | in     | varchar  | The name of the namespace                 |
| a_schema_name         | in     | varchar  | The schema name to use in the database    |
| a_description         | in     | varchar  | An optional description of the namespace/it's purpose |
| a_updated_by          | in     | int      | The ID of the person inserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_schema_name character varying ;
    l_is_default boolean ;

BEGIN

    l_name := coalesce ( a_name, initcap ( replace ( a_schema_name, '_', ' ' ) ) ) ;
    l_schema_name := coalesce ( a_schema_name, lower ( replace ( a_name, ' ', '_' ) ) ) ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_namespace
            WHERE name = l_name
        ) LOOP

        a_err := 'Namespace not inserted - another namespace exists with the same name.' ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT count (*) AS kount
            FROM tdm.dt_namespace
            WHERE model_id = a_model_id
        ) LOOP

        l_is_default := ( dt.kount = 1 ) ;

        INSERT INTO tdm.dt_namespace (
                model_id,
                name,
                schema_name,
                is_default,
                description,
                created_by,
                created_dt,
                updated_by,
                updated_dt )
            VALUES (
                a_model_id,
                l_name,
                l_schema_name,
                l_is_default,
                a_description,
                a_updated_by,
                now () AT TIME ZONE 'UTC',
                a_user_id_created,
                now () AT TIME ZONE 'UTC' )
            RETURNING id
            INTO a_namespace_id ;

    END LOOP ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Namespace not inserted - ' || sqlerrm ;

END ;
$$ ;
