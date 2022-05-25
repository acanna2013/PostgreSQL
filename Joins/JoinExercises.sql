-- How can you produce a list of the start times for bookings by members named 'David Farrell'?
SELECT cd.bookings.starttime
FROM cd.bookings
INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
WHERE cd.members.surname = 'Farrell' AND cd.members.firstname = 'David';
