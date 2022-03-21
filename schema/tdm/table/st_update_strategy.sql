CREATE TABLE tdm.st_update_strategy (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 200 ),
    CONSTRAINT st_update_strategy_pk PRIMARY KEY ( id ),
    CONSTRAINT st_update_strategy_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_update_strategy IS 'Types of update conflict control strategies.' ;
COMMENT ON COLUMN tdm.st_update_strategy.id IS 'The ID of the role.' ;
COMMENT ON COLUMN tdm.st_update_strategy.name IS 'The name of the role.' ;
COMMENT ON COLUMN tdm.st_update_strategy.description IS 'The description of the role.' ;

REVOKE ALL ON TABLE tdm.st_update_strategy FROM public ;

insert into tdm.st_update_strategy ( id, name, description )
values
( 0, 'TBD', 'To be determined.' ),
( 1, 'None', 'Last commit wins.' ),
( 2, 'Edition', 'Use editioning to determine if a tuple has changed between select and update.' ),
( 3, 'Hash', 'Use a has of the selected tuple to determine if a tuple has changed between select and update.' ),
( 4, 'Compare', 'Compare selected and current values to determine if a tuple has changed between select and update.' ) ;
