-- 	#3 questions to answer
-- 		1. what are the most popular three articles -sorted list?
-- 			- how do i measure popularity? - count ip address after joining articles with logs table (group by title/slug may be)
-- 			- create a view that join articles with author name
-- 			- create a view that join article id with log id
-- 				- count paths
-- 				- paths have slug as path - /article/slug - so path has to have a regex - use like "%slug%"
-- 		2. who are the most pop authors - sorted list
-- 		3. on which days did more than 1% of requests lead to errors?
-- 			- example: July 29, 2016 — 2.5% errors

select author_info.*, log.path 
	from author_info inner join log.path
	on log.path like concat("%", articles.slug, "%")
	where log.status like "%200%"
