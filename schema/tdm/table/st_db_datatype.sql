CREATE TABLE tdm.st_db_datatype (
    id int NOT NULL,
    db_engine_id int NOT NULL,
    datatype_id int NOT NULL,
    entity_size_id int,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_db_datatype_pk PRIMARY KEY ( id ),
    CONSTRAINT st_db_datatype_nk UNIQUE ( db_engine_id, name )
    --CONSTRAINT st_db_datatype_nk02 UNIQUE ( db_engine_id, datatype_id )
    ) ;

ALTER TABLE tdm.st_db_datatype
    ADD CONSTRAINT st_db_datatype_fk01
    FOREIGN KEY ( db_engine_id )
    REFERENCES tdm.st_db_engine ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.st_db_datatype
    ADD CONSTRAINT st_db_datatype_fk02
    FOREIGN KEY ( datatype_id )
    REFERENCES tdm.st_datatype ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.st_db_datatype
    ADD CONSTRAINT st_db_datatype_fk03
    FOREIGN KEY ( entity_size_id )
    REFERENCES tdm.st_entity_size ( id ) ON UPDATE CASCADE ;

CREATE INDEX st_db_datatype_idx01 ON tdm.st_db_datatype (
    db_engine_id ) ;

CREATE INDEX st_db_datatype_idx02 ON tdm.st_db_datatype (
    datatype_id ) ;

CREATE INDEX st_db_datatype_idx03 ON tdm.st_db_datatype (
    entity_size_id ) ;

COMMENT ON TABLE tdm.st_db_datatype IS 'Datatypes as supported by specific database engines. This provides the mappping between the base datatypes and the corresponding datatype for the target database.' ;
COMMENT ON COLUMN tdm.st_db_datatype.id IS 'The ID for a database datatype.' ;
COMMENT ON COLUMN tdm.st_db_datatype.db_engine_id IS 'The ID for the databse engine.' ;
COMMENT ON COLUMN tdm.st_db_datatype.datatype_id IS 'The ID for the generic datatype.' ;
COMMENT ON COLUMN tdm.st_db_datatype.name IS 'The name/datatype of the datatype as used by the database.' ;
COMMENT ON COLUMN tdm.st_db_datatype.description IS 'The description of the datatype.' ;

REVOKE ALL ON TABLE tdm.st_db_datatype FROM public ;

/*
( 1, 'pg', 'Postgresql' ),
( 2, 'ora', 'Oracle' ),
( 3, 'sqlite', 'SQLite' ) ;


( 1, 1, 'bytea', '' ),
( 1, 2, 'boolean', '' ),
( 1, 3, 'character varying', '' ),
( 1, 4, 'number', '' ),
( 1, 5, 'double', '' ),
( 1, 6, 'float', '' ),
( 1, 7, 'real', '' ),
( 1, 8, 'bigint', '' ),
( 1, 9, 'integer', '' ),
( 1, 10, 'smallint', '' ),
( 1, 11, 'json', '' ),
( 1, 12, 'xml', '' ),
( 1, 13, 'date', '' ),
( 1, 14, 'date and time', '' ),
( 1, 15, 'interval', '' ),
( 1, 16, 'time', '' ),
( 1, 17, 'timestamp', '' ),
( 1, 18, 'timestamp with timezone', '' ) ;

( 0, 'TBD', 'To be determined' ),
( 1, '30k', 'The entity will never have more than 30,000 rows of data.' ),
( 2, '2E+9', 'The entity will never have more than 2,000,000,000 rows of data.' ),
( 3, '9E+18', 'The entity will never have more than 9 E+19 rows of data.' ) ;


*/
