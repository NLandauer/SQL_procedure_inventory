/*
CIS276 Lab 7
Noelle Landauer, 11/20/22

UpdateInventoryTRG
  Trigger runs before an update on the INVENTORY table.  Determines whether the 
  resulting StockQty value is less than zero; if so, it raises a custom exception.
*/
SET SERVEROUTPUT ON

CREATE OR REPLACE TRIGGER UpdateInventoryTRG
BEFORE UPDATE ON INVENTORY
FOR EACH ROW

DECLARE

    Inadequate_StockQty EXCEPTION;
    PRAGMA EXCEPTION_INIT(Inadequate_StockQty, -20101);
    
BEGIN
    IF :new.StockQty < 0 THEN
        RAISE Inadequate_StockQty;
    END IF;
           
EXCEPTION 
    WHEN Inadequate_StockQty THEN
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR from UpdateInventoryTRG: ' || SQLERRM);
        RAISE;

END UpdateInventoryTRG;

            