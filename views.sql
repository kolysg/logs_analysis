-- slug is a short name given to an article for production
-- """Database code for the reporting tool """
-- """create a reporting tool
-- 	#prints out reports (in plain text)
-- 	#3 questions to answer
-- 		1. what are the most popular three articles -sorted list?
-- 			- how do i measure popularity? 
-- 			- create a view that join article with author name
-- 			- create a view that join article id with log id
-- 				- count paths
-- 		2. who are the most pop authors - sorted list
-- 		3. on which days did more than 1% of requests lead to errors?
-- 			- example: July 29, 2016 — 2.5% errors


-- join authors with articles table to create a table that also has author's name

CREATE VIEW author_info AS 
	SELECT authors.name as author_name, articles.slug as article_name, articles.title as article_title, articles.author as author_id 
	FROM articles, authors
	WHERE authors.id = articles.author
	ORDER BY authors.name;


-- create a view with articles, how many success counts, author.
create view articles_info as 
	select a.article_name, a.author_name, count (*) as click_count 
	from author_info as a inner join log
	on log.path like concat('%', a.article_name, '%')
	where log.status like '%200%'
	group by a.article_name, a.author_name, log.path
	order by click_count desc;


-- create view total_requests_per_day as
-- select cast(log.time as date), log.status, count(*) as total_req
-- 	from log
-- 	group by log.time, log.status
-- 	order by total_req desc
-- 	limit 2;

-- create view error_requests_per_day as 
-- 	select cast(log.time as date), log.status, count(*) as error_req
-- 		from log
-- 		where log.status like '%404%'
-- 		group by log.time, log.status
-- 		order by error_req desc
-- 		limit 2;

create view total_rqst as 
	select date(log.time) as day, count(log.id) as total
	from log
	group by (date(log.time))
	order by (date(log.time));

create view error_rqst as 
	select date(log.time) as day, count(log.id) as total_errors
	from log
	where log.status like '404%'
	group by (date(log.time))
	order by (date(log.time));



