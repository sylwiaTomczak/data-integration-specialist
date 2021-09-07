public class BillingCalloutService {


    //metoda testuje czy wykona się integrecja, 
    //przekazane parametry według kryteriów i future
    @future(callout = true)
    public static void callBillingService(String ProjectRef, Decimal amount) {

        //pobieranie wartości z wcześniej stworzonego obiektu i tworzenie zmiennej
        ServiceCredentials__c serviceCredentials = ServiceCredentials__c.getValues('BillingServiceCredential');

        //odowłanie się do wygenerowaniej klasy z WSLD pliku i jej metody
        //przypisanie hasla i usera itp do project ze zmiennej pobranej wyżej
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.username = serviceCredentials.Username__c;
        project.password = serviceCredentials.Password__c;
        project.billAmount = amount;

        //odowłanie się do wygenerowaniej klasy z WSLD pliku i jej metody
        //przypisanie do zmiennej response wartosci z metody billPRoject
        // z dodaniem parametru z wartosciami przypisanymi wyzej do project
        BillingServiceProxy.InvoicesPortSoap11 portSoap = new BillingServiceProxy.InvoicesPortSoap11();
        String response = portSoap.billProject(project);

        //tworzenie listy z projektami
        //sprawdzenie czy lista nie jest pusta i czy równa się ok ignorując wielkość liter
        List<Project__c> projectList = new List<Project__C>();
        if(response != null && response.equalsIgnoreCase('OK')){

            //nowa lista z selectem pobierajacym status z z obiektu project gdzie pole równa się external id
            //przechodzenie po liscie i szukanie statusu równego Billed. 
            //Dodanie tego do listy i updatowanie
            List<Project__c> projectList2 = [SELECT Status__c FROM Project__c WHERE ProjectRef__c =: projectRef];
            for(Project__c pro : projectList2){
                pro.Status__C = 'Billed';

                projectList2.add(pro);
            }

            update projectList2;
        }

    }
}
