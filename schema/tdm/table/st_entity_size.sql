CREATE TABLE tdm.st_entity_size (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_entity_size_pk PRIMARY KEY ( id ),
    CONSTRAINT st_entity_size_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_entity_size IS 'Maximum size (row count) buckets for entities.' ;
COMMENT ON COLUMN tdm.st_entity_size.id IS 'The ID for an entity max size.' ;
COMMENT ON COLUMN tdm.st_entity_size.name IS 'The name of the entity max size.' ;
COMMENT ON COLUMN tdm.st_entity_size.description IS 'The description of the entity max size.' ;

REVOKE ALL ON TABLE tdm.st_entity_size FROM public ;

insert into tdm.st_entity_size ( id, name, description )
values
( 0, 'TBD', 'To be determined' ),
( 1, '30k', 'The entity will never have more than 30,000 rows of data.' ),
( 2, '2E+9', 'The entity will never have more than 2,000,000,000 rows of data.' ),
( 3, '9E+18', 'The entity will never have more than 9 E+19 rows of data.' ) ;
