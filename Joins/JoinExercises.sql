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
