CREATE TABLE "Customer" (
  "CustomerID" int,
  "FirstName" varchar(50),
  "LastName" varchar(50),
  "Address" varchar(50),
  "PhoneNumber" varchar(50),
  "EmailAddress" varchar(50),
  CONSTRAINT Customer_pk PRIMARY KEY ("CustomerID")
);

CREATE INDEX Customer_idx1 ON "Customer"("LastName");
CREATE INDEX Customer_idx2 ON "Customer"("FirstName","LastName");


CREATE TABLE "OneWayTicket" (
  "SingleTicketID" int,
  "Price" int,
  "FromLocation" varchar(50),
  "AirportCheckInTime" timestamp,
  "FlightTime" timestamp,
  "ToLocation" varchar(50),
  "LastMinuteDiscount" int,
   CONSTRAINT SingleTicket_pk PRIMARY KEY ("SingleTicketID")
);

CREATE INDEX OneWayTicket_idx1 ON "OneWayTicket" ("FromLocation","ToLocation");


CREATE TABLE "MultiCityTicket" (
  "MultiTicketID" int,
  "Price" int,
  "FromLocation" varchar(50),
  "SingleTicketID1" int NOT NULL,
  "SingleTicketID2" int NOT NULL,
  "SingleTicketID3" int,
  "SingleTicketID4" int,
  "ToLocation" varchar(50),
  "MultiCityDiscount" int,
  
  CONSTRAINT MultiCity_pk PRIMARY KEY ("MultiTicketID"),
  
      CONSTRAINT fk_MSingleTicketID1 FOREIGN KEY ("SingleTicketID1")
      REFERENCES pdworako."OneWayTicket"("SingleTicketID"),
    
        CONSTRAINT fk_MSingleTicketID2 FOREIGN KEY ("SingleTicketID2")
        REFERENCES pdworako."OneWayTicket"("SingleTicketID"),
    
        CONSTRAINT fk_MSingleTicketID3 FOREIGN KEY ("SingleTicketID3")
        REFERENCES pdworako."OneWayTicket"("SingleTicketID"),
    
        CONSTRAINT fk_MSingleTicketID4 FOREIGN KEY ("SingleTicketID4")
        REFERENCES pdworako."OneWayTicket"("SingleTicketID")
  
);

CREATE INDEX MultiCity_idx1 ON "MultiCityTicket"("SingleTicketID1","SingleTicketID2");


CREATE TABLE "RoundTripTicket" (
  "RoundTicketID" int,
  "SingleTicketID1" int NOT NULL,
  "SingleTicketID2" int NOT NULL,
  "FromLocation" varchar(50),
  "ToLocation" varchar(50),
  "RoundTripDiscount" int,
    
    CONSTRAINT RoundTrip_pk PRIMARY KEY ("RoundTicketID"),
    
    CONSTRAINT fk_SingleTicketID1 FOREIGN KEY ("SingleTicketID1")
    REFERENCES pdworako."OneWayTicket"("SingleTicketID"),
    
    CONSTRAINT fk_SingleTicketID2 FOREIGN KEY ("SingleTicketID2")
    REFERENCES pdworako."OneWayTicket"("SingleTicketID")
);

CREATE INDEX RoundTrip_idx1 ON "RoundTripTicket"("SingleTicketID1","SingleTicketID2");

CREATE TABLE "FlightTicket" (
  "TicketID" int,
  "MultiTicketID" int,
  "RoundTicketID" int,
  "SingleTicketID" int,
  "FinalPrice" int,
  Constraint FlightTicket_pk PRIMARY KEY ("TicketID"),
  
    CONSTRAINT fk_MultiKey FOREIGN KEY ("MultiTicketID")
    REFERENCES pdworako."MultiCityTicket"("MultiTicketID"),
    
     CONSTRAINT fk_RoundKey FOREIGN KEY ("RoundTicketID")
     REFERENCES pdworako."RoundTripTicket"("RoundTicketID"),
    
     CONSTRAINT fk_SingleKey FOREIGN KEY ("SingleTicketID")
     REFERENCES pdworako."OneWayTicket"("SingleTicketID"),
     
    CONSTRAINT tick_one_is_not_null CHECK (COALESCE("MultiTicketID", "RoundTicketID", "SingleTicketID") IS NOT NULL )
  
);

CREATE INDEX FlightTicket_idx1 ON "FlightTicket"("MultiTicketID","RoundTicketID","SingleTicketID");

CREATE TABLE "BookingOrder" (
  "OrderID" int,
  "OrderTime" timestamp,
  "CustomerID" int NOT NULL,
  "TicketID" int NOT NULL,
  
    CONSTRAINT Order_pk PRIMARY KEY ("OrderID"),
 
    CONSTRAINT fk_CustomerID FOREIGN KEY ("CustomerID")
    REFERENCES pdworako."Customer"("CustomerID"),
    
    CONSTRAINT fk_ticket FOREIGN KEY ("TicketID")
    REFERENCES pdworako."FlightTicket"("TicketID")
);

CREATE INDEX BookingOrder_idx1 ON "BookingOrder"("OrderID","CustomerID");


CREATE SEQUENCE OneWayTicketSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;

CREATE SEQUENCE CustomerIDSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;

CREATE SEQUENCE BookingIDSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;

CREATE SEQUENCE MultiCityIDSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;

CREATE SEQUENCE RoundTripIDSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;

CREATE SEQUENCE FlightTicketIDSeq
START WITH 1
MAXVALUE 99999999
MINVALUE 1
CACHE 20
NOORDER;


CREATE OR REPLACE TRIGGER OneWayTicketTrigger
BEFORE INSERT ON "OneWayTicket" FOR EACH ROW
BEGIN
  SELECT pdworako.OneWayTicketSeq.NEXTVAL
  INTO :NEW."SingleTicketID"
  FROM DUAL;
END;

CREATE OR REPLACE TRIGGER CustomerIDTrigger
BEFORE INSERT ON "Customer" FOR EACH ROW
BEGIN
  SELECT pdworako.CustomerIDSeq.NEXTVAL
  INTO :NEW."CustomerID"
  FROM DUAL;
