CREATE OR REPLACE procedure tdm.attribute_upsert (
    a_attribute_id inout int default null,
    a_entity_id in int default null,
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
Procedure attribute_upsert upserts an entity attribute

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_attribute_id        | inout  | int      | The ID of the attribute to upsert     |
| a_entity_id           | in     | int      | The ID of the entity that the attribute belongs to |
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
| a_updated_by          | in     | int      | The ID of the person upserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

BEGIN

    IF a_attribute_id IS NULL THEN
        call tdm.attribute_insert (
            a_attribute_id => a_attribute_id,
            a_entity_id => a_entity_id,
            a_domain_id => a_domain_id,
            a_range_type_id => a_range_type_id,
            a_ordinal_order => a_ordinal_order,
            a_is_required => a_is_required,
            a_multiples_allowed => a_multiples_allowed,
            a_is_natural_key => a_is_natural_key,
            a_name => a_name,
            a_column_name => a_column_name,
            a_abbreviation => a_abbreviation,
            a_description => a_description,
            a_default_value => a_default_value,
            a_range_values => a_range_values,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    ELSE
        call tdm.attribute_update (
            a_attribute_id => a_attribute_id,
            a_entity_id => a_entity_id,
            a_domain_id => a_domain_id,
            a_range_type_id => a_range_type_id,
            a_ordinal_order => a_ordinal_order,
            a_is_required => a_is_required,
            a_multiples_allowed => a_multiples_allowed,
            a_is_natural_key => a_is_natural_key,
            a_name => a_name,
            a_column_name => a_column_name,
            a_abbreviation => a_abbreviation,
            a_description => a_description,
            a_default_value => a_default_value,
            a_range_values => a_range_values,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    END IF ;

    RETURN ;
END ;
$$ ;
