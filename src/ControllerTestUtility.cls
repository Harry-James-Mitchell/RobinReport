@isTest
public class ControllerTestUtility {

    public static User createUser(String profileName){
        User u = new User();
        u.LastName = 'test';
        u.Alias = 'test';
        String name = String.valueOf( Math.random());
        u.Username = name + '@project2.com';
        u.Email = 'hcrane88@gmail.com';
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name= :profileName LIMIT 1];
    	u.ProfileId = testProfile.Id;
        
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        return u;
    }
}