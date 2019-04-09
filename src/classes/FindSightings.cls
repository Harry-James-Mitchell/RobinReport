public class FindSightings {
    public String input{get;set;}
   // Apexpages.StandardSetController ctrl;
    public Sighting__c[] sightings{ get;  set;}
    public String searchBy{get;set;}
    
    public FindSightings(Apexpages.StandardSetController ctrl){
       // this.ctrl = ctrl;
       // ctrl.setPageSize(5);
        
       // sightings= new Sighting__c[]{};
    }
    
    public void search(){
        if(!Schema.SObjectType.Sighting__c.isAccessible()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING ,
            	'You do not have permission to access sightings. Please contact the system admindinistrator if you believe this is an error.');
            ApexPages.addMessage(msg);
            sightings=null;
            return;
        }
        
        if(input.length() <2){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO ,'Please enter a longer name');
            ApexPages.addMessage(msg);
            sightings=null;
            return ;
        }
        
        String query = '%' + input + '%';
        
        switch on searchBy{
            when 'Species'{
                sightings = searchBySpecies(query);
            }
            when'Sighting'{
                sightings = searchBySighting(query);
            }
            when else{
                return;
            }

        }
        if(sightings.size() == 0 ){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO ,'No results returned, please change your search.');
                ApexPages.addMessage(msg);
                sightings=null;
                return ;
            }
        
    }
    
    private Sighting__c[] searchBySpecies(String speciesName){
        
        return [SELECT Name, Species__c, SightingDate__c FROM Sighting__c  WHERE Species__r.Name like :speciesName];
    }

    private Sighting__c[] searchBySighting(String sightingName){

        
        return [SELECT Name, Species__c, SightingDate__c FROM Sighting__c WHERE Name like :sightingName];
      
  
            }
    
    public PageReference nearbyRedirect(){
        PageReference pf = new  PageReference('/apex/VF/RecordPageSighting');
        pf.setRedirect(true);
        return pf;
    }
    
}