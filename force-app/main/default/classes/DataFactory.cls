public with sharing class DataFactory {

    public static final String DRAFT = 'Draft'; 

    public static User createStandardUser() {
        User user = new User(Firstname ='testeur',
        Lastname ='test',
        Username ='standard@test.com' + System.currentTimeMillis(),
        Email ='test@test.com',
        Alias ='alias',
        CommunityNickname ='test' + System.currentTimeMillis() ,
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id, 
        LanguageLocaleKey ='en_US');
        return user;
    }

    public static PricebookEntry initPriceBook(String name, String productCode,Decimal price){
        Id pricebookId = Test.getStandardPricebookId();
        Product2  prod = new Product2();
        prod.Name = name;
        prod.ProductCode = productCode;
        prod.IsActive = true;
        insert prod;
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = prod.Id;
        pricebookEntry.UnitPrice = price;
        pricebookEntry.IsActive = true;
        return pricebookEntry;
    }

    public static Account createAccount(String name,boolean insertFlag) {
        Account account = new Account(Name = name);
        if(insertFlag) {
            insert account;
        }
        return account;
    }

    // Function to create an order with an account
    public static Order createOrder(Account a,Id pb2Id,boolean insertFlag) {
        Order order = new Order(AccountId = a.Id,Status = DRAFT,Pricebook2Id = pb2Id,EffectiveDate = System.today());
        if(insertFlag) {
            insert order;
        }
        return order;
    }

    public static OrderItem createOrderItem(Order o,Id pbeID,Decimal am,boolean insertFlag) {
        OrderItem orderItem = new OrderItem(OrderId = o.Id,PricebookEntryId = pbeID, Quantity = 1,UnitPrice=am);
        if(insertFlag) {
            insert orderItem;
        }
        return orderItem;
    }
}
