CREATE OR REPLACE PROCEDURE tdm.entity_delete_check (
    a_entity_id in int default null,
    a_can_delete inout boolean default false,
    a_reason inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure entity_delete_check determines if an entity can be deleted

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | in     | int      | The ID of the entity to be deleted    |
| a_can_delete          | inout  | boolean  | Indicates if the entity can be deleted |
| a_reason              | inout  | varchar  | The reason that the entity cannot be deleted |

*/
DECLARE

    dt record ;

BEGIN

    a_can_delete := true ;
    a_reason := null ;

    -- Determine if the domain for the entity is referenced by any attributes of any other entities
    FOR dt IN (
        SELECT dd.id
            FROM tdm.dt_domain dd
            JOIN tdm.dt_attribute da
                ON ( da.domain_id = dd.id
                    AND da.a_entity_id <> dd.entity_id )
            WHERE dd.entity_id = a_entity_id
        ) LOOP

        a_reason := 'is referenced attributes of one or more other entities.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;

    -- Determine if the entity is a super-type for other entities
    FOR dt IN (
        SELECT id
            FROM tdm.dt_entity
            WHERE supertype_entity_id = a_entity_id
        ) LOOP

        a_reason := 'is supertype to one or more other entities.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;

EXCEPTION
    WHEN others THEN
        a_reason := sqlerrm ;
        a_can_delete := false ;

END ;
$$ ;
