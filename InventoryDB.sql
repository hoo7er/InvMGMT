									/***************************** CREATE ALL TABLES *****************************/

CREATE TABLE brands (
	bid INT NOT NULL PRIMARY KEY,
	bname NVARCHAR(20)
	); 

CREATE TABLE inv_user (
	user_id NVARCHAR(20),
	name NVARCHAR(20),
	password NVARCHAR(20),
	last_login TIMESTAMP,
	user_type NVARCHAR(20) 
	);

ALTER TABLE inv_user
	ALTER COLUMN user_id NVARCHAR(20 )NOT NULL;	

CREATE TABLE categories (
	cid INT PRIMARY KEY,					
	category_name NVARCHAR(20)	
	);

DROP TABLE product

CREATE TABLE product (
	pid INT PRIMARY KEY,
	cid INT REFERENCES categories(cid),
	bid INT REFERENCES brands(bid),
	sid INT,
	p_name NVARCHAR(20),
	p_stock INT,
	price INT,
	added_date datetime
	CONSTRAINT sid_fk FOREIGN KEY(sid) REFERENCES stores(sid)
	);

CREATE TABLE stores (
	sid INT PRIMARY KEY,
	sname NVARCHAR(20),
	address NVARCHAR(20),
	mobno INT
);

CREATE TABLE provides (
	bid INT REFERENCES brands(bid),
	sid INT REFERENCES stores(sid),
	discount INT
);

CREATE TABLE customer_cart (
	cust_ID INT PRIMARY KEY,
	name NVARCHAR(20),
	mobno INT
);

CREATE TABLE select_product (
	cust_id INT REFERENCES customer_cart(cust_id),
	pid INT REFERENCES product(pid),
	quantity INT 
);

CREATE TABLE transactions (
	id INT PRIMARY KEY,
	total_amount INT,
	paid INT,
	due INT,
	gst INT,
	discount INT,
	payment_method NVARCHAR(10),
	cart_id INT REFERENCES customer_cart(cust_id)
);



					/************************** INSERT VALUES INTO TABLES **************************/

INSERT INTO brands VALUES(1,'Apple'),(2,'Samsung'),(3,'Nike'),(4,'Fortune')

INSERT INTO brands VALUES(5,'Micron'),(6,'Amazon'),(7,'Uber'),(8,'Gamestop')
;

SELECT*FROM brands;

DECLARE @inputdateINSERT DATETIME 
	SELECT @inputdateINSERT= ('2018-06-28 15:12:02.739')
	INSERT INTO inv_user VALUES('jimbo@hotmail.com','Jimmy Boderik','2468','Manager', @inputdateINSERT);

INSERT INTO inv_user VALUES('edfgujsehg@yahoo.com','Kyle','46836','trainee','2018-06-25 16:42:40.004'),
('qwertyug@gmail.com','Ray','2688','trainee','2019-01-05 18:02:49.087'),
('yallo5@yahoo.com','Yallo','123623','admin','2015-04-02 18:48:13.053');



				/******************** INSERT into categories ********************/

INSERT INTO dbo.categories VALUES(1,'Electronics'),(2,'Furniture'),(3,'Camping'),(4,'Baby'),(5,'Automotive'),(6,'Gardening')
;
SELECT*FROM dbo.categories;


				/******************** INSERT into store ********************/

INSERT INTO dbo.stores VALUES(1,'Rancher','5755 Fizer St.',16496034), (2,'Big Boys','5483 Lamer blvd.',6432657),(3,'Curtainly','18th Market St.',9302154),
(4,'Who Wanna Eat','Market Suite 102',45785434),(5,'Loobers','3741 Saller Ave.',5873936)
;

SELECT * FROM dbo.stores; 


				/******************** INSERT into product ********************/

SELECT * FROM dbo.product; 

INSERT INTO dbo.product VALUES(1,1,1,1,'IPHONE',4,45000,'2018-10-18 07:33:25.700'),
(2,1,1,1,' Airpods',3,18500,'2019-06-05 08:56:09.007'), (3,1,1,1,' Smart Watch',3,16800,'2020-04-19 07:39:57.727'),
(4,2,3,2,'Air Max',6,7000,'2018-12-28 09:04:11.830'),(5,3,4,3,'Unrefined Oils',6,750,'2021-09-03 18:13:49.036');


				/******************** INSERT into provides ********************/
SELECT*FROM dbo.provides;

INSERT INTO dbo.provides VALUES(1,1,12),(2,2,7),(3,3,25),(1,2,7),(4,2,16),(4,3,15);

				/******************** INSERT into Customer Cart ********************/
SELECT*FROM dbo.customer_cart

INSERT INTO dbo.customer_cart VALUES(1,'Gene',98763210),(2,'Lonna',8574793),(3,'Geezeb',6588675),
(4,'Andrey',54776557);

				/******************** INSERT into select_prodcut ********************/

SELECT *FROM dbo.select_product;

INSERT INTO dbo.select_product VALUES(1,3,1),(2,4,5),(3,2,4),(4,1,3);

				/******************** INSERT into transactions ********************/
SELECT*FROM dbo.transactions;

