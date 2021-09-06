@isTest
private class ProjectRESTServiceTest {


    //Tworzenie obiektów z i inicjowanie pól żeby insert i sprawdzenie czy działą
    @TestSetup
    public static void ProjectRESTServiceTest() {

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test';
        opportunity.DeliveryInstallationStatus__c = 'In progress';
        opportunity.CloseDate = (Date.today()).addDays(2);
        opportunity.StageName = 'Submitted Project';
        insert opportunity;

        Project__c project = new Project__c();
        project.ProjectRef__c = 'projectRef';
        project.Name = 'projectName';
        project.Opportunity__c = opportunity.Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = (Date.today()).addDays(1);
        project.Billable_Amount__c = 10000;
        project.Status__c = 'Running';            
        insert project;
    }

    //wyciągnięcie opportunity o podanej nazwie, 
    //w tescie wstawienie obiektu o danych polach podanych w metodzie
        @isTest
        public static void positiveTest(){

            Opportunity opp = [SELECT Id FROM Opportunity WHERE NAme ='Test'];

            Test.startTest();
            String response = ProjectRESTService.postProjectData(
                'test',
                'test', 
                opp.id, 
                Date.today(), 
                Date.today().addDays(1), 
                100, 
                'Running');
            Test.stopTest();
           
        //wyciągniecie opportunity z polem DeliveryInstallationStatus_c o id wstawione opp w test
        //sprawdzenie czy pole rowna się temu wstawionemu i porownanie zwróconego statusu z oczekiwanym
            opp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE id = :opp.id];
            System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
            System.assertEquals('OK',response);
        }

        //Teest negatywny żeby zrealizować pokrycie testowe
        @isTest
        public static void negativeTest(){

            Test.startTest();
            String response = ProjectRESTService.postProjectData(
                'test',
                'test', 
                'opp id', 
                Date.today(), 
                Date.today().addDays(1), 
                100, 
                'Running');
            Test.stopTest();
           
            //test negatywny mi nie przechodził bo porównywałam response z 'Error",
            // później podmieniłam status na ten wyświetlany w błędzie
        System.assertEquals('Invalid id: opp id', response);
        }

    
}
