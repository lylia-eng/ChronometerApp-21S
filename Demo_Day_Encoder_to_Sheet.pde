// Version date: May 24, 2021
import processing.serial.*;
Serial mySerial;
import processing.net.*;
Client myClient; 
import java.net.MalformedURLException;
import java.net.URL;
import java.security.cert.Certificate;
import java.io.*;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLPeerUnverifiedException;

String port = "/dev/cu.usbmodem14201"; // or e.g. "COM7" on Windows
String USER_AGENT = "Chrome/81.0.4044.141";

Table table;
int found_start_char = 0;
int start_char = 126;

void setup() 
{
  //set mySerial to listen on COM port 10 at 9600 baud
  mySerial = new Serial(this, port, 115200);
  int c;
  
  // temp test submitting the form URL
  // submit_form("MJF,1,2,3,4,5");
  
  mySerial.clear(); // get rid of pending input
  mySerial.stop();  // somehow opening, clearing, stopping, and opening again clears the buffer
  mySerial = new Serial(this, port, 115200);
  table = new Table();
  //add a column header "Data" for the collected data
  table.addColumn("Data");
}
   
void draw()
{
  if(mySerial.available() > 0)
  {
    //set the value recieved as a String
    String value;
    Character c = 'X';

    value = "";
    delay(100);
    do {
      // print("next value");
      do {
        delay(10);
        c = mySerial.readChar();
      }
      while (c == -1);  // wait until there is actual input
      if (c != 10) {  // don't put newline in our data
        value = value + c;
      }
    } while (c != 10);  // scan up to linefeed
    
    //check to make sure there is a value
    if(value != null)
    {
      //add a new row  for each value
      print("got: [" + value + "]\n");
      if (value.charAt(0) == start_char)  // got the start character
      {
        print("***Successful buffering\n");
        if (found_start_char == 1)
        {
          print("Communications error, please restart.");
          exit();
        }
        found_start_char = 1;
      }
      if (found_start_char == 1)
      { 
        if (value.charAt(0) == start_char)
        {
          ;
        }
        else
        {
          //place the new row and value under the "Data" column
          TableRow newRow = table.addRow();
          newRow.setString("Data", value);
          // Send the values to the Google spreadsheet
          submit_form(value);
        }
      }
    }
  }
}
 
void keyPressed()
{
  //save as a table in csv format(data/table - data folder name table)
  saveTable(table, "data/table.csv");
  exit();
}

void submit_form(String values)
{
  // Make a silent Google form submission passing the six values provided in the string (whitespace separated)
  // Original from Google:
  // https://docs.google.com/forms/d/e/1FAIpQLSdThHY2_m3mWk0BW_mJnTiVuqqsn9dSy9BhOPGr3QhRQrfwww/viewform?usp=pp_url&entry.870043936=name&entry.1146981135=val1&entry.1876202486=val2&entry.760049515=val3&entry.864227038=val4&entry.1241692629=val5&entry.1491548388=val6
  // Add sillent submit magic:
  // https://docs.google.com/forms/d/e/1FAIpQLSdThHY2_m3mWk0BW_mJnTiVuqqsn9dSy9BhOPGr3QhRQrfwww/viewform?usp=pp_url&entry.870043936=name&entry.1146981135=val1&entry.1876202486=val2&entry.760049515=val3&entry.864227038=val4&entry.1241692629=val5&entry.1491548388=val6&submit=Submit
  String[] vals = values.split(",", 8);  // expecting 7 values
  //System.out.println("Seventh token is:" + vals[6] + "\n");
  
  // https://docs.google.com/forms/d/e/1FAIpQLSdThHY2_m3mWk0BW_mJnTiVuqqsn9dSy9BhOPGr3QhRQrfwww/viewform?usp=pp_url&entry.870043936=A+B+C&entry.1146981135=1&entry.1876202486=2&entry.760049515=3&entry.864227038=4&entry.1241692629=5&entry.1491548388=6
  // String url_start = https://docs.google.com/forms/d/e/1FAIpQLSdThHY2_m3mWk0BW_mJnTiVuqqsn9dSy9BhOPGr3QhRQrfwww/formResponse?usp=pp_url
  String url_start = "https://docs.google.com/forms/d/e/1FAIpQLSdThHY2_m3mWk0BW_mJnTiVuqqsn9dSy9BhOPGr3QhRQrfwww/formResponse?usp=pp_url";
  String entry_0 = "&entry.870043936=";
  String entry_1 = "&entry.1146981135=";
  String entry_2 = "&entry.1876202486=";
  String entry_3 = "&entry.760049515=";
  String entry_4 = "&entry.864227038=";
  String entry_5 = "&entry.1241692629=";
  String entry_6 = "&entry.1491548388=";
  String url_end = "&submit=Submit";
  String https_url;
  
  HttpsURLConnection con = null;
  URL url;
  
  https_url = url_start + entry_0 + vals[0] + entry_1 + vals[1] + entry_2 + vals[2] + entry_3 + vals[3] + entry_4 + vals[4] + entry_5 + vals[5] + entry_6 + vals[6] + url_end;
  
  //System.out.println(https_url);

  try 
  {
    url = new URL(https_url);
    con = (HttpsURLConnection)url.openConnection();  
    con.setRequestMethod("GET");
    con.setRequestProperty("User-Agent", USER_AGENT);
    int responseCode = con.getResponseCode();
    print("GET Response Code: " + responseCode + "\n");
  } 
  catch (MalformedURLException e)
  {
    e.printStackTrace();
  } 
  catch (IOException e) 
  {
    e.printStackTrace();
  }
  // Code below prints the Google response - useful only for debugging and very verbose
  /* if(con!=null)
  {
    try 
    {
      System.out.println("****** Content of the URL ********");
      BufferedReader br =
      new BufferedReader(
      new InputStreamReader(con.getInputStream()));

      String input;

      while ((input = br.readLine()) != null)
      {
        System.out.println(input);
      }
      br.close();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
    }
  } */
}
