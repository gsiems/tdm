CREATE OR REPLACE PROCEDURE tdm.model_update (
    a_model_id in int default null,
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
| a_model_id            | in     | int      | The ID of the model to update         |
| a_db_engine_id        | in     | int      | The ID of the database engine that will host the database |
| a_update_strategy_id  | in     | int      | The default strategy to use to deal with update conflicts |
| a_name                | in     | varchar  | The name of the model                 |
| a_description         | in     | varchar  | An optional description of the model/it's purpose |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_db_engine_id int ;
    l_update_strategy_id int ;

BEGIN

    FOR dt IN (
        SELECT id
            FROM tdm.dt_model
            WHERE name = a_name
                AND id <> a_model_id
        ) LOOP

        a_err := 'Model not updated - another model exists with the same name.' ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.st_update_strategy
            WHERE id = a_update_strategy_id
        ) LOOP

        l_update_strategy_id := dt.id ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.st_db_engine
            WHERE id = a_db_engine_id
        ) LOOP

        l_db_engine_id := dt.id ;

    END LOOP ;

    UPDATE tdm.dt_model
        SET db_engine_id = l_db_engine_id,
            update_strategy_id = l_update_strategy_id,
            name = a_name,
            description = a_description,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE id = a_model_id
            AND ( db_engine_id IS DISTINCT FROM l_db_engine_id
                OR update_strategy_id IS DISTINCT FROM l_update_strategy_id
                OR name IS DISTINCT FROM a_name
                OR description IS DISTINCT FROM a_description ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Model not updated - ' || sqlerrm ;

END ;
$$ ;
