@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    private static final String STATUS_NEW = 'New';
    private static final String STATUS_WORKING = 'Working';
    private static final String STATUS_CLOSED = 'Closed';
    private static final String TYPE_REPAIR = 'Repair';
    private static final String ORIGIN_WEB = 'Web';
    private static final String TYPE_ROUTINE_MAINTENANCE = 'Routine Maintenance';
    private static final String SUBJECT_TEST = 'Testing subject';
    
    private static Vehicle__c createVehicle() {
        Vehicle__c vehicle = new Vehicle__c(Name = 'SuperTruck');
        return vehicle;
    }
    
    private static Product2 createEquipment() {
        Product2 equipment = new Product2(Name = 'SuperEquipment',
                                          Lifespan_Months__c = 10,
                                          Maintenance_Cycle__c = 10,
                                          Replacement_Part__c = true);
        return equipment;
    }
    
    private static Case createMaintenanceRequest(Id vehicleId, Id equipmentId) {
        Case cs = new Case(Type = TYPE_REPAIR,
                           Status = STATUS_NEW,
                           Origin = ORIGIN_WEB,
                           Subject = SUBJECT_TEST,
                           Equipment__c = equipmentId,
                           Vehicle__c = vehicleId);
        return cs;
    }
    
    private static Equipment_Maintenance_Item__c createWorkPart(Id equipmentId, Id requestId) {
        Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(Equipment__c = equipmentId,
                                                                             Maintenance_Request__c = requestId);
        return wp;
    }
    
    @isTest
    private static void testMaintenanceRequestPositive() {
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        
        Product2 equipment = createEquipment();
        insert equipment;
        
        Case maintenanceRequest = createMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;
        
        Equipment_Maintenance_Item__c workPart = createWorkPart(equipment.Id, maintenanceRequest.Id);
        insert workPart;
        
        Test.startTest();
        maintenanceRequest.Status = STATUS_CLOSED;
        update maintenanceRequest;
        Test.stopTest();
        
        Case newRequest = [SELECT Id, Subject, Type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c 
                           FROM Case 
                           WHERE Status = :STATUS_NEW LIMIT 1];
        
        Equipment_Maintenance_Item__c newWorkPart = [SELECT Id 
                                                     FROM Equipment_Maintenance_Item__c 
                                                     WHERE Maintenance_Request__c = :newRequest.Id LIMIT 1];
        
        System.assert(newWorkPart != null, 'New work part should not be null');
        System.assert(newRequest.Subject != null, 'New request subject should not be null');
        System.assertEquals(newRequest.Type, TYPE_ROUTINE_MAINTENANCE, 'New request type should be Routine Maintenance');
        System.assertEquals(newRequest.Equipment__c, equipment.Id, 'Equipment IDs should match');
        System.assertEquals(newRequest.Vehicle__c, vehicle.Id, 'Vehicle IDs should match');
        System.assertEquals(newRequest.Date_Reported__c, System.today(), 'Date Reported should be today');
    }
    
    @isTest
    private static void testMaintenanceRequestNegative() {
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        
        Product2 equipment = createEquipment();
        insert equipment;
        
        Case maintenanceRequest = createMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;
        
        Equipment_Maintenance_Item__c workPart = createWorkPart(equipment.Id, maintenanceRequest.Id);
        insert workPart;
        
        Test.startTest();
        maintenanceRequest.Status = STATUS_WORKING;
        update maintenanceRequest;
        Test.stopTest();
        
        List<Case> allRequests = [SELECT Id FROM Case];
        Equipment_Maintenance_Item__c existingWorkPart = [SELECT Id 
                                                          FROM Equipment_Maintenance_Item__c 
                                                          WHERE Maintenance_Request__c = :maintenanceRequest.Id LIMIT 1];
        
        System.assert(existingWorkPart != null, 'Existing work part should not be null');
        System.assertEquals(allRequests.size(), 1, 'There should be only one request');
    }
    
    @isTest
    private static void testMaintenanceRequestBulk() {
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2> equipmentList = new List<Product2>();
        List<Case> requestList = new List<Case>();
        List<Equipment_Maintenance_Item__c> workPartList = new List<Equipment_Maintenance_Item__c>();
        List<Id> oldRequestIds = new List<Id>();
        
        for (Integer i = 0; i < 300; i++) {
            vehicleList.add(createVehicle());
            equipmentList.add(createEquipment());
        }
        insert vehicleList;
        insert equipmentList;
        
        for (Integer i = 0; i < 300; i++) {
            requestList.add(createMaintenanceRequest(vehicleList.get(i).Id, equipmentList.get(i).Id));
        }
        insert requestList;
        
        for (Integer i = 0; i < 300; i++) {
            workPartList.add(createWorkPart(equipmentList.get(i).Id, requestList.get(i).Id));
        }
        insert workPartList;
        
        Test.startTest();
        for (Case req : requestList) {
            req.Status = STATUS_CLOSED;
            oldRequestIds.add(req.Id);
        }
        update requestList;
        Test.stopTest();
        
        List<Case> allNewRequests = [SELECT Id FROM Case WHERE Status = :STATUS_NEW];
        List<Equipment_Maintenance_Item__c> newWorkParts = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :oldRequestIds];
        
        System.assertEquals(allNewRequests.size(), 300, 'There should be 300 new requests');
        System.assertEquals(newWorkParts.size(), 300, 'There should be 300 new work parts');
    }

    @isTest
    private static void testMaintenanceRequestWithoutMaintenanceCycle() {
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        
        Product2 equipment = createEquipment();
        insert equipment;
        
        Case maintenanceRequest = createMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;
        
        // Do not insert an Equipment_Maintenance_Item__c record to ensure no entry in maintenanceCycles map
        
        Test.startTest();
        maintenanceRequest.Status = STATUS_CLOSED;
        update maintenanceRequest;
        Test.stopTest();
        
        Case newRequest = [SELECT Id, Subject, Type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c 
                           FROM Case 
                           WHERE Status = :STATUS_NEW LIMIT 1];
        
        // Ensure the Date_Due__c is set based on Equipment's maintenance cycle
        System.assertEquals(newRequest.Date_Due__c, System.today().addDays((Integer) equipment.Maintenance_Cycle__c), 
                           'Date Due should be set based on Equipment maintenance cycle');
    }
}
