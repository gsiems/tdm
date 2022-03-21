CREATE TABLE tdm.st_range_type (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 200 ),
    CONSTRAINT st_range_type_pk PRIMARY KEY ( id ),
    CONSTRAINT st_range_type_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_range_type IS 'Indicators of the range of valid values for a domain/attribute.' ;
COMMENT ON COLUMN tdm.st_range_type.id IS 'The ID of the range type.' ;
COMMENT ON COLUMN tdm.st_range_type.name IS 'The name of the range type.' ;
COMMENT ON COLUMN tdm.st_range_type.description IS 'The description of the range.' ;

REVOKE ALL ON TABLE tdm.st_range_type FROM public ;

insert into tdm.st_range_type ( id, name, description )
values
( 0, 'TBD', 'The range of allowed values has yet to be determined.' ),
( 1, 'open', 'The allowed values can be anything that the base datatype/domain supports.' ),
( 2, 'small fixed set', 'The list of allowed values is both fixed and small. This results in a check constraint for the fixed set of allowed values.' ),
( 3, 'adjustable set', 'The list of allowed values is either fixed and large or is constrained to an adjustable list. This results in a foreign-key constraint to a (probably reference) table of allowed values.' ) ;
