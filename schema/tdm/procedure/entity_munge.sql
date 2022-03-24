CREATE OR REPLACE PROCEDURE tdm.entity_munge (
    a_entity_id in int default null,
    a_entity_type_id inout int default NULL,
    a_name inout character varying default NULL,
    a_table_name inout character varying default NULL,
    a_abbreviation inout character varying default NULL,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure entity_munge TBD

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | in     | int      | The ID of the entity to update        |
| a_entity_type_id      | inout  | int      | The ID indicating the nature of the kind of entity |
| a_name                | inout  | varchar  | The name of the entity                |
| a_table_name          | inout  | varchar  | The table name to use in the database |
| a_abbreviation        | inout  | varchar  | The abbreviation to use when shortening the table name |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_table_name character varying ;
    l_abbreviation character varying ;
    l_prefix character varying ;

BEGIN

    a_entity_type_id := coalesce ( a_entity_type_id, 1::int ) ; -- default to dt

    l_name := trim ( coalesce ( a_name, '' ) ) ;
    l_table_name := trim ( coalesce ( a_table_name, '' ) ) ;
    l_abbreviation := trim ( coalesce ( a_abbreviation, '' ) ) ;

    /*
    Ensure that there is a name and a table name. If either are missing
    then derive the missing from the provided
    */
    IF l_name = '' THEN
        l_name := initcap ( trim ( replace ( l_table_name, '_', ' ' ) ) ) ;
    END IF ;

    IF a_table_name = '' THEN
        IF l_abbreviation <> '' THEN
            l_table_name := lower ( replace ( l_abbreviation, ' ', '_' ) ) ;
        ELSE
            l_table_name := lower ( replace ( l_name, ' ', '_' ) ) ;
        END IF ;
    END IF ;

    FOR dt IN (
        SELECT table_prefix
            FROM tdm.st_entity_type
            WHERE table_prefix = lower ( split_part ( l_table_name, '_', 1 ) )
        ) LOOP

        l_prefix := split_part ( dt.table_prefix, '_', 1 ) ;
        l_table_name := substring ( l_table_name FROM length ( l_prefix ) + 2 ) ;

--raise info 'l_prefix is "%"', l_prefix ;

    END LOOP ;

    /*
    If the name is derived from the table name and has a dt, rt,
    etc. prefix then remove the prefix.
    */
    IF l_prefix IS NOT NULL THEN

        FOR dt IN (
            SELECT table_prefix
                FROM tdm.st_entity_type
                WHERE table_prefix = lower ( split_part ( l_name, ' ', 1 ) )
            ) LOOP

            l_name := substring ( l_name FROM length ( l_prefix ) + 2 ) ;

        END LOOP ;

    END IF ;

    /*
    If the table name does not have a prefix then prepend the appropriate
    prefix (as specified by the a_entity_type_id) to the table name.

    If the table name does have a prefix then ensure that the prefix
    matches the one specified by a_entity_type_id.
    */
    FOR dt IN (
        SELECT table_prefix
            FROM tdm.st_entity_type
            WHERE id = a_entity_type_id
        ) LOOP

        l_table_name := dt.table_prefix || '_' || l_table_name ;

    END LOOP ;

    a_name := l_name ;
    a_table_name := l_table_name ;
    a_abbreviation := l_abbreviation ;

    RETURN ;
END ;
$$ ;
