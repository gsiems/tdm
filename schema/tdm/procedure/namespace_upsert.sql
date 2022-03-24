CREATE OR REPLACE procedure tdm.namespace_upsert (
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
Procedure namespace_upsert upserts a namespace

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_namespace_id        | inout  | int      | The ID of the namespace to upsert     |
| a_model_id            | in     | int      | The ID of the model that the namespace belongs to |
| a_name                | in     | varchar  | The name of the namespace             |
| a_schema_name         | in     | varchar  | The schema name to use in the database |
| a_description         | in     | varchar  | An optional description of the namespace/it's purpose |
| a_updated_by          | in     | int      | The ID of the person upderting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

BEGIN

    IF a_namespace_id IS NULL THEN
        call tdm.namespace_insert (
            a_namespace_id => a_namespace_id,
            a_model_id => a_model_id,
            a_name => a_name,
            a_schema_name => a_schema_name,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    ELSE
        call tdm.namespace_update (
            a_namespace_id => a_namespace_id,
            a_name => a_name,
            a_schema_name => a_schema_name,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    END IF ;

    RETURN ;
END ;
$$ ;
