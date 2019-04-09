@isTest
public class FindSightingsTest {
	
    @testSetup
    public static void setup(){
        
        Species__c[] species = new Species__c[]{};
        
            for(Integer i=0; i < 5; i += 1){
                String name = 'bird' + i;
                String description = String.valueOf(Math.random());
                Species__c tmp = new Species__c();
                
                tmp.name=name;
                tmp.SpeciesDescription__c = description;
                
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
        
        User u = ControllerTestUtility.createUser('Robin Report Test');
       
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