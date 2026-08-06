<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iGetVendorAddrDetails.jsp" %>
<%@ include file="../Misc/ezStateCodesAndNames.jsp" %> 

<%@ page import ="java.util.*"%>
<Html>
<Head>
<Script>
function funSubmitToSAP()
{
	document.myForm.action="ezChangeAddrInSAP.jsp";
	document.myForm.submit();
}

function funSubmit()
{
	document.myForm.action="ezVendAddrChangesSubmit.jsp";
	document.myForm.submit();
}

</Script>
</Head>
<Body>
<%
Hashtable<String,String> hTable=new Hashtable<String,String>();
hTable.put("AP", "Andhra Pradesh");
hTable.put("ARP", "Arunachal Pradesh");
hTable.put("AS", "Assam");
hTable.put("BH", "Bihar");
hTable.put("CH", "Chhattisgarh");
hTable.put("GOA", "Goa");
hTable.put("GJ", "Gujarat");
hTable.put("HY", "Haryana          ");
hTable.put("HP", "Himachal Pradesh");
hTable.put("JK", "Jammu and Kashmir");
hTable.put("JH", "Jharkhand");
hTable.put("KA", "Karnataka");
hTable.put("KL", "Kerala");
hTable.put("MP", "Madhya Pradesh");
hTable.put("MH", "Maharashtra");
hTable.put("MN", "Manipur       ");
hTable.put("MG", "Meghalaya");
hTable.put("MZ", "Mizoram       ");
hTable.put("NG", "Nagaland");
hTable.put("OR", "Orissa");
hTable.put("PN", "Punjab");
hTable.put("RJ", "Rajasthan");
hTable.put("SK", "Sikkim");
hTable.put("TN", "Tamil Nadu");
hTable.put("TI", "Tripura");
hTable.put("UP", "Uttar Pradesh");
hTable.put("UT", "Uttarakhand");
hTable.put("WB", "West Bengal");
%>

<Form name='myForm' method='POST'>
<%	
	String display_header = "Address Change Request Details";
%>
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>

<%
	String	vendor		= VendorListRetObj.getFieldValueString(0,"EVA_VENDOR");
	String	refNum		= VendorListRetObj.getFieldValueString(0,"EVA_REF_NO");
	String	companyName	= VendorListRetObj.getFieldValueString(0,"EVA_COMPANY_NAME");
	String	houseNo		= VendorListRetObj.getFieldValueString(0,"EVA_ADDRESS1");
	String	address		= VendorListRetObj.getFieldValueString(0,"EVA_ADDRESS2");
	String	city		= VendorListRetObj.getFieldValueString(0,"EVA_CITY");
	String	district	= VendorListRetObj.getFieldValueString(0,"EVA_EXT1");
	String	state		= VendorListRetObj.getFieldValueString(0,"EVA_STATE");
	String	postalCode	= VendorListRetObj.getFieldValueString(0,"EVA_PIN");
	String	country		= VendorListRetObj.getFieldValueString(0,"EVA_COUNTRY");
	String	telephone1	= VendorListRetObj.getFieldValueString(0,"EVA_CONTACT_NO");
	String	email		= VendorListRetObj.getFieldValueString(0,"EVA_EMAIL");
	String	companyCode	= VendorListRetObj.getFieldValueString(0,"EVA_COMP_CODE");
