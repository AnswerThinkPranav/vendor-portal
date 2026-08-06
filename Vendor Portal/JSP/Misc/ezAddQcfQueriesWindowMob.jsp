<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iblockcontrol.jsp" %>
<%@ include file="../../../Includes/JSPs/Rfq/iAddQcfQueriesWindow.jsp" %>
<%//@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%//@ include file="../../../Includes/JSPs/Misc/iWFMethods.jsp"%>
<%//@ include file="../Misc/ezGetUserAuthDefaults.jsp"%>
<%@ include file="../Misc/ezCommonMethods.jsp"%>
<%@ include file="../Misc/ezWFCommonMethods.jsp"%> 
<%@ include file="../../../Includes/JSPs/Rfq/iQueryToUser.jsp"%>
<%//@ include file="../Misc/ezHeader.jsp"%>
<html>
<head>
<Title>Queries Add Form-- Powered By The Hackett Group India Pvt Ltd. </Title>
<base TARGET="_self">
<Script src="../../Library/JavaScript/Rfq/ezQCS.js"></Script>
<Script>
function closeWindow()
{
	
	var rfqObj = document.myForm.chk1;
	var rfqLen; 
	var chooseUser = "";
	var chooseRfq = 0;
	
	
	if(Trim(document.myForm.qcfComments.value)=="")
	{
		alert("Please Enter Query String");
		document.myForm.qcfComments.value="";
		document.myForm.qcfComments.focus();		
		return;
	}
	else if(document.myForm.qcfComments.value.length>1000)
	{
		alert("Query Should Not Exceed 1000 Characters");
		document.myForm.qcfComments.focus();
		return;
	}
	
	if(rfqObj != null)
	{
		rfqLen = document.myForm.chk1.length;
		if(!isNaN(rfqLen))
		{
			for(i=0;i<rfqLen;i++)
			{
				if(document.myForm.chk1[i].checked)
				{
					if(chooseRfq == 0)
						chooseUser = document.myForm.chk1[i].value;
					else
						chooseUser += "¥"+document.myForm.chk1[i].value;
					chooseRfq++;
				}
			}
		}
		else
		{
			if(document.myForm.chk1.checked)
			{
				chooseUser = document.myForm.chk1.value;
				chooseRfq = 1;
			}	
			else
			{
				chooseRfq = 1;
			}
		}
		if(chooseRfq > 0)
		{
			
			document.myForm.QcfNumber.value		=	window.opener.document.myForm.QcfNumber.value;
			document.myForm.qcsCommentNo.value	=	window.opener.document.myForm.qcsCommentNo.value;
			document.myForm.Type.value		=	window.opener.document.myForm.commentType.value;
			document.myForm.Initiator.value		=	chooseUser;
			document.getElementById("ButtonsDiv").style.visibility="hidden";
			document.getElementById("msgDiv").style.visibility="visible";
			document.myForm.action="ezAddSaveQcfQuery.jsp";
			document.myForm.submit();
			
		}
		else
		{
			alert("Please select the user to send the query"); 
		}
	}	
	
		
}

function sendReminder()
{
	var qryObj = document.myForm.rd1
	var qryLen = document.myForm.rd1.length
	var remUser = "";
	var count = 0;
	
	if(!isNaN(qryLen))
	{
		for(i=0;i<qryLen;i++)
		{
			if(document.myForm.rd1[i].checked)
			{
				remUser = document.myForm.rd1[i].value
				count++;
			}
		}
		if(count==0)
		{
			alert("Please select a Query for Reminder");
			return;
		}
	}
	else
	{
		if(document.myForm.rd1.checked)
		{
			remUser = document.myForm.rd1.value
		}
		else
		{
			alert("Please select a Query for Reminder");
			return;
		}
	}

	document.myForm.reminderUser.value = remUser
	document.getElementById("ButtonsDiv").style.visibility="hidden"
	document.getElementById("msgDiv").style.visibility="visible"
	document.myForm.action="ezReminderQuery.jsp";
	document.myForm.submit();
}

</Script>

</head>
<Body scroll="no">
<Form name="myForm">
<Input type=hidden name='QcfNumber'>
<Input type=hidden name='qcsCommentNo'>
<Input type=hidden name='Type'>
<Input type=hidden name='Initiator'>
<Input type=hidden name='DOCTYPE' value='<%=DOCTYPE%>'>
<Input type=hidden name='VENDOR' value='<%=VENDOR%>'>
<Input type=hidden name='QRYCOUNT' value='<%=(qcsCount+1)%>'>
<Input type=hidden name='reminderUser'>
<Input type=hidden name='docNum' value='<%=colectiveNo%>'>


