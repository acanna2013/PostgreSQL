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

-- Produce a list of the total number of slots booked per facility per month in the year of 2012. 
-- In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. 
-- The output table should consist of facility id, month and slots, sorted by the id and month. 
-- When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots)
FROM cd.bookings
WHERE starttime >= '2012-01-01' AND starttime < '2013-01-01'
GROUP BY ROLLUP(facid, month)
ORDER BY facid, month;

-- Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. 
-- The output table should consist of the facility id, name, and hours booked, sorted by facility id. Try formatting the hours to two decimal places.
SELECT fc.facid, fc.name, trim(TO_CHAR(SUM(slots) * 0.5, '9999.99'))
FROM cd.bookings bks
INNER JOIN cd.facilities fc ON fc.facid = bks.facid
GROUP BY fc.facid, fc.name
ORDER BY fc.facid;

-- Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
SELECT surname, firstname, m.memid, MIN(starttime)
FROM cd.members m
INNER JOIN cd.bookings b ON m.memid = b.memid
WHERE starttime > '2012-09-01'
GROUP BY m.memid, surname, firstname
ORDER BY m.memid;

-- Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.
SELECT (
  SELECT COUNT(*)
  FROM cd.members), firstname, surname
FROM cd.members
GROUP BY firstname, surname, joindate
ORDER BY joindate;

-- Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. 
-- Remember that member IDs are not guaranteed to be sequential.
SELECT firstname, surname
FROM cd.members
ORDER BY joindate;

-- Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
SELECT facid, total from (
  SELECT facid, sum(slots) total, RANK() OVER(ORDER BY sum(slots) DESC) rank
  FROM cd.bookings
  GROUP BY facid
  ) as ranked
  where rank = 1;
  
-- Produce a list of members (including guests), along with the number of hours they've booked in facilities, rounded to the nearest ten hours. 
-- Rank them by this rounded figure, producing output of first name, surname, rounded hours, rank. Sort by rank, surname, and first name.
SELECT firstname, surname, 
((SUM(bks.slots)+10)/20)*10,
RANK() OVER(ORDER BY ((SUM(bks.slots)+10)/20)*10 DESC) rank
FROM cd.bookings bks
INNER JOIN cd.members m ON bks.memid = m.memid
GROUP BY m.memid
ORDER BY rank, surname, firstname;

