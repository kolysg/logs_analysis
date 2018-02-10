
-- create a reporting tool
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


-- author and articles joined
create view authors_details_2 as 
	select authors.name as author_name, articles.slug as article_name, articles.title as article_title, articles.author as author_id 
	from articles, authors
	where authors.id = articles.author
	order by authors.name;


-- successful clicks to articles and authors joined
create view articles_details_2 as 
	select a.article_name, a.article_title, a.author_name, count (*) as click_count 
		from authors_details as a inner join log
		on log.path like concat('/article/', a.article_name)
		where log.status like '%200%'
		group by a.article_name, a.article_title, a.author_name, log.path
		order by click_count desc;


-- most three popular articles
create view popular_articles_5 as
	select articles_details_2.article_title as title, articles_details_2.click_count as count
		from articles_details_2
		limit 3;

-- most popular author
create view popular_authors_2 as
	select a.author_name as title, count(*) as click_count
		from authors_details_2 as a inner join log
		on log.path like concat('/article/', a.article_name)
		where log.status like '%200%'
		group by a.author_name
		order by click_count desc;


-- total requests per day
create view total_rqsts as 
	select date(log.time) as day, count(log.id) as total
		from log
		group by (date(log.time))
		order by (date(log.time));


-- total bad requests per day
create view error_rqsts as 
	select date(log.time) as day, count(log.id) as total_errors
		from log
		where log.status like '404%'
		group by (date(log.time))
		order by (date(log.time));


-- days where bad requests are > 1%
create view high_error_days as 
	select t.day as day,
	round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) as percentage
		from total_rqsts as t join error_rqsts as e
		on t.day = e.day
		where round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) > 1::numeric;


-- Todos

-- create view popular_articles_4 as 
-- 	select articles.title, count(*) as count
-- 		from articles join log
-- 			on log.path = concat('/article/', articles.slug)
-- 			where log.status like '%200%'
-- 			group by articles.title
-- 			limit 2;
