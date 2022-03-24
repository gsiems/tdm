CREATE OR REPLACE procedure tdm.entity_upsert (
    a_entity_id inout int default null,
    a_model_id in int default NULL,
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
Procedure entity_upsert upserts an entity

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_entity_id           | inout  | int      | The ID of the entity to upsert        |
| a_model_id            | in     | int      | The ID of the model that the entity belongs to |
| a_namespace_id        | in     | int      | The ID of the namespace that contains the entity |
| a_supertype_entity_id | in     | int      | The ID of the entity that this is a subset of |
| a_entity_type_id      | in     | int      | The ID indicating the nature of the kind of entity |
| a_history_type_id     | in     | int      | The type of history to keep for the table data |
| a_update_strategy_id  | in     | int      | The strategy to use when dealing with update conflicts |
| a_name                | in     | varchar  | The name of the entity                |
| a_table_name          | in     | varchar  | The table name to use in the database |
| a_abbreviation        | in     | varchar  | The abbreviation to use when shortening the table name |
| a_description         | in     | varchar  | An optional description of the entity/it's purpose |
| a_updated_by          | in     | int      | The ID of the person upserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |


*/
DECLARE

BEGIN

    IF a_entity_id IS NULL THEN
        call tdm.entity_insert (
            a_entity_id => a_entity_id,
            a_model_id => a_model_id,
            a_namespace_id => a_namespace_id,
            a_supertype_entity_id => a_supertype_entity_id,
            a_entity_type_id => a_entity_type_id,
            a_history_type_id => a_history_type_id,
            a_update_strategy_id => a_update_strategy_id,
            a_name => a_name,
            a_table_name => a_table_name,
            a_abbreviation => a_abbreviation,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    ELSE
        call tdm.entity_update (
            a_entity_id => a_entity_id,
            a_namespace_id => a_namespace_id,
            a_supertype_entity_id => a_supertype_entity_id,
            a_entity_type_id => a_entity_type_id,
            a_history_type_id => a_history_type_id,
            a_update_strategy_id => a_update_strategy_id,
            a_name => a_name,
            a_table_name => a_table_name,
            a_abbreviation => a_abbreviation,
            a_description => a_description,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    END IF ;

    RETURN ;
END ;
$$ ;
