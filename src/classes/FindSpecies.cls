public with sharing class FindSpecies {
    
    public String speciesName {get;set;}
    public List<Species__c> species {get;set;}
    public boolean speciesFound {get;set;}
    
    public FindSpecies() {
        speciesFound = false;
    }
    
    public void findSpecies() {
        String searchCriteria = '%' + speciesName + '%';
        species = [SELECT Id, Name, SpecieDescription__c FROM Species__c WHERE Name LIKE :searchCriteria];
        if(species != null)
            speciesFound = true;
    }
}