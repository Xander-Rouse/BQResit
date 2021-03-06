/*
Xander Rouse
103590876
*/


/*
ORGANISATION (ORGID, ORGANISATIONNAME)
PRIMARY KEY (ORGID)

CLIENT (CLIENTID, NAME, PHONE)
PRIMARY KEY (CLIENTID)

MENUITEM (ITEMID, DESCRIPTION, SERVESPERUNIT, UNITPRICE)
PRIMARY KEY (ITEMID)

ORDER (CLIENTID, DATETIMEPLACED, DELIVERYADDRESS)
PRIMARY KEY (CLIENTID, DATETIMEPLACED)
FOREIGN KEY (CLIENTID) REFERENCES CLIENT

ORDERLINE (CLIENTID, DATETIMEPLACED, ITEMID, QTY)
PRIMARY KEY (CLIENTID, DATETIMEPLACED, ITEMID)
FOREIGN KEY (CLIENTID) REFERENCES CLIENT
FOREIGN KEY (DATETIMEPLACED) REFERENCES ORDER
FOREIGN KEY (ITEMID) REFERENCES MENUITEM
*/

DROP TABLE IF EXISTS ORDERLINE, "ORDER", MENUITEM, CLIENT, ORGANISATION;

CREATE TABLE "ORGANISATION" (
"ORGID" NVARCHAR(4), 
"ORGANISATIONNAME" NVARCHAR(200) NOT NULL UNIQUE,
PRIMARY KEY (ORGID))

CREATE TABLE "CLIENT" (
    "CLIENTID" INT, 
    "NAME" NVARCHAR(100) NOT NULL, 
    "PHONE" NVARCHAR(15) NOT NULL UNIQUE,
    "ORGID" NVARCHAR(4) NOT NULL,
PRIMARY KEY (CLIENTID)
)

CREATE TABLE "MENUITEM" (
    "ITEMID" INT, 
    "DESCRIPTION" NVARCHAR(100) NOT NULL UNIQUE, 
    "SERVESPERUNIT" INT NOT NULL, 
    "UNITPRICE" MONEY NOT NULL,
PRIMARY KEY (ITEMID))

CREATE TABLE "ORDER" (
    "CLIENTID" INT, 
    "DATETIMEPLACED" DATE, 
    "DELIVERYADDRESS" NVARCHAR (MAX),
PRIMARY KEY (CLIENTID, DATETIMEPLACED),
FOREIGN KEY (CLIENTID) REFERENCES CLIENT)

GO

CREATE TABLE ORDERLINE (
    "CLIENTID" INT, 
    "DATETIMEPLACED" DATE, 
    "ITEMID" INT, 
    "QTY" INT NOT NULL,
PRIMARY KEY (CLIENTID, DATETIMEPLACED, ITEMID),
FOREIGN KEY (CLIENTID, DATETIMEPLACED) REFERENCES "ORDER"(CLIENTID, DATETIMEPLACED),
FOREIGN KEY (ITEMID) REFERENCES MENUITEM,
CONSTRAINT QTY_LEGNTH CHECK( LEN(QTY)>0))

INSERT INTO ORGANISATION("ORGID", "ORGANISATIONNAME") VALUES
('DODG',	'Dod & Gy Widget Importers'),
('SWUT',	'Swinburne University of Technology');

INSERT INTO CLIENT (CLIENTID, NAME, PHONE, ORGID) VALUES
(12,	'James Hallinan',	'(03)5555-1234',	'SWUT'),
(15,	'Any Nguyen',	'(03)5555-2345',	'DODG'),
(18,	'Karen Mok',	'(03)5555-3456',	'SWUT'),
(21,	'Tim Baird',	'(03)5555-4567',	'DODG'),
(39, 'Xander Rouse', '(61)0284-9584', 'SWUT');

INSERT INTO MENUITEM (ITEMID, DESCRIPTION, SERVESPERUNIT, UNITPRICE) VALUES
(3214,	'Tropical Pizza - Large',	2,	 $16.00), 
(3216,	'Tropical Pizza - Small',	1,	 $12.00 ),
(3218,	'Tropical Pizza - Family',	4,	 $23.00 ),
(4325,	'Can - Coke Zero',	1,	 $2.50 ),
(4326,	'Can - Lemonade',	1,	 $2.50 ),
(4327,	'Can - Harden Up',	1,	 $7.50 );

