CREATE OR REPLACE procedure tdm.model_upsert (
    a_model_id inout int default null,
    a_db_engine_id in int default null,
    a_update_strategy_id in int default null,
    a_name in character varying default null,
    a_description in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure model_delete deletes a model

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_model_id            | in     | int      | The ID of the model to upsert         |
| a_db_engine_id        | in     | int      | The ID of the database engine that will host the database |
| a_update_strategy_id  | in     | int      | The default strategy to use to deal with update conflicts |
| a_name                | in     | varchar  | The name of the model                 |
| a_description         | in     | varchar  | An optional description of the model/it's purpose |
| a_updated_by          | in     | int      | The ID of the person upserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

BEGIN

    IF a_model_id IS NULL THEN
        call tdm.model_insert (
            a_model_id => a_model_id,
            a_db_engine_id => a_db_engine_id,
            a_update_strategy_id => a_update_strategy_id,
            a_name => a_name,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    ELSE
        call tdm.model_update (
            a_model_id => a_model_id,
            a_db_engine_id => a_db_engine_id,
            a_update_strategy_id => a_update_strategy_id,
            a_name => a_name,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    END IF ;

    RETURN ;
END ;
$$ ;
