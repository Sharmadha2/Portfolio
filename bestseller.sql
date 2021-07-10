/* Count duplicates */

SELECT [Name],count(*) 
FROM [TestDB].[dbo].[bestsellers] 
GROUP BY [Name]
HAVING count(*)>1;
/*to find duplicates using rowid*/

SELECT [Name] FROM (SELECT [Name], ROW_NUMBER()   
OVER (PARTITION BY Name ORDER BY Name) AS row_num   
FROM [TestDB].[dbo].[bestsellers])AS temptable WHERE row_num>1 ;  

/*delete duplicates*/
DELETE FROM  [TestDB].[dbo].[bestsellers] WHERE [Name] IN
 (SELECT [Name] FROM (SELECT [Name], ROW_NUMBER()   
OVER (PARTITION BY Name ORDER BY Name) AS row_num   
FROM [TestDB].[dbo]. [bestsellers]) AS temptable WHERE row_num>1) ;  

/****** top authors without considering recopy ******/
SELECT 
       [Author]
       ,COUNT(DISTINCT Name) As totalbooks
	   FROM 
	   [TestDB].[dbo].[bestseller_bkp]
	   GROUP BY [Author]
	   ORDER BY COUNT(DISTINCT Name) DESC
	   
/* to find books with high reviews*/

	select 
	   DISTINCT[Name],[Author],[Reviews],[Genre] from [TestDB].[dbo].[bestseller_bkp]   order by [Reviews] DESC

/****** Top 14 Best selling Authors considering recopy ratings******/
SELECT 
       [Author]
       ,Avg(User_Rating) AS Avg_Rating
	   FROM [TestDB].[dbo].[bestseller_bkp]
	   Group by [Author]
	   ORDER BY Avg(User_Rating) DESC


