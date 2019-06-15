public class Stripe_Charge{
    public Boolean sendRequest(String custID, Integer Amount){
        
        Stripe_Details__c BaseEndPoint = Stripe_Details__c.getInstance('BaseEndPoint');       
        Stripe_Details__c ContentType = Stripe_Details__c.getInstance('ContentType'); 
        Stripe_Details__c PublishableKey = Stripe_Details__c.getInstance('PublishableKey'); 
        Stripe_Details__c SecretKey = Stripe_Details__c.getInstance('SecretKey'); 
        
        String TripItAccessDataUri=BaseEndPoint.value__c +'charges';       
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(TripItAccessDataUri);
        req.setHeader('Content-Type',ContentType.value__c);
        req.setHeader('Authorization', 'Bearer '+SecretKey.value__c);
        Map<String, Object> params = new Map<String,Object>();
        params.put('amount', Amount);
        params.put('currency', 'usd');
        params.put('customer',custID);   
        req.setBody(String.valueOf(params).remove('}').remove('{').replace(',','&'));    
        system.debug('Request  ' + req.getBody());
        HttpResponse res = h.send(req);
           
        string resData =  res.getBody();
        
        Map<String,Object> reponseMap = (Map<String,Object>)JSON.deserializeUntyped(resData);
        system.debug(' reponseMap ' + reponseMap );
        List<Contact> contList = [Select id from Contact where StripeId__c =:custID limit 1];
        if(contList != null && contList.size() >0 && reponseMap != null && reponseMap.get('status') == 'succeeded'){
            String cardNum='';
            if(reponseMap.get('payment_method_details') != null){
                Map<String, Object> paymentObj= (Map<String, Object>)reponseMap.get('payment_method_details');
                cardNum = String.valueOf(paymentObj.get('last4'));
            }
            
            Payment_Details__c pd = new Payment_Details__c();
            pd.Amount__c = Integer.valueOf(reponseMap.get('amount'));
            pd.Contact__c = contList[0].id;
            pd.Charge_Id__c = String.valueOf(reponseMap.get('id'));
            pd.Receipt_URL__c = String.valueOf(reponseMap.get('receipt_url'));          
            pd.Card_Number__c = cardNum;
            insert pd;
            return true;
        }
        return false;
        
    }
    
    
    public void createCustomer(String Name, String Email, String Description){
        string TripItAccessDataUri='https://api.stripe.com/v1/customers';
        //string TripItAccessDataUri = 'http://webhook.site/5a1eed17-dd47-4209-b63f-8b4dfb12ffa2';
    
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(TripItAccessDataUri);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setHeader('Authorization', 'Bearer sk_test_uC8p8C6Gazk21VW4RVLznNrz00TRw2nVKO');
        Map<String, Object> params = new Map<String,Object>();
        params.put('name', Name);
        //params.put('source', 'tok_amex');
        params.put('email',Email);
        params.put('description',Description);   
        req.setBody(String.valueOf(params).remove('}').remove('{').replace(',','&'));    
        system.debug(' Request' + req );
        HttpResponse res = h.send(req);    
        string resData =  res.getBody();
        system.debug(' Respose' + resData );
   
    }
    
   /* public void createToken(){
    string TripItAccessDataUri='https://api.stripe.com/v1/tokens';
    //string TripItAccessDataUri = 'http://webhook.site/5a1eed17-dd47-4209-b63f-8b4dfb12ffa2';

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod('POST');
    req.setEndpoint(TripItAccessDataUri);
    req.setHeader('Content-Type','application/x-www-form-urlencoded');
    req.setHeader('Authorization', 'Bearer sk_test_uC8p8C6Gazk21VW4RVLznNrz00TRw2nVKO');
    Map<String, Object> params = new Map<String,Object>();
    params.put('number', '4111111111111111');
    params.put('exp_month', 8);
    params.put('exp_year', 2020);
    params.put('cvc', '909');
    Map<String, Object> tknParams = new Map<String,Object>();
    tknParams.put('card',params);   
    req.setBody(String.valueOf(tknParams).removeEnd('}').removeStart('{'));    
    system.debug(' Request' + req );
    HttpResponse res = h.send(req);
    
    
    string resData =  res.getBody();
    system.debug(' Respose' + resData );
    }*/
}