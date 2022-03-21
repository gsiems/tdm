CREATE TABLE tdm.dt_model_user (
    model_id int NOT NULL,
    user_id int NOT NULL,
    role_id int NOT NULL,
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_model_user_pk PRIMARY KEY ( model_id, user_id ) ) ;

ALTER TABLE tdm.dt_model_user
    ADD CONSTRAINT dt_model_user_fk01
    FOREIGN KEY ( model_id )
    REFERENCES tdm.dt_model ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model_user
    ADD CONSTRAINT dt_model_user_fk02
    FOREIGN KEY ( user_id )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model_user
    ADD CONSTRAINT dt_model_user_fk03
    FOREIGN KEY ( role_id )
    REFERENCES tdm.st_role ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model_user
    ADD CONSTRAINT dt_model_user_fk04
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_model_user
    ADD CONSTRAINT dt_model_user_fk05
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

CREATE INDEX dt_model_user_idx01 ON tdm.dt_model_user (
    model_id ) ;

CREATE INDEX dt_model_user_idx02 ON tdm.dt_model_user (
    user_id ) ;

CREATE INDEX dt_model_user_idx03 ON tdm.dt_model_user (
    role_id ) ;

COMMENT ON TABLE tdm.dt_model_user IS 'Users that have access to models.' ;
COMMENT ON COLUMN tdm.dt_model_user.model_id IS 'The ID of the model that a user has access to.' ;
COMMENT ON COLUMN tdm.dt_model_user.user_id IS 'The ID of the user that has access to the model.' ;
COMMENT ON COLUMN tdm.dt_model_user.role_id IS 'The ID of the role that determine the level of user access.' ;
COMMENT ON COLUMN tdm.dt_model_user.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_model_user.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_model_user.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_model_user.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_model_user FROM public ;
