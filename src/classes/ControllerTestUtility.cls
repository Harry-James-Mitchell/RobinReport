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
    
    
    //Creates 40 species named bird[0-39] and 120 sightings randomly associated with those species named sighting[0-119] 
    public static void createSpeciesAndSightings(){
                
        Species__c[] species = new Species__c[]{};
        
            for(Integer i=0; i < 40; i += 1){
                String name = 'bird' + i;
                String description = String.valueOf(Math.random());
                Species__c tmp = new Species__c();
                
                tmp.name=name;
                tmp.SpeciesDescription__c = description;
                tmp.ScientificName__c = name + 'ous';
                species.add(tmp);
            }
        	
        	insert species;
        
        Sighting__c[] sightings = new Sighting__c[]{};
        
        for(Integer i = 0; i < 120; i +=1 ){
            Integer speciesIndex = (Integer) Math.floor(Math.random()*5);
            String name = 'Sighting' + i ;
            Date theDate = Date.newInstance((Integer) Math.floor(Math.random()*19) +2000,(Integer) Math.floor(Math.random()*12),(Integer) Math.floor(Math.random()*28));
            
            Sighting__c tmp = new Sighting__c();
            tmp.Name = name;
            tmp.SightingDate__c = theDate;
            tmp.species__c = species[speciesIndex].Id;
            sightings.add(tmp);
        }
        
        insert sightings;

    }
}