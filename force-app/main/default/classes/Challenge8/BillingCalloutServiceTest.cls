@isTest
private class BillingCalloutServiceTest {
  
  //tworzenie i wstawienie prowizorycznych obiektow 
  @testSetup static void testSetup(){

    Opportunity opportunity = new Opportunity();
    opportunity.Name = 'test';
    opportunity.CloseDate = Date.today();
    opportunity.StageName = 'Prospecting';
    insert opportunity;

    Project__c project = new Project__C();
    project.Name = 'testPro';
    project.Billable_Amount__c = 10;
    project.ProjectRef__c = 'testPro';
    project.Status__c = 'Running';
    project.Opportunity__c = opportunity.Id;
    insert project;

    ServiceCredentials__c serviceCredentials = new ServiceCredentials__c();
    serviceCredentials.Name = 'BillingServiceCredential';
    serviceCredentials.Username__c ='usr1';
    serviceCredentials.Password__c ='pwd1';
    insert serviceCredentials;

  }

  //pozytywny przypadek testowy
  //podstawiam mock success
  @isTest 
  static void testSuccess(){
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    //select pobierający status wstawionego obiektu project
    //asercja czy jest 1
    List<Project__c> project = [SELECT Status__c FROM Project__C WHERE ProjectRef__c = 'testPro'];
    System.assertEquals(1, project.size());

    //wywołanie testu ze sprawdzeniem czy 1 pozycja ma status rowny billable i update. 
    Test.startTest();
      project[0].Status__c='Billable';
      update project;
    Test.stopTest();
  }

  //tak samo jak wyżej tylko negatywny przypadek 
    @isTest 
    static void testFail(){
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure()); 

      List<Project__c> project2 = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'testPro'];
      System.assertEquals(1, project2.size());

      Test.startTest(); 
        project2[0].Status__c = 'Running';
          update project2;
      Test.stopTest();
  }
}