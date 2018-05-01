/* CREATE TABLE FOR DEPARTMENT */
CREATE TABLE DEPARTMENT 
(
"ID" NUMBER, 
"NAME" VARCHAR2(30), 
 PRIMARY KEY ("ID")  
) ;

/* CREATE TABLE FOR EMP */
CREATE TABLE EMP
(
"ID" NUMBER, 
"MGR_ID" NUMBER, 
"DEPT_ID" NUMBER, 
"NAME" VARCHAR2(30), 
"SAL" NUMBER, 
"DOJ" DATE, 
 PRIMARY KEY ("ID") ENABLE, 
 FOREIGN KEY ("MGR_ID") REFERENCES EMP ("ID") ENABLE, 
 FOREIGN KEY ("DEPT_ID") REFERENCES DEPARTMENT ("ID") ENABLE
) ;

/* INSERT STATEMENT FOR DEPARTMENT */
INSERT INTO DEPARTMENT  values (1,'HR');
INSERT INTO DEPARTMENT  values (2,'Engineering');
INSERT INTO DEPARTMENT  values (3,'Marketing');
INSERT INTO DEPARTMENT  values (4,'Sales');
INSERT INTO DEPARTMENT  values (5,'Logistics');

/* INSERT STATEMENT FOR EMP */
INSERT INTO EMP  values (1, NULL, 2,'Hash', 100, to_date('2012-01-01', 'YYYY-MM-DD'));
INSERT INTO EMP  values (2, 1, 2, 'Robo', 100, to_date('2012-01-01', 'YYYY-MM-DD'));
INSERT INTO EMP  values (3, 2, 1, 'Privy', 50, to_date('2012-05-01', 'YYYY-MM-DD'));
INSERT INTO EMP  values (4, 1, 1, 'Inno', 50, to_date('2012-05-01', 'YYYY-MM-DD'));
INSERT INTO EMP  values (5, 2, 2, 'Anno', 80, to_date('2012-02-01', 'YYYY-MM-DD'));
INSERT INTO EMP  values (6, 1, 2, 'Darl', 80, to_date('2012-02-11', 'YYYY-MM-DD'));
INSERT INTO EMP  values (7, 1, 3, 'Pete', 70, to_date('2012-04-16', 'YYYY-MM-DD'));
INSERT INTO EMP  values (8, 7, 3, 'Meme', 60, to_date('2012-07-26', 'YYYY-MM-DD'));
INSERT INTO EMP  values (9, 2, 4, 'Tomiti', 70, to_date('2012-07-07', 'YYYY-MM-DD'));
INSERT INTO EMP  values (10, 9, 4, 'Bhuti', 60, to_date('2012-08-24', 'YYYY-MM-DD'));

SELECT dept.name DEPARTMENT, emp.name EMPLOYEE 
FROM DEPARTMENT dept, EMP emp
WHERE dept.id = emp.dept_id; /*Inner only 4 depts*/

SELECT dept.name DEPARTMENT, emp.name EMPLOYEE 
FROM DEPARTMENT dept, EMP emp
WHERE dept.id = emp.dept_id(+); /*Left Outer 5 depts, 5th one is null emp*/

--SQL JOIN allows us to “lookup” records on other table based on the given conditions between two tables. 
--UNION operation allows us to add 2 similar data sets to create resulting data set that contains all the data from the source data sets.

SELECT * FROM EMP WHERE ID = 5
UNION ALL
SELECT * FROM EMP WHERE ID = 5;

--WHERE clause can only be applied on a static non-aggregated column whereas we will need to use HAVING for aggregated columns.
--Departments where Average salary is greater than 80
SELECT dept.name DEPARTMENT, avg(emp.sal) AVG_SAL
FROM DEPARTMENT dept, EMP emp
WHERE dept.id = emp.dept_id(+)
group by dept.name having avg(emp.sal) > 80; 

SELECT dept.name DEPARTMENT
FROM DEPARTMENT dept, EMP emp
WHERE dept.id = emp.dept_id(+)
group by dept.name having avg(emp.sal) > 80;

select * from emp order by SAL desc;

SELECT e.name EMPLOYEE, m.name MANAGER
FROM EMP e, EMP m
WHERE e.mgr_id = m.id(+) ;

--use CASE statement or DECODE statement to transpose a table using SQL (changing rows to column or vice-versa)
--row num in SQL
SELECT name, sal, (SELECT COUNT(*)  FROM EMP i WHERE o.name >= i.name) row_num
FROM EMP o
order by row_num;

--5 rows
SELECT  name 
FROM EMP o
WHERE (SELECT count(*) FROM EMP i WHERE i.name < o.name) < 5;

--3rd max salary in the employment table
Select distinct sal from emp e1 where 3= (select count (distinct sal) from emp e2 where e1.sal<=e2.sal);

--Substract two dates
SELECT TO_DATE('2000-01-03', 'YYYY-MM-DD') -  TO_DATE('2000-01-01', 'YYYY-MM-DD') AS DateDiff FROM   dual;

