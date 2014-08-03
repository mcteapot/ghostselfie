import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.*;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.*;
import org.apache.http.params.*;
import org.apache.http.client.entity.*;
import org.apache.http.util.*;
import org.apache.http.util.EntityUtils;
import org.apache.http.Consts;  
import java.lang.StringBuilder;
import java.io.*;

class HTTPClient {
   
 //URL of  
  String urlHTTP = "http://localhost:3000/";
  HTTPClient(String url) {
    urlHTTP = url;
  }
String POSTPageHeader(String url, ArrayList nameValueHeader ) {
  String textResponce = null;
  try
  {
    DefaultHttpClient httpClient = new DefaultHttpClient();

    HttpPost  httpPost   = new HttpPost( url );

     for(int i = 0; i < nameValueHeader.size(); i++) {
       BasicNameValuePair tempBaseValue = (BasicNameValuePair)nameValueHeader.get(i);
       httpPost.addHeader(tempBaseValue.getName(), tempBaseValue.getValue());
     }
  
    println( "executing request: " + httpPost.getRequestLine() );

    HttpResponse response = httpClient.execute( httpPost );
    HttpEntity entity = response.getEntity();

    // convert output to string
    if ( entity != null ) {
      StringBuilder sb = new StringBuilder();
      String line = null;
      try {
        BufferedReader reader = new BufferedReader(new InputStreamReader(entity.getContent()), 65728);

        while ( (line = reader.readLine ()) != null) {
          sb.append(line);
        }
      }
      catch (IOException e) { 
        e.printStackTrace();
      }
      catch (Exception e) { 
        e.printStackTrace();
      }

      textResponce = sb.toString();
      //System.out.println("POST Result: " + sb.toString());

      //entity.writeTo( System.out );
      entity.consumeContent();
    }

    // When HttpClient instance is no longer needed, 
    // shut down the connection manager to ensure
    // immediate deallocation of all system resources
    httpClient.getConnectionManager().shutdown();
  } 
  catch( Exception e ) { 
    e.printStackTrace();
  }

  return textResponce;
}

  
String GETPage(String url) {
  String textResponce = null;
  try {
    DefaultHttpClient httpClient = new DefaultHttpClient();

    HttpGet httpGet = new HttpGet(url);

    println( "executing request: " + httpGet.getRequestLine() );
    HttpResponse response = httpClient.execute( httpGet );
    HttpEntity entity = response.getEntity();

    println("----------------------------------------");
    println( response.getStatusLine() );
    println("----------------------------------------");

    // convert output to string
    if ( entity != null ) {
      StringBuilder sb = new StringBuilder();
      String line = null;
      try {
        BufferedReader reader = new BufferedReader(new InputStreamReader(entity.getContent()), 65728);

        while ( (line = reader.readLine ()) != null) {
          sb.append(line);
        }
      }
      catch (IOException e) { 
        e.printStackTrace();
      }
      catch (Exception e) { 
        e.printStackTrace();
      }

      textResponce = sb.toString();
      System.out.println("GET Result: " + sb.toString());

      //entity.writeTo( System.out );
      entity.consumeContent();
    }


    // When HttpClient instance is no longer needed, 
    // shut down the connection manager to ensure
    // immediate deallocation of all system resources
    httpClient.getConnectionManager().shutdown();
  } 
  catch( Exception e ) { 
    e.printStackTrace();
  }

  return textResponce;
}
 
  void printUrl () {  
    println("URL: " + urlHTTP);
  } 
 
} 

