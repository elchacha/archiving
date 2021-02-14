public class CaseTriggerHandler {
	
    public static void deleteArchived(List<Case> cases){
        List<Document> docs = new List<Document>();
        for(Case aCase : cases){
            if(aCase.idDocumentCaseChildArchived__c!=null)
	            docs.add(new Document(Id=aCase.idDocumentCaseChildArchived__c));
        }
        delete docs;
    }
}