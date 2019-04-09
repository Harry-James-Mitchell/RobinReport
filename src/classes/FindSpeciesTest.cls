@isTest
public class FindSpeciesTest {
	
    @testSetup static void setup(){
        ControllerTestUtility.createSpeciesAndSightings();
    }
    
    @isTest static void testFindSpecies(){
        FindSpecies finder = new FindSpecies();
        finder.speciesName = 'bir';
        String query='%bir%';
        Species__c[] shouldBe = [SELECT Id, Name, ScientificName__c, SpeciesDescription__c, Picture__c FROM Species__c WHERE Name LIKE :query ];
        
        
        
        Test.startTest();
        //Positive
        finder.FindSpecies();
        system.assertEquals(shouldBe.size(), finder.species.size());
        
        for(Integer i = 0; i < shouldBe.size(); i += 1){
            system.assertEquals(shouldBe[i], finder.species[i]);
        }
        
        //Negative
        
        finder.speciesName = 'asdgbn';
        finder.FindSpecies();
        system.assertEquals(0, finder.species.size());
        
        
        //User perms
        finder.speciesName = 'bir';
        User u = ControllerTestUtility.createUser('Read Only');
        
        System.runAs(u)
        {
            finder.FindSpecies();
        	system.assertEquals(0, finder.species.size());
        }        
        
        Test.stopTest();
	}
    
    @isTest static void testNextAndPrevious(){
        FindSpecies finder = new FindSpecies();
        finder.speciesName = 'bir';
        String query='%bir%';
        Species__c[] shouldBe = [SELECT Id, Name, ScientificName__c, SpeciesDescription__c, Picture__c FROM Species__c WHERE Name LIKE :query ];
        finder.findSpecies();
        
        Test.startTest();
        System.assertEquals(finder.notFirstPage, false);
        
        System.assertEquals(Math.min(shouldBe.size(), 8), finder.speciesSubList.size());
        
        finder.next();
        finder.next();
        
        
        for(Integer i =0; i < finder.speciesSubList.size(); i += 1){
            system.assertEquals(shouldBe[16+i], finder.speciesSubList[i]);
        }
		

		finder.previous();        
        for(Integer i =0; i < finder.speciesSubList.size(); i += 1){
            system.assertEquals(shouldBe[8+i], finder.speciesSubList[i]);
        }
        Test.stopTest();
    }
    
}