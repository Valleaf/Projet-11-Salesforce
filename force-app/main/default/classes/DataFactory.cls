public with sharing class DataFactory {

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

    

}
