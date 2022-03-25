CREATE OR REPLACE PROCEDURE tdm.entity_insert (
    a_entity_id inout int default null,
    a_model_id in int default NULL,
    a_namespace_id in int default NULL,
    a_supertype_entity_id in int default NULL,
    a_entity_type_id in int default NULL,
    a_entity_size_id in int default NULL,
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
Procedure entity_insert inserts an entity

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | inout  | int      | The ID of the entity to insert        |
| a_model_id            | in     | int      | The ID of the model that the entity belongs to |
| a_namespace_id        | in     | int      | The ID of the namespace that contains the entity |
| a_supertype_entity_id | in     | int      | The ID of the entity that this is a subset of |
| a_entity_type_id      | in     | int      | The ID indicating the nature of the kind of entity |
| a_entity_size_id      | in     | int      | The ID indicating the maximum number of entities to be stored |
| a_history_type_id     | in     | int      | The type of history to keep for the table data |
| a_update_strategy_id  | in     | int      | The strategy to use when dealing with update conflicts |
| a_name                | in     | varchar  | The name of the entity                |
| a_table_name          | in     | varchar  | The table name to use in the database |
| a_abbreviation        | in     | varchar  | The abbreviation to use when shortening the table name |
| a_description         | in     | varchar  | An optional description of the entity/it's purpose |
| a_updated_by          | in     | int      | The ID of the person inserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_table_name character varying ;
    l_abbreviation character varying ;
    l_entity_type_id int ;
    l_domain_id int ;

BEGIN

    /*
    TODO: There should probably be a way of indicating whether or not an
        entity should show in the conceptual model view.
    */

    l_name := a_name ;
    l_table_name := a_table_name ;
    l_abbreviation := a_abbreviation ;
    l_entity_type_id := coalesce ( a_entity_type_id, 1::int ) ; -- default to business data

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
        ) LOOP

        a_err := 'Entity not inserted - another entity exists with the same name.' ;
        RETURN ;

    END LOOP ;

    INSERT INTO tdm.dt_entity (
            model_id,
            namespace_id,
            supertype_entity_id,
            entity_type_id,
            entity_size_id,
            history_type_id,
            update_strategy_id,
            name,
            table_name,
            abbreviation,
            description,
            created_by,
            created_dt,
            updated_by,
            updated_dt )
        VALUES (
            a_model_id,
            a_namespace_id,
            a_supertype_entity_id,
            l_entity_type_id,
            a_entity_size_id,
            a_history_type_id,
            a_update_strategy_id,
            l_name,
            l_table_name,
            l_abbreviation,
            a_description,
            a_updated_by,
            now () AT TIME ZONE 'UTC',
            a_updated_by,
            now () AT TIME ZONE 'UTC' )
        RETURNING id
        INTO a_entity_id  ;

    call tdm.domain_insert (
        a_domain_id => l_domain_id,
        a_model_id => a_model_id,
        a_datatype_id => 9::int,
        a_entity_id => a_entity_id,
        a_range_type_id => 3::int,
        a_size => NULL::int,
        a_scale => NULL::int,
        a_name => l_name,
        a_abbreviation => l_abbreviation,
        a_description => ( 'Domain for the ' || l_name || ' entity' )::varchar,
        a_default_value => NULL::character varying,
        a_range_values => NULL::character varying,
        a_updated_by => a_updated_by,
        a_err => a_err ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Entity not inserted - ' || sqlerrm ;

END ;
$$ ;
