CREATE TABLE tdm.dt_entity (
    id serial NOT NULL,
    model_id int NOT NULL,
    namespace_id int NOT NULL,
    supertype_entity_id int,
    entity_type_id int NOT NULL default 0,
    history_type_id int NOT NULL default 0,
    update_strategy_id int NOT NULL default 0,
    name character varying ( 60 ) NOT NULL,
    table_name character varying ( 60 ),
    abbreviation character varying ( 20 ),
    description character varying ( 1000 ),
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_entity_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_entity_nk UNIQUE ( model_id, name ) ) ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk01
    FOREIGN KEY ( model_id )
    REFERENCES tdm.dt_model ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk02
    FOREIGN KEY ( namespace_id )
    REFERENCES tdm.dt_namespace ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk03
    FOREIGN KEY ( supertype_entity_id )
    REFERENCES tdm.dt_entity ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk04
    FOREIGN KEY ( entity_type_id )
    REFERENCES tdm.st_entity_type ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk05
    FOREIGN KEY ( history_type_id )
    REFERENCES tdm.st_history_type ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk06
    FOREIGN KEY ( update_strategy_id )
    REFERENCES tdm.st_update_strategy ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk07
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_entity
    ADD CONSTRAINT dt_entity_fk08
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;


CREATE INDEX dt_entity_idx01 ON tdm.dt_entity (
    model_id ) ;

CREATE INDEX dt_entity_idx02 ON tdm.dt_entity (
    namespace_id ) ;

CREATE INDEX dt_entity_idx03 ON tdm.dt_entity (
    supertype_entity_id ) ;

CREATE INDEX dt_entity_idx04 ON tdm.dt_entity (
    entity_type_id ) ;

CREATE INDEX dt_entity_idx05 ON tdm.dt_entity (
    history_type_id ) ;

CREATE INDEX dt_entity_idx06 ON tdm.dt_entity (
    update_strategy_id ) ;

COMMENT ON TABLE tdm.dt_entity IS 'The business objects/entities that are being modeled. These probably result in the creation of one or more DB tables.' ;
COMMENT ON COLUMN tdm.dt_entity.id IS 'The system generated ID for the entity.' ;
COMMENT ON COLUMN tdm.dt_entity.model_id IS 'The ID of the model that the entity belongs to.' ;
COMMENT ON COLUMN tdm.dt_entity.namespace_id IS 'The ID of the name-space that the entity belongs to.' ;
COMMENT ON COLUMN tdm.dt_entity.supertype_entity_id IS 'The entity that is a supertype to the entity. Indicates if the entity is a subclass of another entity.' ;
COMMENT ON COLUMN tdm.dt_entity.entity_type_id IS 'The ID of the type/nature of the entity.' ;
COMMENT ON COLUMN tdm.dt_entity.history_type_id IS 'The ID of the type of history to keep for the entity data.' ;
COMMENT ON COLUMN tdm.dt_model.update_strategy_id IS 'The update conflict control strategy to use for the entity (if different from the default).' ;
COMMENT ON COLUMN tdm.dt_entity.name IS 'The name of the entity.' ;
COMMENT ON COLUMN tdm.dt_entity.table_name IS 'The logical table name for the entity.' ;
COMMENT ON COLUMN tdm.dt_entity.abbreviation IS 'The abbreviation for the name of the entity. ' ;
COMMENT ON COLUMN tdm.dt_entity.description IS 'The description of the entity. This may be used for creating DB table comments.' ;
COMMENT ON COLUMN tdm.dt_entity.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_entity.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_entity.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_entity.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_entity FROM public ;

/*
If the entity has an abbreviation (default to name if not specified) then the namespace/abbreviation combo needs to be unique... or do we push that off to the next level of model?


*/
/*
insert into tdm.dt_entity ( id, model_id, namespace_id, supertype_entity_id, entity_type_id, history_type_id, name, abbreviation, description )
values
( 1, 1, 1, null, 1, 1, 'model', '', 'Entry point/definition for models.' ),
( 2, 1, 1, null, 1, 1, 'namespace', '', 'The name-space that modeled entities belong to. These probably result in the creation of DB schemas.' ),
( 3, 1, 1, null, 1, 1, 'entity', '', 'The business objects/entities that are being modeled. These probably result in the creation of DB tables.' ),
( 4, 1, 1, null, 1, 1, 'domain', '', 'Data domains for entity attributes.' ),
( 5, 1, 1, null, 1, 1, 'entity attribute', 'ea', 'Attributes for entities. Attributes may result in the creation of DB table columns.' ) ;

SELECT pg_catalog.setval('tdm.dt_entity_id_seq', ( select max ( id ) from tdm.dt_entity ), true);
*/