%>
	

	

	<br>
	
	<TABLE width="80%" align=center border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=0 cellSpacing=0 >

	<tr>
		<th  height=30 width="40%" align="left">&nbsp;Vendor</th>
		<td  height=30 width="60%" >
		&nbsp;<%=vendor%></td>
		<input type="hidden" name="vendor" value="<%=vendor%>">
		<input type="hidden" name="refNum" value="<%=refNum%>">
	</tr>
	<tr>
	<th  height=30 width="40%" align="left">&nbsp;Company Name</th>
	<td  height=30 width="60%" >
	&nbsp;<%=companyName%></td>
	<input type="hidden" name="companyName" value="<%=companyName%>">
	</tr>

	<tr>
		<th height=30 width="40%" align="left">&nbsp;House No.</th>
		<td height=30 width="60%">
			&nbsp;<%=houseNo%>
		<input type="hidden" name="houseNo" value="<%=houseNo%>">
	</td>
	</tr>
	<tr>
		<th height=30 width="40%" align="left">&nbsp;Address&nbsp;</th>
		<td height=30 width="60%">&nbsp;<%=address%>&nbsp;
		<input type="hidden" name="address" value="<%=address%>">	
		</td>
	</tr>				
	<tr>
		<th height=30 width="40%" align="left">&nbsp;City</th>
		<td height=30 width="60%">
		&nbsp;<%=city%>
		<input type="hidden" name="city" value="<%=city%>">
		</td>
	</tr>
	<tr>
		<th  height=30 width="40%" align="left">&nbsp;District</th>
		<td  height=30 width="60%">
		&nbsp;<%=district%>
		<input type="hidden" name="district" value="<%=district%>">
		</td>
	</tr>
	<tr>
		<th height=30 width="40%" align="left">&nbsp;Postal Code</th>
		<td height=30 width="60%">
		&nbsp;<%=postalCode%>
		<input type="hidden" name="postalCode" value="<%=postalCode%>">
		</td>
	</tr> 
	<tr>
		<th  height=30 width="40%" align="left" >&nbsp;State</th>
		<td  height=30 width="60%">&nbsp;<%=statesHT.get(state)%>&nbsp;
		</td>
	</tr>
	<tr>
		<th height=30 width="40%" align="left" >&nbsp;Contact No.</th>
		<td height=30 width="60%">
		<input type="hidden" name="telephone1" value="<%=telephone1%>">
			&nbsp;<%=telephone1%>
		</td>
	</tr>
	<tr>

	</tr>
<%
	if(email==null||"null".equals(email))
		email="";
%>				
	<tr>
		<th  height=30 width="40%" align="left" >&nbsp;Email</th>
		<td  height=30 width="60%">
			<input type="hidden" name="email" value="<%=email%>">
		&nbsp;<%=email%>

		</td>
		<input type="hidden" name="companyCode" value="<%=companyCode%>">
		<input type="hidden" name="country" value="<%=country%>">


	</TABLE>
	<Br><Br><Br>
<center>
<%
	String statusFlag = request.getParameter("statusFlag");
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();

	buttonName.add("Back");
	buttonMethod.add("navigateBack(\"../Misc/ezVendorAddChangeList.jsp?statusFlag="+statusFlag+"\")");

	String conStatus ="";
	String uploadKey = "";
	String docsKeyStr="'999111ADDR_CHG"+refNum+"'";
%>
<%@ include file="../Misc/ezGetUploadedDocs.jsp"%>
<%
	if(docsListCnt>0)
	{
		buttonName.add("View Documents");
		buttonMethod.add("openViewUploadWindow()");
	}

		
	String userType = (String)session.getValue("UserType");
	String userRole = (String)session.getValue("USERROLE");
	
	if(userRole!=null)
		userRole = userRole.trim();
			
	if("2".equals(userType))
	{
		//buttonName.add("Approve");
		//buttonMethod.add("funSubmitToSAP()");
		//if("TBA".equals(statusFlag) && ("PP".equals(userRole) || "PH".equals(userRole)))
		if("TBA".equals(statusFlag) && ("PP".equals(userRole)))
		{
			buttonName.add("Submit");
			buttonMethod.add("funSubmit()");
		}else  if("PH".equals(userRole)) {
			buttonName.add("Approve");
			buttonMethod.add("funSubmitToSAP()");
		}
	}	

	out.println(getButtonStr(buttonName,buttonMethod));	
%> 
</center>
<Div id="MenuSol"></Div> 
</Body>
</Html>

<Div id="MenuSol"></Div> 
</Form>
</Body>
