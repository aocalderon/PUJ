CREATE TABLE account (
	account_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	dob DATE
);

CREATE TABLE thread (
	thread_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL REFERENCES account(account_id),
	title TEXT NOT NULL
);

CREATE TABLE post (
	post_id SERIAL PRIMARY KEY,
	thread_id INTEGER NOT NULL REFERENCES thread(thread_id),
	account_id INTEGER NOT NULL REFERENCES account(account_id),
	created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
	visible BOOLEAN NOT NULL DEFAULT TRUE,
	comment TEXT NOT NULL
);

CREATE TABLE words (word TEXT);
COPY words(word) FROM '/usr/share/dict/words.txt';

-- Creating 100 dummy accounts...
INSERT INTO account (name, dob)
	SELECT
		substring('AEIOU', (random() * 4)::int + 1, 1) ||
		substring('bcdfghjklmnpqrstvwxyzbcdfghjklmnpqrstvwxyz', (random() * 21 * 2 + 1)::int, 2) ||
		substring('aeiou', (random() * 4 + 1)::int, 1) ||
		substring('bcdfghjklmnpqrstvwxyzbcdfghjklmnpqrstvwxyz', (random() * 21 * 2 + 1)::int, 2) ||
		substring('aeiou', (random() * 4 + 1)::int, 1),
		NOW() + ('1 days'::interval * random() * 365)
	FROM
		generate_series(1, 100);

-- Creating 1000 random threads...
INSERT INTO thread (account_id, title)
	SELECT
		random() * 99 + 1,
		(
			SELECT
				initcap(string_agg(word, ' '))
			FROM
				(TABLE words ORDER BY random() + n LIMIT 5) AS words (word)
		)
	FROM
		generate_series(1, 1000) AS s(n);

-- Let's work with 100K random posts...
INSERT INTO post (thread_id, account_id, created, visible, comment)
	SELECT
		random() * 999 + 1,
		random() * 99 + 1,
		NOW() - ('1 days'::interval * random() * 1000),
		CASE WHEN random() > 0.1 THEN TRUE ELSE FALSE END,
		(
			SELECT string_agg(word, ' ') FROM (TABLE words ORDER BY random() * n LIMIT 20) AS words(word)
		)
	FROM
		generate_series(1, 100000) AS s(n);
