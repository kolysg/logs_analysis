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

-- """


CREATE VIEW author_details AS
	select author, slug, title
	from articles
