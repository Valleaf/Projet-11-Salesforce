/**
 * createTasksOnAccountsBatchTest Description
 *
 * @author trouillet.valentin@resilient-koala-seczrx.com
 * @version Version number
 */
@isTest
public with sharing class createTasksOnAccountsBatchTest{
    @isTest
    static void testBatch(){
        User u = DataFactory.createStandardUser();
        insert u;

        System.runAs(u){
            // Set data, then start batch. Query the data anew and assert
            Account acc1 = DataFactory.createAccount('Test 1', false);
            Account acc2 = DataFactory.createAccount('Test 2', false);
            Account acc3 = DataFactory.createAccount('Test 3', false);
            Account acc4 = DataFactory.createAccount('Test 4', false);
            insert new List<Account>{ acc1, acc2, acc3, acc4 };
            PricebookEntry pbe = DataFactory.initPriceBook('Test Item', 'TTII', 100);
            insert pbe;
            Order o1 = DataFactory.createOrder(acc1, pbe.Pricebook2Id, true);
            Task t2 = DataFactory.createTask(acc2,u,true);

            // Now test the batch.
            Test.startTest();
            createTasksOnAccountsBatch.run();
            Test.stopTest();
            // Query the tasks. There should be a task for acc3 and acc4 only
            Task[] tasks = [SELECT WhatId, Subject, Status, Priority, OwnerId, isReminderSet, ReminderDateTime
                            FROM Task WHERE Id != :t2.Id];
            System.assertEquals(2, tasks.size());
            System.assertEquals(tasks[0].WhatId, acc3.Id);
            System.assertEquals(tasks[1].WhatId, acc4.Id);
        }
    }

}