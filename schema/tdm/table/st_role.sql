CREATE TABLE tdm.st_role (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 200 ),
    CONSTRAINT st_role_pk PRIMARY KEY ( id ),
    CONSTRAINT st_role_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_role IS 'User roles.' ;
COMMENT ON COLUMN tdm.st_role.id IS 'The ID of the role.' ;
COMMENT ON COLUMN tdm.st_role.name IS 'The name of the role.' ;
COMMENT ON COLUMN tdm.st_role.description IS 'The description of the role.' ;

REVOKE ALL ON TABLE tdm.st_role FROM public ;

insert into tdm.st_role ( id, name, description )
values
( 1, 'read', 'The user can view the model.' ),
( 2, 'update', 'The user can view and update the model.' ),
( 3, 'manage', 'The user can manage the model.' ) ;
