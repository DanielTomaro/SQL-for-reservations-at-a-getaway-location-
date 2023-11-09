#Task 1

#1

SELECT C.Name, COUNT(*) AS ReservationCount
FROM CLIENT C
JOIN RESERVATION R ON C.ClientNo = R.ClientNo
GROUP BY C.Name
ORDER BY ReservationCount DESC
FETCH FIRST 1 ROWS ONLY;

#answer is Robin Williams with 5 reservations

#2

SELECT C.Name
FROM CLIENT C
JOIN RESERVATION R ON C.ClientNo = R.ClientNo
WHERE R.EndDate - R.StartDate = (
    SELECT MAX(R2.EndDate - R2.StartDate)
    FROM RESERVATION R2
)
AND ROWNUM = 1;

#Answer is Janice Freeman with 10 days in duration

#3

SELECT A.RoomNo, AT.AccTypeName, AT.AccTypeRate, R.NoOfGuests
FROM CLIENT C
JOIN RESERVATION R ON C.ClientNo = R.ClientNo
JOIN RESERVATION_ACCOMMODATION RA ON R.ResNo = RA.ResNo
JOIN ACCOMMODATION A ON RA.RoomNo = A.RoomNo
JOIN ACCOMMODATION_TYPE AT ON A.AccTypeID = AT.AccTypeID
WHERE C.Name LIKE '%Perez%'

#Answer is
#ROOMNO	ACCTYPENAME	ACCTYPERATE	NOOFGUESTS
#102		Deluxe Single		55	  	1
#301		Honeymoon Cottage	100		2

#4

SELECT oi.InstrName
FROM OUTDOOR_INSTRUCTOR oi
JOIN SUPERVISION s ON oi.InstructorID = s.SupervisorID
GROUP BY oi.InstrName
HAVING COUNT(s.ResNo) = (
    SELECT MAX(supervision_count)
    FROM (
        SELECT COUNT(s.ResNo) AS supervision_count
        FROM OUTDOOR_INSTRUCTOR oi
        JOIN SUPERVISION s ON oi.InstructorID = s.SupervisorID
        GROUP BY oi.InstrName
    )
)

#Answer is Aaron Spencer

#5

SELECT AVG(EndDate - StartDate) AS AverageDuration
FROM RESERVATION;

# Average is 3.8 days

SELECT ResNo, (EndDate - StartDate) AS Duration
FROM RESERVATION
WHERE (EndDate - StartDate) > (
    SELECT AVG(EndDate - StartDate)
    FROM RESERVATION
)


#Answer is
#RESNO	DURATION
#1		4
#2		5
#3		10
#8		4
#9		5
#10		5
#11		5
#13		5
#14		4
#18		4
#20		5

#Task 2

#1

#Procedure

