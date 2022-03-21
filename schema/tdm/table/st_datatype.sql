CREATE TABLE tdm.st_datatype (
    id int NOT NULL,
    has_size boolean NOT NULL default false,
    has_scale boolean NOT NULL default false,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_datatype_pk PRIMARY KEY ( id ),
    CONSTRAINT st_datatype_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_datatype IS 'Supported datatypes.' ;
COMMENT ON COLUMN tdm.st_datatype.id IS 'The ID for a datatype.' ;
COMMENT ON COLUMN tdm.st_datatype.has_size IS 'Indicates if the datatype has a user definable size.' ;
COMMENT ON COLUMN tdm.st_datatype.has_scale IS 'Indicates if the datatype has a user definable scale.' ;
COMMENT ON COLUMN tdm.st_datatype.name IS 'The name of the datatype.' ;
COMMENT ON COLUMN tdm.st_datatype.description IS 'The description of the datatype.' ;

REVOKE ALL ON TABLE tdm.st_datatype FROM public ;

insert into tdm.st_datatype ( id, has_scale, has_size, name, description )
values
( 0, FALSE, FALSE, 'TBD', 'Any datatype that has yet to be determined' ),
( 1, FALSE, FALSE, 'blob', '' ),
( 2, FALSE, FALSE, 'boolean', '' ),
( 3, TRUE, FALSE, 'varchar', '' ),
( 4, TRUE, TRUE, 'number', '' ),
( 5, FALSE, FALSE, 'double', '' ),
( 6, TRUE, FALSE, 'float', '' ),
( 7, FALSE, FALSE, 'real', '' ),
( 8, FALSE, FALSE, 'bigint', '' ),
( 9, FALSE, FALSE, 'int', '' ),
( 10, FALSE, FALSE, 'smallint', '' ),
( 11, FALSE, FALSE, 'json', '' ),
( 12, FALSE, FALSE, 'xml', '' ),
( 13, FALSE, FALSE, 'date', '' ),
( 14, FALSE, FALSE, 'date and time', '' ),
( 15, FALSE, FALSE, 'interval', '' ),
( 16, FALSE, FALSE, 'time', '' ),
( 17, FALSE, FALSE, 'time with time zone', '' ),
( 18, FALSE, FALSE, 'timestamp', '' ),
( 19, FALSE, FALSE, 'timestamp with time zone', '' ) ;
