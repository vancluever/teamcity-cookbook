Yet Another TeamCity Cookbook
==============================

There seems to be a ton of these on Supermarket, and to be honest, none of them
seem to have the level of quality that I really want in a upstream, independent
cookbook. Hence, I'm making my own.

This CookBook is setting out to do two things:

 * TeamCity server - standalone system suitable for testing and learning
 * TeamCity agent - basic TeamCity instance that can be used as an agent node

**Linux only for now**. I have no interest in developing this for Windows, and
is only being stood up so that I can teach myself TeamCity.


Supported Platforms
--------------------

This cookbook has been tested on:

 * Ubuntu (14.04)


Usage
------

Installing TeamCity can be done via the following recipes:

### server (teamcity::server)

This recipe installs TeamCity via the recommend installation method (using the
bundled Tomcat).

This recipe by default pulls in a Java using the [Java cookbook]
(https://github.com/agileorbit-cookbooks/java).

**NOTE:** the server cookbook does not configure a Application URL by
default - and leaves the server port. It's up to you to configure a SSL
endpoint yourself (usually via some sort of SSL terminator, like ELB, etc).

### agent (teamcity::agent)

This recipe installs a TeamCity agent on the machine, using the parameters
supplied to ensure that it can be used with the server deployed with this
recipe as well.

### database (teamcity::database)

This recipe prepares a database on the server that it is deployed to for use
with TeamCity.

Note that by default, this sets the database server's admin password (ie:
the `postgres` or the `root` user) to the same password as the database password
for TeamCity. To fix this, set the admin passwords for the cookbooks that this
one consumes for the database:

 * **PostgreSQL:** `node['postgresql']['password']['postgres']`


Node Variables and Defaults
----------------------------

The intention of this cookbook is not NOT have pages of tunable values,
focusing only on what is really needed to get the system up and running in a
reasonable way. This will probably mean that this list will grow organically
as it needs to.
