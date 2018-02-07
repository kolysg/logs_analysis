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

--question 1 - most popular three articles of all time

-- select articles_info.article_name, articles_info.click_count
-- 	from articles_info
-- 	limit 3;

--question 2 - most popular authors
-- select articles_info.author_name, articles_info.click_count
-- 	from articles_info
-- 	limit 3;

-- select author_info.author_name, count(*) as click_count
-- 	from author_info inner join log
-- 	on log.path like concat('%', author_info.article_name, '%')
-- 	where log.status like '%200%'
-- 	group by author_info.author_name
-- 	order by click_count desc;

--question 3 - on which days did more than 1% of requests lead to error
	--a table with time, and error status
	-- convert timestamp 
	-- count % of all errors based on time - divide by total error

-- two views where one has the number of failed calls per day 
-- and then the other with the number of total calls per day.

-- create a view that joins log table with article_info table


-- select cast(time as date),status, count(status) as count 
-- 	from log
-- 	where log.status like '%200%'
-- 	group by log.time, log.status
-- 	limit 2;

-- select a.time as day, a.total_req as total, b.error_req as error,
-- 	b.error_req::numeric * 100 / a.total_req::numeric as perc 
-- 		from total_requests_per_day as a join error_requests_per_day as b
-- 		on a.time = b.time
-- 		where (b.error_req::numeric * 100::numeric / a.total_req::numeric) > 1::numeric
-- 			limit 2;

-- create view high_error_days as 
	select t.day as day,
		round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) as percentage
		from total_rqst as t join error_rqst as e
			on t.day = e.day
			where round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) > 1::numeric
			limit 2;

	



