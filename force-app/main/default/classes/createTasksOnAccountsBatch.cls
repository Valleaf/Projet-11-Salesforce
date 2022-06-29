/**
 * createTasksOnAccountsBatch Description This batch will add tasks to owners of accounts who do not have neither orders nor tasks associated. It is scheduled every First Monday of the Month. 
 *
 * @author trouillet.valentin@resilient-koala-seczrx.com
 */
global class createTasksOnAccountsBatch implements Database.Batchable<sObject>{
    public static void run(){
        Database.executeBatch(new createTasksOnAccountsBatch());
    }

    global Database.QueryLocator start(Database.BatchableContext info){

        // Get Accounts Without orders and without calls. Entity 'Task' is not supported for semi join inner selects so it will be filtered via apex further on
        return Database.getQueryLocator('SELECT Id,OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Orders)');
    }

    global void execute(Database.BatchableContext info, List<Account> scope){
        AccountUtils.createTasks(scope);
    }

    global void finish(Database.BatchableContext info){
    }

}