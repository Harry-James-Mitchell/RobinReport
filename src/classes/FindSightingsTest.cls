@isTest
public class FindSightingsTest {
	
    @testSetup
    public static void setup(){
        ControllerTestUtility.createSpeciesAndSightings();
    }
    
    @isTest static void testSearchBySpecies(){
        
        Sighting__c[] shouldBe = [SELECT id FROM Sighting__c WHERE Species__r.Name like '%bird1%'];
        testSearch(shouldBe,'Species', '%bird1%');
    }

	@isTest static void testSearchBySighting(){
        
        Sighting__c[] shouldBe = [SELECT id FROM Sighting__c WHERE Name like '%Sighting1%'];
        testSearch(shouldBe,'Sighting', '%Sighting1%');
    }
  
    
    
    public static void testSearch(Sighting__c[] shouldBe, String mode, String query){
        //setup
        FindSightings finder = new FindSightings(null);
        finder.searchBy = mode;
        finder.input = query;
        
        User u = ControllerTestUtility.createUser('Read Only');
       
        Test.startTest();
        //Positive
        finder.search();
        for(Integer i=0; i < shouldBe.size(); i += 1){
            System.assertequals(shouldBe[i].Id, finder.sightings[i].Id);
        }
        
        //negative
        finder.sightings = null;
        finder.input = 'asdf';
        finder.search();
        System.assertEquals(null, finder.sightings);
        
        finder.sightings = null;
        finder.input = 'a';
        finder.search();
        System.assertEquals(null, finder.sightings);
        
        //User perms
        finder.sightings = null;
        
        
        System.runAs(u){
            finder.input = query;
            finder.search();            
        }
        System.assertEquals(null,finder.sightings);
        
        Test.stopTest();
    }
    
    
}