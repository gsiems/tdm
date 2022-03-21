CREATE TABLE tdm.dt_user (
    id serial NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    username character varying ( 32 ) NOT NULL,
    full_name character varying ( 128 ) NOT NULL,
    email_address character varying ( 320 ),
    created_by integer,
    created_dt timestamp with time zone DEFAULT ( now () AT TIME ZONE 'UTC' ),
    updated_by integer,
    updated_dt timestamp with time zone,
    CONSTRAINT dt_user_pk PRIMARY KEY ( id ),
    CONSTRAINT dt_user_nk UNIQUE ( username ) ) ;

ALTER TABLE tdm.dt_user
    ADD CONSTRAINT dt_user_fk01
    FOREIGN KEY ( created_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

ALTER TABLE tdm.dt_user
    ADD CONSTRAINT dt_user_fk02
    FOREIGN KEY ( updated_by )
    REFERENCES tdm.dt_user ( id ) ON UPDATE CASCADE ;

COMMENT ON TABLE tdm.dt_user IS 'Users of the tdm application.' ;
COMMENT ON COLUMN tdm.dt_user.id IS 'The system generated ID for the user.' ;
COMMENT ON COLUMN tdm.dt_user.is_enabled IS 'Indicates if the user account is enabled.' ;
COMMENT ON COLUMN tdm.dt_user.is_admin IS 'Indicates if the user can administer the tdm application.' ;
COMMENT ON COLUMN tdm.dt_user.username IS 'The username for the user.' ;
COMMENT ON COLUMN tdm.dt_user.full_name IS 'The full name for the user.' ;
COMMENT ON COLUMN tdm.dt_user.email_address IS 'The email address for the user.' ;
COMMENT ON COLUMN tdm.dt_user.created_by IS 'The ID of the individual that created the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_user.created_dt IS 'The timestamp when the row was created.' ;
COMMENT ON COLUMN tdm.dt_user.updated_by IS 'The ID of the individual that most recently updated the row (ref dt_user).' ;
COMMENT ON COLUMN tdm.dt_user.updated_dt IS 'The timestamp when the row was most recently updated.' ;

REVOKE ALL ON TABLE tdm.dt_user FROM public ;
