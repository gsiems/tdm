CREATE TABLE tdm.dt_attribute (
    id serial NOT NULL,
    entity_id int NOT NULL,
    domain_id int,
    range_type_id int NOT NULL default 0,
    ordinal_order int NOT NULL default 0,
    is_required boolean NOT NULL default false,
    multiples_allowed boolean NOT NULL default false,
    is_natural_key boolean NOT NULL default false,
    name character varying ( 60 ) NOT NULL,
    column_name character varying ( 60 ),
    abbreviation character varying ( 20 ),
    description character varying ( 1000 ),
    default_value character varying,
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_attribute_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_attribute_nk UNIQUE ( entity_id, name ) ) ;

ALTER TABLE tdm.dt_attribute
    ADD CONSTRAINT dt_attribute_fk01
    FOREIGN KEY ( entity_id )
    REFERENCES tdm.dt_entity ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_attribute
    ADD CONSTRAINT dt_attribute_fk02
    FOREIGN KEY ( domain_id )
    REFERENCES tdm.dt_domain ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_attribute
    ADD CONSTRAINT dt_attribute_fk03
    FOREIGN KEY ( range_type_id )
    REFERENCES tdm.st_range_type ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_attribute
    ADD CONSTRAINT dt_attribute_fk04
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_attribute
    ADD CONSTRAINT dt_attribute_fk05
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

CREATE INDEX dt_attribute_idx01 ON tdm.dt_attribute (
    entity_id ) ;

CREATE INDEX dt_attribute_idx02 ON tdm.dt_attribute (
    domain_id ) ;

COMMENT ON TABLE tdm.dt_attribute IS 'Attributes for entities. Attributes may result in the creation of DB table columns.' ;
COMMENT ON COLUMN tdm.dt_attribute.id IS 'The system generated ID for the entity attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.entity_id IS 'The ID of the entity that the attribute belongs to.' ;
COMMENT ON COLUMN tdm.dt_attribute.domain_id IS 'The ID of the domain/data type for the attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.range_type_id IS 'The ID of the range for the attribute. Indicates if the attribute is constrained in the values it may contain.' ;
COMMENT ON COLUMN tdm.dt_attribute.ordinal_order IS 'Indicates the order that the attribute should be displayed in the resulting view. May also be used for determining the ordianl order in the resulting table.' ;
COMMENT ON COLUMN tdm.dt_attribute.is_required IS 'Indicates if the attribute is required or is optional.' ;
COMMENT ON COLUMN tdm.dt_attribute.multiples_allowed IS 'Indicates if there can be multiple values for the attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.is_natural_key IS 'Indicates if the attribute is part of the natural key for the entity. Used for creating unique constraints and/or indexes.' ;
COMMENT ON COLUMN tdm.dt_attribute.name IS 'The name of the attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.column_name IS 'The logical column name for the attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.abbreviation IS 'The abbreviation for the name of the attribute.' ;
COMMENT ON COLUMN tdm.dt_attribute.description IS 'The description of the attribute. May be used for creating DB column comments.' ;
COMMENT ON COLUMN tdm.dt_attribute.default_value IS 'The default value of the attribute, for those attributes that have a default. May be used for creating DB column defaults.' ;
COMMENT ON COLUMN tdm.dt_attribute.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_attribute.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_attribute.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_attribute.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_attribute FROM public ;
