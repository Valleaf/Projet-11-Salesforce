/**
 * OrderTriggerHandlerTest Description
 *
 * @author trouillet.valentin@resilient-koala-seczrx.com
 * @version Version number
 */
@isTest
public with sharing class OrderTriggerHandlerTest{
    private static final String ACTIVATED = 'Activated';
    
    @TestSetup
    static void makeData(){
        Account acc1 = DataFactory.createAccount('Test Account 1', true);

        PricebookEntry pbe = DataFactory.initPriceBook('Chemise Verte longue XXL', 'TTII', 100);
        insert pbe;
    }
    
    @isTest
    static void updateOrderStatusTEST(){
        User u = DataFactory.createStandardUser();
        insert u;

        System.runAs(u){
            Account acc1 = [SELECT Id, Name
                            FROM Account
                            WHERE Name = 'Test Account 1'];
            Product2 pd1 = [SELECT Id
                            FROM Product2
                            WHERE Name = 'Chemise Verte longue XXL'];
            PricebookEntry pbe = [SELECT Id, Pricebook2Id
                                  FROM PricebookEntry
                                  WHERE Product2Id = :pd1.Id
                                  LIMIT 1];

            Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, false);
            insert o1;

            Test.startTest();
            boolean expectedExceptionThrown = false;
            try{
                o1.Status = ACTIVATED;
                update o1;
            } catch (Exception e){
                expectedExceptionThrown = e.getMessage().contains(System.Label.VR_OrderWithoutProductsActivated) ? true : false;
            }
            System.AssertEquals(expectedExceptionThrown, true, 'Exception should be thrown');

            // Now add an order item and it will work
            DataFactory.createOrderItem(o1, pbe.Id, 100, true);
            update o1;
            // Query o1 and check its status
            Test.stopTest();
            Order orderAfter = [SELECT Status FROM Order WHERE Id = :o1.Id];
            System.assertEquals(ACTIVATED, orderAfter.Status,'Status should be activated');
        }
    }




}