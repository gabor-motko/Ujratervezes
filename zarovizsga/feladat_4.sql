CREATE DATABASE [World]
    COLLATE Hungarian_CI_AI

GO

CREATE TABLE World.dbo.Kontinens (
    KontinensID int NOT NULL,
    Nev varchar(100) NOT NULL,
    CONSTRAINT Kontinens_PK PRIMARY KEY (KontinensID)
);

INSERT INTO World.dbo.Kontinens (KontinensID, Nev)
VALUES (0, 'Afrika'),(1, 'Amerika'),(2, 'Antarktisz'),(3, 'Arktisz'),(4,'Ausztrália'),(5, 'Ázsia'),(6, 'Európa');

CREATE TABLE World.dbo.Orszag (
    OrszagID int NOT NULL,
    Nev varchar(100) NOT NULL,
    CONSTRAINT Orszag_PK PRIMARY KEY (OrszagID)
);

INSERT INTO World.dbo.Orszag (OrszagID, Nev)
VALUES (0, 'Kína'),(1, 'Mexikó'),(2, 'India'),(3, 'Belgium');

ALTER TABLE World.dbo.Orszag ADD KontinensID int NULL;
ALTER TABLE World.dbo.Orszag ADD CONSTRAINT Orszag_FK FOREIGN KEY (KontinensID) REFERENCES World.dbo.Kontinens(KontinensID);

UPDATE World.dbo.Orszag
    SET KontinensID=5
    WHERE OrszagID=0;
UPDATE World.dbo.Orszag
    SET KontinensID=1
    WHERE OrszagID=1;
UPDATE World.dbo.Orszag
    SET KontinensID=5
    WHERE OrszagID=2;
UPDATE World.dbo.Orszag
    SET KontinensID=6
    WHERE OrszagID=3;

SELECT k.Nev, o.Nev
FROM Kontinens k LEFT JOIN Orszag o ON k.KontinensID = o.KontinensID

USE [master]
CREATE LOGIN [Worldreader] WITH PASSWORD='Password987!'
USE [World]
CREATE USER [Worldreader] FOR LOGIN [Worldreader]


DROP DATABASE [World]
DROP LOGIN [Worldreader]
