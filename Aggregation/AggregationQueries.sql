-- For our first foray into aggregates, we're going to stick to something simple. 
-- We want to know how many facilities exist - simply produce a total count.
SELECT COUNT(facid)
FROM cd.facilities;

-- Produce a count of the number of facilities that have a cost to guests of 10 or more.
SELECT COUNT(*)
FROM cd.facilities
WHERE guestcost >= 10;

-- Produce a count of the number of recommendations each member has made. Order by member ID.
SELECT recommendedby, COUNT(*)
FROM cd.members
WHERE recommendedby is not null
GROUP BY recommendedby
ORDER BY recommendedby;

-- Produce a list of the total number of slots booked per facility. 
-- For now, just produce an output table consisting of facility id and slots, sorted by facility id.
SELECT fc.facid, SUM(bks.slots)
FROM cd.facilities fc
INNER JOIN cd.bookings bks ON bks.facid = fc.facid
GROUP BY fc.facid
ORDER BY fc.facid;

-- Produce a list of the total number of slots booked per facility in the month of September 2012. 
-- Produce an output table consisting of facility id and slots, sorted by the number of slots.
SELECT facid, SUM(slots) as count
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY count;

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. 
-- Produce an output table consisting of facility id and slots, sorted by the id and month.
SELECT facid, EXTRACT(MONTH FROM starttime) as month, SUM(slots) 
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

-- Find the total number of members (including guests) who have made at least one booking.
SELECT COUNT(DISTINCT memid)
FROM cd.bookings;

-- Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.
SELECT facid, SUM(slots) 
FROM cd.bookings
GROUP BY facid
HAVING sum(slots) > 1000
ORDER BY facid;

-- Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. 
-- Remember that there's a different cost for guests and members!
SELECT name, SUM(slots * CASE 
WHEN memid != 0 THEN membercost
ELSE guestcost
END) AS revenue
FROM cd.facilities fc
INNER JOIN cd.bookings bks ON bks.facid = fc.facid
GROUP BY fc.name
ORDER BY revenue;

-- Produce a list of facilities with a total revenue less than 1000. 
-- Produce an output table consisting of facility name and revenue, sorted by revenue. 
-- Remember that there's a different cost for guests and members!
SELECT name, 
SUM(slots * CASE
	WHEN memid = 0 THEN guestcost
	ELSE membercost
	END) AS revenue
FROM cd.facilities fc
INNER JOIN cd.bookings bks ON bks.facid = fc.facid
GROUP BY name
HAVING SUM(slots * CASE
	WHEN memid = 0 THEN guestcost
	ELSE membercost
	END) < 1000
ORDER BY revenue;

-- Output the facility id that has the highest number of slots booked. 
SELECT facid, SUM(slots) 
FROM cd.bookings
GROUP BY facid
ORDER BY SUM(slots) DESC
LIMIT 1;