--ROW_NUMBER() is an analytical function which is used in conjunction to OVER() clause wherein we can specify ORDER BY and also PARTITION BY columns
SELECT name, sal, row_number() over(order by sal desc) rownum_by_sal FROM EMP o;

--5th highest salary in a table
SELECT * FROM
(SELECT ROW_NUMBER () OVER (ORDER BY sal DESC) row_number, emp.* FROM emp) a
WHERE row_number = 5;

--RANK does not assign unique numbers—nor does it assign contiguous numbers. If two records tie for second place, no record will be assigned the 3rd rank as no one came in third, according to RANK
SELECT name, sal, rank() over(order by sal desc) rank_by_sal FROM EMP o;
SELECT * FROM (SELECT RANK() OVER(ORDER BY SAL DESC) RANK, emp.* FROM EMP) WHERE RANK=5; --works with duplicate data

--DENSE_RANK, like RANK, does not assign unique numbers, but it does assign contiguous numbers. Even though two records tied for second place, there is a third-place record.
SELECT name, sal, dense_rank() over(order by sal desc) rank_by_sal FROM EMP o;
SELECT * FROM (SELECT DENSE_RANK() OVER(ORDER BY SAL DESC) RANK, emp.* FROM EMP) WHERE RANK=5;

--A sub-query is a form of an SQL statement that appears inside another SQL statement Also termed as nested query
SELECT name FROM emp
WHERE dept_id = (SELECT id FROM DEPARTMENT WHERE name = 'Engineering' ); --single row

SELECT name FROM emp
WHERE dept_id IN (SELECT id FROM DEPARTMENT ); --Multi row

--ANY: the condition evaluates to true, if there exist at least one row selected by the sub-query for which the comparison holds
SELECT * FROM emp WHERE sal >= ANY
( SELECT sal FROM emp WHERE dept_id = 1 )
and dept_id = 2;

--ALL: the condition evaluates to true, if there exist all the rows selected by the sub-query for which the comparison holds.
SELECT * FROM emp WHERE sal >= ALL
(SELECT sal FROM emp WHERE dept_id = 1)
and dept_id <> 1;

--Inline Views: The inline view is a construct in Oracle SQL where you can place a query in the SQL FROM clause, just as if the query was a table name
SELECT name, sal FROM (select * from emp ORDER BY sal desc ) WHERE ROWNUM < 6;

--Multiple-column Sub-queries: When you want to compare more than one columns in a sub-query.
SELECT name, doj FROM emp WHERE ( dept_id, sal ) IN ( 
SELECT dept_id, max( sal ) FROM emp GROUP BY dept_id );

--Co-related Sub-queries

--A co-related query is a form of query used in SELECT, Update or Delete commands to force the DBMS to evaluate the query once per row of the parent query rather than once for the entire query
--`A co-related query is used to answer questions whose answers depends on the values in each row of the parent query
--The EXISTS condition is considered "to be met" if the sub-query returns at least one row.
SELECT ID, name FROM DEPARTMENT a WHERE EXISTS ( 
SELECT ID FROM emp e WHERE a.ID = e.dept_id );

--With Clause and Sub-queries/Common Table Expression CTE
--With clause lets us factor out the sub-query, give it a name, then reference that name multiple times within the original complex query
--This improves the performance of this query by having Oracle 9i execute the query only once, then simply reference it at the appropriate points in the main query. 
WITH summary AS
( SELECT DEPARTMENT.name, SUM( emp.sal ) AS dept_total
FROM emp,DEPARTMENT
WHERE emp.dept_id = DEPARTMENT.ID
GROUP BY DEPARTMENT.name )
SELECT name,dept_total
FROM summary
WHERE dept_total > ( 
SELECT SUM( dept_total ) * 1 / 3
FROM summary )
ORDER BY dept_total desc;

---to find duplicate
---other way could be create a table select distinct from table. Then drop/rename table rename new one  
select count(ID),MGR_ID  from emp group by MGR_ID having count(ID) > 1;

SELECT emp.*, ROW_NUMBER() OVER (PARTITION BY MGR_ID ORDER BY MGR_ID) AS RN FROM emp;

with CTE as
(SELECT emp.*, ROW_NUMBER() OVER (PARTITION BY MGR_ID ORDER BY MGR_ID) AS RN FROM emp)
select * from CTE where RN <> 1; --to delete duplicates

-- second heighst sal from each department
SELECT * FROM(SELECT DEPT_ID,NAME,SAL ,DENSE_RANK() OVER (PARTITION BY DEPT_ID ORDER BY SAL DESC)R FROM EMP) WHERE R=2;

--Employee who is part of atleast 1 department
SELECT e.Name, count(d.ID) FROM emp e,DEPARTMENT d
WHERE e.dept_id = d.ID
  GROUP BY e.Name 
  HAVING COUNT(d.ID) = 1