"""Create a reporting tool to run_queries."""

import psycopg2

DBNAME = 'news'


def run_queries(user_query):
    """Execute user's query and returns the result in a table."""
    db = psycopg2.connect(database=DBNAME)
    c = db.cursor()
    c.execute(user_query)
    results = c.fetchall()
    db.close()
    return results


def print_header(query_text):
    """Print a header before each query."""
    print('\n\t' + query_text + '\n')


def find_top_three_articles():
    """Print the three most popular articles."""
    most_popular_articles = run_queries(('select * from popular_articles'))
    print_header('Three most popular articles')

    for name, count in most_popular_articles:
        print('{} -- {} views'.format(name, count))


def find_popular_authors():
    """Print the most popular authors in a sorted table."""
    most_popular_authors = run_queries(('select * from popular_authors'))
    print_header('Most popular authors based on article-clicks')

    for name, count in most_popular_authors:
        print('{} -- {} views'.format(name, count))


def find_bad_requests():
    """Print 1% of the 404 requests per day."""
    bad_requests = run_queries(('select * from high_error_days'))
    print_header('All bad requests that exceed 1% of the total requests')

    for day, percentage in bad_requests:
        print ('{0:%B %d, %Y} -- {1:.1f} % errors'.format(day, percentage))


if __name__ == '__main__':
    find_top_three_articles()
    find_popular_authors()
    find_bad_requests()
