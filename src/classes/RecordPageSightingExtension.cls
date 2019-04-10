public class RecordPageSightingExtension {

    public ApexPages.StandardSetController setController {get;set;}
    
    public List<Sighting__c> sighting {
        get {
            return setController.getRecords();
        }
        set;
    }
    
    public RecordPageSightingExtension(ApexPages.StandardSetController ctrl) {
        setController = new ApexPages.StandardSetController([SELECT Name,
                                                             SightingDate__c,
                                                             SightingTime__c,
                                                             Specie__c
                                                             FROM Sighting__c]);
        setController.setPageSize(5);
    }
}