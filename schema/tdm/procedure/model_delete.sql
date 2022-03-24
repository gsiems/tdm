CREATE OR REPLACE PROCEDURE tdm.model_delete (
    a_model_id in int default null,
    a_force boolean default false,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure model_delete deletes a model

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_model_id            | in     | int      | The ID of the model to delete         |
| a_force               | in     | boolean  | Delete the model even if it has entities |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;

BEGIN


    IF coalesce ( a_force, false ) THEN

        DELETE FROM tdm.dt_attribute o
            WHERE EXISTS (
                SELECT 1
                    FROM tdm.dt_entity de
                    WHERE de.model_id = a_model_id
                        AND id = o.entity_id ) ;

        DELETE FROM tdm.dt_entity
            WHERE model_id = a_model_id ;

    ELSE

        FOR dt IN (
            SELECT
                FROM tdm.dt_entity
                WHERE model_id = a_model_id
            ) LOOP

            a_err := 'Model not deleted - it contains one or more entities.' ;
            RETURN ;

        END LOOP ;

    END IF ;

    DELETE FROM tdm.dt_domain
        WHERE model_id = a_model_id ;

    DELETE FROM tdm.dt_namespace
        WHERE model_id = a_model_id ;

    DELETE FROM tdm.dt_model_user
        WHERE id = a_model_id ;

    DELETE FROM tdm.dt_model
        WHERE id = a_model_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Model not deleted - ' || sqlerrm ;

END ;
$$ ;
