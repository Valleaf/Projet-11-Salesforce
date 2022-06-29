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

// Command to schedule via anonymous
// System.schedule('Monthly Job', '0 0 10 ? * 2#1', new createTasksSchedulable());

