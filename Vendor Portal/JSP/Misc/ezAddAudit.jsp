<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@ include file="../Misc/ezGetVendorCodesAndNames.jsp"%> 
<%@ include file="../../../../EzCommon/Includes/iShowCal.jsp"%>

<Html>
<Head>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js">
<Script src="../../Library/JavaScript/ezStatus.js"></Script>
	<Script src="../../Library/JavaScript/ezTrim.js"></Script>
	<Script src="../../Library/JavaScript/Misc/ezLoginBanner.js"></Script>
	<link rel="stylesheet" href="../../Library/Styles/Banner/ezBannerPink.css">
	<script>
	
	function vendSrch()
	{
		
		window.open("ezVendSrch.jsp","PopUp","width=500,height=500,top=90,left=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		
		//window.showModalDialog('ezVendSrch.jsp','','unadorned:yes;resizable:1;dialogHeight:200px;dialogwidth:450px;scroll:yes;status=no');
		
		
	}
	
	</script>

<Script>
function funSave()
{	
	
	if(document.myForm.Vndr.value=='')
	{
		alert('Please  Select  Vendor');
		document.myForm.Vndr.focus();
		return;
	}
	if(document.myForm.year.value=='')
	{
		alert('Please  Select  Year');
		document.myForm.year.focus();
		return;
	}
	if(document.myForm.month.value=='')
	{
		alert('Please  Select  Month');
		document.myForm.month.focus();
		return;
	}
	if(document.myForm.dueDate.value=='')
	{
		alert('Please  Enter  Due Date');
		return;
	}
	if(document.myForm.auditFindingRem.value=='')
	{
		alert('Please  Enter  Audit Finding Remarks');
		document.myForm.auditFindingRem.focus();
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
		
		
		$('#attachs option').prop('selected', 'selected');
		
		document.myForm.action = "ezSaveAudit.jsp";
		document.myForm.submit();
	}	
		
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
	
</Script>
</Head>
<Body  onLoad="scrollInit();" onResize="scrollInit()" scroll="no" >
<Form name='myForm' method="POST">
<input type=hidden name='attachflag' 	value=''>
<input type=hidden name='fn' 	value=''>
<%
		String purGrpTemp  = "";	
		String purGrpDesc  = "";
		String display_header	= "Addition Of Audit Findings  ";
	
%>
		<%@ include file="../Misc/ezDisplayHeader.jsp" %>
		
		
		<br>
			<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="50%">
				
				<Tr>
				<Th width='30%' height="30" align=left>Vendor</Th>
				<Td width='70%'>
				<Select name='Vndr'  style="width:100%">
					<Option value=''>--Select Vendor--</Option>
<%
					for(int v=0;v<vendorsRetObjCnt;v++)
					{
%>
						<Option value='<%=vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO").trim()%>'><%=vendorsRetObj.getFieldValueString(v,"ECA_NAME")+"["+vendorsRetObj.getFieldValueString(v,"EC_ERP_CUST_NO")+"]"%></Option>
<%
					}
%>
				</Select>
				</Td>
				</Tr>
				<TR>
				<Th   width='20%' height="30"  align=left>Year</Th>

				<Td width="15%">
				<Select name='year' style="width:100%">
				<option  value=''>--Select Year-- </option>
				<option value="2012">2012</option>
				<option value="2013">2013</option>
				<option value="2014">2014</option>

				</Select>
				</Td>
				</Tr>
				<Tr>
				<Th   width='20%' height="30"   align=left>Month</Th>
				<Td width="50%"  align=left>
				   <Select name='month'   style="width:100%">
				   <option value=''>--Select Month-- </option>
				   <option value="01">January</option>
				       <option value="02">February</option>
				       <option value="03">March</option>
				       <option value="04">April</option>
				       <option value="05">May</option>
				       <option value="05">June</option>
				       <option value="07">July</option>
				       <option value="08">August</option>
				       <option value="09">September</option>
				       <option value="10">October</option>
				       <option value="11">November</option>
					<option value="12">December</option>
				   </Select>
				   </Td>


					

				</Tr>
				<Tr>
				<th align=left width=20%>Due Date</td>
					<td width=20%>
						<input type="text" class=InputBox  value="" id="dueDate"  name="dueDate"  size=12 readonly>
						<%=getDateImage("dueDate")%>
					</td>
				</Tr>	
				<Tr>

					<Th   width='20%' align=left>Audit Findings  Remarks</Th>
					<td><textarea name='auditFindingRem' rows='4' cols='50' align='center' ></Textarea></td>
				</Tr>
				<Tr>
				<Th    width='20%' align=left>Attachment</Th>
				<Td  align="center">
				<a href="JavaScript:funAttach()" title="Click Here To Attach A File"><img src="../../Images/attach_icon.png" alt="Click Here To Add Attachments" height="20" border="0" width="20"></a>&nbsp;&nbsp;&nbsp;&nbsp;
				<Select name='attachs' id="attachs" multiple=1 style="width:355px"></Select>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="JavaScript:funRemove()" title="Click Here To Remove Attached File"><img src="../../Images/remove_icon.png" alt="Click Here To Delete Attachments" height="20" border="0"  width="20"></a>
				</td>
				</Tr>
			</Table>
			<br>
			
			
<Div id="ButtonDiv" style="position:absolute;top:90%;width:80%;visibility:visible">	
<Center>
<%	
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Save");
	buttonMethod.add("funSave()");
	out.println(getButtonStr(buttonName,buttonMethod));
%>
</Center>
</Div>	

<Div id="MenuSol"></Div> 
</Form>
</Body>
</Html>


