/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do.
Ans: SELECT *
FROM Facilities
WHERE membercost <>0
LIMIT 0 , 30
Tennis Court 1, Tennis Court 2, Massage room 1, Massage room2, Squash Court. */


/* Q2: How many facilities do not charge a fee to members?
Ans : 4 Facilities - Badminton Court, Table Tennis, Snooker Table,Pool Table. */


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question.
Ans: 
SELECT faceid,name,membercost,monthlymaintenance
FROM Facilities
WHERE membercost < (0.2*monthlymaintenance);
Tennis Court 1, Tennis Court 2, Massage room 1, Massage room2, Squash Court, snooker table, pool table,
Badminton Court, Table Tennis.

 */


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator.
Ans: 
SELECT * FROM Facilities
WHERE facid IN (1,5);
Tennis Court 2, Massage room 2 */


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question.
Ans:
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
     ELSE 'cheap' END AS maintenance_type
FROM Facilities; */


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution.
Ans:
SELECT firstname,surname, joindate FROM Members
ORDER BY joindate DESC;
Darren Smith joined on 2012-09-26 18:08:45  */


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name.
Ans:
SELECT DISTINCT CONCAT(firstname,' ', surname) AS customer_name, Members.memid, Facilities.name FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE Facilities.facid IN (0,1)
ORDER BY customer_name; */


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries.

solution1:

SELECT CONCAT(firstname,' ', surname) AS customer_name, Facilities.name, starttime, 
(Facilities.membercost*Bookings.slots*2) AS mem_costs ,(Facilities.guestcost* Bookings.slots*2) AS Guest_costs 
FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE ((Facilities.membercost*Bookings.slots*2 > 30.0) OR (Facilities.guestcost* Bookings.slots*2 >30.0))
AND Bookings.starttime BETWEEN '2012-09-14' and '2012-09-14 23:59:59'
ORDER BY Guest_costs DESC;
============================================================================================================================
Solution 2:

SELECT CONCAT(firstname,' ', surname) AS customer_name, 
Facilities.name, starttime, Facilities.membercost AS mem_costs ,(Facilities.guestcost* Bookings.slots*2) AS Guest_costs 
FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE (Facilities.membercost > 30.0 AND Members.memid <> 0)  OR (Facilities.guestcost* Bookings.slots*2 > 30 AND Members.memid = 0)
AND (Bookings.starttime BETWEEN '2012-09-14' and '2012-09-14 23:59:59')
ORDER BY Guest_costs DESC;
======================================================================================================================================
Solution 3:
SELECT surname AS Member, name AS Facility,
CASE
WHEN Members.memid =0
THEN Bookings.slots * Facilities.guestcost
ELSE Bookings.slots * Facilities.membercost
END AS cost
FROM Members
JOIN Bookings ON Members.memid = Bookings.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.starttime >= '2012-09-14'
AND Bookings.starttime < '2012-09-15'
AND ((Members.memid =0
AND Bookings.slots * Facilities.guestcost >30)
OR (Members.memid !=0
AND Bookings.slots * Facilities.membercost >30))
ORDER BY cost DESC;
-------------------------------------------------------
SELECT CONCAT(firstname,' ', surname) AS customer_name, 
Facilities.name, starttime, 
CASE WHEN Members.memid = 0 THEN Facilities.guestcost * Bookings.slots
     ELSE Facilities.membercost * Bookings.slots END AS cost

FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE ((Facilities.membercost * Bookings.slots > 30.0 AND Members.memid <> 0)  OR (Facilities.guestcost* Bookings.slots > 30 AND Members.memid = 0))
AND (Bookings.starttime BETWEEN '2012-09-14' AND '2012-09-14 23:59:59')
ORDER BY cost DESC;

 */

/* Q9: This time, produce the same result as in Q8, but using a subquery. 
Ans:

SELECT customer_name, Facility, cost, starttime FROM

(SELECT CONCAT(firstname,' ', surname) AS customer_name, 
Facilities.name AS Facility, starttime, 
CASE WHEN Members.memid = 0 THEN Facilities.guestcost * Bookings.slots
     ELSE Facilities.membercost * Bookings.slots END AS cost

FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE Bookings.starttime BETWEEN '2012-09-14' AND '2012-09-14 23:59:59') AS bookings

WHERE cost>30
ORDER BY cost DESC;

*/


/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
Ans:
SELECT customer_name, recommender_name
FROM (SELECT CONCAT(surname,' ', firstname) AS customer_name, 
  CASE WHEN Members.recommendedby = Members.memid THEN CONCAT(surname,' ', firstname)
 ELSE 'Nobody' END AS recommender_name FROM Members) AS names

ORDER BY customer_name;
----------------------------------------------------------------------------------------------------------------

SELECT 
    M.memid
    ,M.firstname
    ,M.surname
    ,M.address
    ,M.zipcode
    ,M.telephone
    ,R.firstname || ' ' || R.surname as recommendedby_name
    FROM Members AS M
    INNER JOIN Members AS R ON M.recommendedby = R.memid
    WHERE M.recommendedby IS NOT NULL
    ORDER BY
    M.surname
    ,M.firstname;

/* Q12: Find the facilities with their usage by member, but not guests */
Ans: 
SELECT  Members.memid, Members.firstname || ' ' || Members.surname,
Facilities.facid, Facilities.name, SUM(Bookings.slots) AS
usage FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE Members.memid > 0 
GROUP BY Facilities.name, Members.memid  ##### This is imp. here
ORDER BY usage DESC;

/* Q13: Find the facilities usage by month, but not guests */
Ans:
SELECT  name, month FROM (SELECT Facilities.name AS name, EXTRACT(MONTH FROM starttime) AS month FROM Bookings
INNER JOIN Members
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE (Members.memid <> 0 AND Bookings.memid <> 0)) AS new
GROUP BY month;
------------------------------------------------------------------
SELECT  Members.memid, Members.firstname || ' ' || Members.surname AS member_name,
Facilities.facid, Facilities.name, strftime('%m', Bookings.slots) AS
month,SUM(Bookings.slots) AS
usage
FROM Members
INNER JOIN Bookings 
ON Bookings.memid = Members.memid
INNER JOIN Facilities
ON Facilities.facid = Bookings.facid
WHERE Members.memid > 0 
GROUP BY Facilities.name, month
ORDER BY usage DESC;