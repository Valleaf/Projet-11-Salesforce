/**
 * classname Description
 *
 * @author trouillet.valentin@resilient-koala-seczrx.com
 * @version Version number
 */
global class createTasksSchedulable implements Schedulable{
    
    global void execute(SchedulableContext sc){
        createTasksOnAccountsBatch b = new createTasksOnAccountsBatch(); 
        database.executebatch(b);
    }
}