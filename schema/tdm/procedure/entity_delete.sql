CREATE OR REPLACE PROCEDURE tdm.entity_delete (
    a_entity_id in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure entity_delete deletes an entity

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | in     | int      | The ID of the entity to delete        |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_can_delete boolean ;
    l_reason character varying ;

BEGIN

    call tdm.entity_delete_check (
        a_entity_id => a_entity_id,
        a_can_delete => l_can_delete,
        a_reason => l_reason ) ;

    IF NOT l_can_delete THEN
        a_err := 'Entity not deleted - ' || l_reason ;
        RETURN ;
    END IF ;

    DELETE FROM tdm.dt_attribute
        WHERE entity_id = a_entity_id ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_domain
            WHERE entity_id = a_entity_id
        ) LOOP

        UPDATE tdm.dt_domain
            SET entity_id = null
            WHERE id = dt.id ;

        call tdm.domain_delete (
            a_domain_id := dt.id,
            a_err := a_err ) ;

        IF a_err IS NOT NULL THEN
            RETURN ;
        END IF ;

    END LOOP ;

    DELETE FROM tdm.dt_entity
        WHERE id = a_entity_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Entity not deleted - ' || sqlerrm ;

END ;
$$ ;
