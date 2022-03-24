CREATE OR REPLACE PROCEDURE tdm.attribute_munge (
    a_attribute_id inout int default null,
    a_entity_id in int default null,
    a_domain_id inout int default null,
    a_range_type_id in int default null,
    a_datatype_id in int default null,
    a_size in int default null,
    a_scale in int default null,
    a_default_value in character varying default null,
    a_range_values in character varying default null,
    a_name inout character varying default null,
    a_column_name inout character varying default null,
    a_abbreviation inout character varying default null,
    a_description in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure attribute_munge TBD

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_attribute_id        | inout  | int      | The ID of the attribute to update     |
| a_entity_id           | in     | int      | The ID of the entity that the attribute belongs to |
| a_domain_id           | inout  | int      | The ID of the domain that the attribute is an expression of |
| a_range_type_id       | in     | int      | The ID of the range of valid values for the attributes domain |
| a_datatype_id         | in     | int      | The ID of the datatype for the attributes domain |
| a_size                | in     | int      | The size for the datatype (length for text) for the attributes domain |
| a_scale               | in     | int      | The scale for the datatype for the attributes domain |
| a_default_value       | in     | varchar  | The default value, if any, for the attributes domain |
| a_range_values        | in     | varchar  | The delimited list of allowed values (small fixed set domains only) where the first byte in the string is the delimiter |
| a_name                | inout  | varchar  | The name of the attribute             |
| a_column_name         | inout  | varchar  | The column name to use in the database |
| a_abbreviation        | inout  | varchar  | The abbreviation to use when shortening the column name |
| a_description         | in     | varchar  | An optional description of the attribute/it's purpose |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_column_name character varying ;
    l_abbreviation character varying ;
    l_entity_name character varying ;

    l_model_id int ;
    l_range_type_id int ;
    l_namespace_id int ;
    l_datatype_id int ;
    l_domain_entity_id int;

BEGIN

    l_name := trim ( coalesce ( a_name, '' ) ) ;
    l_column_name := trim ( coalesce ( a_column_name, '' ) ) ;
    l_abbreviation := trim ( coalesce ( a_abbreviation, '' ) ) ;

    /*
    Ensure that there is a name and a column name. If either are missing
    then derive the missing from the provided
    */
    IF l_name = '' THEN
        l_name := initcap ( trim ( replace ( l_column_name, '_', ' ' ) ) ) ;
    END IF ;

    IF a_column_name = '' THEN
        IF l_abbreviation <> '' THEN
            l_column_name := lower ( replace ( l_abbreviation, ' ', '_' ) ) ;
        ELSE
            l_column_name := lower ( replace ( l_name, ' ', '_' ) ) ;
        END IF ;
    END IF ;

    a_name := l_name ;
    a_column_name := l_column_name ;
    a_abbreviation := l_abbreviation ;

    --------------------------------------------------------------------
    /*
    ASSERT that either the:
        - domain ID is not null, OR
        - the range type is 3, OR
        - the datatype, size, scale are specified, OR
        - the domain is TBD
    */
    FOR dt IN (
        SELECT model_id,
                namespace_id,
                name
            FROM tdm.dt_entity
            WHERE id = a_entity_id
        ) LOOP

        l_model_id := dt.model_id ;
        l_namespace_id := dt.namespace_id ;
        l_entity_name := dt.name ;

    END LOOP ;

    IF l_model_id IS NULL THEN
        -- we shouldn't ever get to here... so it's an error if we do
        a_err := 'Model lookup error in attribute_munge' ;
        RETURN ;
    END IF ;

    ----
    IF a_domain_id IS NOT NULL THEN
        -- lookup the domain
        FOR dt IN (
            SELECT range_type_id,
                    entity_id,
                    datatype_id
                FROM tdm.dt_domain
                WHERE id = a_domain_id
                    AND model_id = l_model_id
            ) LOOP

            l_range_type_id := dt.range_type_id ;
            l_domain_entity_id := dt.entity_id ;
            l_datatype_id := dt.datatype_id ;

        END LOOP ;

    END IF ;

    IF l_range_type_id IS NULL THEN
        l_range_type_id := coalesce ( a_range_type_id, 0::int ) ;
    END IF ;

    IF l_range_type_id = 3::int AND l_domain_entity_id IS NULL THEN

        -- search for the entity-based domain
        FOR dt IN (
            SELECT id,
                    entity_id,
                    datatype_id
                FROM tdm.dt_domain
                WHERE name = l_name -- assert that the domain name of an entity-based domain matches the entity name
                    AND model_id = l_model_id
                    AND entity_id = l_range_type_id ) LOOP

            a_domain_id := coalesce ( a_domain_id, dt.id ) ;
            l_domain_entity_id := dt.entity_id ;
            l_datatype_id := dt.datatype_id ;

        END LOOP ;

    END IF ;

    IF a_domain_id IS NULL THEN
        IF l_range_type_id = 3::int THEN
            -- create an entity
            call tdm.entity_insert (
                a_entity_id => l_domain_entity_id,
                a_model_id => l_model_id,
                a_namespace_id => l_namespace_id,
                a_supertype_entity_id => NULL::int,
                a_entity_type_id => 2::int, -- default to reference data
                a_history_type_id => 1::int,
                a_name => a_name,
                a_table_name => a_column_name,
                a_abbreviation => a_abbreviation,
                a_description => ( 'Entity for the ' || l_entity_name || '(' || a_name || ') attribute' )::varchar,
                a_updated_by => a_updated_by,
                a_err => a_err ) ;

            IF a_err IS NOT NULL THEN
                RETURN ;
            END IF ;

            FOR dt IN (
                SELECT id
                    FROM tdm.dt_domain
                    WHERE model_id = l_model_id
                        AND entity_id = l_domain_entity_id
                ) LOOP

                a_domain_id := dt.id ;
                RETURN ;

            END LOOP ;

            -- we shouldn't ever get to here... so it's an error if we do
            a_err := 'Domain lookup error in attribute_munge' ;
            RETURN ;

        ELSE
            -- create a domain
            l_datatype_id := coalesce ( l_datatype_id, a_datatype_id, 0::int ) ;


            FOR dt IN (
                SELECT id
                    FROM tdm.dt_domain
                    WHERE model_id = l_model_id
                        AND datatype_id = l_datatype_id
                        AND name = a_name
                ) LOOP

                a_domain_id := dt.id ;
                RETURN ;

            END LOOP ;

            call tdm.domain_insert (
                a_domain_id => a_domain_id,
                a_model_id => l_model_id,
                a_datatype_id => l_datatype_id,
                a_domain_entity_id => NULL::int,
                a_range_type_id => l_range_type_id,
                a_size => a_size,
                a_scale => a_scale,
                a_name => a_name,
                a_abbreviation => a_abbreviation,
                a_description => a_description,
                a_default_value => a_default_value,
                a_range_values => a_range_values,
                a_updated_by => a_updated_by,
                a_err => a_err ) ;

            IF a_err IS NOT NULL THEN
                RETURN ;
            END IF ;

        END IF ;

    END IF ;

    RETURN ;
END ;
$$ ;