INSERT INTO dbo.transactions VALUES(1,53000,30000,5000,700,280,'Card',1),(2,58300,13456,7600,1290,450,'Bitcoin',2),
(3,64000,48000,7000,1600,3280,'Card',3),(4,13000,4000,2000,300,0,'PayPal',4), (5,375,269,25,12,15,'DOGE-USD',1),
(6,9732,7346,733,636,536,'Bitcoin',2),(7,7533,48000,7000,1600,3280,'Bitcoin',4),(8,73368,3567,1257,600,4673,'XRP-USD',3)
;


				
				
					/******************** Stored Procedures ********************/
	


/******************** sp that displays Category with its Product ********************/
	
CREATE PROC sp_CategoryandProduct
AS
	SELECT categories.category_name AS[Category], product.p_name AS[Product Name]
	FROM categories
	INNER JOIN product ON product.cid=categories.cid
	;
GO
EXEC sp_CategoryandProduct 





/******************** displays payment type and No of payment types from Cart ********************/
CREATE PROC sp_PaymentType
(@paymentype NVARCHAR(10)= 'Crypto') 
AS
	SELECT cart_id, (payment_method) AS[Payment Type], COUNT (payment_method) AS[Payment Count] 
	FROM dbo.transactions
	WHERE payment_method = @paymentype
	GROUP BY cart_id,(payment_method)
GO

EXEC sp_PaymentType


/******************** displays users who joined in 2018 ********************/
CREATE PROC sp_userlastlogin
AS
SELECT name AS[Name], last_login AS[Last Login]
FROM dbo.inv_user 
WHERE last_login BETWEEN '2018-01-01' AND '2018-12-31'
GO 
EXEC sp_userlastlogin;


/******************** displays only paid transactions that are >= 50% of total amount  ********************/
CREATE PROC sp_paid50
AS
	SELECT id AS[ID], 
	FORMAT((paid),'C') AS[Amount Paid], 
	FORMAT((total_amount),'C') AS[Total Amount],
	FORMAT((total_amount-paid),'C') AS[Remaining Amount],
	FORMAT((paid/total_amount),'P') AS[Percent Paid]
	FROM dbo.transactions
	WHERE paid/total_amount >=.50  
	ORDER BY [Percent Paid] DESC
GO
EXEC sp_paid50;


/******************** rows that contain NULL or 0 discounts ********************/
CREATE PROC sp_Nodiscounts
AS
SELECT id AS[ID],
FORMAT((total_amount),'C') AS[Total Amount],
FORMAT((paid),'C') AS[Amount Paid], 
FORMAT((total_amount-paid),'C') AS[Remaining Amount],
FORMAT((discount),'C') AS[Discount]
FROM dbo.transactions
WHERE discount IS NULL
OR discount=0
ORDER BY (total_amount-paid) DESC
;
EXEC sp_Nodiscounts;										
										
										
					/******************** DDL/DML statements ********************/


ALTER TABLE inv_user
ADD last_login DATETIME;

DELETE FROM inv_user WHERE name is NULL;

DECLARE @inputdate DATETIME 
SELECT @inputdate= ('2020-04-19 07:39:57.728')
 UPDATE inv_user
	SET last_login= @inputdate 
	WHERE user_id='prashant@gmail.com'
	;


UPDATE dbo.transactions
SET paid=36592
WHERE id=7
;
SELECT*FROM dbo.transactions;

ALTER TABLE dbo.transactions
ALTER COLUMN total_amount DECIMAL(19,2)
;

UPDATE dbo.transactions
SET discount= NULL
WHERE id IN (2,7,8)
;

UPDATE dbo.inv_user
SET password='default password'
WHERE user_type='trainee'
;
												
										
							/******************** Triggers ********************/


/******************** show inserted record when INSERT statement executed for user/transactions/product********************/
CREATE TRIGGER tr_inv_user_INSERT
ON dbo.inv_user
FOR INSERT
AS
BEGIN
SELECT*FROM inserted 
END
						/*         check trigger with insert statement          */
								
INSERT INTO inv_user VALUES('heyheyg@yahoo.com','Heyyo','684347','admin','2015-12-29 23:41:02.172')


CREATE TRIGGER tr_transactions_INSERT
ON dbo.transactions
FOR INSERT 
AS
BEGIN
SELECT*FROM inserted
END

						/*         check trigger with insert statement          */

INSERT INTO transactions VALUES (9,12867,6843,898,0,'Crypto',2);


select*from product;
CREATE TRIGGER tr_product_INSERT
ON dbo.product
FOR INSERT
AS 
BEGIN
SELECT*FROM inserted 
END 		
						/*         check trigger with insert statement          */
								

INSERT INTO dbo.product VALUES (6,2,3,2,'Slim Jeans',5,599,'2016-04-11 05:14:45.936');

INSERT INTO dbo.product VALUES(1,1,1,2,'IPHONE',4,45000,'2018-10-18 07:33:25.700'),


					/******************** INDEXES********************/
CREATE INDEX IX_inv_user
ON dbo.inv_user(user_id,name,password,last_login)
;

CREATE INDEX IX_transactions
ON dbo.transactions(total_amount,paid)
;

