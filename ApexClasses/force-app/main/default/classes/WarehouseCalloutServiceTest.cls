@isTest
private class WarehouseCalloutServiceTest {   
    @isTest  
    static void testWareHouseCallout(){
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Product2]);
    }     
    @isTest
    static void testWarehouseCallout2() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Start test context
        Test.startTest();
        // Enqueue the job to test the execute method
        Id jobId = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();

        // Verify the number of Product2 records created
        System.assertEquals(1, [SELECT COUNT() FROM Product2]);

        // Verify the values of the created Product2 record
        Product2 product = [SELECT Name, Replacement_Part__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Cost__c, Warehouse_SKU__c FROM Product2 LIMIT 1];
        System.assertEquals('Generator 1000 kW', product.Name);
        System.assertEquals(false, product.Replacement_Part__c);
        System.assertEquals(5.0, product.Current_Inventory__c);
        System.assertEquals(120, product.Lifespan_Months__c);
        System.assertEquals(365, product.Maintenance_Cycle__c);
        System.assertEquals(5000, product.Cost__c);
        System.assertEquals('100003', product.Warehouse_SKU__c);
    }
}