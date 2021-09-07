@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   
    //Mockowanie czyli taka symulacja aplikacji. Wysyłanie odpowiedzi podczas testowania wywołań HTTP
    //W tym przypadku scenariusz jeśli komunikat zwrotny będzie fail
    global HTTPResponse respond(HTTPRequest request){

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(500);
        response.setStatus('Error');

        return response;
    }
}