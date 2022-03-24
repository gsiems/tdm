CREATE OR REPLACE procedure tdm.domain_upsert (
    a_domain_id inout int default null,
    a_model_id in int default null,
    a_datatype_id in int default null,
    a_entity_id in int default null,
    a_range_type_id in int default null,
    a_size in int default null,
    a_scale in int default null,
    a_name in character varying default null,
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
Procedure domain_upsert upserts a domain

| Parameter             | In/Out | Datatype | Remarks                               |
| --------------------- | ------ | -------- | ------------------------------------- |
| a_domain_id           | inout  | int      | The ID of the domain to update        |
| a_model_id            | in     | int      | The ID of the model that the domain belongs to |
| a_datatype_id         | in     | int      | The ID of the datatype for the domain |
| a_entity_id           | in     | int      | The ID of the entity that the domain embodies (entity-based domains only) |
| a_range_type_id       | in     | int      | The ID of the range of valid values for the domain |
| a_size                | in     | int      | The size for the datatype (length for text) |
| a_scale               | in     | int      | The scale for the datatype            |
| a_name                | in     | varchar  | The name of the domain                |
| a_abbreviation        | in     | varchar  | The defauult abbreviation to use when shortening the column name |
| a_description         | in     | varchar  | An optional description of the domain/it's purpose |
| a_default_value       | in     | varchar  | The default value, if any, for the domain |
| a_range_values        | in     | varchar  | The delimited list of allowed values (small fixed set domains only) where the first byte in the string is the delimiter |
| a_updated_by          | in     | int      | The ID of the person upserting the record |
| a_err                 | inout  | varchar  | Any errors that might be generated    |

*/
DECLARE

BEGIN

    IF a_domain_id IS NULL THEN
        call tdm.domain_insert (
            a_domain_id => a_domain_id,
            a_model_id => a_model_id,
            a_datatype_id => a_datatype_id,
            a_entity_id => a_entity_id,
            a_range_type_id => a_range_type_id,
            a_size => a_size,
            a_scale => a_scale,
            a_name => a_name,
            a_abbreviation => a_abbreviation,
            a_description => a_description,
            a_default_value => a_default_value,
            a_range_values => a_range_values,
            a_updated_by => a_updated_by,
            a_err => a_err ) ;

    ELSE
        call tdm.domain_update (
            a_domain_id => a_domain_id,
            a_datatype_id => a_datatype_id,
            a_size => a_size,
            a_scale => a_scale,
            a_name => a_name,
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
