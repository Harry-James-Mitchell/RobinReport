@isTest
public class RecordPageSpeciesExtensionTest {
    
    @isTest static void testContructor(){
        ControllerTestUtility.createSpeciesAndSightings();
        Species__c[] shouldBe =[SELECT Name,
                                  ScientificName__c,
                                  SpeciesDescription__c,
                                  Picture__c
                                  FROM Species__c LIMIT 5];
        RecordPageSpeciesExtension rpse = new RecordPageSpeciesExtension(null);
        
        System.assertEquals(5,rpse.species.size());
        for(Integer i =0; i < shouldBe.size(); i++){
            System.assertEquals(shouldBe[i].Id, rpse.species[i].Id);
        }
    }
}