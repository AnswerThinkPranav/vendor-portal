<%//@ include file="../../Library/Globals/errorPagePath.jsp"%>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
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
		alert('1');
		
		$('#attachs option').prop('selected', 'selected');
		alert('2')
		document.myForm.action = "ezUploadDocs.jsp";
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
		String display_header	= "  Audit Findings  ";
	
%>
		<%@ include file="../Misc/ezDisplayHeader.jsp" %>
		
		
		<br>
		<Div id="theads">
			<Table id="tabHead" align=center border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 width="43%">
				
				<Tr>
				<Th>Select Vendor</Th>
<%
		String showDisplayFrame = "N";
		String USERDEFPURGRP =(String)session.getValue("USERDEFPURGRP");
		
		if(USERDEFPURGRP==null|| "null".equals(USERDEFPURGRP) ||"".equals(USERDEFPURGRP.trim()))
		USERDEFPURGRP="";
		if (catareaRows > 0)
		{
			String purGroupArea = "",purGroupCode = "";
			String purGroupDesc = "",domainType   = "";
			String companyCode  = "";
			String selectLabel  = "";
			String bannerLabel = "";
			/*if("3".equals(userType))
				bannerLabel = "Company Code";
			else*/
				bannerLabel = "Purchase Group";
			
			String selected = "";
			int selPAIndex = 0;
			int selVNIndex = 0;
			String colSpan = "";
			String selWidth= "";
			String colAlign= "";
			String colSpace= "";
			int soldtoRows = 0;
			if(retsoldto!=null)
				soldtoRows = retsoldto.getRowCount();
			if("3".equals(userType) || soldtoRows == 0)
			{
				colSpan = "colspan=3";
				selWidth= "width:30%";
				colAlign= "align=right"; 
				colSpace= "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			}	
			else		
			{
				colSpan = "";
				selWidth= "width:55%";
				colAlign= "align=left"; 
				colSpace= "";
			}
%>	
			
			
			
			</Font><%=colSpace%>
			</Td>

<%
			boolean noVendor = false;
			String retVendorCode = "";
			String retVendorName = "";
			String selVendorCode = "";
			String selVendorName = "";

			if(!"3".equals(userType))
			{
				if(retsoldto!=null)
				{
					if(soldtoRows > 0)
					{
					
						retsoldto.sort(new String[]{"ECA_NAME"},true);
%>					
						<Td width=40% valign=bottom align=left colspan='3'>
						<Font color='#00355D' size=2 face="Tahoma"><b>&nbsp;&nbsp;</b></font>
<%
						if(soldtoRows == 1)
						{
							selVendorCode = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO").trim();
							selVendorName = retsoldto.getFieldValueString(0,"ECA_NAME").trim();
%>
							<input type=hidden name='Vndr' value='<%=selVendorCode%>'>
							<input type=text class='tx' value='<%=selVendorCode+" --> "+selVendorName%>'>
<%
						}
						else
						{
%>
						
							<Select name="Vndr" onChange="changeVendor('N')" style="width:65%">
							<option value="">---Select Vendor---</option>
<%					
							for(int i=0;i<soldtoRows;i++)
							{
								retVendorCode = retsoldto.getFieldValueString(i,"EC_ERP_CUST_NO").trim();
								retVendorName = retsoldto.getFieldValueString(i,"ECA_NAME").trim();
								if((vendorCode.trim()).equals(retVendorCode.trim()))
								{
									selected = "selected";
									selVNIndex = i;
									selVendorCode = retVendorCode;
									selVendorName = retVendorName;
								}	
								else
									selected = "";
									
								String vendorCodeString = "";	
								try
								{
									vendorCodeString = Integer.parseInt(retVendorCode)+"";
								}catch(Exception e){vendorCodeString = retVendorCode;}
%>
								<option  value="<%=retVendorCode+"#"+retVendorName%>"><%=vendorCodeString+"->"+retVendorName%></option>
<%
							}
							if(selVNIndex == 0)
							{
								selVendorCode = retsoldto.getFieldValueString(0,"EC_ERP_CUST_NO").trim();
								selVendorName = retsoldto.getFieldValueString(0,"ECA_NAME").trim();
							}
							noVendor = false;
%>
							</Select>
							
							<img src="../../Images/Others/find.gif" style="cursor:hand" height="18" alt="Find" onClick="javascript:vendSrch()">
<%
						}
%>
						</Td>
						<input type=hidden name="VENDOR_CODE" value="<%=selVendorCode%>">
						<input type=hidden name="VENDOR_NAME" value="<%=selVendorName%>">	
						<input type="hidden" name="selVNIndex" value="<%=selVNIndex%>">
<%
						showDisplayFrame = "Y";
					}
					else
					{
						noVendor = true;
					}
				}
				else
				{
					noVendor = true;
					showDisplayFrame = "N";
				}
				if(noVendor)
				{
%>
					<script>
						document.getElementById("home_mail").style.visibility="hidden"
						top.display.location.href='ezBlank.jsp?statement=Vendors not synchronized';
					</script>
<%
					showDisplayFrame = "N";
				}
			}
			else
			{
				showDisplayFrame = "Y";
			}
%>
			<input type="hidden" name="selPAIndex" value="<%=selPAIndex%>">
<%
		}
		else
		{
%>
			<script>
				document.getElementById("home_mail").style.visibility="hidden"
				top.display.location.href='ezBlank.jsp?statement=Purchase Groups not defined...Please contact Administrator';
			</script>
<%
			showDisplayFrame = "N";
		}
%>				<Tr>
				<Th>Select Year</Th>

				<Td>
				<Select name='year'>
				<option>--Select Year-- </option>
				<option value="2012">2012</option>
				<option value="2013">2013</option>

				</Select>
				</Td>

				<Th >Select Month</Th>
				<Td>
				   <Select name='month'>
				   <option>--Select Month-- </option>
				   <option value="JAN">January</option>
				       <option value="FEB">February</option>
				       <option value="MAR">March</option>
				       <option value="APR">April</option>
				       <option value="MAY">May</option>
				       <option value="JUN">June</option>
				       <option value="JUL">July</option>
				       <option value="AUG">August</option>
				       <option value="SEP">September</option>
				       <option value="OCT">October</option>
				       <option value="NOV">November</option>
					<option value="DEC">December</option>
				   </Select>
				   </Td>


					

				</Tr>
				<Tr>

					<Th>Audit Findings  Remarks</Th>
					<td colspan='4'><textarea name='auditFindingRem' rows='10' cols='48' ></Textarea></td>
				</Tr>
				<Tr>
				<Th  align="left" width="40%">Attachment</Th>
				<Td colspan=3 align="center">
				<a href="JavaScript:funAttach()" title="Click Here To Attach A File"><img src="../../Images/attach_icon.png" alt="Click Here To Add Attachments" height="20" border="0" width="20"></a>&nbsp;&nbsp;&nbsp;&nbsp;
				<Select name='attachs' id="attachs" multiple=1 style="width:380px"></Select>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="JavaScript:funRemove()" title="Click Here To Remove Attached File"><img src="../../Images/remove_icon.png" alt="Click Here To Delete Attachments" height="20" border="0"  width="20"></a>
				</td>
				</Tr>
			<Table>
			<br>
<Div id="ButtonDiv" style="position:absolute;top:90%;width:100%;visibility:visible">
<center>
<%
	buttonName = new java.util.ArrayList();
	buttonMethod = new java.util.ArrayList();
	
	buttonName.add("Save");
	buttonMethod.add("funSave()");
	out.println(getButtonStr(buttonName,buttonMethod));
	
%>	
		
		</Div>	
		</Form>
		</Body>
		</Html>


