public class FindSighting {
    // property for sighting name 
    public String sightingName {get; set;}
    // storage for sighting records
    public Sighting__c sighting {get; set;}
    // boolean wil return true if sighting is found 
    public boolean sightingFound {get; set;}
    
    // Constuctor initializes boolean to false 
    public FindSighting(){
        sightingFound = false; 
    }
    
    // function uses query to search specified Species records 
    // Store those records in above specified List 
    public void findMySighting(){
        // Store speciesName so it can be used in the query 
        String searchSightingName = '%' + sightingName + '%'; 
        // SOQL query store in sighting 
        sighting = [SELECT Id, Name, SightingDate__c, SightingTime__c, Species__c 
                   FROM Sighting__c
                   WHERE Name 
                   LIKE :searchSightingName];
        // If sightingName is found change sightingFound to true 
        if(sighting != null)
            sightingFound = true; 
    }
}