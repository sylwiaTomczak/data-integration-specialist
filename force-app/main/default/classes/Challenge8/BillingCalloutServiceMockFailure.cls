@isTest
global class BillingCalloutServiceMockFailure implements WebServiceMock{
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
        //podstawienie statusu error i porownanie z tym co zwroci proxy i tym co podstawilam
        BillingServiceProxy.billProjectResponse_element respElement = new BillingServiceProxy.billProjectResponse_element();
        respElement.status ='UNAUTHORIZED';
        response.put('response_x', respElement);
    }
}