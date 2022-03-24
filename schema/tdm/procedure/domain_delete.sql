CREATE OR REPLACE PROCEDURE tdm.domain_delete (
    a_domain_id in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure domain_delete deletes a domain

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_domain_id           | in     | int      | The ID of the dopmain to delete       |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    l_can_delete boolean ;
    l_reason character varying ;

BEGIN

    call tdm.domain_delete_check (
        a_domain_id => a_domain_id,
        a_can_delete => l_can_delete,
        a_reason => l_reason ) ;

    IF NOT l_can_delete THEN
        a_err := 'Domain not deleted - ' || l_reason ;
        RETURN ;
    END IF ;

    DELETE FROM tdm.dt_domain
        WHERE id = a_domain_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Domain not deleted - ' || sqlerrm ;

END ;
$$ ;
