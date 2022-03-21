CREATE TABLE tdm.dt_domain (
    id serial NOT NULL,
    model_id int NOT NULL,
    --namespace_id int NOT NULL,
    datatype_id int NOT NULL,
    entity_id int,
    range_type_id int NOT NULL,
    size int,
    scale int,
    name character varying ( 60 ) NOT NULL,
    abbreviation character varying ( 20 ),
    description character varying ( 1000 ),
    default_value character varying,
    range_values character varying,
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_domain_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_domain_nk UNIQUE ( model_id, name ) ) ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk01
    FOREIGN KEY ( model_id )
    REFERENCES tdm.dt_model ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk02
    FOREIGN KEY ( datatype_id )
    REFERENCES tdm.st_datatype ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk03
    FOREIGN KEY ( entity_id )
    REFERENCES tdm.dt_entity ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk04
    FOREIGN KEY ( range_type_id )
    REFERENCES tdm.st_range_type ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk05
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_domain
    ADD CONSTRAINT dt_domain_fk06
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

CREATE INDEX dt_domain_idx01 ON tdm.dt_domain (
    model_id ) ;

CREATE INDEX dt_domain_idx02 ON tdm.dt_domain (
    datatype_id ) ;

CREATE INDEX dt_domain_idx03 ON tdm.dt_domain (
    entity_id ) ;

CREATE INDEX dt_domain_idx04 ON tdm.dt_domain (
    range_type_id ) ;

COMMENT ON TABLE tdm.dt_domain IS 'Data domains for entity attributes.' ;
COMMENT ON COLUMN tdm.dt_domain.id IS 'The system generated ID for the domain' ;
COMMENT ON COLUMN tdm.dt_domain.model_id IS 'The ID of the model that the domain belongs to.' ;
COMMENT ON COLUMN tdm.dt_domain.datatype_id IS 'The base datatype of the domain.' ;
COMMENT ON COLUMN tdm.dt_domain.entity_id IS 'The entity that the domain is a pointer to.' ;
COMMENT ON COLUMN tdm.dt_domain.range_type_id IS 'The default range for the domain. Indicates if the domain is constrained in the values it may contain. TBD is this really needed or does this belong to the attribute?' ;
COMMENT ON COLUMN tdm.dt_domain.size IS 'The size of the domain datatype.' ;
COMMENT ON COLUMN tdm.dt_domain.scale IS 'The scale for the domain datatype.' ;
COMMENT ON COLUMN tdm.dt_domain.name IS 'The name of the domain.' ;
COMMENT ON COLUMN tdm.dt_domain.abbreviation IS 'The abbreviation for the domain. May be used in creating DB names for columns.' ;
COMMENT ON COLUMN tdm.dt_domain.description IS 'The description of the domain,' ;
COMMENT ON COLUMN tdm.dt_domain.default_value IS 'The default value of the domain, for those domains that have a default.' ;
COMMENT ON COLUMN tdm.dt_domain.range_values IS 'The delimieted list of valid values for the "domains with a small fixed set of values".' ;
COMMENT ON COLUMN tdm.dt_domain.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_domain.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_domain.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_domain.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_domain FROM public ;
