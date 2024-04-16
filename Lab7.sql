/*
CIS276 Lab 7
Noelle Landauer, 11/20/22

Lab7
  Script accepts four input parameters via numeric-ampersand substitution and
  performs a series of validations (identical to Lab6).  But instead of modifying
  data it will simply execute the AddLineItemSP procedure, passing values for 
  input parameters: (OrderID, PartID, Qty).
*/

SET SERVEROUTPUT ON

DECLARE

    inpCustid CHAR(5) := &1;
    inpOrderid CHAR(5) := &2;
    v_Matching_Custid ORDERS.CUSTID%TYPE;
    inpPartid CHAR(5) := &3;
    inpOrderQty CHAR(5) := &4;
    v_ErrorMsg CHAR(225);
    
    Invalid_Custid EXCEPTION;
    Invalid_Orderid EXCEPTION;
    Custid_Orderid_Mismatch EXCEPTION;
    Invalid_Partid EXCEPTION;
    Invalid_OrderQty EXCEPTION;
    Inadequate_StockQty EXCEPTION;
    PRAGMA EXCEPTION_INIT(Inadequate_StockQty, -20101);


BEGIN
    BEGIN
        SELECT CUSTID 
        INTO inpCustid
        FROM CUSTOMERS
        WHERE CUSTID = inpCustid;      
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RAISE Invalid_Custid;
    END;
    
    BEGIN    
        SELECT ORDERID
        INTO inpOrderid
        FROM ORDERS
        WHERE ORDERID = inpOrderid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE Invalid_Orderid;
    END;

    BEGIN
        SELECT CUSTID
        INTO v_Matching_Custid
        FROM ORDERS
        WHERE CUSTID = inpCustid
        AND ORDERID = inpOrderid;      
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE Custid_Orderid_Mismatch;
    END;
    
    BEGIN
        SELECT PARTID
        INTO inpPartid
        FROM INVENTORY
        WHERE PARTID = inpPartid;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE Invalid_Partid;
    END;
    
    IF inpOrderQty <= 0 THEN
        RAISE Invalid_OrderQty;
    END IF;
    
    BEGIN
        AddLineItemSP(inpOrderid, inpPartid, inpOrderQty);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND EXCEPTION HANDLER performs ROLLBACK');
            ROLLBACK;
        WHEN Inadequate_StockQty THEN
            DBMS_OUTPUT.PUT_LINE('Insufficent stock for part ID ' || 
            TRIM(inpPartid) || ' to complete this order.' ||
            chr(10) || 'Changes to order ' 
            || TRIM(inpOrderid) || ' have been rolled back.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR: ' || SQLERRM);
            ROLLBACK;
    END;
    
EXCEPTION
    WHEN Invalid_Custid THEN
        DBMS_OUTPUT.PUT_LINE('Customer ID ' || TRIM(inpCustid) 
        || ' does not exist.'); 
    WHEN Invalid_Orderid THEN
        DBMS_OUTPUT.PUT_LINE('Order ID ' || TRIM(inpOrderid) 
        || ' does not exist.');
    WHEN Custid_Orderid_Mismatch THEN
        DBMS_OUTPUT.PUT_LINE('Order ID '
        || TRIM(inpOrderid) || ' does not belong to Customer ID '
        || TRIM(inpCustid));
    WHEN Invalid_Partid THEN
        DBMS_OUTPUT.PUT_LINE('Part ID ' || TRIM(inpPartid) 
        || ' does not exist');
    WHEN Invalid_OrderQty THEN
        DBMS_OUTPUT.PUT_LINE('Order quantity must be greater than zero.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UNKNOWN ERROR from Lab7 script: ' || SQLERRM);
END;
