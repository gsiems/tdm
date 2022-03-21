CREATE TABLE tdm.st_history_type (
    id int NOT NULL,
    name character varying ( 60 ) NOT NULL,
    description character varying ( 1000 ),
    CONSTRAINT st_history_type_pk PRIMARY KEY ( id ),
    CONSTRAINT st_history_type_nk UNIQUE ( name ) ) ;

COMMENT ON TABLE tdm.st_history_type IS 'Approaches to maintaining historical data for an entity.' ;
COMMENT ON COLUMN tdm.st_history_type.id IS 'The ID of the history type.' ;
COMMENT ON COLUMN tdm.st_history_type.name IS 'The name of the historical data management approach.' ;
COMMENT ON COLUMN tdm.st_history_type.description IS 'The description of the historical data management approach.' ;

REVOKE ALL ON TABLE tdm.st_history_type FROM public ;

insert into tdm.st_history_type ( id, name, description )
values
( 0, 'TBD', 'To be determined.' ),
( 1, 'None', 'Do not keep any historical data.' ),
( 2, 'History table', 'Use a separate table for tracking historical data.' ),
( 3, 'Minimal temporal table', 'Use the data table to track historical data using a minimal set of temporal columns.' ) ;

--https://github.com/nearform/temporal_tables
