<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<%@ include file="../../Library/Globals/ezBannerErrPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%@ include file="../../../Includes/JSPs/Misc/iLoginBanner.jsp" %>
<%@ include file="ezMultiVendorSelect.jsp" %>
<%@ page import="javax.xml.parsers.*,org.w3c.dom.*,javax.xml.transform.*,javax.xml.transform.dom.DOMSource,java.io.FileOutputStream,javax.xml.transform.stream.StreamResult" %>
<%
	java.util.Hashtable purGrpsHT = new java.util.Hashtable();
	purGrpsHT.put("ALL","All Purchase Groups");
	purGrpsHT.put("M16","Annual Maintenance");
	purGrpsHT.put("M11","Beverages");
	purGrpsHT.put("M19","Capex- Projects");
	purGrpsHT.put("M18","Capex-P&M,Utilitie");
	purGrpsHT.put("M17","Capital Expenditur");
	purGrpsHT.put("M08","Head Manufacturing");
	purGrpsHT.put("M03","Head Office");
	purGrpsHT.put("M10","HRD");
	purGrpsHT.put("M07","Icecream");
	purGrpsHT.put("M05","Inst.Foods");
	purGrpsHT.put("M14","IT");
	purGrpsHT.put("M04","Lab");
	purGrpsHT.put("M15","Marketing");
	purGrpsHT.put("M09","Packaging");
	purGrpsHT.put("M20","R&M-MasterPlanning");
	purGrpsHT.put("R01","Rasoi Magic");
	purGrpsHT.put("M02","Ready to Eat");
	purGrpsHT.put("M12","Repairs&Maintenanc");
	purGrpsHT.put("M01","Spices");
	purGrpsHT.put("S01","Sudarshan Ent");
	purGrpsHT.put("M13","Supply Chain");
	purGrpsHT.put("M06","Vermicelli");


	session.removeValue("PAGE_VISISTED");

	String XMLsupportid=""; 
	/*try
		{
			DocumentBuilderFactory docFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			String fileName = "ezLoginBanner.jsp";
			String filePath=request.getRealPath(fileName);
			filePath=filePath.substring(0,filePath.indexOf(fileName));
			String filePath1 = filePath+"\\..\\..\\..\\..\\EzCommon\\XMLs\\ezData.xml";
			java.io.File fileObj = new java.io.File(filePath1);
			if(!fileObj.exists())
			{
				filePath1 = filePath+"\\EzCommerce\\EzCommon\\XMLs\\ezData.xml";
			}

			Element element=null;
			Node node=null;
			Document doc = docBuilder.parse("file:"+filePath1);
			Element root = doc.getDocumentElement();

			NodeList list = root.getElementsByTagName("EzVendor");
			node=list.item(0);
			XMLsupportid = ((Element)node).getElementsByTagName("support").item(0).getFirstChild().getNodeValue();
			if(XMLsupportid == null || "null".equals(XMLsupportid))
				XMLsupportid = "";
			
			
			
		}
	catch(Exception e){}
	*/




%>

