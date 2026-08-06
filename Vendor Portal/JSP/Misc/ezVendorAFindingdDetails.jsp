<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<Html>
<Head>
<Script>
function funClose()
{
window.close();
}
function funAttach()
{
	
	window.open('../Inbox/ezAttachFile.jsp','popuppage','left=510,top=180,width=400,height=360,statusbar=no');
	
}

function funRemove()
{
	var attachments=new Array();
	var j=0;
	var count=0;
	
	if(document.myForm.attachs.length>0)
	{
		for(var i=0;i<document.myForm.attachs.length;i++)
		{
			if(document.myForm.attachs.options[i].selected==true)
			{
				count++;
			}
		}
		if(count==0)
		{
			alert("Please Select a File To Remove");
			return ;
		}
	}
	else
	{
		alert("No Attachments To Remove");
	}
	for(var i=0;i<document.myForm.attachs.length;i++)
	{
		
		if(document.myForm.attachs.options[i].selected==false)
		{
			attachments[j]=document.myForm.attachs.options[i].value;
			j++;
		}
	}

	for(var i=document.myForm.attachs.length;i>=0;i--)
	{
		document.myForm.attachs.options[i]=null;
	}
	for(var i=0;i<attachments.length;i++)
	{
		document.myForm.attachflag.value="true"
		document.myForm.attachs.options[i]=new Option(attachments[i],attachments[i]);
	}
}
function funSave()
{

	
	if(document.myForm.vendorComments.value=='')
	{
		alert('Please  Enter  Vendor Comments ');
		document.myForm.vendorComments.focus();
		return;
	}
	if(document.myForm.attachs.length=='0')
	{
			alert('Please  Upload Atleast One  Attachment');
			document.myForm.attachs.focus();
			return;
	}
	
	else
	{
		

		var attachs = document.getElementById('attachs');
		attachs.selectedIndex = 0;
		document.myForm.action='ezSaveVendorAFindings.jsp';
		document.myForm.submit();
	}
 
}
</Script>
</Head>
<Body>
<Form name='myForm'>
<input type=hidden name='attachflag' 	value=''>
<%	
	String display_header = "Audit Details";
	
	String auditNumber 	= request.getParameter("auditNumber");
	String vendor	        = request.getParameter("vendor");
	String year	        = request.getParameter("year");
	String month  	        = request.getParameter("month");
	String buyerComments     = request.getParameter("buyerComments");
	String vendorComments     = request.getParameter("vendorComments");
	String dueDate     	= request.getParameter("dueDate");
	String vendorName	= request.getParameter("vendorName");
%>
	
	<%@ include file="../Misc/ezDisplayHeader.jsp" %>
	<br>
	
	<center>
		<table  width='75%' border=1 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=2 cellSpacing=0>
		
			
			<Tr>
				<th align="left" width="10%">Audit Number</th>
				<td align="left" width="10%"><%=auditNumber%></td>
				<input type='hidden' name='auditNumber' value='<%=auditNumber%>'>
				<th align="left" width="10%">Vendor</th>	
				<td align="left" width="10%"><%=vendorName%></td>
				<input type='hidden' name='vendor' value='<%=vendor%>'>
			</Tr>	
			 <Tr>
				<th align="left" width="15%">Year</th>	
				<td align="left" width="20%"><%=year%></td>
				<input type='hidden' name='year' value='<%=year%>'>
				<th align="left" width="15%">Month</th>    
				<td align="left" width="20%"><%=month%></td>
				<input type='hidden' name='month' value='<%=month%>'>
				
				
			</tr>
			 <Tr>
				<th align="left" width="15%">Due Date</th>
				<td align="left" width="20%" colspan='3'><%=dueDate%></td>
			</tr>
			<Tr>
				<th align="left" width="15%">Remarks(MTR)</th>  <td align="left" width="20%" colspan='3'><%=buyerComments%></td>
				<input type='hidden' name='buyerComments' value='<%=buyerComments%>'>
			</Tr>
<%
			if(vendorComments!=null && !"null".equals(vendorComments))
			{
%>
	
				<Tr>
					<th align="left" width="15%">Vendor  Remarks</th>  <td align="left" width="20%" colspan='3'><Textarea name='vendorComments' align='left' rows='4' cols='75' ><%=vendorComments%></Textarea></td>
				</Tr>
<%
			}
			else
			{
%>
			<Tr>
				<th align="left" width="15%">Vendor  Remarks</th>  <td align="left" width="20%" colspan='3'><Textarea name='vendorComments' align='left' rows='4' cols='75' ></Textarea></td>
			</Tr>
<%
			}
%>			
			<Tr>
			<Th  align="left" width="40%">Attachment</Th>
			<Td colspan=3 align="left">
			<a href="JavaScript:funAttach()" title="Click Here To Attach A File"><img src="../../Images/attach_icon.png" alt="Click Here To Add Attachments" height="20" border="0" width="20"></a>&nbsp;&nbsp;&nbsp;&nbsp;
			<Select name='attachs' id="attachs" multiple=1 style="width:590px"></Select>&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="JavaScript:funRemove()" title="Click Here To Remove Attached File"><img src="../../Images/remove_icon.png" alt="Click Here To Delete Attachments" height="20" border="0"  width="20"></a>
			</td>
			</Tr>
			
			
		</thead>
		
		<tbody>
		<center>
		
	<Div align='center' style='position:absolute;rigth:88%'>
	<br><br><br><bR>

</center>
<div>
<%
	String conStatus ="";
	String uploadKey = "";
	String docsKeyStr="'999111VAUDIT"+auditNumber+"','999111VAUDIT"+auditNumber+"','999111BAUDIT"+auditNumber+"','999111BAUDIT"+auditNumber+"'";
%>
<br><Center>
<%@ include file="../Misc/ezGetUploadedDocs.jsp"%>
<%
	//out.println("docsListCnt=="+docsListCnt);
	buttonName.add("Back");
	buttonMethod.add("history.go(-1)");
	
	if(!"C".equals(request.getParameter("auditStatus")))
	{
		buttonName.add("Save");
		buttonMethod.add("funSave()");
	}	
	
	if(docsListCnt>0)
	{
		buttonName.add("View Documents");
		buttonMethod.add("openViewUploadWindow()");

	}
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>	

<Div id="MenuSol"></Div> 
</Center>
</Form>
</Body>
</Html>