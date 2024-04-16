/*
CIS276 Lab 7
Noelle Landauer, 11/20/22

InsertOrderitemsTRG
  Trigger runs before an insert on the ORDERITEMS table.  Dynamically calculates 
  the new Detail value for the specified OrderID and assigns it to :NEW.Detail
  (overriding any invalid or NULL values).  Update the INVENTORY table to reduce
  StockQty by the :NEW.Qty value for this row.  Determines whether a custom 
  exception resulted from that operation; if so, it raises a custom exception.
*/

SET SERVEROUTPUT ON 

CREATE OR REPLACE TRIGGER InsertOrderItemsTRG
BEFORE INSERT OR UPDATE ON ORDERITEMS
FOR EACH ROW
    
DECLARE 
    Inadequate_StockQty EXCEPTION;
    PRAGMA EXCEPTION_INIT(Inadequate_StockQty, -20101);
    
BEGIN
    SELECT (NVL(MAX(Detail),0) + 1)
    INTO :new.Detail
    FROM ORDERITEMS 
    WHERE Orderid = :new.Orderid;
            
    UPDATE INVENTORY
        SET STOCKQTY = (STOCKQTY - :new.Qty)
        WHERE PARTID = :new.Partid;
                    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Order ID not found');
        DBMS_OUTPUT.PUT_LINE('Error from InsertOrderItemsTRG');
        RAISE;
    WHEN Inadequate_StockQty THEN
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR from InsertOrderItemsTRG: ' || SQLERRM);
        RAISE;
        
END InsertOrderItemsTRG;

    
