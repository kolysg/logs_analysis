"""create a reporting tool
	which answers three questions about the news database
	- run_queries - function connects to the database through Python DB-API and runs a query.
	- print_headers - prints a header before each function call 
	- print functions for each queries
"""

import psycopg2

DBNAME = 'news'

def run_queries(user_query) :
	"""execute user's query and returns the result in a table"""
	db = psycopg2.connect(database-DBNAME)
	c = db.cursor()
	c.execute(user_query)
	results = c.fetchall()
	db.close()
	return results

def print_header(query_text):
	"""Prints a header before each query"""
	print('\n\t' + heading + '\n')