<%
	java.util.Vector userIdsVect =  new java.util.Vector();
	boolean flag = false;
	if(hashSize > 0)
	{
		java.util.Enumeration ezEnum = userHash.keys();
		String keyId = "";
		String valueId = "";
%>
		<Div align=center style="position:absolute;top:60%;visibility:visible;width:70%;overflow-y:scroll; height:100px">
		<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1  width="50% height="100px"">
		<Tr>
			<Th width=20%>&nbsp;</Th><Th width=80%>UserName</Th>
		</Tr>
<%
		String tempData = "";
		for(int i =0;i<userHash.size();i++)
		{
			flag = false;
			tempData = (String)userHash.get(i+"");
			keyId 	= tempData.substring(0,tempData.indexOf("¥"));
			
			if(!userIdsVect.contains(keyId))
			{
				userIdsVect.addElement(keyId);
				flag = true;
			}	
			
			valueId = tempData.substring(tempData.indexOf("¥")+1);
			if(!("-".equals(keyId) || "-".equals(valueId)) && flag)	
			{	
%>
			<Tr>
				<Td width=20% align=center><input type=checkbox name=chk1 value='<%=keyId%>'></Td>
				<Td width=80%><%=valueId%></Td>
			</Tr>
<%
			}
			initCount++;
		}
%>
		</Table>
		</Div>
<%
	}
	else
	{
%>
		<Div align=center style="position:absolute;top:60%;visibility:visible;width:100%">
		<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1  width="50%">
		<Tr>
			<Th>No users to send query</Th>
		</Tr>
		</Table>
		</Div>
<%
	}
%>
		
		



