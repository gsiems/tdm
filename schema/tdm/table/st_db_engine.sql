CREATE TABLE tdm.st_db_engine (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_db_engine_pk PRIMARY KEY ( id ),
    CONSTRAINT st_db_engine_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_db_engine IS 'Database engines to generate DB schemas for. NB that this should support the notion of allowing for different versions of the same base engine (i.e. Postgres 9.6 vs Postgres 14).' ;
COMMENT ON COLUMN tdm.st_db_engine.id IS 'Id for a DB engine.' ;
COMMENT ON COLUMN tdm.st_db_engine.name IS 'The "name" of the DB engine.' ;
COMMENT ON COLUMN tdm.st_db_engine.description IS 'The description of the DB engine.' ;

REVOKE ALL ON TABLE tdm.st_db_engine FROM public ;

insert into tdm.st_db_engine ( id, name, description )
values
( 0, 'TBD', 'To be determined' ),
( 1, 'pg', 'Postgresql' ),
( 2, 'ora', 'Oracle' ),
( 3, 'sqlite', 'SQLite' ) ;
