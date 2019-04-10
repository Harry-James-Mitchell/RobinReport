@isTest
public class RecordPageSightingExtensionTest {

    @isTest static void testContructor(){
        Sighting__c[] shouldBe =[SELECT Id FROM Sighting__c];
        RecordPageSightingExtension rpse = new RecordPageSightingExtension(null);
        
        System.assertEquals(shouldBe.size(),rpse.sighting.size());
        for(Integer i =0; i < shouldBe.size(); i++){
            System.assertEquals(shouldBe[i].Id, rpse.sighting[i].Id);
        }
    }
}