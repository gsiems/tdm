# TDM

An exploration/proof of concept. A work in progress

 * Tabular (or textual) Data Modeling
 * Pronounced tedium
 * An exploration of an attempt to remove some of the tedium from data modeling
 * Firstly by eliminating the fiddly graphical modeling (plus, who really needs the carpal tunnel from dragging boxes and lines around all day)
 * Secondly by being opinionated about how a model should be translated between conceptual, logical, and physical
 * Should be able to generate database DDL
 * May not work for all situations
 * May not work 100% for any situation
 * Hope to be at least 90% for many situations
 * Even if generating DDL is a bridge or two too far, it should still be a usefull tool
 * Graphical diagrams, if they exist, are generated representations of the tabular modeling data

# Opinions

 * The generated physical model will be in 3rd normal form
 * All tables will use synthetic primary keys
 * If specified, or inferrable, tables will use a unique constraint to indicate the natural key
 * Each table will have a corresponding (façade) view that flattens the 3rd normal form (by how much though?)
 * Tables should not be directly selectable (that is what the views are for)
 * Data manipulation should be done through database functions or procedures, possibly by attaching the function/procedure to triggers on the façade views.
