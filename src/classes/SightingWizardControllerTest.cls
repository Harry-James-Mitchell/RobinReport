@isTest
public class SightingWizardControllerTest {

    @isTest static void testGetSelectSpeciesItems(){
       ControllerTestUtility.createSpeciesAndSightings();
       SightingWizardController swc = new SightingWizardController();
        
       Species__c[] shouldBe = [SELECT Id, Name FROM Species__c];
       SelectOption[] options = swc.getSelectSpeciesItems();
       
        Test.startTest();
        system.assertEquals(shouldBe.size(), options.size());
        for(Integer i = 0; i < shouldBe.size(); i += 1){
            system.assertEquals(new SelectOption(shouldBe[i].id,shouldBe[i].Name), options[i]);
        }
       Test.stopTest();
    }
    
    @isTest static void testRedirects(){
        SightingWizardController swc = new SightingWizardController();
        
        System.assertEquals(Page.SightingPage2.getURL(), swc.pageOneNext().getURL());
        
        System.assertEquals(Page.SightingPage3.getURL(), swc.pageTwoNext().getURL());
        System.assertEquals(Page.SightingPage1.getURL(), swc.pageTwoPrevious().getURL());
        
        System.assertEquals(Page.SightingPage4.getURL(), swc.pageThreeNext().getURL());
        System.assertEquals(Page.SightingPage2.getURL(), swc.pageThreePrevious().getURL());
        
        System.assertEquals(Page.SightingPage3.getURL(), swc.pageFourPrevious().getURL());
    }
}