<%
	boolean reminder = false;
	
	ezc.ezutil.FormatDate fD = new ezc.ezutil.FormatDate();
	String type = "";
	if(request.getParameter("TYPE") != null)
		type = request.getParameter("TYPE");
	if(qcsCount>0)
	{
%>
		<Br>
		<DIV style="position:absolute;overflow:auto;width:100%;height:30%;top:5%">
		<Table align="center" style="width:100%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
			<Tr>
				<Th colspan=3>List of Query/Reply</Th>
			</Tr>
		</Table>		
<%	
		String statusDate = "";
		for(int i=0;i<qcsCount;i++)
		{
			String  query_map = qcsRet.getFieldValueString(i,"QCF_COMMENT_NO");
			if(qcsRet.getFieldValueString(i,"QCF_QUERY_MAP") == "-1" || "-1".equals(qcsRet.getFieldValueString(i,"QCF_QUERY_MAP")))
			{
				/*
					java.util.Date stsDate	= (java.util.Date)qcsRet.getFieldValue(i,"QCF_DATE");
					statusDate = fD.getStringFromDate(stsDate,".",fD.DDMMYYYY);
				*/
				statusDate = globalRet.getFieldValueString(i,"QCF_DATE");
%>
				<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1 width=100%>
				<Tr>
					<Td>
					<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1 width=100%>
					<Tr>
						<Th width="30%" colspan=2>Query sent by <%=qcsRet.getFieldValueString(i,"QCF_USER")%> to <%=qcsRet.getFieldValueString(i,"QCF_DEST_USER")%> on <%=statusDate%></Th>
						<!-- <Td width="70%"><%=qcsRet.getFieldValueString(i,"QCF_COMMENTS")%></Td> -->
						<Td width="70%"><textarea readonly rows=4 style="width:100%"><%=qcsRet.getFieldValueString(i,"QCF_COMMENTS")%></textarea></Td>
					</Tr>
					</Table>
					<Table align=center border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1 width=100%>
<%
					for(int k=0;k<qcsCount;k++)
					{
						if(query_map == qcsRet.getFieldValueString(k,"QCF_QUERY_MAP") || query_map.equals(qcsRet.getFieldValueString(k,"QCF_QUERY_MAP")))
						{
							/*
								stsDate	= (java.util.Date)qcsRet.getFieldValue(k,"QCF_DATE");
								statusDate = fD.getStringFromDate(stsDate,".",fD.DDMMYYYY);
							*/
							statusDate = globalRet.getFieldValueString(k,"QCF_DATE");

%>
							<Tr>
								<Th width="30%" colspan=2>Reply sent by <%=qcsRet.getFieldValueString(k,"QCF_USER")%> on <%=statusDate%></Th>
								<!-- <Td width="70%"><%=qcsRet.getFieldValueString(k,"QCF_COMMENTS")%></Td> -->
								<Td width="70%"><textarea readonly rows=4 style="width:100%"><%=qcsRet.getFieldValueString(k,"QCF_COMMENTS")%></textarea></Td>

							</Tr>
<%
						}
					}
%>
					</Table>
					</Td>
				</Tr>
				</Table>
<%
			}
			else if(qcsRet.getFieldValueString(i,"QCF_QUERY_MAP") == "0" || "0".equals(qcsRet.getFieldValueString(i,"QCF_QUERY_MAP")))
			{
				/*
					java.util.Date stsDate	= (java.util.Date)qcsRet.getFieldValue(i,"QCF_DATE");
					statusDate = fD.getStringFromDate(stsDate,".",fD.DDMMYYYY);
				*/
				
				reminder = true;
				
				statusDate = globalRet.getFieldValueString(i,"QCF_DATE");
%>
				<Table align="center" style="width:100%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
				<Tr>
					<Th width="5%"><input type=radio name="rd1" value="<%=qcsRet.getFieldValueString(i,"QCF_DEST_USER")%>"></Th>
					<Th width="25%">Query sent by <%=qcsRet.getFieldValueString(i,"QCF_USER")%> to <%=qcsRet.getFieldValueString(i,"QCF_DEST_USER")%> on <%=statusDate%></Th>
					<!-- <Td width="70%"><%=qcsRet.getFieldValueString(i,"QCF_COMMENTS")%></Td> -->
					<Td width="70%"><textarea readonly rows=4 style="width:100%"><%=qcsRet.getFieldValueString(i,"QCF_COMMENTS")%></textarea></Td>

				</Tr>
				</Table>
<%
			}
		}
%>
		</Div>
<DIV style="position:absolute;overflow:auto;width:100%;top:40%">		
	<Table>
	 <Tr>
		<Th>View Attached Files</Th>
	 </Tr>
	<Tr>
<%
		String docType="QCF";
%>
		<Td borderColorDark=#ffffff width=40% align='center' >
			<iframe src='../UploadFiles/ezQueryAttachments.jsp?docNum=<%=colectiveNo%>&docType=<%=docType%>' frameborder=1 width=100% scrolling=auto scrolling=yes  height='85'></iframe>
		</Td>
	</Tr>
	</Table>
</DIV>		
		
<%
	}		
	else
	{
%>
		<Div style="position:absolute;top:45%;width:100%;visibility:visible;" >
		<TABLE id="tabHead" width="50%" align=center border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
		<Tr align="center" valign="middle">
			<Th width=60%>No queries posted for this document</Th>
		</Tr>
		</Table>
		</Div>
<%
	}
	if(!"REPORT".equals(type))
	{
		if(qcsCount>0)
		{
%>
			<DIV style="position:absolute;width:100%;height:40%;top:80%">
<%
		}
		else
		{
%>	
			<DIV style="position:absolute;width:100%;height:40%;top:20%">
<%
		}

			String firstValue = (String)session.getValue("FIRST");
			String userRole_A = (String)session.getValue("USERROLE");
			if(!"Y".equals(firstValue) && !"VR".equals(userRole_A) )
			{
%>	
				<Table align="center" style="width:80%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
				<Tr>
					<Th>Query</Th>
				</Tr>
				<Tr>
					<Td><textarea rows=4 name="qcfComments" style="width:100%"></textarea></Td>
				</Tr>
				</Table>
<%
			}
%>	
			</Div>	
			<DIV id="ButtonsDiv" style="position:absolute;width:100%;top:95%">
<%			
			if(!"Y".equals(firstValue) && !"VR".equals(userRole_A) )
			{
%>			
				<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="closeWindow()"><i class="fa fa-remove"></i>&nbsp;Close</button>
<%
				if(reminder)
				{
%>				
					<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="sendReminder()"><i class="fa fa-remove"></i>&nbsp;Close</button>
<%					
				}
			}	
%>
			<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>

			</Div>
			<Div id="msgDiv" style="position:absolute;top:95%;width:100%;visibility:hidden" align="center">
			<Table align="center" width="60%" border=0 borderColorDark=#ffffff borderColorLight=#006666 cellPadding=5 cellSpacing=1 >
			<Tr>
				<Th  align="center">Your request is being processed. Please wait ...............</Th>
			</Tr>
			</Table>
			</Div>
<%
	}
	else
	{
%>
		<DIV id="ButtonsDiv" style="position:absolute;width:100%;top:95%">
		<button type="button" class="btn btn-danger pull-right" style="margin:5px" onclick="window.parent.closeIframe()"><i class="fa fa-remove"></i>&nbsp;Close</button>

		</Div>
<%
	}
%>
</form>
<Div id="MenuSol"></Div>
</body>
</html>

