/*
CIS276 Lab 7
Noelle Landauer, 11/20/22

AddLineItemSP
  Script creates a stored procedure which will be executed by Lab7.sql to create
  a new row in the ORDERITEMS table.  Procedure will accept three input parameters
  (OrderID, PartID, Qty) which will be used to INSERT a row into ORDERITEMS - 
  deliberately omitting the Detail value (see InsertOrderitemsTRG; value will be
  calculated and set in that trigger).  Determines whether a custom 
  exception resulted from that operation; if so, it raises a custom exception and
  executes ROLLBACK.  If not, it displays a success message and executes COMMIT.
*/

CREATE OR REPLACE Procedure AddLineItemSP (
    i_Orderid IN ORDERITEMS.ORDERID%TYPE,
    i_Partid IN ORDERITEMS.PARTID%TYPE,
    i_OrderQty IN ORDERITEMS.QTY%TYPE)
    
    IS 
    
    Inadequate_StockQty EXCEPTION;
    PRAGMA EXCEPTION_INIT(Inadequate_StockQty, -20101);
    
BEGIN
    INSERT INTO ORDERITEMS (Orderid, Partid, Qty)
    VALUES(
        i_Orderid, 
        i_Partid,
        i_OrderQty
        );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('A new item for order ' || i_Orderid || ' has been added.');

    EXCEPTION
        WHEN Inadequate_StockQty THEN
        DBMS_OUTPUT.PUT_LINE('Insufficent stock for part ID ' || 
            TRIM(i_Partid) || ' to complete this order.' ||
            chr(10) || 'Changes to order ' 
            || TRIM(i_Orderid) || ' have been rolled back.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR from AddLineItemSP: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Changes have been rolled back');
            ROLLBACK;
 
END AddLineItemSP;


    
    