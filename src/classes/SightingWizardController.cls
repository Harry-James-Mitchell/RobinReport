public class SightingWizardController {
    public string Name{get;set;}
    public Date sightingDate{get;set;}
    public Time sightingTime{get;set;}
    public decimal longitude{get;set;}
    public decimal latitude{get;set;}
    public Id species{get;set;}
   
    
    public List<SelectOption> getSelectSpeciesItems(){
        List<SelectOption> options = new List<SelectOption> ();
        List<Species__c> tempSpecieList = [SELECT Id, ScientificName__c, Name
                                           FROM Species__c]; 
        for(Species__c tempSpecie : tempSpecieList){
            SelectOption option = new SelectOption(tempSpecie.id, tempSpecie.Name ); 
            options.add(option); 
        }
        
        return options; 
                
    }

    public PageReference pageOneNext(){
        System.debug('newSighting: ' + Name);
        return Page.SightingPage2; 
    }
    
    public PageReference pageTwoPrevious(){
        return Page.SightingPage1; 
    }
    
    public PageReference pageTwoNext(){
        System.debug('newSighting: ' + sightingDate);
        System.debug('newSighting: ' + sightingTime);
        return Page.SightingPage3; 
    }

     public PageReference pageThreePrevious(){
        return Page.SightingPage2; 
    }

    public PageReference pageThreeNext(){
        System.debug('long: ' + longitude);
        System.debug('lat: ' + latitude);
        return Page.SightingPage4; 
    }
    
    public PageReference pageFourPrevious(){
        return Page.SightingPage3; 
    }
    
    public PageReference saveSighting(){
        system.debug('start Save!!!');
        Sighting__c newSighting = new Sighting__c(); 
        newSighting.Name = Name; 
        newSighting.SightingDate__c = sightingDate; 
        newSighting.SightingTime__c = sightingTime; 
        newSighting.GeoAddress__longitude__s = longitude; 
        newSighting.GeoAddress__latitude__s = latitude; 
        newSighting.Species__c = species;
        system.debug('Inserting!!!');
        System.debug('newSighting: ' + newSighting);
        try{
            insert newSighting; 
        }catch(DMLException e){
            System.debug('ERROR inserting newSighting' + e.getMessage());
        }    
        system.debug('That B IN !!!');
        
        return (new ApexPages.StandardController(newSighting)).view(); 
            
    }  
}