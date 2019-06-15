global class StripePaymentController {
    public Integer amount {get;set;}
    List<Contact> conList {get;set;}
    public List<SelectOption> items {get;set;}
    public String cust {get;set;}
    public boolean success {get;set;}

    public StripePaymentController(){
        List<Contact> conList = [SELECT ID, Name,StripeID__c  FROM Contact WHERE StripeID__c != NULL];
        List<SelectOption> options = new List<SelectOption>(); 
        for (Contact c : conList ) {
            options.add(new SelectOption(c.StripeID__c, c.Name));
        }
        items  = options;
        success = false;
    }
    
    public String getcust(){
        return cust;
    }

    public void makePayment(){
        system.debug(cust);
        Stripe_Charge s = new Stripe_Charge();
        success = s.sendRequest(cust, amount);
        
    }
    
}