CREATE OR REPLACE PROCEDURE PromoteOutdoorActivity IS
BEGIN
    FOR client IN (
        SELECT c.Name, c.Phone, c.Email
        FROM CLIENT c
        WHERE c.ClientNo NOT IN (
            SELECT cp.ClientNo
            FROM CLIENT_PREFERENCE cp
            INNER JOIN CCONDITION cc ON cp.ClientNo = cc.ClientNo
            WHERE cc.Condition IN ('Heart Condition', 'Acrophobia')
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || client.Name);
        DBMS_OUTPUT.PUT_LINE('Phone: ' || client.Phone);
        DBMS_OUTPUT.PUT_LINE('Email: ' || client.Email);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    END LOOP;
END;
/


#Executing Procedure

BEGIN
    PromoteOutdoorActivity;
END;
/

#Results
#Name: Frank Write
#Phone: +61450612121
#Email: fwrite@hugedomains.com
#-----------------------------------
#Name: Juan Carpenter
#Phone: +61450661111
#Email: jcarpenter9@hugedomains.com
#-----------------------------------
#Name: Alex Mahone
#hone: +61450666777
#Email: amahone@hugedomains.com
#-----------------------------------
#Name: Diane Nichols
#hone: +61450666431
#Email: dnichols@hugedomains.com
#-----------------------------------
#Name: Janice Freeman
#Phone: +61450666411
#Email: jfreeman@hugedomains.com
#-----------------------------------
#Name: Abdullah Maruf
#Phone: +61450664848
#Email: amaruf@hugedomains.com
#----------------------------------
#Name: Timothy Day
#Phone: +61450872445
#Email: tday6@hugedomains.com
#-----------------------------------
#Name: Richard Perry
#Phone: +61450212121
#Email: rperry@hugedomains.com
#-----------------------------------
#Name: Carlos Howard
#Phone: +61450672446
#Email: ghoward@hugedomains.com
#-----------------------------------
#Name: Gregory Perez
#Phone: +61450555433
#Email: gperez3@hugedomains.com
#-----------------------------------
#Name: Susan Moore
#Phone: +61450662222
#Email: smoore@hugedomains.com
#-----------------------------------

#2

#Function

CREATE OR REPLACE FUNCTION GetSupervisorName(reservationNo INT, activityID INT, dateVal DATE)
RETURN VARCHAR2
IS
    supervisorName VARCHAR2(255);
BEGIN
    -- Get the supervisor ID for the given reservation, activity, and date
    SELECT s.InstrName INTO supervisorName
    FROM SUPERVISION su
    INNER JOIN ACTIVITY_SUPERVISOR a ON su.SupervisorID = a.SupervisorID
    INNER JOIN OUTDOOR_INSTRUCTOR s ON a.SupervisorID = s.SupervisorID
    WHERE su.ResNo = reservationNo
    AND su.ActivityID = activityID
    AND su.Day = dateVal;

    -- If no outdoor instructor is found, check for masseuse
    IF supervisorName IS NULL THEN
        SELECT m.MassName INTO supervisorName
        FROM SUPERVISION su
        INNER JOIN ACTIVITY_SUPERVISOR a ON su.SupervisorID = a.SupervisorID
        INNER JOIN MASSEUSE m ON a.SupervisorID = m.SupervisorID
        WHERE su.ResNo = reservationNo
        AND su.ActivityID = activityID
        AND su.Day = dateVal;
    END IF;

    -- If no masseuse is found, check for swimming instructor
    IF supervisorName IS NULL THEN
        SELECT sw.SwimName INTO supervisorName
        FROM SUPERVISION su
        INNER JOIN ACTIVITY_SUPERVISOR a ON su.SupervisorID = a.SupervisorID
        INNER JOIN SWIMMING_INSTRUCTOR sw ON a.SupervisorID = sw.SupervisorID
        WHERE su.ResNo = reservationNo
        AND su.ActivityID = activityID
        AND su.Day = dateVal;
    END IF;

    RETURN supervisorName;
END;
/

SELECT
    res.ResNo,
    res.StartDate,
    res.EndDate,
    act.ActName,
    sup.Day,
    GetSupervisorName(res.ResNo, act.ActivityID, sup.Day) AS SupervisorName
FROM
    RESERVATION res
    INNER JOIN SUPERVISION sup ON res.ResNo = sup.ResNo
    INNER JOIN ACTIVITY act ON sup.ActivityID = act.ActivityID;


#Results


#RESNO	STARTDATE	ENDDATE	ACTNAME	DAY	SUPERVISORNAME
#1	01-Feb-2016	05-Feb-2016	Hot Air Balloon Ride	02-Feb-2016	Aaron Spencer
#1	01-Feb-2016	05-Feb-2016	Mountaineering	03-Feb-2016	Adam Addison
#2	05-Jan-2016	10-Jan-2016	Bungee Jumping	06-Jan-2016	Adam Addison
#2	05-Jan-2016	10-Jan-2016	Sauna	08-Jan-2016	-
#4	03-Jan-2016	06-Jan-2016	Hot Air Balloon Ride	04-Jan-2016	Aaron Spencer
#5	20-Feb-2016	22-Feb-2016	Rafting	20-Feb-2016	Jony Abbott
#5	20-Feb-2016	22-Feb-2016	Spa	21-Feb-2016	-
#6	25-Feb-2016	28-Feb-2016	Sauna	26-Feb-2016	-
#9	10-Mar-2016	15-Mar-2016	Hot Air Balloon Ride	10-Mar-2016	Aaron Spencer
#9	10-Mar-2016	15-Mar-2016	Swimming	12-Mar-2016	-
#9	10-Mar-2016	15-Mar-2016	Spa	13-Mar-2016	-
#9	10-Mar-2016	15-Mar-2016	Spa	14-Mar-2016	-
#10	15-Mar-2016	20-Mar-2016	Hot Air Balloon Ride	15-Mar-2016	Aaron Spencer
#10	15-Mar-2016	20-Mar-2016	Mountaineering	19-Mar-2016	Adam Addison
#12	15-Apr-2016	15-Apr-2016	Hot Air Balloon Ride	15-Apr-2016	Ehsan Bell
#14	17-May-2016	21-May-2016	Rafting	17-May-2016	Ray Write
#14	17-May-2016	21-May-2016	Fishing	18-May-2016	Albert Whitecker
#14	17-May-2016	21-May-2016	Swimming	19-May-2016	-
#14	17-May-2016	21-May-2016	Sauna	20-May-2016	-
#16	25-May-2016	27-May-2016	Fishing	26-May-2016	Jony Abbott
#17	25-Jun-2016	27-Jun-2016	Rafting	26-Jun-2016	Ray Write
#17	25-Jun-2016	27-Jun-2016	Spa	27-Jun-2016	-
#18	25-Aug-2016	29-Aug-2016	Sauna	26-Aug-2016	-
#19	21-Jul-2016	24-Jul-2016	Hot Air Balloon Ride	21-Jul-2016	Ehsan Bell
#19	21-Jul-2016	24-Jul-2016	Bungee Jumping	22-Jul-2016	Fransis Barnard
#19	21-Jul-2016	24-Jul-2016	Spa	19-Mar-2016	-
#20	01-Aug-2016	06-Aug-2016	Hot Air Balloon Ride	01-Aug-2016	Aaron Spencer
#20	01-Aug-2016	06-Aug-2016	Mountaineering	03-Aug-2016	Anthony De Silva

#Task 3

#Trigger

CREATE OR REPLACE TRIGGER CheckAquaphobiaRafting
BEFORE INSERT ON CLIENT_PREFERENCE
FOR EACH ROW
DECLARE
    aquaphobia_count INT;
    activity_exists INT;
BEGIN
    SELECT COUNT(*) INTO aquaphobia_count
    FROM CCONDITION
    WHERE ClientNo = :NEW.ClientNo AND Condition = 'Aquaphobia';
    
    SELECT COUNT(*) INTO activity_exists
    FROM OUTDOOR_ACTIVITY
    WHERE ActivityID = :NEW.ActivityID;
    
    IF aquaphobia_count > 0 AND activity_exists > 0 THEN
        raise_application_error(-20001, 'Clients with aquaphobia cannot select rafting as a preferred outdoor activity.');
    END IF;
END;
/


INSERT INTO CLIENT_PREFERENCE (ClientNo, ActivityID)
VALUES (2, 4);

#Results

ORA-20001: Clients with aquaphobia cannot select rafting as a preferred outdoor activity.
ORA-06512: at "GHRschema.CHECKAQUAPHOBIARAFTING", line 10
ORA-04088: error during execution of trigger 'GHRschema.CHECKAQUAPHOBIARAFTING'


