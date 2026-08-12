<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@page import="com.sap.mw.jco.*,ezc.sapconnection.EzSAPHandler"%>
<%@page import="java.io.*"%><%@page import="java.util.*,java.text.ParseException,java.text.SimpleDateFormat"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import ="java.util.*,ezc.ezutil.*,java.text.*,ezc.ezpreprocurement.params.*,ezc.ezparam.*" %>
<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
<%@include file="../../../Includes/JSPs/Rfq/iGetMaterialList.jsp"%>
<%@ page import="java.util.Enumeration,javax.servlet.*,javax.servlet.http.*,java.io.*" %>
<%@ page import="ezc.ezupload.MultipartRequest" %>
<%@ page import ="org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.disk.*" %>

<Html>
<Head>
<Script>
	var tabHeadWidth=95
	var tabHeight="70%"
	if(screen.width==800)
	{
		tabHeight="57%";
	}

function vendorList()
{
	document.myForm.target="_self";
	document.getElementById("back").innerHTML="<Table border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 ><Tr><Th>Please wait .Your Request is being Processed ...</Th></Tr></Table>"
	document.myForm.action="ezVendorViewList.jsp";
	document.myForm.submit();
}
function funGoBack(flag)
{
	document.myForm.downloadStatus.value="Y"
	document.myForm.action = "ezRFQMassCreation.jsp";
	document.myForm.submit();
}
</Script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</Head>
<Body>
<Form name="myForm" method="post">
<input type=hidden name="backChk" value="MULMAT">
<input type=hidden name="downloadStatus" value="N">
<Div id="theads" style="overflow:auto;position:absolute;width:90%;top:10%;left:5%">
  	<Table id="tabHead"  width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
	<Tr align="center" valign="middle">

		<Th width="20%">SAP Mat Code</Th>
		<Th width="23%">Mat Description</Th>
		<Th width="8%">UOM</Th>
		<Th width="10%">Quantity</Th>
		<Th width="15%">Delivery Date</Th>
		<Th width="24%">Status</Th>

	</Tr>
</Table>
</Div>

<Div id="InnerBox1Div" style="overflow:auto;position:absolute;width:90%;height:65%;top:14%;left:5%">
	<Table id="InnerBox1Tab" width="100%" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 >
