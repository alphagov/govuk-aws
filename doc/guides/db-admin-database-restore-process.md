Getting data into AWS databases
===============================

Most apps have a database. They all need data importing from eg Carrenza. To do
this, you'll need to do some things with non-obvious usernames, because of
Amazon RDS.

In these examples, we'll be using Publishing API, a PostgreSQL database, as
it's key to make everything work.

1. Connect to `postgres-primary-1`.

2. Dump the database:

        sudo -u postgres pg_dump publishing_api_production > publishing_api_integration.dump

3. We don't have seamless access between Carrenza and AWS yet (2017-08-17), so
   copy the database dump you just made down to your local machine (`scp -C`
   does transfer-level compression so it won't take several hours):

        scp -C postgresql-primary-1.integration:publishing_api_integration.dump .

4. Check that it's the same size as it was when you dumped it.

5. Copy it up to the jumpbox:

        scp -C publishing_api_integration.dump jumpbox.blue.integration.govuk.digital:.

6. Once it's there, connect to the jumpbox with SSH agent forwarding enabled
   (`-A`), and copy the file to the dbadmin machine. You'll need to find the
   `db_admin` machine, so use `govuk_node_list` for this.

        scp -C publishing_api_integration.dump `govuk_node_list -c db_admin`

7. Now, the "fun" starts. The db\_admin machine is an Amazon RDS instance, so
   it has one user to administer the database with. We've set this to
   `changeme2` for now, with the password `thisisatestaswell`. You'll need to
   specify the hostname of the RDS instance, which is liable to change, so not
   included here. You can find it in the RDS section of the AWS Console. The
   command you want is:

        psql -U changeme2 -h placeholder -d publishing_api_production -f publishing_api_integration.dump

8. It will import for a while (Publishing API in particular is ~20G of database
   dump) and then there'll be data for apps to read!
