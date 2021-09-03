public with sharing class ProjectCalloutService {
   
        @InvocableMethod
        public static void postOpportunityToPMS(List<ID> opportunityIds) {

                //pobranie opportunity z tabeli , które mają id z przekazanej listy
                Opportunity processOpportunity =[SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id= :opportunityIds];

                Id oppId = opportunityIds[0];
                String token = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;

                String postJson =       '{"opportunityId": "'+opportunityIds[0]+'",' +
                                        '"opportunityName": "'+processOpportunity.Name+'",'+
                                        '"accountName": "'+processOpportunity.Account.Name+'",'+
                                        '"closeDate": "'+processOpportunity.CloseDate+'",'+
                                        '"amount": '+processOpportunity.Amount+'+ }';


                //sprawdzenie czy lista przekazana w parametrze nie jest nullem i jednocześnie czy ma jakieś elementy,
                //jeśli tak to tworzy tworzy obiekty QueueablePMSCall do kolejki
                if(opportunityIds != null && opportunityIds.size()> 0){
                         System.enqueueJob(new QueueablePMSCall(token, postJson, oppId));
                }
        }

        private static void makePost(String projectServiceToken, String jsonInput, ID oppId){


                //zapytanie htttp post, w setBody serializuje- czyli tak jakby zapisuje w tablicy bajtów info o nowo utworzonym obiekcie 
                HttpRequest request = new HttpRequest();
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('token', projectServiceToken);
                request.setEndpoint('callout:ProjectService');
                request.setBody(jsonInput);
                HttpResponse response = new Http().send(request);

                Opportunity opportunity = new Opportunity(id = oppId);

                //Sprawdenie odpowiedzi. Jeśli status kodu 201 to ok i działa, jeśli 500 to fail. 
                //Na koniec robi update- aktualizuje opportunity w bazie
                if(response.getStatusCode() == 201 && response.getStatus() == 'OK')
                        opportunity.StageName = 'Submitted Project';
                else if(response.getStatusCode() == 500)
                        opportunity.StageName = 'ResubmitProject';

                update opportunity;
        }


        //klasa w kolejce do umieszczenia w kolejce rządania POST
        public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{

                private String token;
                private String json;
                private Id oppId;

                public QueueablePMSCall(String token, String json, Id oppId){
                        this.token = token;
                        this.json = json;
                        this.oppId = oppId;
                }

                public void execute(System.QueueableContext context){

                        makePost(token, json, oppID);
                }
        }
 

	private Id SystemEnqueueJob(ProjectCalloutService.QueueablePMSCall q){
		return null;
	} 
}