BEGIN;

--TODO delete schema and references accross requests
CREATE SCHEMA IF NOT EXISTS power_up;

--TODO don't drop schema on creation


-- Creation of entity tables
CREATE TABLE IF NOT EXISTS power_up.games (
  id                          SERIAL  NOT NULL PRIMARY KEY,
  name                        VARCHAR,
  summary                     TEXT,
  avg_score                   REAL,
  release                     DATE,
  cover_picture_cloudinary_id VARCHAR,
  counter                     INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS power_up.genres (
  id   SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR
);
CREATE TABLE IF NOT EXISTS power_up.platforms (
  id   SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR
);
CREATE TABLE IF NOT EXISTS power_up.companies (
  id   SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR
);
CREATE TABLE IF NOT EXISTS power_up.keywords (
  id   SERIAL  NOT NULL PRIMARY KEY,
  name VARCHAR NOT NULL
);
CREATE TABLE IF NOT EXISTS power_up.users (
  id              SERIAL  NOT NULL PRIMARY KEY,
  email           VARCHAR NOT NULL,
  username        VARCHAR          DEFAULT NULL,
  hashed_password VARCHAR NOT NULL,
  enabled         BOOLEAN NOT NULL DEFAULT TRUE,

  UNIQUE (email),
  UNIQUE (username)
);

-- Creation of relationship tables
CREATE TABLE IF NOT EXISTS power_up.game_genres (
  id       SERIAL  NOT NULL PRIMARY KEY,
  game_id  INTEGER NOT NULL,
  genre_id INTEGER NOT NULL,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES power_up.genres (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (game_id, genre_id)
);
CREATE TABLE IF NOT EXISTS power_up.game_platforms (
  id           SERIAL  NOT NULL PRIMARY KEY,
  game_id      INTEGER NOT NULL,
  platform_id  INTEGER NOT NULL,
  release_DATE DATE    NOT NULL,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (platform_id) REFERENCES power_up.platforms (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (game_id, platform_id, release_DATE)  --A game can be released for the same platform several times (i.e. remake)
);

CREATE TABLE IF NOT EXISTS power_up.game_keywords (
  id         SERIAL  NOT NULL PRIMARY KEY,
  game_id    INTEGER NOT NULL,
  keyword_id INTEGER NOT NULL,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (keyword_id) REFERENCES power_up.keywords (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS power_up.game_developers (
  id           SERIAL  NOT NULL PRIMARY KEY,
  game_id      INTEGER NOT NULL,
  developer_id INTEGER NOT NULL,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (developer_id) REFERENCES power_up.companies (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (game_id, developer_id)
);
CREATE TABLE IF NOT EXISTS power_up.game_publishers (
  id           SERIAL  NOT NULL PRIMARY KEY,
  game_id      INTEGER NOT NULL,
  publisher_id INTEGER NOT NULL,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (publisher_id) REFERENCES power_up.companies (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (game_id, publisher_id)
);
CREATE TABLE IF NOT EXISTS power_up.game_pictures (
  id            SERIAL  NOT NULL PRIMARY KEY,
  cloudinary_id VARCHAR NOT NULL,
  game_id       INTEGER NOT NULL,
  width         INTEGER,
  height        INTEGER,

  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS power_up.game_scores (
  id      SERIAL  NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  score   INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES power_up.users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (user_id, game_id)
);
CREATE TABLE IF NOT EXISTS power_up.game_play_statuses (
  id      SERIAL  NOT NULL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  game_id INTEGER NOT NULL,
  status  TEXT    NOT NULL,

  FOREIGN KEY (user_id) REFERENCES power_up.users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (game_id) REFERENCES power_up.games (id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (user_id, game_id)
);
CREATE TABLE IF NOT EXISTS power_up.user_authorities (
  id        SERIAL  NOT NULL PRIMARY KEY,
  username  VARCHAR NOT NULL,
  authority VARCHAR NOT NULL,

  FOREIGN KEY (username) REFERENCES power_up.users (username),
  UNIQUE (username, authority)
);
COMMIT;