END;

CREATE OR REPLACE TRIGGER BookingIDTrigger
BEFORE INSERT ON "BookingOrder" FOR EACH ROW
BEGIN
  SELECT pdworako.BookingIDSeq.NEXTVAL
  INTO :NEW."OrderID"
  FROM DUAL;
END;

CREATE OR REPLACE TRIGGER MultiCityIDTrigger
BEFORE INSERT ON "MultiCityTicket" FOR EACH ROW
BEGIN
  SELECT pdworako.MultiCityIDSeq.NEXTVAL
  INTO :NEW."MultiTicketID"
  FROM DUAL;
END;

CREATE OR REPLACE TRIGGER RoundTripIDTrigger
BEFORE INSERT ON "RoundTripTicket" FOR EACH ROW
BEGIN
  SELECT pdworako.RoundTripIDSeq.NEXTVAL
  INTO :NEW."RoundTicketID"
  FROM DUAL;
END;

CREATE OR REPLACE TRIGGER FlightTicketIDTrigger
BEFORE INSERT ON "FlightTicket" FOR EACH ROW
BEGIN
  SELECT pdworako.FlightTicketIDSeq.NEXTVAL
  INTO :NEW."TicketID"
  FROM DUAL;
END;



INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Yeo','Perkins','P.O. Box 248, 2896 Ac Rd.','07691 968918','penatibus@tristiquesenectus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Whilemina','Miller','185-4859 Lectus Rd.','0341 664 3057','arcu.Vestibulum.ante@libero.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lester','Espinoza','254-4777 In Av.','07624 005397','Nam.ligula.elit@accumsaninterdum.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kylan','Emerson','P.O. Box 227, 1059 Risus. St.','0845 46 48','elit@pharetrasedhendrerit.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lydia','Richmond','Ap #996-1536 Quisque Rd.','055 6598 9555','Pellentesque.habitant.morbi@magnanecquam.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('McKenzie','Noel','Ap #853-711 Nec, Street','076 9935 2897','orci.Phasellus@maurisaliquameu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jasper','Mcgowan','6772 Donec Road','056 3454 6191','dictum.Phasellus@ipsumporta.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Aquila','Carter','P.O. Box 881, 9312 Enim St.','(01543) 45066','diam.Duis.mi@quis.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kerry','Morris','240-1045 Imperdiet St.','(0121) 455 1445','eros.Nam@eu.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Amal','Robinson','P.O. Box 758, 1171 At, Av.','(0115) 272 0411','consectetuer@tortoratrisus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Kimberley','Cooke','P.O. Box 577, 1334 Sed, Road','07783 657115','volutpat.Nulla@tempuseuligula.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Quin','Garza','619-129 Orci Avenue','07886 317073','tristique@miloremvehicula.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jade','Stone','9275 Lorem Rd.','0872 480 5365','tempor.augue.ac@montes.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Tamekah','Diaz','Ap #315-2243 Cursus Rd.','(029) 3628 9099','amet.ante@Duisrisusodio.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Raja','Randall','4428 Facilisis. Street','(029) 1037 8182','semper.egestas@mauris.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Timothy','Rice','7204 Egestas Rd.','(025) 1616 5971','Nunc.ut.erat@lacusMauris.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Alvin','Gross','655-1395 Nulla Av.','076 5918 6800','nisl.elementum@Nunc.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Raphael','Navarro','Ap #949-771 Risus. Street','0951 316 6325','Etiam.gravida@nibhDonecest.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lane','Maxwell','P.O. Box 109, 3014 Dui. Av.','(0101) 297 0016','vitae@ipsumdolor.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Roanna','Skinner','Ap #220-7277 Ultrices Avenue','(016250) 54296','purus.accumsan@arcu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Zelenia','Morales','5755 Morbi Rd.','070 8063 4359','Duis@molestie.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Stephen','Rich','Ap #664-1317 Molestie Av.','(011966) 91852','dignissim.Maecenas.ornare@acorciUt.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Damian','Bush','Ap #770-7991 Nullam Road','07624 588937','nisl.Maecenas.malesuada@Quisquefringilla.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Emerald','Gross','Ap #195-1253 Et Road','(01717) 81722','malesuada@vulputatelacus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Zenaida','Logan','Ap #173-2507 Suspendisse Road','(016977) 8253','lobortis@metus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Gretchen','Bernard','Ap #891-244 Sagittis Street','0800 490 9804','luctus@sapien.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Nayda','Clemons','Ap #373-9923 Felis Av.','0928 835 5000','cursus@Quisque.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Adrian','Montgomery','975-1628 Erat, Av.','070 5547 9490','ipsum.dolor.sit@aptent.co.uk');





INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (960,'Pizzoferrato','2020-05-25 07:51:17','2019-08-25 04:57:47','Beawar',17);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1567,'Sgonico','2020-03-27 17:48:57','2019-02-13 20:47:50','Arbroath',76);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1977,'Friedberg','2019-11-07 04:27:26','2020-04-11 02:56:28','Bludenz',72);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1868,'Denver','2019-12-03 04:13:38','2020-07-13 05:30:50','Bettiah',39);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1098,'Södertälje','2019-08-27 18:54:28','2020-06-20 21:18:28','Dawson Creek',30);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (848,'Redcliffe','2020-11-29 20:41:57','2019-07-18 12:00:34','Bajardo',9);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (710,'Massa e Cozzile','2019-04-11 13:07:31','2020-07-17 22:42:06','Massimino',41);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (750,'Copertino','2020-10-15 05:44:43','2020-03-06 04:56:14','Collecchio',6);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1084,'Cisano Bergamasco','2020-12-09 03:59:45','2020-02-29 10:30:15','Daussoulx',30);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (397,'Guben','2020-11-19 01:32:54','2020-07-05 00:12:42','Codó',24);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1819,'Brisbane','2020-11-09 22:51:38','2019-03-24 19:10:30','Orange',53);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1134,'Chihuahua','2019-08-04 13:22:00','2019-06-27 21:33:16','Helmond',48);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1218,'Yangsan','2020-08-12 21:30:55','2021-01-05 11:40:30','Guadalajara',95);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (889,'Sahiwal','2019-12-12 16:15:22','2019-09-14 17:05:33','Merzig',34);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (994,'Castel Giorgio','2019-02-11 02:44:16','2020-09-04 22:40:05','Hoyerswerda',8);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (869,'Pallavaram','2020-10-23 07:48:56','2020-11-04 23:46:25','Cranbrook',96);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1996,'Poza Rica','2020-04-26 12:36:25','2019-10-05 08:25:47','Solnechnogorsk',87);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1815,'Saint-Denis','2019-11-06 00:11:54','2020-04-13 08:04:05','Vanderhoof',51);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (495,'Olsztyn','2019-05-07 08:37:30','2019-05-18 17:51:31','Lancaster',84);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1664,'Bronnitsy','2020-07-20 20:45:35','2019-05-20 08:10:46','Camerino',22);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (575,'Dadu','2020-05-04 19:04:52','2020-04-26 02:53:54','Hartford',40);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1693,'Dhule','2019-08-27 08:40:46','2020-03-15 20:59:32','Lugnano in Teverina',68);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (76,'Genova','2020-02-25 03:22:51','2020-12-25 22:46:00','Alassio',96);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (329,'Cholet','2020-07-23 04:25:16','2020-02-29 11:20:45','Gonda',77);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1703,'Crecchio','2020-03-08 05:06:28','2019-06-25 19:28:53','Girifalco',86);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1611,'BiercŽe','2020-03-03 02:51:42','2020-04-06 04:38:26','Harrison Hot Springs',36);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1564,'Rebecq','2020-12-01 10:40:05','2019-09-15 21:20:39','Lansing',48);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1724,'Labrecque','2020-07-09 23:32:49','2020-08-05 15:08:30','Warwick',76);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1715,'Campli','2020-09-10 17:25:14','2019-08-02 07:43:37','Jodoigne',94);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1272,'Juan Fernández','2020-02-06 12:55:17','2020-02-26 01:06:46','Viano',17);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1597,'?kersberga','2020-09-16 06:28:54','2019-08-14 01:20:33','Loreto',80);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1420,'Villamassargia','2020-08-29 21:07:06','2020-06-09 13:33:17','Valley East',34);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1336,'Yuryuzan','2019-03-17 00:29:29','2020-05-14 17:26:37','Söderhamn',19);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1700,'Dollard-des-Ormeaux','2020-12-17 07:51:59','2020-11-19 20:38:03','Buren',63);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1692,'Brin-Navolok','2019-10-29 02:56:33','2019-12-26 13:42:59','Thanjavur',99);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1340,'Rock Springs','2020-08-25 21:27:41','2020-03-05 19:29:51','Herne',35);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1513,'Strathcona County','2019-10-17 23:07:28','2019-12-27 00:13:03','Stavoren',66);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1088,'Tierra Amarilla','2020-07-28 09:46:59','2020-05-23 01:25:06','Port Hope',39);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (68,'Hollange','2020-07-24 18:36:28','2019-09-14 09:10:42','Milmort',69);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (136,'Coatbridge','2020-04-04 22:26:41','2020-03-09 09:21:35','Lampeter',76);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1403,'Oxford County','2020-12-27 00:27:48','2020-07-14 12:16:15','Baltimore',45);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1594,'Wals-Siezenheim','2020-03-09 09:49:54','2019-10-04 11:40:33','Savona',4);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1031,'Kansas City','2019-07-30 03:57:27','2020-11-04 11:32:19','Overrepen',9);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (172,'Algeciras','2020-04-02 00:28:18','2019-07-11 14:03:40','Bhagalpur',58);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1749,'Hilo','2019-08-01 11:38:56','2019-08-06 10:22:56','Palembang',90);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (735,'Santa Rosa de Cabal','2020-08-10 22:04:29','2021-01-08 10:12:04','Borgo Valsugana',44);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1098,'Tumaco','2020-07-05 02:09:34','2019-08-18 11:01:22','Ingolstadt',23);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (731,'Mission','2021-01-06 18:47:01','2019-06-17 16:54:59','Sandviken',99);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1823,'Serskamp','2020-11-03 05:03:26','2020-09-28 10:38:38','Rockford',24);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1265,'Thuin','2020-11-21 10:05:44','2019-09-06 14:22:23','SŽlange',11);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (769,'Montpelier','2020-01-10 23:46:43','2020-02-26 13:24:15','Torghar',1);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (418,'Whitewater Region Township','2020-11-30 23:54:49','2020-05-08 09:40:51','Portico e San Benedetto',49);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1499,'Auldearn','2020-10-01 13:35:23','2019-04-05 00:09:35','Köflach',52);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1820,'Graz','2020-08-20 07:52:47','2019-03-22 14:04:48','Uddevalla',3);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (497,'Mala','2020-11-04 03:37:31','2020-10-24 14:53:02','Longano',42);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1309,'Louisville','2019-04-11 19:57:03','2020-08-28 04:47:12','Zvenigorod',5);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1436,'Nijlen','2020-07-16 12:19:26','2019-04-19 19:33:18','Vielsalm',47);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1902,'Kaster','2019-12-05 10:36:40','2019-12-29 05:00:57','Dampremy',50);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (243,'Richmond','2020-06-07 12:12:20','2020-09-24 11:14:18','Griesheim',26);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (369,'Broken Hill','2019-08-20 06:29:33','2020-01-05 01:07:30','Aurora',56);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1272,'Ajmer','2020-09-22 19:26:51','2020-02-16 07:19:47','Tucapel',62);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (879,'Aserrí','2019-09-04 20:35:39','2019-05-28 12:05:38','Osgoode',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1712,'Fratta Todina','2019-09-09 17:17:22','2020-02-12 10:47:25','Baie-Comeau',8);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (778,'Port Hope','2020-07-11 15:03:57','2020-01-02 02:07:41','Monte San Pietrangeli',21);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (277,'Kumluca','2019-12-18 03:23:40','2020-01-23 05:21:12','Saint-GŽry',55);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (806,'Berceto','2019-03-21 18:46:48','2019-12-14 05:36:50','Bello',59);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (815,'Dijon','2020-11-25 02:57:25','2020-01-03 12:57:08','Lives-sur-Meuse',51);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (667,'Amroha','2019-02-17 16:02:41','2020-04-11 11:42:18','Clarksville',47);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (173,'Midway','2019-05-23 14:09:35','2020-11-20 14:28:52','Santander',36);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1206,'Zolder','2020-05-06 06:14:51','2020-10-12 22:53:59','Forge-Philippe',85);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (821,'Harelbeke','2019-06-25 12:54:07','2020-02-22 16:16:43','San Cristóbal de la Laguna',34);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1436,'Liedekerke','2021-01-07 10:45:29','2020-10-29 07:38:12','Laurencekirk',36);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (823,'Wazirabad','2020-06-29 08:23:59','2019-05-17 16:50:14','Kapuskasing',85);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (182,'Moradabad','2019-10-25 07:18:49','2020-05-28 08:39:28','Hull',80);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1717,'Baulers','2020-03-16 12:27:33','2020-07-20 08:44:02','Port Lincoln',25);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (64,'Sint-Stevens-Woluwe','2020-09-09 11:09:20','2019-02-05 09:57:32','Notre-Dame-de-la-Salette',66);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (636,'Sainte-Marie-sur-Semois','2019-02-28 10:28:28','2019-04-23 05:43:24','Dongducheon',42);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1936,'Thurso','2020-08-30 00:02:17','2019-04-06 01:59:31','Duque de Caxias',63);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1915,'Hamm','2020-11-18 18:39:53','2020-12-16 23:19:18','Vilna',91);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1909,'Dessau','2019-10-28 21:53:15','2019-12-30 23:27:02','La Seyne-sur-Mer',34);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (266,'S?te','2019-02-22 14:44:26','2020-06-07 23:25:20','Anklam',22);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1628,'Naumburg','2019-11-07 23:00:00','2020-11-08 01:17:34','Cache Creek',92);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Conchalí','2019-08-06 16:01:57','2020-09-09 21:36:07','Iguala',54);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (538,'Griesheim','2019-05-20 16:46:05','2020-06-07 12:50:53','Omal',82);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (742,'Longueville','2020-03-29 13:37:18','2019-09-15 16:35:14','Zandhoven',20);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1012,'Neufeld an der Leitha','2020-02-04 14:04:57','2019-12-27 16:50:37','Abbotsford',23);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1895,'East Gwillimbury','2019-11-28 21:53:20','2020-07-02 09:36:49','Dro',83);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1410,'Pembroke','2019-12-05 09:11:16','2019-07-11 06:20:33','Portico e San Benedetto',78);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (664,'Marburg','2020-02-29 22:18:27','2019-10-19 14:28:41','Steenhuffel',7);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (152,'Castelluccio Valmaggiore','2020-03-10 22:34:58','2020-12-05 00:22:42','Liedekerke',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1959,'Shatura','2019-11-27 01:09:39','2020-04-28 05:55:38','Vaulx-lez-Chimay',70);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (679,'Bunbury','2020-09-12 05:26:42','2019-08-01 15:14:50','Petorca',20);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1678,'Celle','2019-11-21 12:06:26','2019-09-20 18:12:41','Kamyzyak',9);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (134,'Zhob','2020-12-19 11:34:05','2019-10-11 11:15:27','Acquasparta',31);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (983,'North Saanich','2020-04-30 09:57:25','2019-01-25 19:33:50','Valda',14);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1334,'Blagoveshchensk','2020-05-07 23:12:54','2020-12-14 04:16:36','Bouge',97);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (691,'Thirimont','2020-06-14 10:59:02','2019-10-02 14:02:36','Melazzo',35);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1607,'Limbach-Oberfrohna','2019-08-18 15:30:39','2019-08-14 11:38:09','Lampernisse',43);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (186,'Anjou','2019-10-20 17:27:37','2019-04-12 10:01:23','Mezzana',60);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1039,'Eksaarde','2019-05-26 18:16:20','2019-03-15 02:12:31','Fraser Lake',37);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1306,'La Spezia','2019-10-28 06:42:12','2020-09-06 16:17:41','Opole',62);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1606,'Junagadh','2019-05-29 00:00:09','2020-06-27 05:59:41','Plato',87);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1884,'Langenburg','2020-06-05 01:50:22','2020-09-16 18:25:18','Owerri',78);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1806,'Chelsea','2019-01-22 00:11:09','2020-10-02 22:21:10','Amstetten',28);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1720,'Titagarh','2020-09-24 06:02:50','2019-04-13 09:54:49','Thunder Bay',43);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (321,'Tank','2020-12-05 12:14:36','2020-06-19 02:40:02','Paiguano',9);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1716,'Fontaine-l''Ev?que','2019-08-30 22:49:35','2019-02-13 18:38:57','Nowshera',76);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1948,'P?narbaş?','2019-12-25 00:15:21','2020-08-06 23:31:53','Coldstream',90);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (819,'Brandon','2019-06-04 16:42:40','2019-06-24 00:10:56','Aartrijke',63);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1290,'West Valley City','2019-05-28 15:59:18','2019-04-22 00:49:13','Firenze',32);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1973,'Asbestos','2020-07-16 20:06:49','2019-02-13 20:26:10','Bergeggi',70);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (100,'Rekem','2020-08-24 15:07:41','2019-07-05 13:34:50','Ponte San Nicol?',31);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1521,'Gembloux','2020-03-13 11:03:17','2020-04-19 13:31:28','Korba',51);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1307,'Ivangorod','2020-10-07 07:45:36','2019-03-16 10:13:36','Saravena',24);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1060,'K?z?lcahamam','2019-06-13 04:28:02','2020-04-21 15:30:29','Bydgoszcz',3);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (801,'Kohima','2019-02-10 09:03:29','2019-01-27 05:42:27','Bear',91);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (855,'Tontelange','2019-08-31 19:02:27','2019-12-09 07:22:29','Tredegar',51);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (98,'Poppel','2020-11-17 01:15:49','2019-03-01 01:58:14','Itapipoca',32);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1344,'Pitalito','2019-11-30 20:59:03','2019-12-12 00:16:59','Leerbeek',17);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1860,'Zapopan','2021-01-20 05:30:46','2019-07-29 09:30:24','La Baie',6);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1080,'San Benedetto del Tronto','2020-11-05 16:57:17','2019-12-24 15:29:17','Middelburg',23);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (2000,'St. Andrä','2019-11-07 17:54:34','2019-09-21 18:41:13','Ciudad Valles',74);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1399,'Drogenbos','2020-04-29 04:05:09','2020-06-14 12:23:54','Gasp?',6);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (640,'Utrecht','2019-02-18 14:58:32','2020-01-02 23:51:01','Gonda',24);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1767,'ThimŽon','2020-09-26 22:22:49','2019-04-10 05:12:58','South Portland',34);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1014,'Fokino','2020-09-19 22:54:48','2019-04-18 02:09:18','Pessac',30);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (643,'Burntisland','2019-12-26 20:45:01','2019-12-19 00:29:00','Jhansi',82);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1752,'Kingston-on-Thames','2019-05-19 12:51:48','2019-07-23 19:14:42','Palembang',98);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1520,'Dessel','2020-10-20 09:52:05','2020-07-26 09:43:58','Saint-Denis',52);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1133,'Pointe-aux-Trembles','2020-10-19 15:58:23','2020-12-24 11:14:24','Macul',1);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (479,'Herselt','2020-09-28 19:32:11','2019-08-03 09:43:16','Padang Sidempuan',83);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1721,'Sluis','2020-05-02 02:31:46','2020-11-18 11:19:54','Vejano',15);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (404,'Oristano','2021-01-05 08:43:41','2021-01-01 10:49:45','Acoz',84);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (62,'Acciano','2020-06-06 16:17:56','2019-07-05 00:12:12','Erie',8);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1460,'Meeffe','2020-04-24 11:17:09','2020-01-21 04:13:14','Taber',54);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1060,'Sambalpur','2019-05-31 03:40:58','2021-01-18 20:20:30','Oostkerk',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (343,'La Paz','2020-05-17 03:24:00','2019-04-30 16:44:54','Granada',29);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (369,'Benestare','2021-01-05 19:46:41','2019-06-25 11:34:50','Unnao',45);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1414,'Alandur','2020-12-08 23:33:41','2020-11-12 21:40:40','Medea',82);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1574,'Perwez','2020-09-04 22:47:14','2019-03-06 17:57:19','Notre-Dame-du-Nord',76);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1481,'San Zenone degli Ezzelini','2019-07-21 15:44:50','2020-03-23 20:23:50','Polcenigo',95);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1160,'Bridgnorth','2019-09-21 11:49:22','2020-07-06 18:11:28','Killa Abdullah',90);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (267,'Metairie','2020-05-24 18:04:04','2020-03-04 01:39:19','Shreveport',30);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (460,'Portland','2019-11-08 10:19:44','2020-07-20 22:46:29','Barkhan',56);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (315,'Castle Douglas','2019-10-29 10:45:23','2020-05-05 14:06:13','Tuktoyaktuk',77);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (949,'Burnie','2020-08-23 06:27:52','2019-07-29 22:34:39','Huaraz',41);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (668,'Gillette','2019-11-18 15:27:39','2020-12-24 08:26:42','Wodonga',39);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (896,'San Vicente de Ca?ete','2020-11-28 10:32:53','2019-05-05 18:07:43','Angoul?me',50);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1197,'Bhind','2020-03-31 17:27:40','2020-05-20 10:54:52','Rocca di Cambio',9);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1866,'Requínoa','2020-05-22 14:38:32','2020-07-20 22:07:30','Newark',82);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1905,'Abergavenny','2020-07-19 05:13:15','2020-03-22 08:58:49','Fremantle',81);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (550,'Klemskerke','2020-03-13 15:28:23','2020-06-18 05:18:15','Cavaion Veronese',58);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (928,'Des Moines','2020-03-03 03:27:38','2020-12-16 16:50:57','Abbotsford',74);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1262,'Porto Cesareo','2019-02-04 10:38:35','2019-12-10 17:47:33','Machalí',26);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (431,'Dornbirn','2019-12-28 05:40:12','2020-05-24 19:09:10','Zuienkerke',89);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1424,'Gojra','2020-12-30 03:48:26','2020-08-22 22:56:15','Vielsalm',92);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1232,'Braunau am Inn','2019-06-12 17:12:35','2020-02-19 06:57:03','Ozyorsk',45);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1273,'La Serena','2020-07-03 08:13:54','2020-06-25 06:24:45','Daiano',94);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (283,'Bamberg','2019-11-28 18:13:10','2020-05-09 17:20:51','Gianico',64);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1004,'Ensenada','2020-12-15 12:24:04','2019-11-19 00:25:04','Galbiate',100);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (709,'San Vito Chietino','2020-04-15 05:12:50','2019-09-07 14:44:00','Patna',29);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (783,'Fratta Todina','2020-11-22 07:38:53','2020-07-30 01:22:42','Norfolk',83);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1737,'Mango','2019-02-27 08:43:32','2019-11-10 17:21:34','Wood Buffalo',95);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1866,'Roccanova','2020-04-09 01:12:59','2020-01-28 16:59:20','San Rafael Abajo',98);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (963,'Falkensee','2019-04-08 22:09:28','2019-06-03 12:18:24','HomprŽ',98);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1326,'Termes','2020-11-04 09:51:21','2020-12-06 14:01:04','North Battleford',46);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (182,'Erie','2020-03-28 21:15:22','2019-02-02 14:33:25','Paine',86);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (894,'Tarrasa','2019-07-05 10:28:02','2020-11-02 17:10:38','Meridian',27);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1432,'Khanpur','2020-07-10 13:48:44','2019-10-13 16:25:30','Maidstone',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (673,'Nice','2019-07-28 08:44:53','2021-01-06 08:18:19','Merthyr Tydfil',46);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (502,'Oderzo','2019-09-19 15:12:15','2020-11-07 08:03:57','North Cowichan',85);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (889,'Overland Park','2020-04-22 03:36:54','2020-09-25 04:29:13','Le Cannet',27);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (723,'Gibbons','2020-02-20 18:15:36','2019-08-18 14:06:52','Linkhout',88);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (519,'Gander','2019-08-26 12:33:49','2019-03-30 10:23:26','Dundee',3);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1882,'Lelystad','2019-04-15 17:08:18','2020-12-24 20:26:54','San Pietro Mussolino',59);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1719,'Wayaux','2019-10-12 10:23:48','2019-08-12 00:48:27','Palombaro',11);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (267,'Sevilla','2020-06-13 17:03:43','2019-10-19 19:38:44','Ruvo del Monte',30);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (254,'Enines','2019-09-17 02:23:14','2020-11-04 08:11:31','Catacaos',80);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1568,'Guarapuava','2019-01-24 08:33:56','2019-09-27 20:31:49','Jaboat?o dos Guararapes',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1061,'Grand-Manil','2019-09-09 12:24:23','2020-04-12 04:48:14','Namen',59);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (838,'Leers-et-Fosteau','2019-07-25 10:56:22','2020-04-02 20:15:30','Faisalabad',42);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1788,'Collecchio','2019-10-11 02:12:49','2019-10-03 05:31:18','Kamarhati',77);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (251,'Portici','2020-04-22 00:22:16','2019-07-05 15:24:35','Poggio Berni',90);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (54,'Thionville','2020-07-04 06:28:00','2019-10-17 21:44:06','Allappuzha',23);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (423,'Truro','2020-12-18 16:45:11','2020-01-25 12:39:57','Ostrowiec Świętokrzyski',11);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1363,'Mainz','2020-03-02 23:19:06','2020-10-16 09:37:46','Nazilli',19);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1210,'Halen','2020-06-01 13:02:33','2019-04-12 23:29:10','Dereham',73);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (49,'Dole','2021-01-13 00:17:36','2020-04-23 01:47:08','Birmingham',67);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (937,'Henderson','2020-04-01 21:56:08','2019-07-17 14:12:03','Bima',97);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1105,'Surbo','2019-07-14 16:44:14','2019-08-14 20:48:15','Mandela',66);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1086,'Faridabad','2019-10-25 08:25:01','2020-08-25 08:35:50','Pickering',44);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (405,'Saarbrücken','2020-01-22 16:57:41','2019-02-04 16:29:17','B?gles',42);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1039,'Riparbella','2020-10-15 01:18:16','2019-04-20 23:41:14','Colico',70);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount")VALUES (1599,'Bucheon','2019-03-29 03:01:32','2019-12-29 04:03:54','Hénin-Beaumont',75);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1748,'Maria','2020-12-26 01:58:08','2020-06-15 15:19:46','Kaneohe',10);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1150,'Saint-Denis','2020-11-20 02:10:40','2020-04-20 13:14:24','Limbach-Oberfrohna',82);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (232,'Awka','2020-10-02 21:34:31','2019-04-18 07:38:50','Ely',19);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (718,'Heerhugowaard','2020-03-13 12:15:44','2020-04-14 15:53:23','Langenhagen',87);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1349,'Cambridge','2020-06-29 14:32:12','2019-12-11 19:12:44','P?narbaş?',78);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Vico nel Lazio','2021-01-17 08:14:29','2019-12-11 11:18:28','Sarreguemines',81);



INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1000,'Warsaw','2020-02-10 14:32:12','2020-02-10 15:00:00','LA',5);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (100,'LA','2020-02-20 08:14:29','2020-02-20 11:18:28','Warsaw',5);



INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1000,'Warsaw','2020-02-10 14:32:12','2020-02-10 15:00:00','Berlin',0);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (100,'Berlin','2020-02-20 08:14:29','2020-02-20 11:18:28','Paris',5);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (1000,'Paris','2020-02-10 14:32:12','2020-02-10 15:00:00','Rome',10);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (100,'Rome','2020-02-20 08:14:29','2020-02-20 11:18:28','Warsaw',15);


Select * FROM "FlightTicket";

INSERT INTO "RoundTripTicket" ("SingleTicketID1","SingleTicketID2","FromLocation","ToLocation","RoundTripDiscount")VALUES (201,202,'Warsaw','LA',10);

INSERT INTO "MultiCityTicket" ("Price","FromLocation","SingleTicketID1","SingleTicketID2","SingleTicketID3","SingleTicketID4","ToLocation","MultiCityDiscount")VALUES(2000, 'Warsaw', 203,204,205,206,'Berlin Paris Rome Warsaw',2);


INSERT INTO "FlightTicket" ("MultiTicketID","RoundTicketID","SingleTicketID","FinalPrice")VALUES (2,2,108,4600);



