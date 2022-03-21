CREATE TABLE tdm.st_entity_type (
    id int NOT NULL,
    table_prefix character varying ( 4 ) NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_entity_type_pk PRIMARY KEY ( id ),
    CONSTRAINT st_entity_type_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_entity_type IS 'Supported indicators of the (primary) type of data associated with an entity.' ;
COMMENT ON COLUMN tdm.st_entity_type.id IS 'The ID for an entity type.' ;
COMMENT ON COLUMN tdm.st_entity_type.table_prefix IS 'The prefix to use when creating tables.' ;
COMMENT ON COLUMN tdm.st_entity_type.name IS 'The name of the entity type.' ;
COMMENT ON COLUMN tdm.st_entity_type.description IS 'The description of the entity type.' ;

REVOKE ALL ON TABLE tdm.st_entity_type FROM public ;

insert into tdm.st_entity_type ( id, table_prefix, name, description )
values
( 1, 'dt', 'Business data', 'The entity (and resulting table) contains business data.' ),
( 2, 'rt', 'Reference data', 'The entity (and resulting table) contains reference data that is maintained by the business.' ),
( 3, 'st', 'System data', 'The entity (and resulting table) contains system (reference, configuration, etc.) data that is not maintained by the business.' ),
( 4, 'ht', 'Historical data', 'The entity (and resulting table) contains historical data.' ),
( 5, 'qt', 'Queue data', 'The entity (and resulting table) contains queue data (work queues, etc.).' ) ;
