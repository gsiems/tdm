CREATE OR REPLACE PROCEDURE tdm.namespace_delete_check (
    a_namespace_id in int default null,
    a_can_delete inout boolean default false,
    a_reason inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure namespace_delete_check determines if a namespace can be deleted

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_namespace_id        | in     | int      | The ID of the namespace to cleanup    |
| a_can_delete          | inout  | boolean  | Indicates if the namespace can be deleted |
| a_reason              | inout  | varchar  | The reason that the namespace cannot be deleted |

*/
DECLARE

    dt record ;

BEGIN

    a_can_delete := true ;
    a_reason := null ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_entity
            WHERE namespace_id = a_namespace_id
        ) LOOP

        a_reason := 'is referenced by one or more entities.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_namespace
            WHERE id = a_namespace_id
                AND is_default
        ) LOOP

        a_reason := 'is default namespace.' ;
        a_can_delete := false ;
        RETURN ;

    END LOOP ;


EXCEPTION
    WHEN others THEN
        a_reason := sqlerrm ;
        a_can_delete := false ;
END ;
$$ ;
