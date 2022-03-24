CREATE OR REPLACE PROCEDURE tdm.model_cleanup (
    a_model_id in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure model_cleanup deletes a model

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_model_id            | in     | int      | The ID of the model to cleanup        |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    dto record ;
    l_can_delete boolean ;
    l_reason character varying ;

BEGIN

    /*
    Clean-up entities
    */
    FOR dto IN (
        SELECT id AS entity_id
            FROM tdm.dt_entity
                WHERE model_id = a_model_id
        ) LOOP

        call tdm.entity_delete_check (
            a_entity_id => dto.entity_id,
            a_can_delete => l_can_delete,
            a_reason => l_reason ) ;

        -- Determine if the entity has attributes
        IF l_can_delete THEN
            FOR dt IN (
                SELECT id
                    FROM tdm.dt_attribute
                    WHERE entity_id = dto.entity_id
                ) LOOP

                l_can_delete := false ;

            END LOOP ;
        END IF ;

        IF l_can_delete THEN

            call tdm.entity_delete (
                a_entity_id => dto.entity_id,
                a_err => a_err ) ;

            IF a_err IS NOT NULL THEN
                RETURN ;
            END IF ;

        END IF ;

    END LOOP ;

    /*
    Clean-up domains
    */
    FOR dto IN (
        SELECT id AS domain_id
            FROM tdm.dt_domain
                WHERE model_id = a_model_id
        ) LOOP

        l_can_delete := true ;

        call tdm.domain_delete_check (
            a_domain_id => dto.domain_id,
            a_can_delete => l_can_delete,
            a_reason => l_reason ) ;

        IF l_can_delete THEN

            call tdm.domain_delete (
                a_domain_id => dto.domain_id,
                a_err => a_err ) ;

            IF a_err IS NOT NULL THEN
                RETURN ;
            END IF ;

        END IF ;

    END LOOP ;

    /*
    Clean-up namespaces
    */
    FOR dto IN (
        SELECT id AS domain_id
            FROM tdm.dt_domain
                WHERE model_id = a_model_id
        ) LOOP

        l_can_delete := true ;

        call tdm.namespace_delete_check (
            a_namespace_id => dto.namespace_id,
            a_can_delete => l_can_delete,
            a_reason => l_reason ) ;

        IF l_can_delete THEN

            call tdm.namespace_delete (
                a_namespace_id => dto.namespace_id,
                a_err => a_err ) ;

            IF a_err IS NOT NULL THEN
                RETURN ;
            END IF ;

        END IF ;

    END LOOP ;

EXCEPTION
    WHEN others THEN
        a_err := 'Model not cleaned up - ' || sqlerrm ;

END ;
$$ ;
