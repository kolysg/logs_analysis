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


CREATE VIEW author_details AS
	SELECT author, slug, title
	FROM articles

-- join authors with articles table to create a table that also has author's name

CREATE VIEW author_info AS 
	SELECT authors.name as author_name, articles.slug as article_name, articles.title as article_title, articles.author as author_id 
	FROM articles, authors
	WHERE authors.id = articles.author
	ORDER BY authors.name;


-- create a view with articles, how many success counts, author.




