/**
* @author Fabrice CHALLIER
* @date 2021/02/14
*
* @group Query
*
* @description Classe permettant de générer une requete pour selectionner tous les champs d'un objet 
*/
public class QueryUtil {


    public static String selectAllFields(String sobjectname,boolean writeable){
    	return selectAllFields(sobjectname,writeable,null);
    }

    
    public static String selectAllFields(String sobjectname,boolean writeable,List<String> additionalFields){
    	Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
  
    	Set<String> useAbleFields = new Set<String>();
        if(additionalFields!=null)useAbleFields.addAll(additionalFields);
  
    	for(Schema.SObjectField field : fields.values()){
            if(writeable&&field.getDescribe().isCreateable())useAbleFields.add(field.getDescribe().getName());
            if(!writeable&&field.getDescribe().isAccessible())useAbleFields.add(field.getDescribe().getName());
        }
        return 'Select '+String.join(new List<String>(useAbleFields),',')+' from '+sObjectName;

  	}    
    
}