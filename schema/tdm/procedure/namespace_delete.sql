CREATE OR REPLACE PROCEDURE tdm.namespace_delete (
    a_namespace_id in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure namespace_delete deletes a namespace

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_namespace_id        | in     | int      | The ID of the namespace to delete     |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_can_delete boolean ;
    l_reason character varying ;

BEGIN

    l_can_delete := true ;

    call tdm.namespace_delete_check (
        a_namespace_id => a_namespace_id,
        a_can_delete => l_can_delete,
        a_reason => l_reason ) ;

    IF NOT l_can_delete THEN
        a_err := 'Namespace not deleted - ' || l_reason ;
        RETURN ;
    END IF ;

    DELETE FROM tdm.dt_namespace
        WHERE id = a_namespace_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Namespace not deleted - ' || sqlerrm ;

END ;
$$ ;
