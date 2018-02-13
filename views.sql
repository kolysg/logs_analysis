
-- create a reporting tool
-- 	#prints out reports (in plain text)
-- 	#3 questions to answer
-- 		1. what are the most popular three articles -sorted list?
-- 			- how do i measure popularity? 
-- 			- create a view that JOIN article with author name
-- 			- create a view that JOIN article id with log id
-- 				- count paths
-- 		2. who are the most pop authors - sorted list
-- 		3. ON which days did more than 1% of requests lead to errors?
-- 			- example: July 29, 2016 — 2.5% errors


-- author and articles joined
CREATE VIEW authors_details_2 AS 
	SELECT authors.name AS author_name, articles.slug AS article_name, articles.title AS article_title, articles.author AS author_id 
	FROM articles, authors
	WHERE authors.id = articles.author
	ORDER BY authors.name;


-- successful clicks to articles and authors joined
CREATE VIEW articles_details_2 AS 
	SELECT a.article_name, a.article_title, a.author_name, count (*) AS click_count 
		FROM authors_details_2 AS a INNER JOIN log
		ON log.path LIKE concat('/article/', a.article_name)
		WHERE log.status LIKE '%200%'
		GROUP BY a.article_name, a.article_title, a.author_name, log.path
		ORDER BY click_count DESC;


-- most three popular articles
CREATE VIEW popular_articles_5 AS
	SELECT articles_details_2.article_title AS title, articles_details_2.click_count AS count
		FROM articles_details_2
		LIMIT 3;

-- most popular author
CREATE VIEW popular_authors_2 AS
	SELECT a.author_name AS title, count(*) AS click_count
		FROM authors_details_2 AS a INNER JOIN log
		ON log.path LIKE concat('/article/', a.article_name)
		WHERE log.status LIKE '%200%'
		GROUP BY a.author_name
		ORDER BY click_count DESC;


-- total requests per day
CREATE VIEW total_rqsts AS 
	SELECT date(log.time) AS day, count(log.id) AS total
		FROM log
		GROUP BY (date(log.time))
		ORDER BY (date(log.time));


-- total bad requests per day
CREATE VIEW error_rqsts AS 
	SELECT date(log.time) AS day, count(log.id) AS total_errors
		FROM log
		WHERE log.status LIKE '404%'
		GROUP BY (date(log.time))
		ORDER BY (date(log.time));


-- days WHERE bad requests are > 1%
CREATE VIEW high_error_days AS 
	SELECT t.day AS day,
	round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) AS percentage
		FROM total_rqsts AS t JOIN error_rqsts AS e
		ON t.day = e.day
		WHERE round(e.total_errors::numeric * 100::numeric / t.total::numeric, 2) > 1::numeric;


-- Todos

-- CREATE VIEW popular_articles_4 AS 
-- 	SELECT articles.title, count(*) AS count
-- 		FROM articles JOIN log
-- 			ON log.path = concat('/article/', articles.slug)
-- 			WHERE log.status LIKE '%200%'
-- 			GROUP BY articles.title
-- 			LIMIT 2;
