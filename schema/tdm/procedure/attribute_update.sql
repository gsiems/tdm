CREATE OR REPLACE PROCEDURE tdm.attribute_update (
    a_attribute_id in int default null,
    a_domain_id in int default null,
    a_range_type_id in int default null,
    a_datatype_id in int default null,
    a_size in int default null,
    a_scale in int default null,
    a_ordinal_order in int default null,
    a_is_required in boolean default null,
    a_multiples_allowed in boolean default null,
    a_is_natural_key in boolean default null,
    a_name in character varying default null,
    a_column_name in character varying default null,
    a_abbreviation in character varying default null,
    a_description in character varying default null,
    a_default_value in character varying default null,
    a_range_values in character varying default null,
    a_updated_by in int default null,
    a_err inout character varying default null )
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
/**
Procedure attribute_update updates an entity attribute

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_attribute_id        | in     | int      | The ID of the attribute to update     |
| a_domain_id           | in     | int      | The ID of the domain that the attribute is an expression of |
| a_range_type_id       | in     | int      | The ID of the range of valid values for the attributes domain |
| a_datatype_id         | in     | int      | The ID of the datatype for the attributes domain |
| a_size                | in     | int      | The size for the datatype (length for text) for the attributes domain |
| a_scale               | in     | int      | The scale for the datatype for the attributes domain |
| a_ordinal_order       | in     | int      | The (optional) order for the database column |
| a_is_required         | in     | boolean  | Indicates if a value for the attribute is required |
| a_multiples_allowed   | in     | boolean  | Indicates if multiple values for the attribute are allowed |
| a_is_natural_key      | in     | boolean  | Indicates if the attribute is part of the natural key for the entity |
| a_name                | in     | varchar  | The name of the attribute             |
| a_column_name         | in     | varchar  | The column name to use in the database |
| a_abbreviation        | in     | varchar  | The abbreviation to use when shortening the column name |
| a_description         | in     | varchar  | An optional description of the attribute/it's purpose |
| a_default_value       | in     | varchar  | The default value, if any, for the attribute |
| a_range_values        | in     | varchar  | The delimited list of allowed values (small fixed set domains only) where the first byte in the string is the delimiter |
| a_updated_by          | in     | int      | The ID of the person updating the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

    dt record ;
    l_name character varying ;
    l_column_name character varying ;
    l_abbreviation character varying ;
    l_domain_id int ;
    l_range_type_id int ;
    l_entity_id int ;

BEGIN

    l_name := a_name ;
    l_column_name := a_column_name ;
    l_abbreviation := a_abbreviation ;
    l_domain_id := a_domain_id ;
    l_range_type_id := a_range_type_id ;

    FOR dt IN (
        SELECT entity_id
            FROM tdm.dt_attribute
            WHERE id = a_attribute_id
        ) LOOP

        l_entity_id := dt.entity_id ;

    END LOOP ;

    IF l_entity_id IS NULL THEN
        -- we shouldn't ever get to here... so it's an error if we do
        a_err := 'Entity lookup error in attribute_update' ;
        RETURN ;
    END IF ;

    call tdm.attribute_munge (
        a_attribute_id => a_attribute_id,
        a_entity_id => l_entity_id,
        a_domain_id => l_domain_id,
        a_range_type_id => l_range_type_id,
        a_datatype_id => a_datatype_id,
        a_size => a_size,
        a_scale => a_scale,
        a_default_value => a_default_value,
        a_range_values => a_range_values,
        a_name => l_name,
        a_column_name => l_column_name,
        a_abbreviation => l_abbreviation,
        a_description => a_description,
        a_err => a_err ) ;

    IF a_err IS NOT NULL THEN
        RETURN ;
    END IF ;

    FOR dt IN (
        SELECT id
            FROM tdm.dt_attribute
            WHERE name = a_name
                AND entity_id = l_entity_id
                AND id <> a_attribute_id
        ) LOOP

        a_err := 'Attribute not updated - another attribute for the entity exists with the same name.' ;
        RETURN ;

    END LOOP ;

    /*
    TODO: There should probably be a way of indicating whether or not an
        attribute should show in the conceptual model view.
    */

    UPDATE tdm.dt_attribute
        SET domain_id = l_domain_id,
            ordinal_order = a_ordinal_order,
            is_required = a_is_required,
            multiples_allowed = a_multiples_allowed,
            is_natural_key = a_is_natural_key,
            name = l_name,
            column_name = l_column_name,
            abbreviation = l_abbreviation,
            description = a_description,
            default_value = a_default_value,
            updated_by = a_updated_by,
            updated_dt = now () AT TIME ZONE 'UTC'
        WHERE attribute_id = a_attribute_id
            AND ( domain_id IS DISTINCT FROM l_domain_id
                OR ordinal_order IS DISTINCT FROM a_ordinal_order
                OR is_required IS DISTINCT FROM a_is_required
                OR multiples_allowed IS DISTINCT FROM a_multiples_allowed
                OR is_natural_key IS DISTINCT FROM a_is_natural_key
                OR name IS DISTINCT FROM l_name
                OR column_name IS DISTINCT FROM l_column_name
                OR abbreviation IS DISTINCT FROM l_abbreviation
                OR description IS DISTINCT FROM a_description
                OR default_value IS DISTINCT FROM a_default_value ) ;

    RETURN ;

EXCEPTION
    WHEN others THEN
        a_err := 'Attribute not updated - ' || sqlerrm ;

END ;
$$ ;
