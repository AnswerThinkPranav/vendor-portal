<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../../../Includes/JSPs/Misc/iMultiVendorDetails.jsp" %>
<%@ page import="java.util.*,java.text.*" %>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/Jsps/Misc/iblockcontrol.jsp" %>

<%@ include file="../../../Includes/JSPs/Misc/iSbuPlantAddress.jsp"%>

<%
	if( (fromDate== null && toDate == null) || ("null".equals(toDate) && "null".equals(fromDate)) ){
	
		fromDate = "";
		toDate = "";
		
	}

	String reqType =  request.getParameter("type");
	ezc.ezcommon.EzLog4j.log(":::::::::::reqType:::::::"+reqType,"I");
	String width = "65%";
	String colspan = "";
	
	if("NotAcknowledged".equals(reqType))
	{
		colspan = "colspan=2";
		width = "50%";
	}	
	
%>

<%		
	if("NotAcknowledged".equals(reqType))
	{
%>
<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
<Table width="<%=width%>%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
<Tr>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
		<Tr>
		
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='40%' align=left valign=center >
				Search PO &nbsp;&nbsp;<input type=text class=inputbox value="" name="searchPO"   size=15 maxlength="10">&nbsp;
				
			</Td>

			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='40%' align=left valign=center >Plant
							
<%
			String userPlant = (String)Session.getUserPreference("PLANT");

			if(!"3".equals(userType) && userPlant!=null && !"null".equals(userPlant) && !"".equals(userPlant))
			{
%>
				<%=userPlant%>
				<input type=hidden name="selplant" value="<%=userPlant%>">
<%
			}
			else
			{
				String purOrgSubStr = multiVendPurOrg.substring(0,2);


%>		
				<select name="selPlant" id="ListBoxDiv1" style="width:50%">
				<option value="">-- Select Plant --</option>
<%
				for(int i=0;i<ret.getRowCount();i++)
				{

					String tempPurOrgSubStr = ret.getFieldValueString(i,"CODE");

					if(tempPurOrgSubStr!=null)
						tempPurOrgSubStr = tempPurOrgSubStr.substring(0,2);

					if(!purOrgSubStr.equals(tempPurOrgSubStr))
					continue;
%>
					<option value="<%=ret.getFieldValueString(i,"CODE")%>"><%=ret.getFieldValueString(i,"CODE")+"["+ret.getFieldValueString(i,"NAME")+" , "+ret.getFieldValueString(i,"LOCATION")+"]"%></option>
<%	   		
				}
			}	
%>  	   		
				</select>
				
					
					
			</Td>
			<!--<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='20%' align=right <%=colspan%>>
				<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
			</Td>-->
			<Td <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true" style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='5%' align=right>
				<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">&nbsp;
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
	}
%>

<%		
	if("Acknowledged".equals(reqType))
	{
%>
<Div id='inputDateDiv' style='position:relative;align:center;top:0%;width:100%;'>
<Table width="<%=width%>%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
<Tr>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
	<Td height="5" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
</Tr>
<Tr>
	<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
	<Td style="background-color:'F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" cellpadding=0 cellspacing=0 class=welcomecell>
		<Tr>
	
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%'>
				From Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=fromDate%>" name="FromDate" id="FromDate"  readonly size=15 maxlength="10">&nbsp;<%=getDateImage("FromDate")%>
			</Td>
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' >
				To Date&nbsp;&nbsp;<input type=text class=inputbox value="<%=toDate%>" name="ToDate" id="ToDate" readonly size=15 maxlength="10">&nbsp;<%=getDateImage("ToDate")%>
			</Td>

			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;' width='30%' align=left valign=center >
				Search PO &nbsp;&nbsp;<input type=text class=inputbox value="" name="searchPO"   size=15 maxlength="10">&nbsp;
				
			<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold;align:center' width='10%' align=right <%=colspan%>>
				<!--<Img src="../../../../EzCommon/Images/Body/left_arrow.gif" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">-->
				<Img src="../../../../EzCommon/Images/Body/arrowright.png" style="cursor:hand" border="none" <%=clickString%> onMouseover="window.status=''; return true" onMouseout="window.status=' '; return true">
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
	}
%>