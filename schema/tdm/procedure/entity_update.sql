CREATE OR REPLACE PROCEDURE tdm.entity_update (
    a_entity_id in int default null,
    a_namespace_id in int default NULL,
    a_supertype_entity_id in int default NULL,
    a_entity_type_id in int default NULL,
    a_history_type_id in int default NULL,
    a_update_strategy_id in int default NULL,
    a_name in character varying default NULL,
    a_table_name in character varying default NULL,
    a_abbreviation in character varying default NULL,
    a_description in character varying default NULL,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure entity_update updates an entity

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | in     | int      | The ID of the entity to update        |
| a_namespace_id        | in     | int      | The ID of the namespace that contains the entity |
| a_supertype_entity_id | in     | int      | The ID of the entity that this is a subset of |
| a_entity_type_id      | in     | int      | The ID indicating the nature of the kind of entity |
| a_history_type_id     | in     | int      | The type of history to keep for the table data |
| a_update_strategy_id  | in     | int      | The strategy to use when dealing with update conflicts |
| a_name                | in     | varchar  | The name of the entity                |
| a_table_name          | in     | varchar  | The table name to use in the database |
| a_abbreviation        | in     | varchar  | The abbreviation to use when shortening the table name |
| a_description         | in     | varchar  | An optional description of the entity/it's purpose |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_table_name character varying ;
    l_abbreviation character varying ;
    l_entity_type_id int ;

BEGIN

    /*
    TODO: There should probably be a way of indicating whether or not an
        entity should show in the conceptual model view.
    */
    l_name := a_name ;
    l_table_name := a_table_name ;
    l_abbreviation := l_abbreviation ;
    l_entity_type_id := l_entity_type_id ;

    call tdm.entity_munge (
        a_entity_id => a_entity_id,
        a_entity_type_id => l_entity_type_id,
        a_name => l_name,
        a_table_name => l_table_name,
        a_abbreviation => l_abbreviation,
        a_err => a_err ) ;

    IF a_err IS NOT NULL THEN
        RETURN ;
    END IF ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_entity
            WHERE name = l_name
                AND id = a_entity_id
        ) LOOP

        a_err := 'Entity not updated - another entity exists with the same name.' ;
        RETURN ;

    END LOOP ;

    UPDATE tdm.dt_entity
        SET namespace_id = a_namespace_id,
            supertype_entity_id = a_supertype_entity_id,
            entity_type_id = l_entity_type_id,
            history_type_id = a_history_type_id,
            update_strategy_id = a_update_strategy_id,
            name = l_name,
            table_name = l_table_name,
            abbreviation = l_abbreviation,
            description = a_description,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE id = a_entity_id
            AND ( namespace_id IS DISTINCT FROM a_namespace_id
                 OR supertype_entity_id IS DISTINCT FROM a_supertype_entity_id
                 OR entity_type_id IS DISTINCT FROM l_entity_type_id
                 OR history_type_id IS DISTINCT FROM a_history_type_id
                 OR update_strategy_id IS DISTINCT FROM a_update_strategy_id
                 OR name IS DISTINCT FROM l_name
                 OR table_name IS DISTINCT FROM l_table_name
                 OR abbreviation IS DISTINCT FROM l_abbreviation
                 OR description IS DISTINCT FROM a_description ) ;

    UPDATE tdm.dt_domain
        SET name = l_name,
            abbreviation = l_abbreviation,
            description = 'Domain for the ' || l_name || ' entity',
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE entity_id = a_entity_id
            AND ( name IS DISTINCT FROM l_name
                OR abbreviation IS DISTINCT FROM l_abbreviation ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Entity not updated - ' || sqlerrm ;

END ;
$$ ;
