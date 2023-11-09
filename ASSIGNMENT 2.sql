CREATE TABLE client (
    clientno INT PRIMARY KEY NOT NULL,
    name VARCHAR2(30),
    address VARCHAR2(30),
    phone INT,
    DOB DATE,
    sex VARCHAR2(6),
    occupation VARCHAR2(30),
    email VARCHAR2(30),
    martial_status VARCHAR2(3),
    anniversary DATE,
    spouse VARCHAR2(3)
);

CREATE TABLE Cconditions (
    clientno INT NOT NULL,
    conditions VARCHAR2(50) NOT NULL,
    PRIMARY KEY (clientno, conditions),
    FOREIGN KEY (clientno) REFERENCES client(clientno)
);

CREATE TABLE reservation (
    resno INT PRIMARY KEY NOT NULL,
    resdate DATE,
    Noofguests INT,
    startdate DATE,
    enddate DATE,
    status VARCHAR2(30),
    clientno INT not null,
    FOREIGN KEY (clientno) REFERENCES client(clientno)
);

CREATE TABLE activity (
    activityid INT PRIMARY KEY NOT NULL,
    actname VARCHAR2(30),
    risklevel VARCHAR2(10),
    actdescription VARCHAR2(150),
    actrate INT,
);

CREATE TABLE Outdoor_activity(
    activityid int PRIMARY KEY NOT NULL,
    FOREIGN KEY (activityid) REFERENCES activity(activityid)
);

CREATE TABLE Indoor_activity(
    activityid int PRIMARY KEY NOT NULL,
    location varchar2(30),
    openinghours int,
    FOREIGN KEY (activityid) REFERENCES activity(activityid)
);

CREATE TABLE accomodation (
    roomno INT PRIMARY KEY NOT NULL,
    accstatus VARCHAR2(30),
    levelno INT
    acctypeid int not null,
    connectedroomno int,
    FOREIGN KEY (acctypeid) REFERENCES accomodation_type(acctypeid)
    FOREIGN KEY (connectedroomno) REFERENCES accomodation(roomno)
);


CREATE TABLE accomodationtype (
    acctypeid INT PRIMARY KEY NOT NULL,
    noofbeds INT,
    acctypename VARCHAR2(30),
    acctyperate VARCHAR2(30)
);

CREATE TABLE equipment (
    equipmentid INT PRIMARY KEY NOT NULL,
    equipname VARCHAR2(30),
    stock VARCHAR2(50),
    nextinspection DATE
);

CREATE TABLE supplier (
    billercode INT PRIMARY KEY NOT NULL,
    businessname VARCHAR2(30),
    contactperson VARCHAR2(30),
    phone INT
);

CREATE TABLE supplies (
    equipmentid INT NOT NULL,
    billercode INT NOT NULL,
    PRIMARY KEY (equipmentid, billercode),
    FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid),
    FOREIGN KEY (billercode) REFERENCES supplier(billercode)
);

CREATE TABLE uses_equipment(
    activityid int PRIMARY KEY not null,
    equipmentid int PRIMARY KEY not null,
    FOREIGN KEY (activityid) REFERENCES activity(activityid)
    FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid)
);


CREATE TABLE client_preferernce (
    clientid INT PRIMARY KEY NOT NULL,
    activityid INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (clientid) REFERENCES client(clientno),
    FOREIGN KEY (activityid) REFERENCES activity(activityid)
);

CREATE TABLE reservation_accomodation (
    resno INT PRIMARY KEY NOT NULL,
    roomno INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (resno) REFERENCES reservation(resno),
    FOREIGN KEY (roomno) REFERENCES accomodation(roomno)
);

CREATE TABLE activitysupervisor (
    supervisorid INT PRIMARY KEY NOT NULL
);

CREATE TABLE outdoorinstructor (
    instructorid INT PRIMARY KEY NOT NULL,
    instrname VARCHAR2(30),
    instphone VARCHAR2(30),
    supervisorid INT not null,
    FOREIGN KEY (supervisorid) REFERENCES activitysupervisor(supervisorid)
);

CREATE TABLE Massuse (
    massuseid INT PRIMARY KEY NOT NULL,
    musename VARCHAR2(30),
    area VARCHAR2(30),
    musephone VARCHAR2(30),
    supervisorid INT,
    FOREIGN KEY (supervisorid) REFERENCES activitysupervisor(supervisorid)
);

CREATE TABLE swimminginstructor (
    swimmerid INT PRIMARY KEY NOT NULL,
    swimname VARCHAR2(30),
    swimphone VARCHAR2(30),
    supervisorid INT,
    FOREIGN KEY (supervisorid) REFERENCES activitysupervisor(supervisorid)
);

CREATE TABLE supervises (
    resno INT PRIMARY KEY NOT NULL,
    activityid INT PRIMARY KEY NOT NULL,
    supervisorid INT PRIMARY KEY NOT NULL,
    day VARCHAR2(15) NOT NULL,
    time DATE,
    FOREIGN KEY (resno) REFERENCES reservation(resno),
    FOREIGN KEY (activityid) REFERENCES activity(activityid),
    FOREIGN KEY (supervisorid) REFERENCES activitysupervisor(supervisorid),
);


#INSERTING DATA INTO TABLES

INSERT INTO client
VALUES (1, 'Daniel Tomaro', 'male', null, '123 apple street', 0401177745, 'daniel@latrobe.com', 'student', null, null, null)


INSERT INTO  Cconditions
VALUES (1, 'no conditions specified')

INSERT INTO  reservation
VALUES (2, '13-06-2000', 2, '13-07-2023', '15-07-2023', 1, null)

INSERT INTO  activity
VALUES (3, 'rock climbing', 'climing up a rocky mountain side', 100, 'high')

INSERT INTO  Outdoor_activity
VALUES (3)

INSERT INTO  Indoor_activity
VALUES (9, 'day spa', '9-5')

INSERT INTO  accomodation
VALUES (101,1, 'open', 5, 6)


INSERT INTO accomodationtype
VALUES (5, null, 1000, 3)


INSERT INTO  equipment
VALUES (10, 'safety harness', 'instock', '14-07=2023')

INSERT INTO  supplier
VALUES (200, 'john egan company', 'john egan', 0401144458)

INSERT INTO supplies
VALUES (10,200)

INSERT INTO uses_equipment
VALUES (3,10)

INSERT INTO client_preferernce
VALUES (1,3)

INSERT INTO reservation_accomodation
VALUES (2,101)

INSERT INTO activitysupervisor
VALUES (999)


INSERT INTO  outdoorinstructor
VALUES (9, 'micky johnson', 0409988845, 999)


INSERT INTO  Massuse
VALUES (99, 'cole smith', 0421133345, 'lower body', 999)


INSERT INTO swimminginstructor
VALUES (998, 'kyle chalmers', 0568883341, 999)


INSERT INTO  supervises
VALUES (2,3,999, 'monday', '10:00am')




















