<% 
	
	
	short a=0;  
	short b=1;  
	short c=2;  
	short d=3;
	short e=4; 
	int i=0;   

	String   value1="", value2="",value3=" ", value4="", value5=""; 
	String xlsValid="";
	int count=0;

	//String filename= request.getParameter("path");
	if (upFile != null)
	{    
		String purreq = "";

		
			FileInputStream fs =new FileInputStream(upFile);    
			HSSFWorkbook wb = new HSSFWorkbook(fs); 
			HSSFSheet mySheet = wb.getSheetAt(0); 
			Iterator rowIter = mySheet.rowIterator();
			String chkValue="Y";
			int firstRow=0;
			
				       
			    try{
			    		
			    		
					while (rowIter.hasNext()) 
					{
						String dispMsg="";
						xlsValid="YES";
						String matDetails = "";
						String mNum="";		
						String mdesc="";
						String mUOM="";
						String mQunty="";
						String mDate="",itemNote="";
						String dString="";
						String dispString		="";
						String dispStringQty		="";
						String matValue			="";
						//out.println("chk");
						HSSFRow myRow = (HSSFRow) rowIter.next();
						
						if(firstRow==0)
						{
							firstRow = firstRow+1;
							continue;
						}
						
						else
						{
%>
							<tr>
<%
							Iterator cellIter = myRow.cellIterator();
							
							int cellCnt=0;
							String cValue="";
							search:
							while (cellCnt<6) 
							{
								
								HSSFCell myCell = null;
								String celValue="";
								dispMsg="YES";
								
								try{
								if(cellIter.hasNext())
								{
									myCell = (HSSFCell) cellIter.next();
									celValue=(String)myCell.toString();
									
									
								}
								}catch(Exception exce){System.out.println("::Error while reading cell:::"+exce);}


								if("".equals(celValue.trim()))
								{
								
								cellCnt = cellCnt+1;
								chkValue="N";
								continue;
								}
								
								
								if(cellCnt==0)
								{
									if(celValue.indexOf("E")>=0)
									mNum = expToString(celValue.trim());
									else
									mNum = celValue.trim();
									
									
									if(!"".equals(mNum))
									{									
									mNum = "000000000000000000"+mNum.trim();
									mNum = mNum.substring(mNum.length()-18);
									}else{
									cellCnt = cellCnt+1;
									continue;
									}
									
%>
									<td width="20%" align="center"><%=mNum%>&nbsp;</td>
<%
								}
								if(cellCnt==1)
								{
									celValue = celValue.replaceAll("'", "`");
									celValue = celValue.replaceAll("\"", "``");
									mdesc=celValue;

%>
									<td width="23%" align="center"><%=celValue%>&nbsp;</td>
<%
								}
								if(cellCnt==2)
								{
									
									mUOM=celValue.trim();

%>
									<td width="8%" align="center"><%=celValue%>&nbsp;</td>
<%
								}
								if(cellCnt==3)
								{
									
									if (celValue.matches("((-|\\+)?[0-9]+(\\.[0-9]+)?)+"))
									{
										mQunty=celValue;
									}
									else
									{
										dispStringQty="<Font color=\"red\"><B>Illegal characters in Quantity</B></Font>";
										xlsValid="NO";
										count=count+1;
									}
									

%>
									<td width="10%" align="center"><%=celValue%>&nbsp;</td>
<%
								}
								if(cellCnt==4)
								{
									boolean excOccured = false;
									mDate=celValue.trim();
									if(mDate=="")continue;
									
									 //SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");
									 SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
									Date testDate = null;
									try 
									{  
										
										testDate = sdf.parse(mDate);  
									
									}  
									catch(ParseException E1){excOccured = true;}
									if(excOccured)
									{
									
										SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MMM-yyyy");
										try{
											testDate = sdf1.parse(mDate); 
											
										}
										catch (ParseException E)  
										{  

											System.out.println("the date you provided is in an invalid date"); 

%>
											<td width="15%" align="center"><%=mDate%>&nbsp;</td>
											<td width="24%" align="center"><Font color="red"><B>Invalid Date</B></Font></td>

<%										
											xlsValid="NO";
											count=count+1;
											cellCnt = cellCnt+1;
											dispMsg="NO";
											break search;


										}
									}
									SimpleDateFormat outFrmt = new SimpleDateFormat("MM/dd/yyyy");
									dString = outFrmt.format(testDate);
									

									//testDate = sdf.parse(mDate); 

%>
									<td width="15%" align="center"><%=dString%>&nbsp;</td>
<%
								}									

								if(cellCnt==5)
								{
									itemNote=celValue.trim();
									if(itemNote==null || "null".equals(itemNote))itemNote="";
									itemNote =itemNote.replaceAll("'","`");
									itemNote =itemNote.replaceAll("\"","``");
								}
								cellCnt = cellCnt+1;
								
							}
							
							matDetails = mNum+"$$NA$$"+dString+"$$"+mQunty+"$$"+mUOM+"$$"+mdesc+"$$-$$-$$"+itemNote+"$$";
							
							if(matListHT!=null)
							{
								matValue	= (String)matListHT.get(mNum);
								
								//out.println("matValue:::"+matValue);
							}
							if(!"".equals(mNum))
							{

								if(matListHT.containsKey(mNum) )
								{
									if(matValue.equalsIgnoreCase(mUOM))
										dispString="Material exist";
									else
									{
									  dispString="<Font color=\"red\"><B>Material and UOM does not match</B></Font>";	
									  xlsValid="NO";
									  count=count+1;
									}
									if(dispStringQty!="")dispString=dispStringQty;

								}
								else
								{
									dispString="<Font color=\"red\"><B>Material does not exist</B></Font>";

									xlsValid="NO";
									count=count+1;
								}
								//out.println("xlsValid:::"+xlsValid);
								if("YES".equals(dispMsg))
								{
	%>
								<td width="24%" align="center"><%=dispString%></td>
								<input type="hidden" name="purchReq" value="<%=matDetails%>">
	<%
								}
							}
%>							
							<input type="hidden" name="xlspath" value="<%=path%>">
							<input type="hidden" name="fromPage" value="RFQMASS">
							
							</tr>
<%
						firstRow = firstRow+1;
						}	
					}
					
            			}catch(Exception Ex)
            			{
            				System.out.println(Ex+":::Exception:::");
            				//out.println(firstRow+"::firstRow::");
            			}
				finally
				{
					try
					{
						fs.close();

					}catch(Exception clex){}

				}            			


boolean success = upFile.delete();
		
	}   
%>    
</table>
</Div>
<Div id="back" align=center style="position:absolute;top:87%;visibility:visible;width:100%">

<span id="EzButtonsSpan" >
<center>

<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	if(count<=0)
	{
		buttonName.add("GetSources");
		buttonMethod.add("vendorList()");
	}
	else
	{
		buttonName.add("Back");
		buttonMethod.add("funGoBack(\"Y\")");
	}
	
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>

</center>
</span>
<span id="EzButtonsMsgSpan" style="display:none">
		<Table align=center>
			<Tr>
				<Th >Your request is being processed... Please wait</Th>
			</Tr>
		</Table>
		</span>
    </Div>
</Form>
<Div id="MenuSol"></Div>
</Body>
</Html>