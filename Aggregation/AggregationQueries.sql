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
