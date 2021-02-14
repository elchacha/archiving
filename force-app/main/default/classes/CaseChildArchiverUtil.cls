public class CaseChildArchiverUtil {
    
    /*
     *	Archiving function 
     */
    
    public static void archive(List<CaseChild__c> ccToArchive){
        // retrieve the field we want to archive aka all of the writable fields
        ccToArchive = Database.query(QueryUtil.selectAllFields('CaseChild__c',true)+' where Id in (\''+String.join(new List<Id>(new Map<Id, CaseChild__c>(ccToArchive).keySet()),'\',\'')+'\')');
        
        // groupons nos resultats par l'objet parent : ici le case
		Map<Id,List<CaseChild__c>> mapCaseChildByIdParent = groupCaseChildbyParentId(ccToArchive);

        List<Document> documents = new List<Document>();
        for(List<CaseChild__c> caseChilds : mapCaseChildByIdParent.values()){
            documents.add(createDocument(caseChilds));
        }
        insert documents;
        saveInfoOnParent(documents);
        delete ccToArchive;
    }
    
    
    private static Map<Id,List<CaseChild__c>> groupCaseChildbyParentId(List<CaseChild__c> ccToArchive){
		Map<Id,List<CaseChild__c>> mapCaseChildByIdParent = new Map<Id,List<CaseChild__c>>();
        for(CaseChild__c caseChild : ccToArchive){
            if(!mapCaseChildByIdParent.containskey(caseChild.Case__c)){
                mapCaseChildByIdParent.put(caseChild.Case__c,new List<CaseChild__c>());
            }
            mapCaseChildByIdParent.get(caseChild.Case__c).add(caseChild);
        }
        return mapCaseChildByIdParent;
    }
    
    // méthode qui va générer le document qui contient nos objets archivés
    private static Document createDocument(List<CaseChild__c> caseChilds){
        // récupérons la clé du parent
        Id parentId = caseChilds.get(0).Case__c;
        Document document = new Document();
        // folder must be created before using the class.
        document.FolderId = label.Folder_ArchiveCaseChild;
        document.Name=parentId;
        // choose the name you want
        document.DeveloperName='caseChildArchived_'+parentId+'_'+Datetime.now().format('yyyyMMddHHmmss');
        // add the description you want
        document.Description='contains all caseChild__c from case with id '+parentId;
        document.Body = Blob.valueOf(JSON.serialize(caseChilds));
        return document;
    }
    
    private static void saveInfoOnParent(List<Document> documents){
        List<Case> caseToUpdate = new List<Case>();
        for(Document doc : documents){
            Case aCase = new Case();
            aCase.id=doc.name;
            aCase.idDocumentCaseChildArchived__c=doc.id;
            caseToUpdate.add(aCase);
        }
        update caseToUpdate;
    }
    
    
    /*
     *	Disarchiving function 
     */
    public static void disarchive(String idParent){
        Case aCase = [select id,idDocumentCaseChildArchived__c from Case where id =:idParent];
        disarchiveObjects(aCase.idDocumentCaseChildArchived__c);
        aCase.idDocumentCaseChildArchived__c='';
        update aCase;        
    }
    
    private static void disarchiveObjects(String idDocument){
        List<Document> docs =[select id,Body,Name from document where id =:idDocument];
        if(docs.size()>0){
            Document doc = docs[0];
            List<CaseChild__c> lstCaseChilds = (List<CaseChild__c>)JSON.deserialize(doc.Body.tostring(), List<CaseChild__c>.class);
            for(CaseChild__c cc : lstCaseChilds)cc.Id=null;
            insert lstCaseChilds;
            delete doc;
        }
    }

}