/**
 * OrderTriggerHandler Handles all logic on trigger operations on orders.
 *
 * @author VT
 * @version 1.0
 */
public with sharing class OrderTriggerHandler {

    // CONSTANTS
    private static final String DRAFT = 'Draft';
    private static final String ACTIVATED = 'Activated';
    private static final String ERRMSG = Label.VR_OrderWithoutProductsActivated;

    public static void beforeUpdate(Map<Id,Order> oldOrders ,Map<Id,Order> newOrders){
        // First restrict scope, check if the status of the order has changed, if the old one was Draft, and the new one Activated
        List<Order> ordersToUpdate = new List<Order>();
        for(Id orderId : newOrders.keySet()){
            Order oldOrder = oldOrders.get(orderId);
            Order newOrder = newOrders.get(orderId);
            if(oldOrder.Status == DRAFT && newOrder.Status == ACTIVATED){
                // Add it to the list
                ordersToUpdate.add(newOrder);
            }
        }

        // Now check if the orders have products 
        Map<Id,Boolean> hasProductsPerOrderId = hasProduct(ordersToUpdate);
        for(Order order : ordersToUpdate){
            if(!hasProductsPerOrderId.get(order.Id)){
                order.addError(ERRMSG);
                return;
            }
        }

    }

    public static void afterDelete(List<Order> orders){
        // Query the Account for each order and check if it has any orders
        // Get the accounts
        List<Account> accounts = new List<Account>();
        for(Order o : orders){
            accounts.add(o.Account);
        }
        Map<Id,Boolean> hasOrdersPerAccountId = AccountUtils.hasOrder(accounts);
        Account[] accsToUpdate = new List<Account>();
        // Loop through the map and change Active__c depending on the value of the map
        for(Id accId : hasOrdersPerAccountId.keySet()){
            Account a = new Account(Id = accId,Active__c = hasOrdersPerAccountId?.get(accId));
            accsToUpdate.add(a);
        }
        try {
            update accsToUpdate;
        } catch (Exception e) {
            System.debug('Error updating accounts : ' + e.getMessage());
        }
    }

    /**
     * hasProduct This method checks if a list of orders has products attached. Will create a map with the orders ids as keys and a boolean as value, being True if there are products attached.
     *
     * @param o (Order): Order being checked
     *
     * @return Map<Id,Boolean>: Attach orders Ids to a boolean value : True if there are products attached, false if not.
     *
     */
    private static Map<Id,Boolean> hasProduct(Order[] orders){
        //Create the map
        Map<Id,Boolean> hasProductsMap = new Map<Id,Boolean>();
        // Loop through the orders and assign them as false
        for(Order order : orders){
            hasProductsMap.put(order.id,false);
        }

        // Query the database for the products attached to the orders
        List<OrderItem> orderItems = [SELECT OrderId FROM OrderItem WHERE OrderId IN :orders];
        // Loop and add the orders to the map if there are products attached
        for(OrderItem orderItem : orderItems){
            hasProductsMap.put(orderItem.orderId, true);
        }
        return hasProductsMap;

    }


}
