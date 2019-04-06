public class FindSpecies {
	// property for species name 
    public String speciesName {get; set;}
    // storage for species records
    public Species__c species {get; set;}
    // boolean wil return true if species is found 
    public boolean speciesFound {get; set;}
    
    // Constuctor initializes boolean to false 
    public findSpecies(){
        speciesFound = false; 
    }
    
    // function uses query to search specified Species records 
    // Store those records in above specified List 
    public void findMySpecies(){
        // Store speciesName so it can be used in the query 
        String searchSpeciesName = '%' + speciesName + '%'; 
        // SOQL query store in list 
        species = [SELECT Id, Name, SpeciesDescription__c, Picture__c
                   FROM Species__c
                   WHERE Name 
                   LIKE :searchSpeciesName];
        // If speciesName is found change speciesFound to true 
        if(species != null)
        	speciesFound = true; 
    }
}