<Html>
<Head>
	<Script src="../../Library/JavaScript/ezStatus.js"></Script>
	<Script src="../../Library/JavaScript/ezTrim.js"></Script>
	<Script src="../../Library/JavaScript/Misc/ezLoginBanner.js"></Script>
	<link rel="stylesheet" href="../../Library/Styles/Banner/ezBannerPink.css">
	<script>
	function callFun(clickedOn)
	{
		if(clickedOn=='H')
		{
			top.display.location.href = "../Misc/ezSBUWelcomeWait.jsp";
		}	
		else if(clickedOn=='L')
		{
			top.location.href='../Misc/ezLogout.jsp'
		} 
	}
	function changePurArea1()
	{
		//if(confirm("Do you want to continue with the selected Purchase Area?"))
		//{
			var selcatarea=document.myForm.CatalogArea.value;
			document.myForm.callPreWelcomePage.value="Y";
			document.myForm.target="banner"
			document.myForm.changePurArea.value="Y";
			document.myForm.action = "ezLoginBanner.jsp?CatalogArea="+selcatarea;
			document.myForm.submit();
		/*}
		else
		{
			document.myForm.CatalogArea.options[document.myForm.selPAIndex.value].selected=true;
		}*/

	}
	function changeVendor(mFlag)
	{
		document.myForm.callPreWelcomePage.value="S";
		if(mFlag == 'Y')
		{

			document.myForm.target="banner"
			document.myForm.action="ezLoginBanner.jsp";
			document.myForm.submit();
		}
		else
		{
			/*if(confirm("Do you want to continue with the selected vendor?"))
			{*/
				var vendorDetails 	= document.myForm.Vndr.options[document.myForm.Vndr.options.selectedIndex].value
				var vendorData		= vendorDetails.split("#")	
				document.myForm.VENDOR_CODE.value = vendorData[0]
				document.myForm.VENDOR_NAME.value = vendorData[1]
				document.myForm.target="banner"
				document.myForm.action="ezLoginBanner.jsp";
				document.myForm.submit();
			/*}
			else
			{
				document.myForm.Vndr.options[document.myForm.selVNIndex.value].selected=true;
			}*/
		}
	}
	function vendSrch()
	{
		
		window.open("ezVendSrch.jsp","PopUp","width=500,height=500,top=90,left=200,resizable=no,scrollbars=yes,toolbar=no,menubar=no,minimize=no,status=yes");
		
		//window.showModalDialog('ezVendSrch.jsp','','unadorned:yes;resizable:1;dialogHeight:200px;dialogwidth:450px;scroll:yes;status=no');
		
		
	}
	
	</script>
