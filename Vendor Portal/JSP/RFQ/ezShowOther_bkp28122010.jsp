 <%@ include file="../../Library/Globals/errorPagePath.jsp"%>
 <%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
 <%@ page import="ezc.ezutil.*,java.util.*"%>
 <html>
 <head>
 <%!
 	String getRequiredValue(java.util.Hashtable myHT,String myKey){
 	
 		String myValue="";
 		
 		if(myHT.containsKey(myKey))
 		myValue=(String)myHT.get(myKey);
 		
 		if("-".equals(myValue))
 		myValue="";
 		
 		return myValue;
 	
 	
 	}
 %>
 <%
  	
  	String taxCode=request.getParameter("taxCode");
  	String condStr=request.getParameter("condStr");
  	String Curr=request.getParameter("Curr");
  	
  	
  	
  	java.util.Hashtable condValHT  = new java.util.Hashtable();
  	java.util.Hashtable condCurrHT = new java.util.Hashtable();
  	java.util.Hashtable condPerHT  = new java.util.Hashtable();
  	java.util.Hashtable condUOMHT  = new java.util.Hashtable();
  	
  	if(condStr!=null && !"null".equals(condStr) && !"".equals(condStr.trim())){
  		ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(condStr,"^^");
  		java.util.Vector Tokens = EzToken.getTokens();
  		String condTypeTemp="";
  		String condValTemp="";
  		String condCurrTemp="";
  		String condPerTemp="";
  		String condUOMTemp="";
  		for(int v=0;v<Tokens.size();v++)
		{
			ezc.ezbasicutil.EzStringTokenizer EzToken1 = new ezc.ezbasicutil.EzStringTokenizer((String)Tokens.elementAt(v),"$$");
			java.util.Vector Tokens1 = EzToken1.getTokens();
			condTypeTemp=(String)Tokens1.elementAt(0);
			condValTemp=(String)Tokens1.elementAt(1);
			condCurrTemp=(String)Tokens1.elementAt(2);
			condPerTemp=(String)Tokens1.elementAt(3);
			condUOMTemp=(String)Tokens1.elementAt(4);
			
			
			condValHT.put(condTypeTemp,condValTemp);
			condCurrHT.put(condTypeTemp,condCurrTemp);
			condPerHT.put(condTypeTemp,condPerTemp);
			condUOMHT.put(condTypeTemp,condUOMTemp);
					
		}	
  	}	
  	
  	
  	
  	int rowIndex 	= Integer.parseInt(request.getParameter("rowIndex"));
  	
  	ResourceBundle TaxC 	= ResourceBundle.getBundle("EzTaxCodes");
  	ResourceBundle CurrC 	= ResourceBundle.getBundle("EzCurrCodes");
  	Enumeration taxEnu 	= TaxC.getKeys();
  	Enumeration currEnu 	= CurrC.getKeys();
  	
  	java.util.TreeMap taxTM = new java.util.TreeMap();
  	while(taxEnu.hasMoreElements())
	{
		String s2=(String)taxEnu.nextElement();
		taxTM.put(s2,TaxC.getString(s2));
	}
	Iterator taxIterator = taxTM.keySet().iterator();
	Object taxObj = new Object();
	
	java.util.TreeMap currTM = new java.util.TreeMap();
	
  	while(currEnu.hasMoreElements())
	{
		String s=(String)currEnu.nextElement();
		currTM.put(s,s+"-->"+CurrC.getString(s));
	}
  	Iterator currIterator = currTM.keySet().iterator();

	
	
	java.util.Vector condCode=new java.util.Vector();
	java.util.Vector condDesc=new java.util.Vector();
	java.util.Vector condTypeAbsDis=new java.util.Vector();
	java.util.Vector condVal=new java.util.Vector();
	java.util.Vector condCurr=new java.util.Vector();
	java.util.Vector condPer=new java.util.Vector();
	java.util.Vector condUOM=new java.util.Vector();
	
	java.util.Vector condTabLab=new java.util.Vector();
	java.util.Vector condTabColWidth=new java.util.Vector();
	java.util.Vector condColalign=new java.util.Vector();
	
	
	condTabLab.add("Type");	  		  condTabColWidth.add("15%");        condColalign.add("center");
	condTabLab.add("Name");			  condTabColWidth.add("20%");        condColalign.add("center");
	condTabLab.add("Value");		  condTabColWidth.add("15%");	     condColalign.add("center");
	condTabLab.add("Curr");		  	  condTabColWidth.add("40%");	     condColalign.add("center");
	condTabLab.add("Per");		  	  condTabColWidth.add("4%");	     condColalign.add("center");
	condTabLab.add("UOM");		  	  condTabColWidth.add("6%");	     condColalign.add("center");
	
	
	
	condCode.add("RA01");	   condTypeAbsDis.add("P");	 condDesc.add("Discount % on Gross");	 
	condCode.add("RB00");	   condTypeAbsDis.add("A");	 condDesc.add("Absolute discount");	 
	condCode.add("RC00");	   condTypeAbsDis.add("A");	 condDesc.add("Discount/Quantity");	 
	condCode.add("ZPA1");	   condTypeAbsDis.add("P");	 condDesc.add("Packing and forw %");	 
	condCode.add("ZPB1");	   condTypeAbsDis.add("A");	 condDesc.add("Packing and forw-val");	 
	condCode.add("ZPC1");	   condTypeAbsDis.add("A");	 condDesc.add("Packing and forw/qty");	 
	condCode.add("FRA1");	   condTypeAbsDis.add("P");	 condDesc.add("Freight %");	 
	condCode.add("FRB1");	   condTypeAbsDis.add("A");	 condDesc.add("Freight (Value)");	 
	condCode.add("FRC1");	   condTypeAbsDis.add("A");	 condDesc.add("Freight/Quantity");	 
	condCode.add("ZIN1");	   condTypeAbsDis.add("P");	 condDesc.add("Insurance %");	 
	condCode.add("ZEX1");	   condTypeAbsDis.add("P");	 condDesc.add("Excise for information");	 
	condCode.add("ZVAT");	   condTypeAbsDis.add("P");	 condDesc.add("VAT");	 
	condCode.add("WCTQ");	   condTypeAbsDis.add("P");	 condDesc.add("WCT for Info");	
	condCode.add("ZCST");	   condTypeAbsDis.add("P");	 condDesc.add("Central sales Tax");	 
	condCode.add("ZSRT");	   condTypeAbsDis.add("P");	 condDesc.add("Service Tax");
	
	condCode.add("ZP20");	   condTypeAbsDis.add("P");	 condDesc.add("Overseas Freight %");	
	condCode.add("ZP21");	   condTypeAbsDis.add("P");	 condDesc.add("Overseas Freight value");	 
	condCode.add("ZP22");	   condTypeAbsDis.add("P");	 condDesc.add("Overseas Freight Quantity");
	

	

	
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("R");	    condUOM.add("R");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("R");	    condUOM.add("R");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("R");	       condPer.add("R");	    condUOM.add("R");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("O");	    condUOM.add("O");
	condVal.add("R");	  condCurr.add("D");	       condPer.add("R");	    condUOM.add("R");
	 

	
	
	java.util.Hashtable actionHT=new java.util.Hashtable();
	
	actionHT.put("D","disabled");
	actionHT.put("O","readOnly");
	actionHT.put("R"," ");
	
	
	
	
 %>
 <title>Create RFQ -- Powered By EzCommerce India</title>
 
 <Script>
 	var tabHeadWidth = "82";
	var tabHeight	 = "60%";
	
	function checkValue(myObj){
	
		var myObjVal=myObj.value;
		
		if(myObjVal!="" && isNaN(myObjVal))
		{
			alert("Please enter valid number");
			myObj.value="";
			myObj.focus();
						
		}
	
	
	}
	function replaceWith(myObject){
	
		myString="-";
		
		if(myObject!=null){
			myString=myObject.value;
			myString=funTrim(myString);
			if(myString==""||myString==null || "null"==myString){
				myString="-";
			}
		
		}
		return myString;
	}	
	
	
	function winClose()
	{
		
		
		
			
		var conTypeObj=document.myForm.condType;
		var conValueObj=document.myForm.condValue;
		var conCurrObj=document.myForm.condCurr;
		var conPerObj=document.myForm.condPer;
		var conUomObj=document.myForm.condUom;
		
		var condString="";
		
		for(i=0;i<conTypeObj.length;i++){
		
			
			if(replaceWith(conValueObj[i])!="-"){
				if(condString!="")
				condString=condString+"^^";
				condString = condString + replaceWith(conTypeObj[i])+"$$"+replaceWith(conValueObj[i])+"$$"+replaceWith(conCurrObj[i])+"$$"+replaceWith(conPerObj[i])+"$$"+replaceWith(conUomObj[i]);
			}	
			
		}
		
		if(isNaN(opener.window.document.myForm.taxCode.length))
		{
			
			opener.window.document.myForm.taxCode.value=""//document.myForm.taxCode.value;
			opener.window.document.myForm.itemCond.value=condString;
			
		}else{
			
			opener.window.document.myForm.taxCode[<%=rowIndex%>].value=""//document.myForm.taxCode.value;
			opener.window.document.myForm.itemCond[<%=rowIndex%>].value=condString;
		}
		
		window.close();
	}
 </Script>
 <%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
 <Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
 <script src="../../Library/JavaScript/ezTrim.js"></Script>
 </head>
 <body  scroll=yes>
 <form name="myForm" method="post">
 


