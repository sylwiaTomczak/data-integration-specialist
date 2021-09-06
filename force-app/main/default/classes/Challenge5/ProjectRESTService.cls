@RestResource(urlMapping='/project/*')
global class ProjectRESTService {

    //przekazuje, wysyła w parametrze metody nazwy rekordów, którę mogą zostać:
    //wstawione, zaktualizowane
    @HttpPost
    global static String postProjectData(
   
    String projectRef,
    String projectName,
    String opportunityId,
    Date startDate,
    Date endDate,
    Double amount,
    String status) {


        //zabezpieczenie jeśli tranzakcja się nie powiedzie zwróci wszystko do bezpiecznego punktu
        //łączy się to z metodą Database.RollBack
        Savepoint savepoint = Database.setSavepoint();
        String returnMsg = 'Error';

        //try stworzyć nowy obiekt i zaktualizować jego pola
        try{
            Project__c project = new Project__c();
            project.ProjectRef__c = projectRef;
            project.Name = projectName;
            project.Opportunity__c = opportunityId;
            project.Start_Date__c = startDate;
            project.End_Date__c = endDate;
            project.Billable_Amount__c = amount;
            project.Status__c = status;            
            upsert project;

            //Tworzenie nowego opportu ity i przypisanie do niego id z obiektu wyżej.
            //uzupełnie statusu i update, upewnienie się, że zwróci status ok czyli, że działą
            Opportunity opp = new Opportunity();
            opp.ID = opportunityId;
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;

            return 'OK';

        //jeśli coś pójdzie nie tak przechwytuje błąd i wraca do savepoint

        }catch(Exception ex){
            Database.rollback(savepoint);
            returnMsg = ex.getMessage();
        }

        return returnMsg;

    }
}
