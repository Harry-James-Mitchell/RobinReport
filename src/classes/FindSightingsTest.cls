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
   
    static void testSearch(Sighting__c[] shouldBe, String mode, String query){
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
    
    @isTest static void testNextAndPrevious(){
        FindSightings finder = new FindSightings();
        finder.searchBy = 'Species';
        finder.input = 'bir';
        String query='%bir%';
        Sighting__c[] shouldBe = [SELECT Id, Name, Species__c FROM Sighting__c WHERE Species__r.Name LIKE :query ];
        finder.search();
        
        Test.startTest();
        System.assertEquals(finder.notFirstPage, false);
        
        System.assertEquals(Math.min(shouldBe.size(), 10), finder.sightingsSubList.size());
        
        finder.next();
        finder.next();
        
        
        for(Integer i =0; i < finder.sightingsSubList.size(); i += 1){
            system.assertEquals(shouldBe[20+i].Id, finder.sightingsSubList[i].Id);
        }
        

        finder.previous();        
        for(Integer i =0; i < finder.sightingsSubList.size(); i += 1){
            system.assertEquals(shouldBe[10+i].Id, finder.sightingsSubList[i].Id);
        }
        Test.stopTest();
    }
    
}