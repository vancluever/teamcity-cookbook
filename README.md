Yet Another TeamCity Cookbook
==============================

There seems to be a ton of these on Supermarket, and to be honest, none of them
seem to have the level of quality that I really want in a upstream, independent
cookbook. Hence, I'm making my own.

This CookBook is setting out to do one job, set up the TeamCity server. Any
other configuration past this for agents I plan on only doing in EC2 and maybe
Docker.

**Linux only**. I have no interest in developing this for Windows, and
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

See `attributes/default.rb` for a hopefully self-documenting list of variables
that can be configured.


Kitchen Testing
----------------

I have been mainly deploying this with Kitchen, hence head over to the
`.kitchen.cloud.yml` file and check it out for details and you can see how
it's deployed.

Key things:

 * Create the `chef-kitchen-test-aws` key pair in AWS
 * Ensure you have a valid credentials in your default AWS profile, or
   export AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and optionally
   AWS_SESSION_TOKEN and AWS_REGION
 * Run KITCHEN_YAML=.kitchen.cloud.yml kitchen COMMAND
