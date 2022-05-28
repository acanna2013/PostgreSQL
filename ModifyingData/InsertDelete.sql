-- The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
INSERT INTO cd.facilities VALUES(9, 'Spa', 20, 30, 100000, 800);

-- In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
-- facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.
INSERT INTO cd.facilities 
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES(9, 'Spa', 20, 30, 100000, 800), (10, 'Squash Court 2', 3.5, 17.5, 5000, 80);

-- Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, 
-- rather than specifying it as a constant. Use the following values for everything else:
-- Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
INSERT INTO cd.facilities 
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

-- We made a mistake when entering the data for the second tennis court. 
-- The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

