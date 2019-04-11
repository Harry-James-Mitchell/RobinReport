@isTest
public class RecordPageSightingExtensionTest {

    @isTest static void testContructor(){
        ControllerTestUtility.createSpeciesAndSightings();
        Sighting__c[] shouldBe =[SELECT Id FROM Sighting__c ORDER BY SightingDate__c desc LIMIT 15];
        RecordPageSightingExtension rpse = new RecordPageSightingExtension(null);

        System.assertEquals(15,rpse.sighting.size());
        for(Integer i =0; i < shouldBe.size(); i++){
            System.assertEquals(shouldBe[i].Id, rpse.sighting[i].Id);
        }
    }
}