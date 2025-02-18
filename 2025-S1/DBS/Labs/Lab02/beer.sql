--
-- File generated with SQLiteStudio v3.4.15 on Tue Feb 4 12:23:54 2025
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Bar
DROP TABLE IF EXISTS Bar;

CREATE TABLE IF NOT EXISTS Bar (
    name    VARCHAR (20) NOT NULL
                         PRIMARY KEY,
    address VARCHAR (20) 
);

INSERT INTO Bar (name, address) VALUES ('Down Under Pub', '802 W. Main Street');
INSERT INTO Bar (name, address) VALUES ('The Edge', '108 Morris Street');
INSERT INTO Bar (name, address) VALUES ('James Joyce Pub', '912 W. Main Street');
INSERT INTO Bar (name, address) VALUES ('Satisfaction', '905 W. Main Street');
INSERT INTO Bar (name, address) VALUES ('Talk of the Town', '108 E. Main Street');

-- Table: Beer
DROP TABLE IF EXISTS Beer;

CREATE TABLE IF NOT EXISTS Beer (
    name   VARCHAR (20) NOT NULL
                        PRIMARY KEY,
    brewer VARCHAR (20) 
);

INSERT INTO Beer (name, brewer) VALUES ('Amstel', 'Amstel Brewery');
INSERT INTO Beer (name, brewer) VALUES ('Budweiser', 'Anheuser-Busch Inc.');
INSERT INTO Beer (name, brewer) VALUES ('Corona', 'Grupo Modelo');
INSERT INTO Beer (name, brewer) VALUES ('Dixie', 'Dixie Brewing');
INSERT INTO Beer (name, brewer) VALUES ('Erdinger', 'Erdinger Weissbrau');
INSERT INTO Beer (name, brewer) VALUES ('Full Sail', 'Full Sail Brewing');

-- Table: Drinker
DROP TABLE IF EXISTS Drinker;

CREATE TABLE IF NOT EXISTS Drinker (
    name    VARCHAR (20) NOT NULL
                         PRIMARY KEY,
    address VARCHAR (20) 
);

INSERT INTO Drinker (name, address) VALUES ('Amy', '100 W. Main Street');
INSERT INTO Drinker (name, address) VALUES ('Ben', '101 W. Main Street');
INSERT INTO Drinker (name, address) VALUES ('Coy', '200 S. Duke Street');
INSERT INTO Drinker (name, address) VALUES ('Dan', '300 N. Duke Street');
INSERT INTO Drinker (name, address) VALUES ('Eve', '100 W. Main Street');

-- Table: Frequents
DROP TABLE IF EXISTS Frequents;

CREATE TABLE IF NOT EXISTS Frequents (
    drinker      VARCHAR (20) NOT NULL
                              REFERENCES Drinker (name),
    bar          VARCHAR (20) NOT NULL
                              REFERENCES Bar (name),
    times_a_week SMALLINT     CHECK (times_a_week > 0),
    PRIMARY KEY (
        drinker,
        bar
    )
);

INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Amy', 'James Joyce Pub', 2);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Ben', 'James Joyce Pub', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Ben', 'Satisfaction', 2);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Ben', 'Talk of the Town', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Coy', 'Down Under Pub', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Coy', 'The Edge', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Dan', 'Down Under Pub', 2);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Dan', 'The Edge', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Dan', 'James Joyce Pub', 1);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Dan', 'Satisfaction', 2);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Dan', 'Talk of the Town', 2);
INSERT INTO Frequents (drinker, bar, times_a_week) VALUES ('Eve', 'James Joyce Pub', 2);

-- Table: Likes
DROP TABLE IF EXISTS Likes;

CREATE TABLE IF NOT EXISTS Likes (
    drinker VARCHAR (20) NOT NULL
                         REFERENCES Drinker (name),
    beer    VARCHAR (20) NOT NULL
                         REFERENCES Beer (name),
    PRIMARY KEY (
        drinker,
        beer
    )
);

INSERT INTO Likes (drinker, beer) VALUES ('Amy', 'Amstel');
INSERT INTO Likes (drinker, beer) VALUES ('Amy', 'Corona');
INSERT INTO Likes (drinker, beer) VALUES ('Ben', 'Amstel');
INSERT INTO Likes (drinker, beer) VALUES ('Ben', 'Budweiser');
INSERT INTO Likes (drinker, beer) VALUES ('Coy', 'Dixie');
INSERT INTO Likes (drinker, beer) VALUES ('Dan', 'Amstel');
INSERT INTO Likes (drinker, beer) VALUES ('Dan', 'Budweiser');
INSERT INTO Likes (drinker, beer) VALUES ('Dan', 'Corona');
INSERT INTO Likes (drinker, beer) VALUES ('Dan', 'Dixie');
INSERT INTO Likes (drinker, beer) VALUES ('Dan', 'Erdinger');
INSERT INTO Likes (drinker, beer) VALUES ('Eve', 'Amstel');
INSERT INTO Likes (drinker, beer) VALUES ('Eve', 'Corona');

-- Table: Serves
DROP TABLE IF EXISTS Serves;

CREATE TABLE IF NOT EXISTS Serves (
    bar   VARCHAR (20)   NOT NULL
                         REFERENCES Bar (name),
    beer  VARCHAR (20)   NOT NULL
                         REFERENCES Beer (name),
    price DECIMAL (5, 2) CHECK (price > 0),
    PRIMARY KEY (
        bar,
        beer
    )
);

INSERT INTO Serves (bar, beer, price) VALUES ('Down Under Pub', 'Amstel', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('Down Under Pub', 'Budweiser', 2.25);
INSERT INTO Serves (bar, beer, price) VALUES ('Down Under Pub', 'Corona', 3);
INSERT INTO Serves (bar, beer, price) VALUES ('The Edge', 'Amstel', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('The Edge', 'Budweiser', 2.5);
INSERT INTO Serves (bar, beer, price) VALUES ('The Edge', 'Corona', 3);
INSERT INTO Serves (bar, beer, price) VALUES ('James Joyce Pub', 'Amstel', 3);
INSERT INTO Serves (bar, beer, price) VALUES ('James Joyce Pub', 'Corona', 3.25);
INSERT INTO Serves (bar, beer, price) VALUES ('James Joyce Pub', 'Dixie', 3);
INSERT INTO Serves (bar, beer, price) VALUES ('James Joyce Pub', 'Erdinger', 3.5);
INSERT INTO Serves (bar, beer, price) VALUES ('Satisfaction', 'Amstel', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('Satisfaction', 'Budweiser', 2.25);
INSERT INTO Serves (bar, beer, price) VALUES ('Satisfaction', 'Corona', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('Satisfaction', 'Dixie', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('Satisfaction', 'Full Sail', 2.75);
INSERT INTO Serves (bar, beer, price) VALUES ('Talk of the Town', 'Amstel', 2.5);
INSERT INTO Serves (bar, beer, price) VALUES ('Talk of the Town', 'Budweiser', 2.2);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
