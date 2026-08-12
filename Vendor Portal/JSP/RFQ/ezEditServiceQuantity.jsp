 <%@ include file="../../Library/Globals/errorPagePath.jsp"%>
 <%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
 <html>
 <head>
 <%
  	
  	String vendQtys[]=request.getParameterValues("vendQty");
  	int rowIndex 	= Integer.parseInt(request.getParameter("rowIndex"));
  	
  	String serLine=request.getParameter("serviceLine");
  	String intiSerQty=request.getParameter("initSerQty");
  	String vendServiceQty[]=request.getParameterValues("vendServiceQty");
  	
  	String currSerQty=vendServiceQty[rowIndex];
  	String vendServiceQtyAlter="";
  	java.util.Hashtable vendorQtys=new java.util.Hashtable();
  	if(!"NA".equals(currSerQty)){
		ezc.ezbasicutil.EzStringTokenizer EzMainToken = new ezc.ezbasicutil.EzStringTokenizer(currSerQty,"@@");
		java.util.Vector Tokens = EzMainToken.getTokens();
		
		for(int v=0;v<Tokens.size();v++)
		{
			ezc.ezbasicutil.EzStringTokenizer EzToken1 = new ezc.ezbasicutil.EzStringTokenizer((String)Tokens.elementAt(v),"#");
			java.util.Vector Tokens1 = EzToken1.getTokens();
			try
			{
				String serVendNo = (String)Tokens1.elementAt(0);	
				String serVendQty= (String)Tokens1.elementAt(1);
				vendorQtys.put(serVendNo,serVendQty);
				
				if(!serVendNo.endsWith("~"+serLine)){
					if("".equals(vendServiceQtyAlter))
						vendServiceQtyAlter=serVendNo+"#"+serVendQty+"@@";
					else
						vendServiceQtyAlter=vendServiceQtyAlter+"@@"+serVendNo+"#"+serVendQty+"@@";
					
				}

			}catch(Exception err){}
		}	
  	
  	}
  	
  	
  	
  	
  	
  	
 %>
 <title>Create RFQ -- Powered By EzCommerce India</title>
 <Script>
 	var tabHeadWidth = "82";
	var tabHeight	 = "60%";
	function winClose(serLine)
	{
		
		var len = document.myForm.vendNo.length;
		if(isNaN(len))
		{

			if(document.myForm.vendQty.value=="")
			{
				alert("Please enter Quantity.");
				document.myForm.vendQty.value="";
				document.myForm.vendQty.focus();
				return false;
			}
			else
			{
				if(isNaN(document.myForm.vendQty.value))
				{
					alert("Please enter valid quantity");
					document.myForm.vendQty.value="";
					document.myForm.vendQty.focus();
					return false;
				}
				else if(parseFloat(document.myForm.vendQty.value) <= 0)
				{
					alert("Quantity should be greater than zero");
					document.myForm.vendQty.value="";
					document.myForm.vendQty.focus();
					return false;

				}
			}
			
		}
		else
		{
			for(var i=0;i<len;i++)
			{
				if(document.myForm.vendQty[i].value == "")
				{
					alert("Please enter quantity for vendor "+document.myForm.vendName[i].value);
					document.myForm.vendQty[i].value="";
					document.myForm.vendQty[i].focus();
					return false;
				}
				else
				{
					if(isNaN(document.myForm.vendQty[i].value))
					{
						alert("Please enter valid quantity for vendor "+document.myForm.vendName[i].value);
						document.myForm.vendQty[i].value="";
						document.myForm.vendQty[i].focus();
						return false;
					}
					else if(parseFloat(document.myForm.vendQty[i].value) <= 0)
					{
						alert("Quantity should be greater than zero for vendor "+document.myForm.vendName[i].value);
						document.myForm.vendQty[i].value="";
						document.myForm.vendQty[i].focus();
						return false;

					}

				}
			}
		}

		var vendNoObj=document.myForm.vendNo;
		var vendNameObj=document.myForm.vendName;
		var vendTypeObj=document.myForm.vendType;
		var vendQtyObj=document.myForm.vendQty;
		var modifiedStr="";
		var serString="";
		if(isNaN(vendNoObj.length))
		{
			modifiedStr=vendNoObj.value+"#"+vendNameObj.value+"#"+vendTypeObj.value+"#"+vendQtyObj.value;
			serString = vendNoObj.value+"~"+serLine+"#"+vendQtyObj.value;
		}else{
			for(i=0;i<vendNoObj.length;i++){
				if(modifiedStr==""){
					modifiedStr=vendNoObj[i].value+"#"+vendNameObj[i].value+"#"+vendTypeObj[i].value+"#"+vendQtyObj[i].value;
					serString=vendNoObj[i].value+"~"+serLine+"#"+vendQtyObj[i].value;
				}else{
					modifiedStr=modifiedStr+"@@"+vendNoObj[i].value+"#"+vendNameObj[i].value+"#"+vendTypeObj[i].value+"#"+vendQtyObj[i].value;
					serString=serString+"@@"+vendNoObj[i].value+"~"+serLine+"#"+vendQtyObj[i].value;
					
				}	
				
				
			}
		}
		serString = "<%=vendServiceQtyAlter%>"+serString;
		
		if(isNaN(opener.window.document.myForm.vendQty.length))
		{
			opener.window.document.myForm.vendQty.value=modifiedStr;
			opener.window.document.myForm.vendServiceQty.value=serString;
		}else{
			opener.window.document.myForm.vendQty[<%=rowIndex%>].value=modifiedStr;
			opener.window.document.myForm.vendServiceQty[<%=rowIndex%>].value=serString;
		}
		
		window.close();
	}
 </Script>
 <%@include file="../../../Includes/Lib/AddButtonDir.jsp"%>
 <Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
 </head>
 <body onLoad="scrollInit(6)" onResize="scrollInit(6)" scroll=no>
 <form name="myForm" method="post">
 
 <Div id="theads">
 	<Table id="tabHead" border=1 align='center' borderColorDark="#ffffff" borderColorLight="#000000" cellPadding=2 cellSpacing=0  width="82%">
 		<Tr>
 			<Th width="30%">Vendor No.</Th>
 			<Th width="40%">Vendor Name</Th>
 			<Th width="30%">Quantity</Th>
 		</Tr>
 	</Table>
