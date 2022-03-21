# The model

A model consists of three primary kinds of elements

 * Entities
 * Attributes
 * Domains

Other possible elements are not currently considered

In addition to the primary elements there are opinions

## Entities

 * An entity is a named container for one or more attributes
 * Entity names for any given model must be unique
 * All business objects (as I learned it) are entities
 * Not all entities are business objects

## Attributes

 * An attribute is a named expression of either
    * a domain or
    * a set of multiple instances of the same domain
 * Attribute names for any given entity must be unique
 * By default an attribute name matches the name of the domain that it expresses
 * The attribute name may differ from the domain name
 * An entity may have multiple attributes that express the same domain

## Domains

 * A domain is either
    * a scalar datatype (text, date, integer, etc.) or
    * is based on an entity
 * Domain names for any given model must be unique
 * All entities have a corresponding domain of the same name
 * A scalar domain may have constraints (max length, is required, range or enumerated set of allowed values, etc.)
 * A scalar domain may have a default value
 * The same domain may be expressed by attributes of multiple entities

## Other elements

It is not (currently) intended to model business processes, data life-cycles, events, etc.

 * A data life-cycle being the cradle-to-grave definition of:

    * How/when/where data enters the system
    * How it flows through, and/or is transformed by, the system,
    * How/where/if the data is stored, and
    * How/when/if the data is discarded

 * Actually, this DOES model the "how/where the data is stored" and possibly the "when/if the data is discarded" portions of the data life-cycle

 * "Data flows" and business processes are probably mostly synonymous

 * An event being the definition of something that triggers one or more business processes.

# Opinions and observations

There should be sufficient information in the model, and enough "opinions", that, when the two are combined, it is possible to generate a workable physical data model.

----

The generated data model should, nominally, be in 3rd normal form.

----

All tables should use synthetic primary keys.

The topic of synthetic vs. natural keys is the kind of thing that some like to argue about (just like Vi vs. Emacs, tabs vs. spaces, Coke vs. Pepsi, etc.). My experience, and therfore my opinion is that, while both have there pros and cons, synthetic keys have have more pros than cons.

The biggest problem I have with synthetic keys is that the ID columns are typically integers and people just aren't wired to deal with numbers the same way they are with words. This can be mitigated by creating façade views for tables that include the natural key columns from the parent table(s) (especially if those façade views can be auto-generated based on the table metadata).

My issues with using natural keys include:

 * Not all tables have a good natural key, or the entire table is the natural key.

 * Instances where the natural key of the parent needs updating and the database engine being used does not support ```ON UPDATE CASCADE``` foreign keys.

 * Instances where children tables have more columns devoted to the relationship with the parent table than they do to the actual data stored in the table.

 * Space. Synthetic keys tend to result in tables that take less disk space and therefore require less I/O when reading/writing data.

Opinion:

 * Larger databases (by table count) probably benefit more from using synthetic keys vs. not.
 * Larger databases (by data size) are probably smaller when using synthetic keys vs. not.
 * Deep data structure (many/nested child tables) probably benefit more from using synthetic keys vs. not.
 * Therefore: use synthetic keys

----

Tables should have a unique constraint/index that indicates the natural key for the table.

Just because the primary key is synthetic doesn't mean that the natural key shouldn't be identifed.

----

Tables should not be directly selectable (that is what the façade views are for).

This makes it easier to refactor tables without breaking things as the view can be rewritten to present the same data as before the refactor.

This doesn't matter as much for stand-alone databases that only have one front-end, however my experiece doesn't tend to reflect that use case much-- even databases that are intended to only have one front-end end up getting used by other applications or interfaced with other databases.

It should be noted that applications that make extensive use of ORMs might not play as well with this approach.

Opinion: Create façade views and use them to the extent possible/practicable.

----

Tables should not be directly updatable, but this really depends on the database enging being used and the use case for the database.

Not all database engines support having procedural code in the database or the use of updatable views so it may not even be a possibility.

Stand-alone databases that only have one front-end may be better off letting the application code directly update the tables.

For those databases that have multiple applications that could be interacting with the data it can make more sense to put common logic in the database vs. repeating it across multiple different applications.

Having procedural code in the database does tie the application(s) more strongly to a specific database engine, however, my experience is that organizations are more likely to change out front-end(s) than they are to change out the back-end so having the code in the database might actually result in less re-writing over time.

Having procedural code in the database can result in developers having yet another language to deal with.

As with façade views, it should be noted that applications that make extensive use of ORMs might not play as well with this approach.

For those applications that can target multiple different database back-ends it may be better letting the application code directly update the tables. The applications may well be depending on an ORM for database access.

Opinion: It depends on the use case

----
