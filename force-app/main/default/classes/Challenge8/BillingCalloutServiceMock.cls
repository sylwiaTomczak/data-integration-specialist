@isTest

//przekazanie zmiennych jako parametry
//zmienne odwołują się do wygenerowanej klasy proxy
global class BillingCalloutServiceMock implements WebServiceMock{
    global void doInvoke(   
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType) {

        //wywołanie metody z klasy proxy
        //podstawienie statusu ok i porownanie z tym co zwroci proxy i tym co podstawilam
        BillingServiceProxy.billProjectResponse_element respElement = new BillingServiceProxy.billProjectResponse_element();
        respElement.status ='OK';
        response.put('response_x', respElement);
    }
}