<Table border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0  width="82%">
<%
	for(int i=0;i<condTabLab.size();i++){
%>
	<th align="<%=condColalign.get(i)%>" width="<%=condTabColWidth.get(i)%>"><%=condTabLab.get(i)%> </th>
<%
	}
%>

<%
	for(int i=0;i<condCode.size();i++){
	
	
%>
	<tr>
		<td><input type="hidden" name="condType"  value="<%=condCode.get(i)%>"><%=condCode.get(i)%></td>
		<td><%=condDesc.get(i)%></td>
		<td><input type="text" class="InputBox" onBlur="checkValue(this)" name="condValue" size="10" value="<%=getRequiredValue(condValHT,(String)condCode.get(i))%>"></td>
		
		<td>
		
		
		<!--<select name="condCurr" class=InputBox style="width:100%" id="CalendarDiv" <%=actionHT.get((String)condCurr.get(i))%>>-->
		<select name="condCurr" class=InputBox style="width:100%" id="CalendarDiv" <%=actionHT.get("R")%>>
		<Option value="-"   >-Select-</Option>
<%
		currIterator = currTM.keySet().iterator();
		while(currIterator.hasNext())
		{
			String currKey = (String)currIterator.next();
			String selected="";
			
			//if(currKey.equals(getRequiredValue(condCurrHT,(String)condCode.get(i))))
			if(currKey.equals(Curr))
			{
			selected="Selected";
						
%>
			<Option value=<%=currKey%> <%=selected%>><%=currTM.get(currKey)%></Option>
			
<%			
			break;

			}

		}

%>
					      
		</select>
		
		</td>
		
		<td><input type="text" name="condPer" onBlur="checkValue(this)" class="InputBox" size="3" value="<%=getRequiredValue(condPerHT,(String)condCode.get(i))%>" <%=actionHT.get((String)condPer.get(i))%>></td>
		<td><input type="text" name="condUom" class="InputBox" size="6" value="<%=getRequiredValue(condUOMHT,(String)condCode.get(i))%>" <%=actionHT.get((String)condUOM.get(i))%>></td>
		
		
	</tr>
	
<%
	}
%>

</Table>

<div align=center id="ButtonDiv" style="position:absolute;width:100%">
		 
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Ok");
	buttonMethod.add("winClose()");
	buttonName.add("Cancel");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</div>	
 
 </form>
 <Div id="MenuSol"></Div>
 </body>
 </html>
