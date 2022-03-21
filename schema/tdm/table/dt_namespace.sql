CREATE TABLE tdm.dt_namespace (
    id serial NOT NULL,
    model_id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    schema_name character varying ( 60 ),
    is_default boolean NOT NULL,
    description character varying ( 1000 ),
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_namespace_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_namespace_nk UNIQUE ( model_id, name ) ) ;

ALTER TABLE tdm.dt_namespace
    ADD CONSTRAINT dt_namespace_fk01
    FOREIGN KEY ( model_id )
    REFERENCES tdm.dt_model ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_namespace
    ADD CONSTRAINT dt_namespace_fk02
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_namespace
    ADD CONSTRAINT dt_namespace_fk03
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

CREATE INDEX dt_namespace_idx01 ON tdm.dt_namespace (
    model_id ) ;

COMMENT ON TABLE tdm.dt_namespace IS 'The namespace that modeled entities may belong to.' ;
COMMENT ON column tdm.dt_namespace.id IS 'The system generated ID for the namespace.' ;
COMMENT ON column tdm.dt_namespace.model_id IS 'The ID of the model that the namespace is part of.' ;
COMMENT ON column tdm.dt_namespace.name IS 'The name of the namespace.' ;
COMMENT ON column tdm.dt_namespace.schema_name IS 'The logical schema name for the namespace.' ;
COMMENT ON column tdm.dt_namespace.is_default IS 'Indicates if the namespace is the default namespace for the model.' ;
COMMENT ON column tdm.dt_namespace.description IS 'The description of the name-space. This may be used for creating DB schema comments.' ;
COMMENT ON COLUMN tdm.dt_namespace.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_namespace.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_namespace.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_namespace.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_namespace FROM public ;

/*
insert into tdm.dt_namespace ( id, model_id, name, description )
values ( 1, 1, 'tdm', 'The business object model to physical data model test case/example schema' ) ;

SELECT pg_catalog.setval('tdm.dt_namespace_id_seq', ( SELECT MAX ( id ) FROM tdm.dt_namespace ), true);
*/
