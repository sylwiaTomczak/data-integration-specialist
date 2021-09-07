//trigger wywoływany na obiekcie project po aktualizacji
trigger ProjectTrigger on Project__C (after update) {

    if(Trigger.isUpdate){

        //przejscie po nowych nowych rekordach
        //jesli status nie jest pusty i rowna sie billable to wywolanie klasy i metody
        //- przypisanie jako parametry tego obiektu i odpowiednich danych
        for(Project__c project : Trigger.new){
            if(project.Status__c != null && project.Status__c.equals('Billable')){
                BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
                       }
        }
    }

}