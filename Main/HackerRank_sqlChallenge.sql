select w1.id,w2.age,w2.cn,w1.power 
from wands w1,(select w.id,w.code,wp.age,w.power,min(coins_needed) cn
             from wands w, wands_property wp
             where w.code = wp.code 
               and wp.is_evil = 0         
             group by w.id,w.code,wp.age,w.power)w2 
where w1.code = w2.code
order by w1.power desc, w2.age desc;


select w.id,w.code,wp.age,w.power,min(coins_needed) cn
             from wands w, wands_property wp
             where w.code = wp.code 
               and wp.is_evil = 0         
             group by w.id,w.code,wp.age,w.power
order by w1.power desc, w2.age desc;	
---------------------------------------------------------------------------------

select ROUND(sum(LAT_N),2), ROUND(sum(LONG_W),2) from station;

SELECT TRUNC(SUM(LAT_N),4) FROM STATION WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

SELECT TRUNC(MAX(LAT_N),4) FROM STATION WHERE LAT_N < 137.2345;

SELECT ROUND(LONG_W,4) 
FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

SELECT ROUND(MIN(LAT_N),4) FROM STATION WHERE LAT_N > 38.7780;


SELECT ROUND(LONG_W,4) 
FROM STATION 
WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.7780);


 |x1 - x2| + |y1 - y2|. 
 
 
--MANHATTAN DISTANCE--
SELECT ROUND((ABS(A-C)+ABS(B-D)),4) FROM (
SELECT MIN(LAT_N) A,MIN(LONG_W) B, MAX(LAT_N) C, MAX(LONG_W) D FROM STATION);

--EUCLIDEAN DISTANCE--

SELECT TRUNC(SQRT(POWER(ABS(B-A),2)+POWER(ABS(D-C),2)),4) FROM (SELECT MIN(LAT_N) A,MIN(LONG_W) C,MAX(LAT_N) B,MAX(LONG_W) D FROM STATION)

--MEDIAN OF ALL LATITUDES -NORTH --
SELECT ROUND(MEDIAN(LAT_N),4) FROM STATION;


SELECT SUM(A.POPULATION)
FROM CITY A INNER JOIN COUNTRY B ON A.COUNTRYCODE = B.CODE 
WHERE CONTINENT = 'Asia';

---
SELECT 
(SELECT MAX(MONTHS * SALARY) FROM EMPLOYEE)
||'  '||
(SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEE WHERE (MONTHS*SALARY) = (SELECT MAX(MONTHS * SALARY) FROM EMPLOYEE)) FROM DUAL;

SELECT CITY.NAME FROM CITY, COUNTRY 
WHERE CITY.COUNTRYCODE = COUNTRY.CODE
AND COUNTRY.CONTINENT = 'Africa';
---
SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
FROM CITY,COUNTRY
WHERE CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;
---
SELECT B.N,CASE 
  WHEN B.P IS NULL THEN 'Root'
  WHEN EXISTS(SELECT A.N FROM BST A WHERE B.N = A.P) THEN 'Inner'
  ELSE 'Leaf'
  END AS NODE_TYPE FROM BST B ORDER BY N;
  
--- 
SELECT CASE WHEN A=B AND B=C THEN 'Equilateral'
            WHEN A=B AND A!=C AND (A+B) > C THEN 'Isosceles'
            WHEN A!= B AND A!=C AND B!=C AND (A+B) > C THEN 'Scalene'
            WHEN (A+B)< C THEN 'Not a Triangle'
            ELSE 'Not a Triangle'
            END FROM TRIANGLES;

---
SELECT 
			CASE WHEN A + B > C AND A + C > B AND B + C > A THEN CASE 
																 WHEN A = B AND B = C THEN 'Equilateral' 
																 WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
																 ELSE 'Scalene' 
																 END 
				 ELSE 'Not A Triangle' END FROM TRIANGLES;

---
SELECT K.HACKER_ID,K.NAME,K.TOT FROM (
SELECT H.HACKER_ID, H.NAME, 
(SELECT L.TOTAL_MARKS FROM(SELECT SUM(T.MAXS) TOTAL_MARKS, T.HACKER_ID 
 FROM (SELECT MAX(S.SCORE) MAXS,S.HACKER_ID,S.CHALLENGE_ID FROM SUBMISSIONS S GROUP BY S.HACKER_ID, S.CHALLENGE_ID)T
 GROUP BY T.HACKER_ID) L WHERE L.HACKER_ID = H.HACKER_ID) AS Tot
FROM HACKERS H) K
WHERE K.TOT != 0
ORDER BY TOT DESC,K.HACKER_ID; 
---

SELECT QUERY.NAME FROM (SELECT S.ID,S.NAME,P.SALARY,F.Friend_id, (SELECT SALARY FROM PACKAGES P1 WHERE P1.ID = F.Friend_id) SAL FROM STUDENTS S, FRIENDS F, PACKAGES P 
WHERE S.ID = P.ID AND S.ID = F.ID ORDER BY S.ID) QUERY
WHERE QUERY.SAL > QUERY.SALARY ORDER BY QUERY.SAL ;
-----------------

SELECT * FROM OCCUPATIONS 
PIVOT [XML] 
(FOR Occupation IN ('Doctor','Professor','Singer','Actor')) ORDER BY NAME;




select min(Doctor), min(Professor),min(Singer),  min(Actor)
from(
select ROW_NUMBER() OVER(PARTITION By Doctor,Actor,Singer,Professor order by name asc) AS Rownum, 
case when Doctor=1 then name else Null end as Doctor,
case when Actor=1 then name else Null end as Actor,
case when Singer=1 then name else Null end as Singer,
case when Professor=1 then name else Null end as Professor
from occupations
pivot
( count(occupation)
for occupation in(Doctor, Actor, Singer, Professor)) as p

) temp

group by Rownum  ;

