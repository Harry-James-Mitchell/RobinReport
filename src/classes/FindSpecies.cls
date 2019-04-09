public with sharing class FindSpecies {
   
    public String speciesName {get;set;} //This name is used for finding relevant species in the SOQL query
    public List<Species__c> species {get;set;} //This master list of all returned results
    public List<Species__c> speciesSubList {get;set;} //This list of all currently displayed results
    public boolean speciesFound {get;set;} //Determines the if the SOQL query found any elements
    public boolean notFirstPage {get;set;} //Determines if the previous button should be visible
    public boolean notLastPage {get;set;} //Determines if the next button should be visible
    private Integer OffSetCount; //Determines which element should be the first element displayed using Pagination
    private final Integer OFFSETAMOUNT = 8; //The amount of elements to be displayed on each page
    
    public FindSpecies() {
        speciesFound = false;
        notFirstPage = false;
        notLastPage = false;
        speciesSubList = new List<Species__c>();
        OffSetCount = 0;
    }
    
    public void findSpecies() {
        //This can be SQL injected. Fix it soontm
        String searchCriteria = '%' + speciesName + '%';
        //Make sure users have permission to view the fields
        if (Schema.sObjectType.Species__c.fields.Id.isAccessible() && Schema.sObjectType.Species__c.fields.Name.isAccessible()) {
            //Mabye change to use LIMIT 10 OFFSET :OffSetCount instead of storing everything in a subList
           species = [SELECT Id, Name, ScientificName__c, SpeciesDescription__c, Picture__c FROM Species__c WHERE Name LIKE :searchCriteria ];
        } else { //Tell user they are not allowed to view the fields on these records
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'You do not have permission to view these records'));
        }
        //No results were found
        if(species.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'No results were found'));
        } else {
            speciesFound = true;
            //Fill the list of elements to be displayed on the VF page
            for(Integer i=0; i<OFFSETAMOUNT && i<species.size(); i++){
                speciesSubList.add(species.get(i));
            }
            //Determine if there is only one page worth of results to be displayed
            if(species.size()>OFFSETAMOUNT){
                notLastPage = true;
                notFirstPage = false;
            }
            
        }
    }
    
    //Update the list of elements to be displayed with the next page of elements or the previous page of elements
    private void fillSubList(){
        speciesSubList = new List<Species__c>();
        for(Integer i=OffSetCount; i<OffSetCount+OFFSETAMOUNT && i<species.size(); i++){
            speciesSubList.add(species.get(i));
        }
    }
    
    //Load the next page of content
    public void next(){
        //Check to prevent an index out of bounds error
        if(OffSetCount + OFFSETAMOUNT > species.size()){
            notLastPage = false;
        } else {
            notFirstPage = true;
            notLastPage = true;
            OffSetCount += OFFSETAMOUNT;
            this.fillSubList();
            //Check to see if this page is the last page
            if(OffSetCount + OFFSETAMOUNT > species.size()){
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
            this.fillSubList();
            //Check to see if this is the first page of content
            if(OffSetCount - OFFSETAMOUNT < 0){
                notFirstPage = false;
            } 
        }
    }
}