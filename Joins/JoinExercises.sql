-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT cd.bookings.starttime
FROM cd.bookings
INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
WHERE cd.members.surname = 'Farrell' AND cd.members.firstname = 'David';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
-- Return a list of start time and facility name pairings, ordered by the time.
SELECT cd.bookings.starttime, cd.facilities.name
FROM cd.bookings
INNER JOIN cd.facilities ON cd.facilities.facid = cd.bookings.facid
WHERE cd.facilities.name LIKE '%Tennis Court%' AND cd.bookings.starttime >= ('2012-09-21') AND cd.bookings.starttime < ('2012-09-22')
ORDER BY cd.bookings.starttime;

-- How can you output a list of all members who have recommended another member? 
-- Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
SELECT DISTINCT two.firstname, two.surname
FROM cd.members AS one
INNER JOIN cd.members AS two ON one.recommendedby = two.memid
ORDER BY surname, firstname;

-- How can you output a list of all members, including the individual who recommended them (if any)? 
-- Ensure that results are ordered by (surname, firstname).
SELECT one.firstname, one.surname, two.firstname, two.surname
FROM cd.members AS one
LEFT OUTER JOIN cd.members AS two ON one.recommendedby = two.memid 
ORDER BY one.surname, one.firstname;

-- How can you produce a list of all members who have used a tennis court? 
-- Include in your output the name of the court, and the name of the member formatted as a single column. 
-- Ensure no duplicate data, and order by the member name followed by the facility name.
SELECT DISTINCT cd.members.firstname || ' ' || cd.members.surname as member , cd.facilities.name as facility
FROM cd.members
INNER JOIN cd.bookings ON cd.members.memid = cd.bookings.memid
INNER JOIN cd.facilities ON cd.facilities.facid = cd.bookings.facid
WHERE cd.facilities.name LIKE '%Tennis Court%'
ORDER BY member, facility;

-- How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? 
-- Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), 
-- and the guest user is always ID 0. 
-- Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. 
-- Order by descending cost, and do not use any subqueries.
SELECT cd.members.firstname || ' ' || cd.members.surname AS member, cd.facilities.name AS facility, 
CASE
WHEN cd.members.memid = 0 THEN cd.bookings.slots*cd.facilities.guestcost
ELSE cd.bookings.slots*cd.facilities.membercost
END AS cost
FROM cd.members
INNER JOIN cd.bookings ON cd.members.memid = cd.bookings.memid
INNER JOIN cd.facilities ON cd.facilities.facid = cd.bookings.facid
WHERE cd.bookings.starttime >= '2012-09-14' AND cd.bookings.starttime < '2012-09-15' AND ((cd.members.memid = 0 AND guestcost*cd.bookings.slots > 30) OR (cd.members.memid != 0 AND membercost*cd.bookings.slots > 30))
ORDER BY cost DESC;
