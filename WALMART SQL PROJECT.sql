CREATE DATABASE WALMART;
USE WALMART;
CREATE TABLE WALMART_DATA(
INVOICE_ID VARCHAR(50),
BRANCH VARCHAR(30),
CITY VARCHAR(40),
CUSTOMER_TYPE VARCHAR(40),
GENDER VARCHAR(30),
PRODUCT_LINE VARCHAR(50),
UNIT_PRICE DECIMAL(20,2),
QUANTITY INT,
TAX_5_PERCENTAGE DECIMAL(20,4),
TOTAL DECIMAL(30,4),
`DATE` DATE,
`TIME` TIME,
PAYMENT VARCHAR(30),
COGS DECIMAL(30,4),
GROSS_MARGIN_PERCENTAGE DECIMAL(10,9),
GROSS_INCOME DECIMAL(30,4),
RATING DECIMAL(10,1));  

LOAD DATA INFILE
'D:/WalmartSalesData.csv.csv'
 INTO TABLE WALMART_DATA
 FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM WALMART_DATA;
/*Q-1 UPDATE TIME INTO MORNING AND AFTERNOON*/
SELECT * ,
CASE                                                          /*MY ANSWER*/
WHEN `TIME`>= "00:00" AND `TIME`< "12:00" THEN "MORNING"
WHEN `TIME`> "12:00" THEN "AFTERNOON"
ELSE 0
END AS STATEMENT
FROM WALMART_DATA;

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM WALMART_DATA;


/*Q-2 UPDATE DAYNAME AND MONTHNAME*/
ALTER TABLE WALMART_DATA
ADD COLUMN `DAYNAME` VARCHAR(20);                                             /*MY ANSWER*/
UPDATE WALMART_DATA SET `DAYNAME` = DAYNAME(`DATE`);

ALTER TABLE WALMART_DATA
ADD COLUMN `MONTHNAME` VARCHAR(20);                                            /*MY ANSWER*/
UPDATE WALMART_DATA SET `MONTHNAME` = MONTHNAME(`DATE`);


ALTER TABLE WALMART_DATA ADD COLUMN day_name VARCHAR(10);
UPDATE WALMART_DATA
SET day_name = DAYNAME(date);
ALTER TABLE WALMART_DATA ADD COLUMN month_name VARCHAR(10);
UPDATE WALMART_DATA
SET month_name = MONTHNAME(date);

/*Q-3 How many unique cities does the data have?*/ 

SELECT DISTINCT(CITY) FROM WALMART_DATA;    /*MY ANSWER*/    

/*Q-4 In which city is each branch?*/  

SELECT DISTINCT(BRANCH),CITY FROM WALMART_DATA;   /*MY ANSWER*/

/*Q-5 How many unique product lines does the data have?*/

SELECT DISTINCT(PRODUCT_LINE) FROM WALMART_DATA;  /*MY ANSWER*/

/*Q-6 What is the most selling product line*/

SELECT PRODUCT_LINE,SUM(QUANTITY) FROM WALMART_DATA    /*my answer*/
GROUP BY PRODUCT_LINE 
ORDER BY SUM(QUANTITY) 
DESC LIMIT 1;

SELECT SUM(quantity) as qty, product_line
FROM WALMART_DATA
GROUP BY product_line
ORDER BY qty DESC;

/*Q-7 What is the total revenue by month*/

SELECT SUM(TOTAL) AS TOTAL_REVENUE , MONTH(`DATE`) FROM WALMART_DATA   /*my answer*/
GROUP BY MONTH(`DATE`);

SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM WALMART_DATA
GROUP BY month_name 
ORDER BY total_revenue;

/*Q-8 What month had the largest COGS?*/

SELECT SUM(COGS),MONTH(`DATE`) FROM WALMART_DATA      /*MY ANSWER*/
GROUP BY MONTH(`DATE`) 
ORDER BY SUM(COGS) 
DESC LIMIT 1;

SELECT
	MONTH(`DATE`) AS month,
	SUM(COGS) AS cogs
FROM WALMART_DATA
GROUP BY MONTH(`DATE`)
ORDER BY cogs LIMIT 1;

/*Q-9 What product line had the largest revenue?*/

SELECT PRODUCT_LINE,SUM(TOTAL) AS REVENUE FROM WALMART_DATA   /*MY ANSWER*/
GROUP BY PRODUCT_LINE 
ORDER BY REVENUE 
DESC LIMIT 1;

SELECT
	product_line,
	SUM(total) as total_revenue
FROM WALMART_DATA
GROUP BY product_line
ORDER BY total_revenue DESC LIMIT 1;

/*Q-10 What is the city with the largest revenue?*/

SELECT CITY,SUM(TOTAL) AS REVENUE FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY CITY 
ORDER BY REVENUE 
DESC LIMIT 1;

SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM WALMART_DATA
GROUP BY city, branch 
ORDER BY total_revenue DESC LIMIT 1;

/*Q-11 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales*/

SELECT *,                                                                      
CASE                                                                        /*MY ANSWER*/
WHEN QUANTITY > (SELECT AVG(QUANTITY) FROM WALMART_DATA) THEN 'GOOD'
WHEN QUANTITY < (SELECT AVG(QUANTITY) FROM WALMART_DATA) THEN 'BAD'
END AS REVIEW
FROM WALMART_DATA;

 SELECT 
	AVG(quantity) AS avg_qnty
FROM WALMART_DATA;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM WALMART_DATA
GROUP BY product_line;

