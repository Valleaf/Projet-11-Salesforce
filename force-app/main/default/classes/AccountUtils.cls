/**
 * AccountUtils Description
 *
 * @author trouillet.valentin@resilient-koala-seczrx.com
 * @version Version number
 */
public class AccountUtils {

        /**
     * hasOrder 
     *
     * @param orders (Order[]): List of Orders deleted. Will check the associated accounts and find out if they have any orders after deletion
     *
     * @return Map<Id, Boolean>: A Map associating a account with a boolean, stating if that accoun thas Orders.
     *
     */
    public static Map<Id,Boolean> hasOrder(Account[] accs){
        // Query the Accounts
        // Get the accounts ids
        List<Id> accsIds = new List<Id>();
        for(Account a : accs){
            accsIds.add(a.Id);
        }
        List<Account> accounts = [SELECT Id , (SELECT Id FROM Orders) FROM Account WHERE Id IN :accsIds];
        // If any accounts have orders, then active__c must become false.
        Map<Id,Boolean> hasOrdersMap = new Map<Id,Boolean>();
        for(Account account : accounts){
            if(!account.Orders.isEmpty()){
                hasOrdersMap.put(account.Id, true);
            } else {
                hasOrdersMap.put(account.Id, false);
            }
        }
        return hasOrdersMap;
    }

    /**
     * hasTasks Description
     *
     * @param accs (Account[]): Write the parameter description
     *
     * @return Map<Id, Boolean>: Write the return description
     *
     * @throws Class name here Write the class description
     */
    public static Map<Id,Boolean> hasTasks(Account[] accs){
        // Create a list of account ids
        List<Id> accsIds = new List<Id>();
        for(Account a : accs){
            accsIds.add(a.Id);
        }
        Set<Id> accountsWithTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task
            WHERE WhatId IN :accsIds
            AND TaskSubtype = 'Call'
            GROUP BY WhatId
            ]).keySet();
        // Now return a map certifying which accounts have a task with the type Call
        Map<Id,Boolean> accsMapToReturn = new Map<Id,Boolean>();
        // Loop on accs
        for(Account a : accs){
            // Add it to the map, if it is contained, set the bool to false. 
            accsMapToReturn.put(a.Id, !accountsWithTask.contains(a.Id));
        }
        return accsMapToReturn;      
    }

    /**
     * createTasks Description Create a task on accounts with no tasks. The task created has the following parameters
     * - Sujet : « Call »
     * - Statut : « Nouvelle »
     * - Priorité : « Normale »
     * - Rappel automatique dans 5 jours
     *
     * @param accs (Account[]): Accounts to check
     *
     */
    public static void createTasks(Account[] accs){
        List<Task> tasksToInsert = new List<Task>();
        // First check if the accounts have tasks
        Map<Id,Boolean> hasTasksPerAccountId = hasTasks(accs);
        // Loop on the accounts and create the tasks
        for(Account a : accs){
            if(hasTasksPerAccountId.get(a.Id) == null){
                // No tasks. Create one
                tasksToInsert.add(new Task(Subject = 'Call',Status = 'New', Priority = 'Normal', WhatId = a.Id, OwnerId = a.OwnerId, isReminderSet = true, ReminderDateTime = DateTime.Now().AddDays(5)));
            }
        }

    }

}
