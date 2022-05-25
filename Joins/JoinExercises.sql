-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT cd.bookings.starttime
FROM cd.bookings
INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
WHERE cd.members.surname = 'Farrell' AND cd.members.firstname = 'David';

-- How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
