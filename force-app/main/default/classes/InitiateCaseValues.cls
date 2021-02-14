public class InitiateCaseValues {

    //cette classe permet juste d'initialiser qq valeurs dans mon org pour la démo
    public static void initData(){
        Case case1 = new Case(Description='test 1');
        Case case2 = new Case(Description='test 2');
        insert (new List<Case>{case1,case2});
        Case caseUsed = case1;
        
        List<CaseChild__c> ccs = new List<CaseChild__c>();
        for(integer count=0;count<7;count++){
            if(count>3)caseUsed=case2;
            ccs.add(new CaseChild__c(
                Name='caseChild'+count
                ,DateTimeFieldTest__c=DateTime.newInstance(2021, 1, count, 0, 0, 0)
                ,NumberFieldTest__c=count,
                TestFieldTest__c=' test value'+count
                ,Case__c=caseUsed.Id)
            );
        }
        insert(ccs);
    }
    
}