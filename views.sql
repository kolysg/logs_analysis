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

create view author_info as 
	select authors.name as author_name, articles.slug as article_name, articles.title as article_title, articles.author as author_id 
	from articles, authors
	where authors.id = articles.author
	order by authors.name;


-- create a view with articles, how many success counts, author.
create view articles_info as 
	select a.article_name, a.author_name, count (*) as click_count 
		from author_info as a inner join log
		on log.path like concat('%', a.article_name, '%')
		where log.status like '%200%'
		group by a.article_name, a.author_name, log.path
		order by click_count desc;

-- most three popular articles
create view most_popular_articles as
	select articles_info.article_name, articles_info.click_count
		from articles_info
		limit 3;

-- most popular author
create view most_popular_author as
	select author_info.author_name, count(*) as click_count
		from author_info inner join log
		on log.path like concat('%', author_info.article_name, '%')
		where log.status like '%200%'
		group by author_info.author_name
		order by click_count desc;


-- total requests per day
create view total_rqst as 
	select date(log.time) as day, count(log.id) as total
	from log
	group by (date(log.time))
	order by (date(log.time));

-- total bad requests per day
create view error_rqst as 
	select date(log.time) as day, count(log.id) as total_errors
	from log
	where log.status like '404%'
	group by (date(log.time))
	order by (date(log.time));


-- days where bad requests are > 1%
create view high_error_days as 
	select t.day as day,
		round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) as percentage
		from total_rqst as t join error_rqst as e
			on t.day = e.day
			where round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) > 1::numeric;


