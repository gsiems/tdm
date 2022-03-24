CREATE OR REPLACE PROCEDURE tdm.attribute_update (
    a_attribute_id in int default null,
    a_new_entity_id in int default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure attribute_update updates an entity attribute to a different entity

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_attribute_id        | in     | int      | The ID of the attribute to move       |
| a_new_entity_id       | in     | int      | The ID of the entity to move the attribute to |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;

BEGIN

    -- Ensure that the new entity is in the same model as the attribute
    FOR dt IN (
        WITH o AS (
            SELECT de.model_id
                FROM tdm.dt_attribute da
                JOIN tdm.dt_entity de
                    ON ( de.id = da.entity_id )
                WHERE da.attribute_id = a_attribute_id
        ),
        n AS (
            SELECT de.model_id
                FROM tdm.dt_entity de
                WHERE de.id = a_new_entity_id
        )
        SELECT 1
            FROM o
            CROSS JOIN n
            WHERE o.model_id IS DISTINCT FROM n.model_id
        ) LOOP

        a_err := 'Attribute not moved - the new entity belongs to a different model.' ;
        RETURN ;

    END LOOP ;

    UPDATE tdm.dt_attribute
        SET entity_id = a_new_entity_id,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE attribute_id = a_attribute_id
            AND entity_id IS DISTINCT FROM a_new_entity_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Attribute not moved - ' || sqlerrm ;

END ;
$$ ;
