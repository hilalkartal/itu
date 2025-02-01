
DROP TABLE IF EXISTS admins;

CREATE TABLE admins (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
) DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

LOCK TABLES admins WRITE;
/*!40000 ALTER TABLE admins DISABLE KEYS */;
INSERT INTO admins VALUES (1,'admin','root@root.com','12345');
/*!40000 ALTER TABLE admins ENABLE KEYS */;
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 0;
-- MELİSA--
DROP TABLE IF EXISTS artists;

CREATE TABLE artists(
    artist_id INT NOT NULL,
    artist_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (artist_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- HİLAL--
DROP TABLE IF EXISTS genres;

CREATE TABLE genres(
    genre_id INT NOT NULL,
    genre_name varchar(255) NOT NULL,
    number_of_songs INT NOT NULL,
    PRIMARY KEY (genre_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- HİLAL--
DROP TABLE IF EXISTS labels;

CREATE TABLE labels(
    label_id INT NOT NULL,
    label_name varchar(255) NOT NULL,
    PRIMARY KEY (label_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ALPER--
DROP TABLE IF EXISTS composers;

CREATE TABLE composers(
    composer_id INT NOT NULL,
    composer_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (composer_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SELİN--
DROP TABLE IF EXISTS languages;

CREATE TABLE languages(
    language_id INT NOT NULL,
    language_name varchar(50) NOT NULL,
    PRIMARY KEY (language_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SELİN--
DROP TABLE IF EXISTS producers;

CREATE TABLE producers(
    producer_id INT NOT NULL,
    producer_name varchar(255) NOT NULL,
    number_of_songs INT NOT NULL,
    PRIMARY KEY (producer_id)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- MELİSA--
DROP TABLE IF EXISTS albums;

CREATE TABLE albums(
    album_id INT NOT NULL,
    album VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    number_of_songs INT NOT NULL,
    label_id INT,
    PRIMARY KEY (album_id),

    FOREIGN KEY (label_id)
        REFERENCES labels (label_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
    
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ÖZDEN--
DROP TABLE IF EXISTS songs;

CREATE TABLE songs(
    song_id INT NOT NULL,
    song_title VARCHAR(255) NOT NULL,
    duration FLOAT(10,2),
    popularity INT NOT NULL,
    stream INT,
    explicit_content VARCHAR(10),
    artist_id INT,
    album_id INT,
    genre_id INT,
    label_id INT,
    language_id INT,
    composer_id INT,
    producer_id INT,
    
    PRIMARY KEY (song_id),
    
    FOREIGN KEY (artist_id)
        REFERENCES artists (artist_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    FOREIGN KEY (album_id)
        REFERENCES albums (album_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    FOREIGN KEY (genre_id)
        REFERENCES genres (genre_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    FOREIGN KEY (label_id)
        REFERENCES labels (label_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    FOREIGN KEY (language_id)
        REFERENCES languages (language_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    FOREIGN KEY (producer_id)
        REFERENCES producers (producer_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    FOREIGN KEY (composer_id)
        REFERENCES composers (composer_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

SET FOREIGN_KEY_CHECKS = 1;