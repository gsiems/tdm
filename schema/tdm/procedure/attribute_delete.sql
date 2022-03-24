CREATE OR REPLACE PROCEDURE tdm.attribute_delete (
    a_attribute_id in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure attribute_delete deletes an attribute

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_attribute_id        | in     | int      | The ID of the attribute to delete     |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

BEGIN

    DELETE FROM tdm.dt_attribute
        WHERE id = a_attribute_id ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Attribute not deleted - ' || sqlerrm ;

END ;
$$ ;