/*Q-12 Which branch sold more products than average product sold?*/
SELECT BRANCH,QUANTITY FROM WALMART_DATA WHERE QUANTITY>(SELECT AVG(QUANTITY) FROM WALMART_DATA);    /*MY ANSWER*/ 

SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM WALMART_DATA
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM WALMART_DATA);

/*Q-13 What is the most common product line by gender?*/

SELECT GENDER, PRODUCT_LINE, COUNT(GENDER) AS TOTAL_COUNT FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY GENDER, PRODUCT_LINE 
ORDER BY TOTAL_COUNT 
DESC LIMIT 1;

SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM WALMART_DATA
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

/*Q-14 What is the average rating of each product line?*/

SELECT PRODUCT_LINE,AVG(RATING) AS AVG_RATING FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY PRODUCT_LINE 
ORDER BY AVG_RATING;

SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM WALMART_DATA
GROUP BY product_line
ORDER BY avg_rating DESC;

/*Q-15 How many unique customer types does the data have?*/
SELECT DISTINCT(CUSTOMER_TYPE) FROM WALMART_DATA;

/*Q-16 How many unique payment methods does the data have?*/
SELECT DISTINCT(PAYMENT) FROM WALMART_DATA;

/*Q-17 What is the most common customer type?*/

SELECT COUNT(CUSTOMER_TYPE),CUSTOMER_TYPE FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY CUSTOMER_TYPE 
ORDER BY COUNT(CUSTOMER_TYPE) 
DESC LIMIT 1;

SELECT
	customer_type,
	count(*) as count
FROM WALMART_DATA
GROUP BY customer_type
ORDER BY count DESC;

/*Q-18 What is the gender distribution per branch?*/
SELECT COUNT(GENDER) , BRANCH FROM WALMART_DATA GROUP BY BRANCH;     /*MY ANSWER*/

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM WALMART_DATA
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

/*Q-19 Which time of the day do customers give most ratings?*/
SELECT `TIME`,`DAYNAME`,RATING FROM WALMART_DATA WHERE RATING = (SELECT MAX(RATING) FROM WALMART_DATA);    /*MY ANSWER*/

SELECT
	time_day,
	AVG(rating) AS avg_rating
FROM WALMART_DATA
GROUP BY time_day
ORDER BY avg_rating DESC;


/*Q-20 Which time of the day do customers give most ratings per branch?*/
SELECT SUM(RATING),`TIME`,`DAYNAME` ,BRANCH FROM WALMART_DATA GROUP BY `TIME`,`DAYNAME` ,BRANCH;   /*MY ANSWER*/

SELECT
	time_day,
	AVG(rating) AS avg_rating
FROM WALMART_DATA
WHERE branch = "A"
GROUP BY time_day
ORDER BY avg_rating DESC;

/*Q-21 Which day OF the week has the best avg ratings?*/
SELECT DATE_FORMAT(`DATE`,'%W') AS DAY_OF_WEEK, MAX(RATING) FROM WALMART_DATA       /*MY ANSWER*/
GROUP BY DAY_OF_WEEK
ORDER BY MAX(RATING) DESC LIMIT 1;

SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM WALMART_DATA
GROUP BY day_name 
ORDER BY avg_rating DESC;

/*Q-22 Which day of the week has the best average ratings per branch?*/
SELECT `DAYNAME`,AVG(RATING) AS BEST_AVG_RATING FROM WALMART_DATA        /*MY ANSWER*/
GROUP BY `DAYNAME` ORDER BY BEST_AVG_RATING 
DESC LIMIT 1;

SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM WALMART_DATA
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

/*Q-23 Number of sales made in each time of the day per weekday*/
SELECT SUM(QUANTITY),`TIME`,`DAYNAME` FROM WALMART_DATA WHERE `DAYNAME`     /*MY ANSWER*/
NOT IN('SATURDAY','SUNDAY') 
GROUP BY `TIME`,`DAYNAME`;

SELECT
	time_day,
	COUNT(*) AS total_sales
FROM WALMART_DATA
WHERE day_name = "Sunday"
GROUP BY time_day 
ORDER BY total_sales DESC;

/*Q-24 Which of the customer types brings the most revenue?*/
SELECT SUM(TOTAL) AS REVENUE,CUSTOMER_TYPE FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY CUSTOMER_TYPE 
ORDER BY REVENUE 
DESC LIMIT 1;

SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM WALMART_DATA
GROUP BY customer_type
ORDER BY total_revenue;

/*Q-25 Which city has the largest tax/VAT percent?*/
SELECT SUM(TAX_5_PERCENTAGE) AS LARGEST_TAX,CITY FROM WALMART_DATA    /*MY ANSWER*/
GROUP BY CITY ORDER BY LARGEST_TAX 
DESC LIMIT 1 ;

SELECT
	city,
    ROUND(AVG(TAX_5_PERCENTAGE), 2) AS avg_tax_pct
FROM WALMART_DATA
GROUP BY city 
ORDER BY avg_tax_pct DESC;

/*Q-26 Which customer type pays the most in VAT?*/
SELECT SUM(TAX_5_PERCENTAGE) AS MOST_VAT,CUSTOMER_TYPE FROM WALMART_DATA   /*MY ANSWER*/
GROUP BY CUSTOMER_TYPE ORDER BY MOST_VAT 
DESC LIMIT 1;

SELECT
	customer_type,
	AVG(TAX_5_PERCENTAGE) AS total_tax
FROM WALMART_DATA
GROUP BY customer_type
ORDER BY total_tax;


