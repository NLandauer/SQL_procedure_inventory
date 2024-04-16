/*
CIS276 Lab 7
Noelle Landauer, 11/20/22

Test7
  Script executes Lab7 with various combinations of input values to verify 
  functionality in different scenarios.  Should work the same as Test6.sql
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- All input valid; SUCCESS (Detail = 6)
SELECT * FROM ORDERITEMS WHERE ORDERID = 6099;
@Lab7 1 6099 1001 15
SELECT * FROM ORDERITEMS WHERE ORDERID = 6099;

-- CustID does not exist, OrderID & Partid exist; FAIL (Invalid_Custid)
@Lab7 5 6099 1001 15

-- CustID & Partid exist, OrderID does not exist; FAIL (Invalid_Orderid)
@Lab7 1 6090 1001 15

-- Neither CustID nor OrderID exist, Partid exists; FAIL (Invalid_Custid)
@Lab7 6 6090 1001 15

-- Neither OrderID nor Partid exist, Custid is valid; FAIL (Invalid_Orderid)
@Lab7 1 6091 1000 15

-- CustID, OrderID, Partid all exist, but OrderID belong to different CustID; 
--FAIL (Custid_Orderid_Mismatch)
@Lab7 2 6099 1001 15

-- CustID & OrderID valid, Partid invalid, Orderid belongs to different Custid; 
--FAIL (Custid_Orderid_Mismatch)
@Lab7 1 6128 1000 15

-- PartID does not exist, CustID & OrderID are valid; FAIL (Invalid_Partid)
@Lab7 1 6099 1000 15

-- Quantity entered is less than 0; FAIL (Invalid_OrderQty)
@Lab7 1 6099 1001 -1

-- Quantity entered = 0; FAIL (Invalid_OrderQty)
@Lab7 1 6099 1001 0

-- Order exists but has no orderitems; SUCCESS (DETAIL = 1)
SELECT * FROM ORDERITEMS WHERE ORDERID = 6240;
INSERT INTO ORDERS
VALUES(6240, 103, 12, SYSDATE);
@Lab7 12 6240 1001 5
SELECT * FROM ORDERITEMS WHERE ORDERID = 6240;

-- Stock Qty is less than 0 after transaction; FAIL (Inadequate_StockQty)
SELECT * FROM INVENTORY WHERE PARTID = 1003;
@Lab7 1 6099 1003 30 
SELECT * FROM INVENTORY WHERE PARTID = 1003;

-- Stock Qty = 0 after transaction; SUCCESS
SELECT * FROM INVENTORY WHERE PARTID = 1007;
@Lab7 1 6099 1007 10
SELECT * FROM INVENTORY WHERE PARTID = 1007;
