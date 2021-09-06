@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock{

    //Mockowanie czyli taka symulacja aplikacji. Wysyłanie odpowiedzi podczas testowania wywołań HTTP
    //W tym przypadku scenariusz jeśli komunikat zwrotny będzie ok

    global HTTPResponse respond(HTTPRequest request){

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(201);
        response.setStatus('OK');

        return response;
    }
}
