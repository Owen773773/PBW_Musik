DROP TABLE IF EXISTS Song_Collection_Log; 
DROP TABLE IF EXISTS User_Song_Collection;
DROP TABLE IF EXISTS Song;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS "User";
DROP TABLE IF EXISTS Artist;
DROP TYPE IF EXISTS user_role;

CREATE TABLE Artist (
    ArtistID SERIAL PRIMARY KEY, --AUTO_INCREMENT di postgres SERIAL
    Name VARCHAR(255) NOT NULL 
);

CREATE TABLE Album (
    AlbumID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseYear INT,
    ArtistID INT NOT NULL,
    AlbumArt BYTEA,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID)
);

CREATE TABLE Song (
    SongID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AlbumID INT NOT NULL,
    ArtistID INT NOT NULL,
    SongArt BYTEA, --Kalau gambar??
    FOREIGN KEY (AlbumID) REFERENCES Album(AlbumID),
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID),
    UNIQUE (Title, AlbumID, ArtistID)
);

CREATE TYPE user_role AS ENUM ('Member', 'Admin');

CREATE TABLE "User" (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    "Password" VARCHAR(255) NOT NULL,
    Role user_role NOT NULL
);

CREATE TABLE User_Song_Collection (
    UserID INT NOT NULL,
    SongID INT NOT NULL,
    PRIMARY KEY (UserID, SongID),
    FOREIGN KEY (UserID) REFERENCES "User"(UserID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID)
);

--GRAFIK??

INSERT INTO Artist (ArtistID, Name) VALUES
(1, 'Taylor Swift'),
(2, 'H2H (Hearts 2 Hearts)'),
(3, 'Fujii Kaze');

INSERT INTO Album (AlbumID, Title, ReleaseYear, ArtistID, AlbumArt) VALUES
(101, '1989 (Taylor''s Version)', 2023, 1, '\x5461796C6F7220417274'::BYTEA), 
(102, '1st Mini Album', 2024, 2, '\x48324820417274'::BYTEA),   
(103, 'LOVE ALL SERVE ALL', 2022, 3, '\x4B617A6520417274'::BYTEA);

INSERT INTO Song (SongID, Title, AlbumID, ArtistID, SongArt) VALUES
(201, 'Style', 101, 1, '\x5374796C652053696E676C65'::BYTEA), 
(202, 'STYLE', 102, 2, NULL),
(203, 'FOCUS', 102, 2, NULL),
(204, 'Shinunoga E-Wa', 103, 3, '\x5368696E756E6F676120417274'::BYTEA),
(205, 'Matsuri', 103, 3, NULL);

INSERT INTO "User" (UserID, Username, "Password", Role) VALUES
(301, 'admin_rizal', 'admin123', 'Admin'),
(302, 'member_dina', 'member456', 'Member');

INSERT INTO User_Song_Collection (UserID, SongID) VALUES
(302, 201), --Dina, 'Style' (Taylor Swift)
(302, 204), --'Shinunoga E-Wa' (Fujii Kaze)
(302, 202); --'Cool' (H2H (Hearts 2 Hearts))




SELECT
    Title,
    AlbumArt
FROM
    Album
WHERE
    AlbumID = 101;

-- TOP !0 Lagu Terbaik
SELECT
    S.SongID,
    S.Title AS SongTitle,
    A.Title AS AlbumTitle,
    ART.Name AS ArtistName,
    COUNT(UGC.SongID) AS FavoriteCount
FROM
    Song S
JOIN
    Album A ON S.AlbumID = A.AlbumID
JOIN
    Artist ART ON S.ArtistID = ART.ArtistID
LEFT JOIN
    User_Song_Collection UGC ON S.SongID = UGC.SongID
GROUP BY
    S.SongID, S.Title, A.Title, ART.Name -- Harus mengelompokkan berdasarkan semua kolom non-agregat
ORDER BY
    FavoriteCount DESC LIMIT 10; --Urutkan dari yang paling banyak 
    

-- User
-- UserID (PK) , Username, Password, Role (Member dan Admin)

-- Artist
-- ArtistID (PK) ,Name 

-- Album 
-- AlbumID (PK),ArtistID (FK)  Title, ReleaseYear,  AlbumArt

-- Song
-- SongID (PK) AlbumID(FK), ArtistID (FK), Title, SongArt

--   User_Song_Collection 
-- UserID (PK, FK), SongID (PK,FK)

-- EXTRA?
-- Artist_Collaboration_Song
 