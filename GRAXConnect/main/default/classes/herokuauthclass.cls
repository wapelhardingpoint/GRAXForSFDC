public class herokuauthclass{

public string authtoken{get;set;}
public string refereshtoken{get;set;}
public string bodyprint{get;set;}

//Settings needed on the google cloud console.One can store this securely in custom settings or an object.

public static final string CLIENT_SECRET='4a60ceb4-325e-4ec8-b18e-0e1a0d0fbacc';//Fill as per your registered app settings in google console
public static final string CLIENT_ID='35f2ebfc-45b1-479f-9510-c0bc0c441b9f'; //Fill as per your registered app settings in google console
public static final string REDIRECT_URL='https://saas-innovation-7529.lightning.force.com/one/one.app#/n/Heroku_Configuration';

public static final string OAUTH_TOKEN_URL=' https://id.heroku.com/oauth/token';
public static final string OAUTH_CODE_END_POINT_URL='https://id.heroku.com/oauth/authorize';

// public static final string GRANT_TYPE='grant_type=authorization_code';
public static final string GRANT_TYPE='response_type=code';

// 
public static final string SCOPE='read-protected,identity,read'; // If Needed Later -> global
public static final string STATE='/profile';

//Approval Prompt Constant
public static final string APPROVAL_PROMPT='force';

   public pagereference connect(){
   
     String x=OAUTH_CODE_END_POINT_URL+'?scope='+EncodingUtil.urlEncode(SCOPE,'UTF-8')+'&state='+EncodingUtil.urlEncode(STATE,'UTF-8')+'&redirect_uri='+EncodingUtil.urlEncode(REDIRECT_URL,'UTF-8')+'&response_type=code&client_id='+CLIENT_ID+'&approval_prompt='+APPROVAL_PROMPT;
     
     pagereference p=new pagereference(x);
     return p;
     
   }
   
    public pagereference showtoken(){
   
   string codeparam=apexpages.currentpage().getparameters().get('code');
      
    // Instantiate a new http object
    Http h = new Http();
    
    String body='code='+codeparam+'&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET+'&redirect_uri='+REDIRECT_URL+'&'+GRANT_TYPE;
    
// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
    HttpRequest req = new HttpRequest();
    req.setEndpoint(OAUTH_TOKEN_URL);
    req.setHeader('Content-Type','application/x-www-form-urlencoded');
    req.setMethod('POST');
    req.setBody(body);
    
    system.debug('REQUEST BODY'+body);

// Send the request, and return a response
    HttpResponse res = h.send(req);
    
    system.debug('body'+res.getbody());
    
    bodyprint=res.getbody();
    
    return null;
   
   }
   
  
}