INSERT INTO "ORDER" (CLIENTID, DATETIMEPLACED, DELIVERYADDRESS) VALUES
(12,	'09/20/2021',	'Room TB225 - SUT - 1 John Street, Hawthorn, 3122'),
(21,	'09/14/2021',	'Room ATC009 - SUT - 1 John Street, Hawthorn, 3122'),
(21,	'09/27/2021',	'Room TB225 - SUT - 1 John Street, Hawthorn, 3122'),
(15,	'09/20/2021',	'The George - 1 John Street, Hawthorn, 3122'),
(18	,   '09/30/2021',	'Room TB225 - SUT - 1 John Street, Hawthorn, 3122');

INSERT INTO ORDERLINE (ITEMID, CLIENTID, DATETIMEPLACED, QTY) VALUES
(3216,	12,	'09/20/21',	2),
(4326,	12,	'09/20/21',	1),
(3218,	21,	'09/14/21',	1),
(3214,	21,	'09/14/21',	1),
(4325,	21,	'09/14/21',	4),
(4327,	21,	'09/14/21',	2),
(3216,	21,	'09/27/21',	1),
(4327,	21,	'09/27/21',	1),
(3218,	21,	'09/27/21',	2),
(3216,	15,	'09/20/21',	2),
(4326,	15,	'09/20/21',	1),
(3216,	18,	'09/30/21',	1),
(4327,	18,	'09/30/21',	1);

SELECT O.ORGANISATIONNAME, C.NAME, "OR".DATETIMEPLACED, "OR".DELIVERYADDRESS, M.DESCRIPTION, OL.QTY
FROM ORDERLINE OL
INNER JOIN "ORDER" "OR"
ON "OR".DATETIMEPLACED = OL.DATETIMEPLACED AND "OR".CLIENTID = OL.CLIENTID
INNER JOIN MENUITEM M
ON M.ITEMID = OL.ITEMID
INNER JOIN CLIENT C
ON "OR".CLIENTID = C.CLIENTID
INNER JOIN ORGANISATION O
ON C.ORGID = O.ORGID 

SELECT O.ORGID "Organisation",  M.ITEMID "Menu Item", SUM(QTY) "Total Quantity Ordered"
FROM ORDERLINE OL
INNER JOIN "ORDER" "OR"
ON "OR".DATETIMEPLACED = OL.DATETIMEPLACED AND "OR".CLIENTID = OL.CLIENTID
INNER JOIN MENUITEM M
ON M.ITEMID = OL.ITEMID
INNER JOIN CLIENT C
ON "OR".CLIENTID = C.CLIENTID
INNER JOIN ORGANISATION O
ON C.ORGID = O.ORGID 
GROUP BY M.ITEMID, O.ORGID
ORDER BY O.ORGID, M.ITEMID

SELECT OL.CLIENTID, OL.DATETIMEPLACED, OL.ITEMID, OL.QTY
FROM ORDERLINE OL
INNER JOIN MENUITEM M
ON M.ITEMID = OL.ITEMID
WHERE UNITPRICE = (SELECT MAX(UNITPRICE)
FROM MENUITEM)

CREATE VIEW TASK5 AS
SELECT O.ORGANISATIONNAME, C.NAME, "OR".DATETIMEPLACED, "OR".DELIVERYADDRESS, M.DESCRIPTION, OL.QTY
FROM ORDERLINE OL
INNER JOIN "ORDER" "OR"
ON "OR".DATETIMEPLACED = OL.DATETIMEPLACED AND "OR".CLIENTID = OL.CLIENTID
INNER JOIN MENUITEM M
ON M.ITEMID = OL.ITEMID
INNER JOIN CLIENT C
ON "OR".CLIENTID = C.CLIENTID
INNER JOIN ORGANISATION O
ON C.ORGID = O.ORGID 


/*There are 13 rows in query 1, which means that 
the orderline table should have 13 rows as well*/
SELECT COUNT(*) FROM ORDERLINE

/*There are 9 rows in query two, therfore there
should be 9 unique organisation/item combos,
which the query below shows*/
SELECT DISTINCT O.ORGID "Organisation",  M.ITEMID "Menu Item"
FROM ORDERLINE OL
INNER JOIN "ORDER" "OR"
ON "OR".DATETIMEPLACED = OL.DATETIMEPLACED AND "OR".CLIENTID = OL.CLIENTID
INNER JOIN MENUITEM M
ON M.ITEMID = OL.ITEMID
INNER JOIN CLIENT C
ON "OR".CLIENTID = C.CLIENTID
INNER JOIN ORGANISATION O
ON C.ORGID = O.ORGID 
GROUP BY M.ITEMID, O.ORGID
ORDER BY O.ORGID, M.ITEMID

/*The item ID with the highest price is 3218, which
is the family sized tropical pizza*/
SELECT DESCRIPTION, ITEMID FROM MENUITEM 
WHERE UNITPRICE = ( SELECT MAX(UNITPRICE) FROM MENUITEM)