INSERT INTO "BookingOrder" ("OrderTime","CustomerID","TicketID") VALUES ('2020-02-10 14:32:12', 22, 2); 



INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Vico Lazio','2021-01-17 08:14:29','2019-12-11 11:18:28','Sarreguemines',81);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Vico ne','2021-01-17 08:14:29','2019-12-11 11:18:28','Sarreguemines',81);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Vico nel Lazio','2021-01-17 08:14:29','2019-12-11 11:18:28','Sarreguemines',81);
INSERT INTO "OneWayTicket" ("Price","FromLocation","AirportCheckInTime","FlightTime","ToLocation","LastMinuteDiscount") VALUES (87,'Vico nel io','2021-01-17 08:14:29','2019-12-11 11:18:28','Sarreguemines',81);



INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Yo','Perins','P.O. Box 248, 2896 Ac Rd.','07691 968918','penatibus@tristiquesenectus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Whilmina','Mller','185-4859 Lectus Rd.','0341 664 3057','arcu.Vestibulum.ante@libero.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Leter','Espioza','254-4777 In Av.','07624 005397','Nam.ligula.elit@accumsaninterdum.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('ylan','Eerson','P.O. Box 227, 1059 Risus. St.','0845 46 48','elit@pharetrasedhendrerit.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lyia','Richmnd','Ap #996-1536 Quisque Rd.','055 6598 9555','Pellentesque.habitant.morbi@magnanecquam.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('McKnzie','oel','Ap #853-711 Nec, Street','076 9935 2897','orci.Phasellus@maurisaliquameu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jaspr','Mcowan','6772 Donec Road','056 3454 6191','dictum.Phasellus@ipsumporta.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Aqila','Crter','P.O. Box 881, 9312 Enim St.','(01543) 45066','diam.Duis.mi@quis.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kery','Mrris','240-1045 Imperdiet St.','(0121) 455 1445','eros.Nam@eu.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Aal','Roinson','P.O. Box 758, 1171 At, Av.','(0115) 272 0411','consectetuer@tortoratrisus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Kiberley','ooke','P.O. Box 577, 1334 Sed, Road','07783 657115','volutpat.Nulla@tempuseuligula.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Qin','Grza','619-129 Orci Avenue','07886 317073','tristique@miloremvehicula.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jde','Stoe','9275 Lorem Rd.','0872 480 5365','tempor.augue.ac@montes.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Tamkah','Diz','Ap #315-2243 Cursus Rd.','(029) 3628 9099','amet.ante@Duisrisusodio.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Rja','Randal','4428 Facilisis. Street','(029) 1037 8182','semper.egestas@mauris.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Timoty','ice','7204 Egestas Rd.','(025) 1616 5971','Nunc.ut.erat@lacusMauris.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Alvn','ross','655-1395 Nulla Av.','076 5918 6800','nisl.elementum@Nunc.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Raphel','avarro','Ap #949-771 Risus. Street','0951 316 6325','Etiam.gravida@nibhDonecest.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lae','Mawell','P.O. Box 109, 3014 Dui. Av.','(0101) 297 0016','vitae@ipsumdolor.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Ronna','Sinner','Ap #220-7277 Ultrices Avenue','(016250) 54296','purus.accumsan@arcu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Zeleia','orales','5755 Morbi Rd.','070 8063 4359','Duis@molestie.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Stepen','Rch','Ap #664-1317 Molestie Av.','(011966) 91852','dignissim.Maecenas.ornare@acorciUt.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Damin','Bsh','Ap #770-7991 Nullam Road','07624 588937','nisl.Maecenas.malesuada@Quisquefringilla.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Emeald','ross','Ap #195-1253 Et Road','(01717) 81722','malesuada@vulputatelacus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Zenaia','Lgan','Ap #173-2507 Suspendisse Road','(016977) 8253','lobortis@metus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Gretchn','ernard','Ap #891-244 Sagittis Street','0800 490 9804','luctus@sapien.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Naya','Cemons','Ap #373-9923 Felis Av.','0928 835 5000','cursus@Quisque.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Adrin','ontgomery','975-1628 Erat, Av.','070 5547 9490','ipsum.dolor.sit@aptent.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Ye','erkins','P.O. Box 248, 2896 Ac Rd.','07691 968918','penatibus@tristiquesenectus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Whilmina','Miler','185-4859 Lectus Rd.','0341 664 3057','arcu.Vestibulum.ante@libero.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lestr','Espinza','254-4777 In Av.','07624 005397','Nam.ligula.elit@accumsaninterdum.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kyan','merson','P.O. Box 227, 1059 Risus. St.','0845 46 48','elit@pharetrasedhendrerit.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lyda','ichmond','Ap #996-1536 Quisque Rd.','055 6598 9555','Pellentesque.habitant.morbi@magnanecquam.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Mcenzie','oel','Ap #853-711 Nec, Street','076 9935 2897','orci.Phasellus@maurisaliquameu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jaser','Mcowan','6772 Donec Road','056 3454 6191','dictum.Phasellus@ipsumporta.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Auia','Cater','P.O. Box 881, 9312 Enim St.','(01543) 45066','diam.Duis.mi@quis.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kery','Mrris','240-1045 Imperdiet St.','(0121) 455 1445','eros.Nam@eu.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Aml','Ronson','P.O. Box 758, 1171 At, Av.','(0115) 272 0411','consectetuer@tortoratrisus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Kimberly','Coke','P.O. Box 577, 1334 Sed, Road','07783 657115','volutpat.Nulla@tempuseuligula.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Qun','Gara','619-129 Orci Avenue','07886 317073','tristique@miloremvehicula.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jae','tone','9275 Lorem Rd.','0872 480 5365','tempor.augue.ac@montes.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Tamekh','Daz','Ap #315-2243 Cursus Rd.','(029) 3628 9099','amet.ante@Duisrisusodio.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Raa','Radall','4428 Facilisis. Street','(029) 1037 8182','semper.egestas@mauris.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('imothy','Rie','7204 Egestas Rd.','(025) 1616 5971','Nunc.ut.erat@lacusMauris.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Avin','Gros','655-1395 Nulla Av.','076 5918 6800','nisl.elementum@Nunc.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('aphael','Nvarro','Ap #949-771 Risus. Street','0951 316 6325','Etiam.gravida@nibhDonecest.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lae','Maxell','P.O. Box 109, 3014 Dui. Av.','(0101) 297 0016','vitae@ipsumdolor.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Ronna','kinner','Ap #220-7277 Ultrices Avenue','(016250) 54296','purus.accumsan@arcu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Zelena','Moales','5755 Morbi Rd.','070 8063 4359','Duis@molestie.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Stephe','ih','Ap #664-1317 Molestie Av.','(011966) 91852','dignissim.Maecenas.ornare@acorciUt.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Damin','Bsh','Ap #770-7991 Nullam Road','07624 588937','nisl.Maecenas.malesuada@Quisquefringilla.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Emeald','ross','Ap #195-1253 Et Road','(01717) 81722','malesuada@vulputatelacus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Zenaia','Lgan','Ap #173-2507 Suspendisse Road','(016977) 8253','lobortis@metus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Grechen','Benard','Ap #891-244 Sagittis Street','0800 490 9804','luctus@sapien.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Naya','Cleons','Ap #373-9923 Felis Av.','0928 835 5000','cursus@Quisque.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Adran','Mtgomery','975-1628 Erat, Av.','070 5547 9490','ipsum.dolor.sit@aptent.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Ye','Prkins','P.O. Box 248, 2896 Ac Rd.','07691 968918','penatibus@tristiquesenectus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Wilemina','Mler','185-4859 Lectus Rd.','0341 664 3057','arcu.Vestibulum.ante@libero.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Leser','Espnoza','254-4777 In Av.','07624 005397','Nam.ligula.elit@accumsaninterdum.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Klan','merson','P.O. Box 227, 1059 Risus. St.','0845 46 48','elit@pharetrasedhendrerit.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lyda','ichmond','Ap #996-1536 Quisque Rd.','055 6598 9555','Pellentesque.habitant.morbi@magnanecquam.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('MKenzie','oel','Ap #853-711 Nec, Street','076 9935 2897','orci.Phasellus@maurisaliquameu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jaspr','Mgowan','6772 Donec Road','056 3454 6191','dictum.Phasellus@ipsumporta.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Aqila','Carer','P.O. Box 881, 9312 Enim St.','(01543) 45066','diam.Duis.mi@quis.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Kery','Moris','240-1045 Imperdiet St.','(0121) 455 1445','eros.Nam@eu.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Aml','Robison','P.O. Box 758, 1171 At, Av.','(0115) 272 0411','consectetuer@tortoratrisus.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Kimberle','ooke','P.O. Box 577, 1334 Sed, Road','07783 657115','volutpat.Nulla@tempuseuligula.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Qui','arza','619-129 Orci Avenue','07886 317073','tristique@miloremvehicula.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Jae','Sone','9275 Lorem Rd.','0872 480 5365','tempor.augue.ac@montes.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Tamekh','Daz','Ap #315-2243 Cursus Rd.','(029) 3628 9099','amet.ante@Duisrisusodio.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Rja','Radall','4428 Facilisis. Street','(029) 1037 8182','semper.egestas@mauris.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Tiothy','Rce','7204 Egestas Rd.','(025) 1616 5971','Nunc.ut.erat@lacusMauris.org');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Alvn','Grss','655-1395 Nulla Av.','076 5918 6800','nisl.elementum@Nunc.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Rahael','Navrro','Ap #949-771 Risus. Street','0951 316 6325','Etiam.gravida@nibhDonecest.edu');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Lae','Maxwll','P.O. Box 109, 3014 Dui. Av.','(0101) 297 0016','vitae@ipsumdolor.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Ranna','kinner','Ap #220-7277 Ultrices Avenue','(016250) 54296','purus.accumsan@arcu.ca');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Zeleni','Mrales','5755 Morbi Rd.','070 8063 4359','Duis@molestie.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Shen','h','Ap #664-1317 Molestie Av.','(011966) 91852','dignissim.Maecenas.ornare@acorciUt.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Dmian','Bh','Ap #770-7991 Nullam Road','07624 588937','nisl.Maecenas.malesuada@Quisquefringilla.net');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Emald','Gss','Ap #195-1253 Et Road','(01717) 81722','malesuada@vulputatelacus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Znaida','Lgan','Ap #173-2507 Suspendisse Road','(016977) 8253','lobortis@metus.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES  ('Gretn','Berd','Ap #891-244 Sagittis Street','0800 490 9804','luctus@sapien.co.uk');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress") VALUES ('Nda','Cmons','Ap #373-9923 Felis Av.','0928 835 5000','cursus@Quisque.com');
INSERT INTO "Customer" ("FirstName","LastName","Address","PhoneNumber","EmailAddress")VALUES ('Adrn','Monomery','975-1628 Erat, Av.','070 5547 9490','ipsum.dolor.sit@aptent.co.uk');





Select * FROM "OneWayTicket"
WHERE "Price" < 1000;

Select * FROM "OneWayTicket"
WHERE "Price" > 1000;


Select COUNT("SingleTicketID"), "Price"
FROM "OneWayTicket"
GROUP BY "Price"
HAVING COUNT("SingleTicketID") > 3;



alter index OneWayTicket_idx1 invisible;

explain plan for
Select COUNT("SingleTicketID"), "Price"
FROM "OneWayTicket"
GROUP BY "Price"
HAVING COUNT("SingleTicketID") > 3;

select *
from table (dbms_xplan.display);






alter index Customer_idx1 visible;
alter index Customer_idx2 visible;

Select COUNT("CustomerID")
FROM "Customer"
GROUP BY "Address";
select *
from table (dbms_xplan.display);












DROP SEQUENCE BOOKINGIDSEQ;
DROP SEQUENCE CUSTOMERIDSEQ;
DROP SEQUENCE FLIGHTTICKETIDSEQ;
DROP SEQUENCE MULTICITYIDSEQ;
DROP SEQUENCE ONEWAYTICKETSEQ;
DROP SEQUENCE ROUNDTRIPIDSEQ;


DROP TABLE pdworako."BookingOrder";
DROP TABLE pdworako."FlightTicket";
DROP TABLE pdworako."MultiCityTicket";
DROP TABLE pdworako."RoundTripTicket";
DROP TABLE pdworako."OneWayTicket";
DROP TABLE pdworako."Customer";
