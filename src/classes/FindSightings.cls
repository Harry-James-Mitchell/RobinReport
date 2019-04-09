public with sharing class FindSightings {
    
    public String input{get;set;} //String to be used for querying later
   // Apexpages.StandardSetController ctrl;
    public Sighting__c[] sightings{ get;  set;} //Master list of all sightings returned from the query
    public Sighting__c[] sightingsSubList {get;set;} //list of all sightings to currently be displayed in the table
    public boolean notFirstPage {get;set;} //Determines if the previous button should be visible
    public boolean notLastPage {get;set;} //Determines if the next button should be visible
    private Integer OffSetCount; //Determines which element should be the first element displayed using Pagination
    private final Integer OFFSETAMOUNT = 10; //The amount of elements to be displayed on each page
    public String searchBy{get;set;}
    
    public FindSightings(Apexpages.StandardSetController ctrl){
       // this.ctrl = ctrl;
       // ctrl.setPageSize(5);
        
       // sightings= new Sighting__c[]{};
        notFirstPage = false;
        notLastPage = false;
        sightingsSubList = new List<Sighting__c>();
        OffSetCount = 0;
    }
    
    public FindSightings(){
        notFirstPage = false;
        notLastPage = false;
        sightingsSubList = new List<Sighting__c>();
        OffSetCount = 0;
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
        } else {
            notFirstPage = false;
            notLastPage = sightings.size()>OFFSETAMOUNT;
            this.updateSubList();
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
    
    //empty the sublist and fill it with the appriorate sightings
    private void updateSubList(){
        sightingsSubList = new List<Sighting__c>();
        for(Integer i=OffSetCount; i<OffSetCount+OFFSETAMOUNT && i<sightings.size(); i++){
            sightingsSubList.add(sightings.get(i));
        }
    }
    
    //Load the next page of content
    public void Next(){
        //Check to prevent an index out of bounds error
        if(OffSetCount + OFFSETAMOUNT > sightings.size()){
            notLastPage = false;
        } else {
            notFirstPage = true;
            notLastPage = true;
            OffSetCount += OFFSETAMOUNT;
            this.updateSubList();
            //Check to see if this page is the last page
            if(OffSetCount + OFFSETAMOUNT > sightings.size()){
            	notLastPage = false;
        	}
        }
    }
    
    //Load the previous page of content
    public void previous(){
        //Check to prevent an index out of bounds error
        if(OffSetCount - OFFSETAMOUNT < 0){
            notFirstPage = false;
        } else {
            notLastPage = true;
            notFirstPage = true;
            OffSetCount -= OFFSETAMOUNT;
            this.updateSubList();
            //Check to see if this is the first page of content
            if(OffSetCount - OFFSETAMOUNT < 0){
                notFirstPage = false;
            } 
        }
    }
}