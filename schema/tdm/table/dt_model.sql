CREATE TABLE tdm.dt_model (
    id serial NOT NULL,
    db_engine_id int NOT NULL default 0,
    update_strategy_id int NOT NULL default 0,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_model_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_model_nk UNIQUE ( name ) ) ;

ALTER TABLE tdm.dt_model
    ADD CONSTRAINT dt_model_fk01
    FOREIGN KEY ( db_engine_id )
    REFERENCES tdm.st_db_engine ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model
    ADD CONSTRAINT dt_model_fk02
    FOREIGN KEY ( update_strategy_id )
    REFERENCES tdm.st_update_strategy ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model
    ADD CONSTRAINT dt_model_fk03
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model
    ADD CONSTRAINT dt_model_fk04
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

CREATE INDEX dt_model_idx01 ON tdm.dt_model (
    db_engine_id ) ;

CREATE INDEX dt_model_idx02 ON tdm.dt_model (
    update_strategy_id ) ;

COMMENT ON TABLE tdm.dt_model IS 'Entry point/definition for models.' ;
COMMENT ON COLUMN tdm.dt_model.id IS 'The system generated ID for the model.' ;
COMMENT ON COLUMN tdm.dt_model.db_engine_id IS 'The database engine that will be used to host the model.' ;
COMMENT ON COLUMN tdm.dt_model.update_strategy_id IS 'The default update conflict control strategy to use for the model.' ;
COMMENT ON COLUMN tdm.dt_model.name IS 'The name for the model.' ;
COMMENT ON COLUMN tdm.dt_model.description IS 'The description of the model.' ;
COMMENT ON COLUMN tdm.dt_model.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_model.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_model.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_model.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_model FROM public ;

/*
insert into tdm.dt_model ( id, db_engine_id, name, description )
values ( 1, null, 'tdm test', 'The tdm database as a test case/example' ) ;

SELECT pg_catalog.setval ( 'tdm.dt_model_id_seq', (
    SELECT max ( id ) FROM tdm.dt_model ), true ) ;
*/
