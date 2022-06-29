@isTest
private class createTasksSchedulableTEST {

    @isTest
    static void testSchedulable() {        
         Test.startTest();
         createTasksSchedulable myClass = new createTasksSchedulable();   
         String chron = '0 0 23 * * ?';        
         System.schedule('Test Sched', chron, myClass);
         Test.stopTest();
    }
}