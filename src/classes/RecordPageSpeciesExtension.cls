public class RecordPageSpeciesExtension {
    public ApexPages.StandardSetController setController {get;set;}
    
    public List<Species__C> species {
        get {
            return setController.getRecords();
        }
        set;
    }
    
    public RecordPageSpeciesExtension(ApexPages.StandardSetController ctrl) {
        setController = new ApexPages.StandardSetController([SELECT Name,
                                                             ScientificName__c,
                                                             SpeciesDescription__c,
                                                             Picture__c
                                                             FROM Species__c]);
        setController.setPageSize(5);
    }
    
}