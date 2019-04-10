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
    
    @isTest static void testSave(){
        ControllerTestUtility.createSpeciesAndSightings();
        SightingWizardController swc = new SightingWizardController();
        Species__c s = [SELECT Id FROM Species__c LIMIT 1];
        
        String randomName = String.valueOf(Math.random());
        swc.latitude = 35;
        swc.longitude = -70;
        
        Date theDate =  Date.newInstance((Integer) Math.floor(Math.random()*19) +2000,
                                         (Integer) Math.floor(Math.random()*12),
                                         (Integer) Math.floor(Math.random()*28));
        Time theTime = Time.newInstance((Integer) Math.floor(Math.random()*24),
                                        (Integer) Math.floor(Math.random()*60),
                                        (Integer) Math.floor(Math.random()*60),
                                        (Integer) Math.floor(Math.random()*1000));
        swc.species=s.Id;
        swc.Name = randomName;
        //negative
        swc.saveSighting();
        boolean saveFailed = false;
        try{
         	Sighting__c negativeInserted =[SELECT Id,Name FROM  Sighting__c WHERE Name = :randomNAme];
        }
        catch(QueryException e){
            saveFailed= true;
        }
        
        system.assertEquals(true, saveFailed);
        
        swc.sightingTime = theTime;
        swc.sightingDate = theDate;
        /*
        Sighting__c shouldBe = new Sighting__c();
        
        shouldBe.species__c=s.Id;
        shouldBe.sightingDate__c = theDate;
        shouldBe.sightingTime__c = theTime;
        shouldBe.Name = randomName;
        shouldBe.GeoAddress__latitude__s= 35;
        shouldBe.GeoAddress__longitude__s= -70;*/
                            
        PageReference pr = swc.saveSighting();
        Sighting__c inserted = [SELECT Id,GeoAddress__latitude__s, GeoAddress__longitude__s, Species__r.Id, SightingDate__c, SightingTime__c, Name 
                                FROM Sighting__c 
                                WHERE Name = :randomName
                                LIMIT 1];
        system.assert(inserted!= null);
        system.assertEquals(theDate, inserted.SightingDate__c);
        system.assertEquals(theTime, inserted.SightingTime__c);                                   
        system.assertEquals(s.id, inserted.Species__r.Id);
        system.assertEquals(35, inserted.GeoAddress__latitude__s);
        system.assertEquals(-70, inserted.GeoAddress__longitude__s);    

        system.assertEquals( (new ApexPages.StandardController(inserted)).view().getUrl() , pr.getUrl() );
        
       
        
            
	}
}