</Div>
<Div id='InnerBox1Div' style='overflow:auto;position:absolute;width:82%;height:60%;'>
	<Table align=center id='InnerBox1Tab' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0 width='100%'>
<%
	ezc.ezbasicutil.EzStringTokenizer EzToken = new ezc.ezbasicutil.EzStringTokenizer(vendQtys[rowIndex],"@@");
	java.util.Vector Tokens = EzToken.getTokens();
	String vendNo="",vendName="",vendType="",vendQty="";
	
	
	for(int v=0;v<Tokens.size();v++)
	{
		ezc.ezbasicutil.EzStringTokenizer EzToken1 = new ezc.ezbasicutil.EzStringTokenizer((String)Tokens.elementAt(v),"#");
		java.util.Vector Tokens1 = EzToken1.getTokens();
		try
		{
			vendNo	= (String)Tokens1.elementAt(0);	
			vendName= (String)Tokens1.elementAt(1);	
			vendType= (String)Tokens1.elementAt(2);	
			vendQty= (String)Tokens1.elementAt(3);	
			
			if("NA".equals(currSerQty)){
				vendQty=intiSerQty;
				
			}else{
				vendQty=(String)vendorQtys.get(vendNo+"~"+serLine);
				if(vendQty==null||"null".equals(vendQty))
				vendQty=intiSerQty;
			}	
			
			
			
			
			
			
		}catch(Exception err){}	
%>
		<Tr>
		<Td width="30%"><input type="hidden" name="vendNo" value="<%=vendNo%>"><%=vendNo%></Td>
	 	<Td width="40%">
	 	<input type="hidden" name="vendName" value="<%=vendName%>">
	 	<input type="hidden" name="vendType" value="<%=vendType%>">
	 	<%=vendName%>
	 	</Td>
 		<Td width="30%">
 		<input type="text" class="InputBox" style="width:100%" size="18" name="vendQty" style="text-align:right"  value="<%=vendQty%>">
 		</Td>
 		</Tr>
 		
<%
	}
	
%>
	</Table>
</Div>
<div align=center id="ButtonDiv" style="position:absolute;top:89%;width:100%">
		 
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	buttonName.add("Ok");
	buttonMethod.add("winClose(\""+serLine+"\")");
	buttonName.add("Cancel");
	buttonMethod.add("window.close()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</div>	
 
 </form>
 <Div id="MenuSol"></Div>
 </body>
 </html>
