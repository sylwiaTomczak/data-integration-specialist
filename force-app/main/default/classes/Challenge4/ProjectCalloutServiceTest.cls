@isTest
private class ProjectCalloutServiceTest {

    //implementacja mocków
    @testSetup static void test(){

        //Stworzenie opportunity żeby podstawić pod testy te rekordy
        Opportunity opportunityTest1 = new Opportunity();
        opportunityTest1.Name = 'Test1';
        opportunityTest1.Type = 'New';
        opportunityTest1.Amount = 100;
        opportunityTest1.CloseDate = Date.today();
        opportunityTest1.StageNAme = 'Submitted Project';
        insert opportunityTest1;

        Opportunity opportunityTest2 = new Opportunity();
        opportunityTest2.Name = 'Test2';
        opportunityTest2.Type = 'New';
        opportunityTest2.Amount = 200;
        opportunityTest2.CloseDate = Date.today();
        opportunityTest2.StageNAme = 'Resubmit Project';
        insert opportunityTest2;


        //zainicjowanie i wstawienie tego tokena
        ServiceTokens__c serviceToken = new ServiceTokens__c();
        serviceToken.Name = 'ProjectServiceToken';
        serviceToken.Token__c = 'TestToken';
        insert serviceToken;

        }
        
        @isTest
        static void testSuccess(){

            //pobranie 1 wstawionego opportunity
            Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test1'];
           
           //pobranie id pobranego selecta- da się zrobić to jakoś inaczej? 
            List<ID> opp1ID = new List<ID>();
            opp1ID.add(opp.id);

            //wywołanie testu wkładam klasę z mockiem,
            Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

            // wywołuję klasę którą testuje i podstawiam jako parametr pobrane id
            Test.startTest();
            ProjectCalloutService.postOpportunityToPMS(opp1ID);
            Test.stopTest();

            //pobranie tego updatowanego opp z test.start, test.stop i sprawdzenie
            //czy nazwa w response 201 podana w klasie, którą testuje zgadza się z id opportunity, które wstawiłam 
            //czyli czy działa i zgadza się z statustem.
            opp = [SELECT StageName FROM Opportunity WHERE id =: opp.Id];
            System.assertEquals('Submitted Project', opp.StageName);
        }  

        //taka sama sytuacja jak wyżej tylko warunek 500 fail
        @isTest
        static void testFail(){

            Opportunity opp2 = [SELECT ID, NAme FROM Opportunity WHERE Name = 'Test2' Limit 1];
            List<ID> opp2ID = new List<ID>();
            opp2ID.add(opp2.id);

            Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

            Test.startTest();
            ProjectCalloutService.postOpportunityToPMS(opp2ID);
            Test.stopTest();

            opp2 = [SELECT StageNAme FROM Opportunity WHERE id =: opp2.Id];
            System.assertEquals('ResubmitProject', opp2.StageName);

        }
}
