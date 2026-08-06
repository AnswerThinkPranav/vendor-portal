<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Materials/iGetUploadTempDir.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iWFAuditTrailList.jsp" %>
<html>
<head>
<Title>WorkFlow Audit Trail List-- Powered by EzCommerce India(An The Hackett Group Company)</Title>

<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<script>
var tabHeadWidth = 70;
var tabHeight="65%";
if(screen.width==800)
{
	tabHeight="40%";
}


function submitPage()
{
	document.myForm.submit()	
       
}
</script>
<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
<Script src="../../Library/JavaScript/Misc/ezWFAuditTrailList.js"></Script>
</head>
<Body onLoad="scrollInit(<%=scrollInit%>)" onresize="scrollInit(<%=scrollInit%>)" scroll=no >
<Form name="myForm">
<input type=hidden name='commentsField'>
<%
	String display_header = "Work Flow Audit Trail";
%>	
<%@ include file="ezDisplayHeader.jsp"%>

<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
<Table width="45%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
<Tr>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
		<Tr width="100%">
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='55%' valign=center align="center">
				
			Document Type&nbsp;
			<select name='wf_trail_type' onchange='submitPage()' id="listBoxDiv2" style="width:50%">
					<option value='-'>Select Audit Type</option>
			<%				
					while(enum.hasMoreElements())
					{
						keyId = (String)enum.nextElement();
						keyValue = (String)auditHash.get(keyId);
						if(auditType!= null && auditType.equals(keyId))
							selected = "selected";
						else
							selected = "";

			%>
						<option value='<%=keyId%>' <%=selected%>><%=keyValue%></option>
			<%
					}
			%>
			</select>
			</Td>
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='55%' align=center valign=center>
				Document No&nbsp;
				<Select name="wf_trail_list" id="listBoxDiv1" style="width:50%" onchange='submitPage()'>
								<Option value="">--Select--</Option>
				<%
								for(int k=0;k<myRetCnt;k++)
								{
									String cmstr = myRet.getFieldValueString(k,"DOCID");
									if(docId == cmstr || cmstr.equals(docId))
									{
				%>				
										<Option value='<%=myRet.getFieldValueString(k,"DOCID")%>' selected><%=myRet.getFieldValueString(k,"DOCID")%></Option>
				<%
									}
									else
									{		
				%>
										<Option value='<%=myRet.getFieldValueString(k,"DOCID")%>'><%=myRet.getFieldValueString(k,"DOCID")%></Option>
				<%
									}	
								}
				%>				
								
				</Select>
			</Td>
			
		</Tr>
		
		</Table>
	</Td>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif" ></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
	<Td width="5" style="background-color:'F3F3F3'" height="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
</Tr>
</Table>
</Div>


<%
	if(request.getParameter("wf_trail_list")!=null && !"null".equals(request.getParameter("wf_trail_list")))
	{
		if(retCount>0)
		{
%>	<BR>
			<Div id="theads" >
			<Table id="tabHead" align=center width="70%" class=tableClass border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
				<Tr>
					<Th width="10%"  align="center">Audit</Th>
					<Th width="55%" align="center">Action</Th>
					<Th width="20%" align="center">Date </Th>
					<Th width="15%" align="center">Time Taken</Th>
				</Tr>
			</Table>
			</Div>
			<DIV   style="overflow:auto;position:absolute;width:100%">
			<Table  align=center width="70%"   class=tableClass border=1 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0>
<%
				String comments = "";
				for(int i=0;i<retCount;i++)
				{
					comments = retGetWFAuditTrailNos.getFieldValueString(i,"EWAT_COMMENTS");
					if(comments.indexOf("$") != -1)
					{
						comments = comments.substring(comments.indexOf("$")+1,comments.length());
					}
%>
					<Tr>
						<Td width="10%" align="center"><%=retGetWFAuditTrailNos.getFieldValueString(i,"EWAT_AUDIT_NO")%>&nbsp;</Td>
						<Td width="55%" title='<%=comments%>'><%=comments%>&nbsp;</Td>
						<Td width="20%" align="center"><%=fd.getStringFromDate((Date)retGetWFAuditTrailNos.getFieldValue(i,"EWAT_DATE"),(String)session.getValue("DATESEPERATOR"),Integer.parseInt((String)session.getValue("DATEFORMAT")))%>&nbsp;&nbsp;<%=retGetWFAuditTrailNos.getFieldValue(i,"AUDIT_TIME")%></Td>
						<Td width="15%" align="center"><%=retGetWFAuditTrailNos.getFieldValueString(i,"TIME_DIFF")%>&nbsp;</Td>
					</Tr>
<%
				}
%>

			</Table>
			</Div>	
<Div id="ButtonsDiv" align=center style="position:absolute;visibility:visible;width:100%;top:90%">
 <%
	        buttonName.add("Back");   
	        buttonMethod.add("history.go(-1)");
	        out.println(getButtonStr(buttonName,buttonMethod));
%>	    
</Div>	

<%
		}
		
		if( myRetCnt>0 && retCount==0)
		{
		  if(docId!=null)
		  {
%>			
			<DIV style="position:absolute;width:100%;height:40%;top:45%">
				<Table align="center" style="width:30%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
					<Tr>
						<Th width="25%">Please Select Document Number  </Th>
					</Tr>
				</Table>
			</Div>
			
<%
		  }
		 else
		  {
 %>
		  <DIV style="position:absolute;width:100%;height:40%;top:45%">
			<Table align="center" style="width:30%" border=0 borderColorDark=#ffffff borderColorLight=#000000 cellPadding=5 cellSpacing=1>
				<Tr>
					
					<Th width="25%">List Not Found For This Document Number.</Th>
				</Tr>
			</Table>
		 </Div>
		  
<%
	}
		  }
	}
%>		

<Div id="MenuSol">
</Div>
</form>
</body>
</html>