<Style>	
.tx {
	border:0;
	background-color:#0C517B;
	text-align:left;
}
a:active {text-decoration: none;color: #00355D;}
a:active {text-decoration: none;color: #00355D;}
a:hover  {color: #00355D;}
a:link   {text-decoration: none;color: #00355D;}
</Style>
</Head>
<Body leftMargin=0 topMargin=0 MARGINWIDTH="0" MARGINHEIGHT="0" onLoad="startBanner()">
<Form name="myForm" method="POST">
<input type=hidden name='changePurArea' value='N'>


<style>
.logo {background-repeat: no-repeat; height:90px; width:400px; background-image:url(../../../../EzCommon/Images/Banner/logo.png); background-size:90px 100px;}
</style>
<TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0 >
<TR>
<!--<TD width=15% valign=top background='../../../../EzCommon/Images/Banner/banner_ext1.jpg'>-->
	<TD valign=top > 
	<TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
	<TR >
		<!--<TD background='../../../../EzCommon/Images/Banner/banner_ext1.jpg'>-->
		<TD class="logo">
			<!--<IMG src="../../../../EzCommon/Images/Banner/completelogo.gif" border=0>-->
			<p style=" position:relative; z-index:50; left: 200px; top: 22px; font-size:2; "><Font  color='#000000' size=2  face="Tahoma"> &nbsp;&nbsp;&nbsp;&nbsp;<i> <b><em>Welcome</i></em> </Font><Font color='#000000' size=2  face="Tahoma"> <i><%=fullName%></i></Font></p>
		</TD>
	</TR>
	</TABLE>
</TD>
<!--<TD valign=top background='../../../../EzCommon/Images/Banner/banner_ext1.jpg'>-->
	<TD valign=top align=right> 
	<Table align=center  width="100%" height=100% border="0" cellspacing="0" cellpadding="3">
	<Tr>
		<Td align=center valign=top >
			&nbsp;<!--<Font color='#00355D' size=2  face="Tahoma"> <b> Welcome <i><%=fullName%></i> to Procurement Portal</b>-->
		</Td>
		<Td valign=top align=right width="50%">
			<Table align=right  width="100%" height=100% border="0" cellspacing="0" cellpadding="5">
				<Tr>
					<Td colspan=2 valign=top align=right>
						<Font color='#FFFFFF' size=2  face="Tahoma">
							<span id='home_mail'>
								<a style="color:#000000;" href="javascript:callFun('H')"><img src="../../../../EzCommon/Images/Banner/home.jpg" border=0>Home</a>
								&nbsp;
								
							</span>
							<a style="color:#000000;"  href='mailto:<%=XMLsupportid%>'><img src="../../../../EzCommon/Images/Banner/support.jpg" border=no title='Contact us thru Mail' style="cursor:hand;">Support</a>
							&nbsp;
							<a style="color:#000000;" href="javascript:callFun('L')"><img src="../../../../EzCommon/Images/Banner/exit.jpg" border=no title='Logout' style="cursor:hand">Logout</a>
							&nbsp;
						</Font>
					</Td>	
				</Tr>
					
	</Table>
		</Td>	
	</Tr>  
	<Tr>
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
			<Td width=45% valign=bottom <%=colAlign%> <%=colSpan%>>
			<Font color='#00355D' size=2 face="Tahoma">
			<b><%//=bannerLabel%>Purchase Area&nbsp;:&nbsp;</b></font>
			<Select name="CatalogArea" onChange="changePurArea1()" style="<%=selWidth%>">
<%		
			for ( int i = 0 ; i < catareaRows; i++ )
			{
				domainType = retUserPurAreas.getFieldValueString(i,"ESKD_SUPP_CUST_FLAG");
				if("C".equals(domainType.trim())) 
					continue;
				purGroupArea	= retUserPurAreas.getFieldValueString(i,"ESKD_SYS_KEY");
				purGroupDesc 	= retUserPurAreas.getFieldValueString (i,"ESKD_SYS_KEY_DESC");
				purGroupCode	= (String)purGroupsHash.get(purGroupArea);
				if(!"".equals(USERDEFPURGRP))
				purGroupCode=USERDEFPURGRP;
				companyCode	= (String)ccHash.get(purGroupArea);
				/*if("3".equals(userType))
					selectLabel  = companyCode;
				else*/	
					//selectLabel  = purGroupCode+" --> "+purGroupDesc;
					
					if(purGroupCode!=null && "ALL".equals(purGroupCode.trim()))
						selectLabel  = purGroupDesc;
					else
						selectLabel  = purGroupDesc;

				
				
				
				
				if(purGroupArea.equals(purchaseArea))
				{
					selected = "selected";
					selPAIndex = i;
					session.putValue("DRL_PURGROUP_DESC",purGroupDesc);
				}	
				else
					selected = "";
%>
				<option <%=selected%> value="<%=purGroupArea%>"><%=selectLabel%></option>
<%			
			}
%>
			</select>
<%
			if(!"3".equals(userType))
			{
			if(userPurGroups!=null && !"null".equals(userPurGroups) && !"".equals(userPurGroups))
			{
				String userPurGroupsArr[] = userPurGroups.split(",");
%>
				<!--<Br>
				<b>Purchase Group&nbsp;:&nbsp;</b></font>
				<Select name="sdafas" onChange="dsafads()" style="<%=selWidth%>">
				<%
					for(int p=0;p<userPurGroupsArr.length;p++)
					{
				%>
						<Option value='<%=userPurGroupsArr[p]%>'><%=purGrpsHT.get(userPurGroupsArr[p])+"["+userPurGroupsArr[p]+"]"%></Option>
				<%
					}
				%>
				</Select>-->
<%
			}
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
						<Td width=40% valign=bottom align=left>
						<Font color='#00355D' size=2 face="Tahoma"><b>Vendor&nbsp;:&nbsp;</b></font>
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
								<option <%=selected%> value="<%=retVendorCode+"#"+retVendorName%>"><%=vendorCodeString+"->"+retVendorName%></option>
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
%>
	</Tr>
	<!--<TR><TD colspan=2 valign=bottom align=left><Font color='#00355D' size=2  face="Tahoma"> <b> Welcome </Font><Font color='#F99C1C' size=2  face="Tahoma"> <i><%=fullName%></i></Font></TD></TR>-->
	
	
	</Table>
</TD>
<TR>
</Table>
<input type="hidden" name="callPreWelcomePage">
</Form>
<Script>
<%
	if("Y".equals(showDisplayFrame))
	{
%>
		top.display.document.location.href="ezSBUWelcomeWait.jsp"
<%
	}
%>
</Script>
</BODY>
</HTML>