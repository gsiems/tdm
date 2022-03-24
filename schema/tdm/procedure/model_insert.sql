CREATE OR REPLACE PROCEDURE tdm.model_insert (
    a_model_id inout int default null,
    a_db_engine_id in int default null,
    a_update_strategy_id in int default null,
    a_name in character varying default null,
    a_description in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure model_delete deletes a model

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_model_id            | inout  | int      | The ID of the model to insert         |
| a_db_engine_id        | in     | int      | The ID of the database engine that will host the database |
| a_update_strategy_id  | in     | int      | The default strategy to use to deal with update conflicts |
| a_name                | in     | varchar  | The name of the model                 |
| a_description         | in     | varchar  | An optional description of the model/it's purpose |
| a_updated_by          | in     | int      | The ID of the person inserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_namespace_id int ;
    l_domain_id int ;
    l_db_engine_id int ;
    l_update_strategy_id int ;

BEGIN

    FOR dt IN (
        SELECT id
            FROM tdm.dt_model
            WHERE name = a_name
        ) LOOP

        a_err := 'Model not inserted - another model exists with the same name.' ;
        RETURN ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.st_update_strategy
            WHERE id = a_update_strategy_id
        ) LOOP

        l_update_strategy_id := dt.id ;

    END LOOP ;

    FOR dt IN (
        SELECT id
            FROM tdm.st_db_engine
            WHERE id = a_db_engine_id
        ) LOOP

        l_db_engine_id := dt.id ;

    END LOOP ;

    INSERT INTO tdm.dt_model (
            db_engine_id,
            update_strategy_id,
            name,
            description,
            created_by,
            created_dt,
            updated_by,
            updated_dt )
        VALUES (
            l_db_engine_id,
            l_update_strategy_id,
            a_name,
            a_description,
            a_updated_by,
            now () AT TIME ZONE 'UTC',
            a_updated_by,
            now () AT TIME ZONE 'UTC' )
        RETURNING id
        INTO a_model_id ;

    -- Initialize the default namespace
    call tdm.namespace_insert (
        a_namespace_id => l_namespace_id,
        a_model_id => a_model_id,
        a_name => a_name,
        a_schema_name => NULL::character varying,
        a_description => ( 'Default namespace for the ' || a_name || ' model' )::varchar,
        a_updated_by => a_updated_by,
        a_err => a_err ) ;

    IF a_err IS NOT NULL THEN
        RETURN ;
    END IF ;

    -- Initialize the default domains
    FOR dt IN (
        SELECT id,
                has_size,
                has_scale,
                name,
                description
            FROM tdm.st_datatype
        ) LOOP

        l_domain_id := null ;
        call tdm.domain_insert (
            a_domain_id => l_domain_id,
            a_model_id => a_model_id,
            a_datatype_id => dt.id,
            a_entity_id => NULL::int,
            a_range_type_id => 1::int,
            a_size => NULL::int,
            a_scale => NULL::int,
            a_name => dt.name,
            a_abbreviation => NULL::character varying,
            a_description => ( 'Domain for ' || dt.name || ' datatype' )::varchar,
            a_values => NULL::character varying,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

        IF a_err IS NOT NULL THEN
            RETURN ;
        END IF ;

    END LOOP ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Model not inserted - ' || sqlerrm ;

END ;
$$ ;
