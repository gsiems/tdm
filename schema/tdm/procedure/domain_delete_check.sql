CREATE OR REPLACE PROCEDURE tdm.domain_delete_check (
    a_domain_id in int default null,
    a_can_delete inout boolean default false,
    a_reason inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure domain_delete_check determines if a domain can be deleted

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_domain_id           | in     | int      | The ID of the domain to cleanup       |
| a_can_delete          | inout  | boolean  | Indicates if the domain can be deleted |
| a_reason              | inout  | varchar  | The reason that the domain cannot be deleted |

*/
DECLARE

    dt record ;

BEGIN

    a_can_delete := true ;
    a_reason := null ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_attribute
            WHERE domain_id = a_domain_id
        ) LOOP

        a_reason := 'is referenced by one or more attributes.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_domain
            WHERE id = a_domain_id
                AND domain_entity_id IS NOT NULL
        ) LOOP

        a_reason := 'is an entity-based domain.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;

EXCEPTION
    WHEN others THEN
        a_reason := sqlerrm ;
        a_can_delete := false ;

END ;
$$ ;
