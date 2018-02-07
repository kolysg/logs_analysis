# Logs Analysis Program

## PURPOSE OF THIS PROJECT

The purpose of the project is to print answers of the following three questions in a human readable format for the three queries using python's psycopg2 library and PostgreSQL database:

1. What are the most popular three articles of all time?
2. Who are the most popular article authors of all time?
3. On which days did more than 1% of requests lead to errors?

## SETTING UP THE ENVIRONMENT

This code is dependent upon the materials provided for Udacity's Logs
Analysis project. For ease of access this repository provides a vagrantfile
and two SQL scripts to set up the environment as intended for this project.  

Follow these steps to get started:

1. Download [Vagrant](https://www.vagrantup.com/) and install.
2. Download [Virtual Box](https://www.virtualbox.org/) and install. *You **do not** need to run this after installing*.
3. Clone this repository to a directory of your choice.

   Now that you have everything in place, it's time to set up your virtual environment.
   
4. `cd` into `logs` (or whatever you happened to name it):
   ```sh
   $ cd logs
   ```

5. Now let Vagrant do the hard work (this may take a few minutes to complete, be patient):
   ```sh
   $ vagrant up
   ```
   Once `vagrant up` has finished, you will be greeted with your shell prompt again.

6. Log in to the virtual machine:
   ```sh
   $ vagrant ssh
   ```
   
   If you are alerted that a restart is required above the virtual machine's prompt upon login, you can simply:
   ```sh
   $ vagrant halt
   ```
   Then
   ```sh
   $ vagrant up
   $ vagrant ssh
   ```
   
7. Once logged in, navigate to the shared directory:
   ```sh
   cd /vagrant
   ```

8. Extract the newsdata SQL script and use it to populate the database with test data:
   ```sh
   $ unzip newsdata.zip
   $ psql -d news -f newsdata.sql
   ```

9. Set up the views needed to query the database:
   ```sh
   $ psql -d news -f views.sql
   ```
9. Lastly, run logs.py:
   ```sh
   $ python(/python3) logs.py
   ```

## EXPECTED OUTPUT
````

        TOP 3 ARTICLES OF ALL TIME

 "Candidate is jerk, alleges rival" -- 338647 views
 "Bears love berries, alleges bear" -- 253801 views
 "Bad things gone, say good people" -- 170098 views

        TOP AUTHORS OF ALL TIME

 Ursula La Multa -- 507594 views
 Rudolf von Treppenwitz -- 423457 views
 Anonymous Contributor -- 170098 views
 Markoff Chaney -- 84557 views

        DAYS WITH GREATER THAN 1% 404 REQUESTS

 July 17, 2016 -- 2.3 % errors
````

## VIEWS USED

This program utilizes views in PostgreSQL. The queries that make up these views are described below.

#### authors_details
````sql
  select authors.name as author_name, articles.slug as article_name, articles.title as article_title, articles.author as author_id 
    from articles, authors
    where authors.id = articles.author
    order by authors.name;
 ````

#### articles_details
````sql
  select a.article_name, a.author_name, count (*) as click_count 
    from authors_details as a inner join log
    on log.path like concat('%', a.article_name, '%')
    where log.status like '%200%'
    group by a.article_name, a.author_name, log.path
    order by click_count desc;
 ````

#### popular_articles
````sql
  select articles_details.article_name as name, articles_details.click_count as count
    from articles_details
    limit 3;
 ````

#### popular_authors
````sql
  select a.author_name as name, count(*) as click_count
    from authors_details as a inner join log
    on log.path like concat('%', a.article_name, '%')
    where log.status like '%200%'
    group by a.author_name
    order by click_count desc;
 ````

#### total_rqsts
````sql
 select date(log.time) as day, count(log.id) as total
    from log
    group by (date(log.time))
    order by (date(log.time));
````

#### error_rqsts
````sql
 select date(log.time) as day, count(log.id) as total_errors
    from log
    where log.status like '404%'
    group by (date(log.time))
    order by (date(log.time));
````

#### high_error_days
````sql
 select t.day as day,
  round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) as percentage
    from total_rqsts as t join error_rqsts as e
    on t.day = e.day
    where round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) > 1::numeric;
````
