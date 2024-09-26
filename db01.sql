-- db01: create a database and a table, then insert data into the table
CREATE DATABASE database_demo;
SHOW databases;
USE database_demo;
SHOW tables;

DROP TABLE IF EXISTS transaction;
CREATE TABLE IF NOT EXISTS transaction (transaction_id INT ,
					date DATE,
					datetime DATETIME,          
                                        cash_type VARCHAR(255),
                                        card VARCHAR(255),
                                        money FLOAT,
                                        coffee_id INT,
                                        PRIMARY KEY (transaction_id)
                                       );
                                       
INSERT INTO transaction (transaction_id, date, datetime, cash_type, card, money, coffee_id) VALUES
(1,'2024-03-01','2024-03-01 10:15:50.520','card','NO-0001',20.5,7),
(2,'2024-04-04','2024-04-04 12:10:40.000','cash',NULL,22.5,5);

-- DESCRIBE transaction;
-- SELECT * FROM transaction;

-- DROP DATABASE test01;

-- DELETE FROM transaction WHERE card = 'NO-0001';
-- DELETE FROM transaction WHERE coffee_id = 5;

-- UPDATE database_demo.transaction SET money=888 WHERE transaction_id = 4;

-- DELETE FROM database_demo.transaction WHERE transaction_id = 4;
