<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ page import="ezc.ezutil.*,java.util.*,java.text.*,java.io.*,com.lowagie.text.*" %>
<%@ page import="com.lowagie.text.pdf.PdfPTable,com.lowagie.text.pdf.PdfPCell,com.lowagie.text.pdf.PdfWriter,com.lowagie.text.Document,com.lowagie.text.Paragraph,com.lowagie.text.Image" %>
<%@include file="../../../Includes/Lib/AddButtonDir.jsp" %>
<%@include file="../../../Includes/JSPs/Request/iAuctionHistoryByAuctionId.jsp" %>
<%
	String filepath = request.getRealPath("ezAuctionHistoryByAuctionId.jsp");
	filepath = filepath.substring(0,filepath.indexOf("ezAuctionHistoryByAuctionId.jsp"));
	
	String path = filepath+"\\EzCommerce\\EzVendor\\Vendor2\\JSPs\\Request\\AuctionReportPDFs\\"+auctionId+".pdf";
	
	
	//out.println("path:::::::::"+path);
	PdfPCell cell = null;
	PdfPTable table = null;
%>

<html>
<head>
<script>
	var tabHeadWidth=95
	var tabHeight="30%"
	
</script>
<Script>
function showItems(obj)
{

	openImg = new Image();
	openImg.src = "../../Images/Others/tree-select.gif";

	closeImg = new Image();
	closeImg.src = "../../Images/Others/tree-closed.gif";

	var spanObj = document.getElementById("span"+obj)
	imgobj	=document.getElementById("IMG"+obj);
	if(spanObj.style.visibility=="hidden")
	{
		spanObj.style.visibility="visible"
		spanObj.style.display=""
		imgobj.src = openImg.src;
	}
	else
	{
		spanObj.style.visibility="hidden"
		spanObj.style.display="none"
		imgobj.src = closeImg.src;
	}
}
function funShow(opt)
{
	//if(opt == 1)
	//{
		//document.getElementById("div1").style.visibility="visible"
		//document.getElementById("div2").style.visibility="hidden"
		//document.getElementById("buttons1").style.visibility="visible"
		//document.getElementById("buttons2").style.visibility="hidden"
		//document.getElementById("history").style.visibility="visible"
		//document.getElementById("rank").style.visibility="hidden"
	//}
	if(opt == 2)
	{
		//document.getElementById("div1").style.visibility="hidden"
		document.getElementById("div2").style.visibility="visible"
		//document.getElementById("buttons1").style.visibility="hidden"
		//document.getElementById("buttons2").style.visibility="visible"
		//document.getElementById("history").style.visibility="hidden"
		document.getElementById("rank").style.visibility="visible"
	}
}
function ezBackCall()
{
			history.go(-1);
			return false;
}
function ezDownloadPDF()
{
	document.myForm.action="ezDownloadPDF.jsp";
	document.myForm.submit();
}
function mySelect()
{

	if(document.myForm.auctionId.selectedIndex==0)
	{
		alert("Please Select Auction")
		document.myForm.auctionId.focus()
	}
	else
	{	
		var msgDiv	  = document.getElementById("msgDiv");
		var headerDiv	  = document.getElementById("headerDiv");
		var buttonDiv	  = document.getElementById("buttonDiv");
		
		if(headerDiv!=null)
		{
		     headerDiv.style.visibility	= "hidden"
		     buttonDiv.style.visibility	= "hidden"
		     msgDiv.style.visibility	= "visible"
		}
		document.myForm.action	= "ezAuctionHistoryByAuctionId.jsp"
		document.myForm.submit();
	}
}
function displayPrice(supplierId,auctionCounter,currency)
{
	
	var browser=navigator.appName;	

	if(browser=="Microsoft Internet Explorer")
	var retValue = window.showModalDialog("ezViewPrices.jsp?supplierId="+supplierId+"&currency="+currency+"&auctionCounter="+auctionCounter+"&auctionId="+'<%=auctionId%>'+"&target=price",window.self,"center=yes;dialogHeight=25;dialogWidth=40;help=no;resizable=no;titlebar=no;status=no;minimize:yes")	
	else 
	{
	var retValue = window.showModalDialog("ezViewPrices.jsp?supplierId="+supplierId+"&currency="+currency+"&auctionCounter="+auctionCounter+"&auctionId="+'<%=auctionId%>'+"&target=price",window.self,"center=yes;dialogHeight=350;dialogWidth=600;help=no;resizable=no;titlebar=no;status=no;minimize:yes")	
	}

}
function funSelect()
{
	for(var i=0;i<document.myForm.auctionId.length;i++)
	{
		if(document.myForm.auctionId.options[i].value=='<%=auctionId%>')
		{
			document.myForm.auctionId.selectedIndex = i
		}
	   }
}
</script>

<Script src="../../Library/JavaScript/ezTabScroll.js"></Script>
</head>
<body  scroll=no <%=bodyLoadString%>  onResize="scrollInit()">
<%@ include file="../Misc/ezDisplayHeader.jsp" %>
<form name="myForm">
<input type="hidden" name="fileName" value="ezAuctionHistoryByAuctionId.jsp">
<input type="hidden" name="filePath" value="<%=path%>">
<%
if(retCount>0)
{
String auctionDesc="";
%>			
	<Div id='inputDiv' style='position:relative;align:center;top:1%;width:100%;height:15%'>
	<Table width="35%" border="0" cellspacing="0" cellpadding="0" align=center valign=center>
	<Tr>
		<Td height="4" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c1.gif"></Td>
		<Td height="4" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e1.gif"></Td>
		<Td height="4" style="background-color:'F3F3F3'" width="5" background="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"><img height="5" width="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c2.gif"></Td>
	</Tr>
	<Tr >
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"><img width="5" height="1" src="../../../../EzCommon/Images/Table_Corners/Cb_e2.gif"></Td>
		<Td style="background-color:'F3F3F3'" valign=middle>
		<Table border="0" align="center" valign=middle width="100%" cellpadding=1 cellspacing=1 class=welcomecell>
		<Tr>
		<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='50%' align=center>
			Select Auction&nbsp;:&nbsp;
		</Td>
		<Td style='background:#F3F3F3;font-size=11px;color:#00355D;font-weight:bold' width='50%' align=left>
		<select name="auctionId" onChange="mySelect()" id = "listBoxDiv" style="width:70%;border: 1px solid">
			<option value="¥">--Select--</option>
<%
			String auctId = "";
			String selected = "";
			for(int i=0;i<retCount;i++)
			{
				auctId = ret.getFieldValueString(i,"EAH_AUCTION_ID").trim();
				if(auctId.equals(auctionId) || auctId==auctionId)
				{
					selected = "selected";
					auctionDesc=ret.getFieldValueString(i,"EAH_AUCTION_NAME");
				}
				else
					selected = "";
%>
					<option value="<%=auctId%>" <%=selected%>><%=ret.getFieldValueString(i,"EAH_AUCTION_NAME")%></option>
<%					
			}
%>
		</select>
		</Td>
		</TR>
		</Table>
		</Td>
		<Td width="5" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e3.gif"><img width="5" height="1" src="Cb_e3.gif"></Td>
	</Tr>
	<Tr>
		<Td width="5" style="background-color:'F3F3F3'" height="4" background="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c3.gif"></Td>
		<Td height="4" style="background-color:'F3F3F3'" background="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"><img width="1" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_e4.gif"></Td>
		<Td width="5" style="background-color:'F3F3F3'" height="4" background="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"><img width="5" height="5" src="../../../../EzCommon/Images/Table_Corners/Cb_c4.gif"></Td>
	</Tr>
	</Table>
	</Div>	

<%
	
		
	
	if(auctionId!=null && !auctionId.equals("¥"))
	{	
	   	if(retAuctionHistory.getRowCount()>0)
	   	{	
	
			
			Document document = new Document(PageSize.LEGAL.rotate());
			PdfWriter.getInstance(document,
			new FileOutputStream(path));
			document.open();

			Font titleFont = new Font(Font.TIMES_ROMAN, 17, Font.BOLD);
			Anchor anchor = new Anchor(auctionDesc+" ("+auctionId+")", titleFont);
			anchor.setName(auctionDesc+" ("+auctionId+")");

			Chapter chapter = new Chapter(new Paragraph(anchor), 1);
			chapter.setNumberDepth(0);
			document.add(chapter);
			

		String supplierName = "",supplierdata = "",lowSupplier="";
		if(retAuctionHistory.getRowCount()>0 && auctionItems.getRowCount()>0)
		{
			Enumeration suppIds  = bidSummary.keys();
			String suId  ="",timeStamp ="",bidValue = "",sid = "";
			String[] supKey = new String[4];
			String[] matKeys = new String[2];
			int noOfColumns=5+bidSummary.size();	
			
			float[] widths = new float[noOfColumns];
			
			for(int e=0;e<noOfColumns;e++)
			{
				if(e==3)
					widths[e]=10;
				else if(e==1)	
					widths[e]=8;
				else if(e==2)	
					widths[e]=20;
				else
					widths[e]=15;
					
			}
			
			
			
%>	
			<Div id="msgDiv" style="visibility:hidden;overflow:auto;position:absolute;top:50%;width:95%;left:2.5%">
			<Table align=center border="0" cellpadding="0" cellspacing="0" width="100%">
				<Tr>
					<Td align='center'><br><b>Loading data, please wait...</b><br><br></Td>
				</Tr>
			</Table>
			</Div>
			<Div  id="headerDiv" style="overflow:auto;position:relative;width:95%;left:2.5%;height:60%;">
			<Table  width="100%" align=center borderColorDark=#ffffff borderColorLight=#000000 cellPadding=2 cellSpacing=0 border=1>
			
			<tr>
				
				<th width="10%">PR&nbsp;</th>
				<th width="5%">Item&nbsp;</th>
				<th width="25%">Material&nbsp;</th>
				<th width="10%">Qty&nbsp;</th>
<%

				while(suppIds.hasMoreElements())
				{
					suId 		 = (String)suppIds.nextElement();
					supplierdata 	 = (String)bidSummary.get(suId);

					supKey = supplierdata.split("##");
					
					supplierName   =  supKey[0];
					sid            =  supKey[3];					

					if(supplierName==null || "null".equals(supplierName.trim()))
						supplierName = suId;
						
					cell = new PdfPCell();
					cell.setBackgroundColor(java.awt.Color.decode("#9F6FBD"));
					cell.setPhrase(new Phrase(supplierName, FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD,java.awt.Color.WHITE)));	
					table.addCell(cell);	
%>
				<td width="15%" style="background-color:#9F6FBD"><font color='white'><b><%=supplierName%></b></font></td>
<%
				}
					cell = new PdfPCell();
					cell.setBackgroundColor(java.awt.Color.decode("#9F6FBD"));
					cell.setPhrase(new Phrase("Lowest Bid", FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD,java.awt.Color.WHITE)));	
					table.addCell(cell);
					//table.completeRow(); 

%>
				<td width="35%" style="background-color:#9F6FBD"><font color='white'><b>Lowest Bid</b></font></td>
				
			</tr>
<%
				int supCount = 0;
				for(int j=0;j<auctionItems.getRowCount();j++)
				{

					String drlPRNumAu = "",drlPRItemAu="";

					if(auctionItems.getFieldValueString(j,"EAI_EXT1")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT1").trim()))
						drlPRNumAu = auctionItems.getFieldValueString(j,"EAI_EXT1");

					if(auctionItems.getFieldValueString(j,"EAI_EXT2")!=null && !"null".equals(auctionItems.getFieldValueString(j,"EAI_EXT2").trim()))
						drlPRItemAu = auctionItems.getFieldValueString(j,"EAI_EXT2");
									
					String matNum = auctionItems.getFieldValueString(j,"EAI_ITEM_CODE").trim();
					table.addCell(drlPRNumAu);
					cell = new PdfPCell();
					cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					cell.setPhrase(new Phrase(drlPRItemAu, FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL,java.awt.Color.BLACK)));	
					table.addCell(cell);
					table.addCell(matNum);
					cell = new PdfPCell();
					cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
					cell.setPhrase(new Phrase(auctionItems.getFieldValueString(j,"EAI_QUANTITY"), FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL,java.awt.Color.BLACK)));	
					table.addCell(cell);
%>
			<tr>
					<td width="10%" valign=top><b><br>&nbsp;<%=drlPRNumAu%></b></td>
					<td width="5%" valign=top><b><br>&nbsp;<%=drlPRItemAu%></b></td>
					<td width="25%" valign=top><b><br>&nbsp;<%=matNum%></b></td>
					<td width="10%" valign=top><b><br>&nbsp;<%=auctionItems.getFieldValueString(j,"EAI_QUANTITY")%></b></td>
<%
					String lowestBid="",LowestBidPDFVendor="",LowestBidfinalVendor="";
					suppIds  = bidSummary.keys();
					while(suppIds.hasMoreElements())
					{
						String tempVal = "",matStr="",matPrice="",matRank="",matValue="";
						suId 		 = (String)suppIds.nextElement();
						supplierdata 	 = (String)bidSummary.get(suId);
						
						supKey = supplierdata.split("##");
						timeStamp      =  supKey[1];
						bidValue       =  supKey[2];
						sid            =  supKey[3];

						//matStr 	 = (String)finalMatValueTable.get(sid+matNum);	
						matStr 	 = (String)finalMatValueTable.get(sid+matNum+auctionItems.getFieldValueString(j,"EAI_ITEM_ID"));	
							
						String auctionHistoryValue="",pdfValue="";	
						
						if(auctionHistoryTable.get(sid+(j+1))!=null && !"null".equals(auctionHistoryTable.get(sid+(j+1))))
						{
							auctionHistoryValue = (String)auctionHistoryTable.get(sid+(j+1));
							pdfValue = (String)pdfTable.get(sid+(j+1));
							
						}	
							
						

						if(matStr!=null)
						{	
							try
							{
								matKeys = matStr.split("#");
								matValue = new java.math.BigDecimal(matKeys[0])+"";
								matRank  = matKeys[1];
								matPrice = ((new java.math.BigDecimal(matKeys[0])).divide(new java.math.BigDecimal(auctionItems.getFieldValueString(j,"EAI_QUANTITY")),2,java.math.BigDecimal.ROUND_HALF_UP))+"";
								if("1".equals(matRank))
								{
									String LowestBidVendor="";
									lowestBid=matPrice;
									//lowestBid=matValue;
									if(supKey[0]==null || "null".equals(supKey[0]) || "".equals(supKey[0]))

										LowestBidVendor=suId;
									else
										LowestBidVendor=supKey[0];

									if(!"".equals(LowestBidfinalVendor))
									{
										LowestBidfinalVendor=LowestBidfinalVendor+"<BR><BR>"+LowestBidVendor;
										LowestBidPDFVendor=LowestBidPDFVendor+"\n\n"+LowestBidVendor;
									}	
									else
									{
										LowestBidfinalVendor=LowestBidVendor;
										LowestBidPDFVendor=LowestBidVendor;
									}	
										
								}	
								
							}catch(Exception e){}
						}
						
						String auctionHistoryValueArr[] = pdfValue.split("¥");
						PdfPTable table1 = new PdfPTable(1);
						

						if(auctionHistoryValueArr!=null)
						{
							
							for(int cnt=0;cnt<auctionHistoryValueArr.length;cnt++)
							{
								if(cnt>0)
								{
									com.lowagie.text.Image image = null;
									try{
										image = com.lowagie.text.Image.getInstance(filepath+"\\EzCommerce\\EzCommon\\Images\\Body\\test.gif");
									}catch(Exception e){out.println(e);}
									cell = new PdfPCell(image,false);
									cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
									cell.setBorder(Rectangle.NO_BORDER);
									cell.setBackgroundColor(java.awt.Color.decode("#D6C7FC"));
									table1.addCell(cell);
								}
								
								cell = new PdfPCell();
								cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								cell.setBackgroundColor(java.awt.Color.decode("#D6C7FC"));
								cell.setPhrase(new Phrase(auctionHistoryValueArr[cnt], new Font(Font.HELVETICA, 11, Font.BOLD)));	
								cell.setBorder(Rectangle.NO_BORDER);
								table1.addCell(cell);
								
							}
						}
						
						table.addCell(table1);
						
						

%>
						<!--<td width="15%" style="background-color:#F99FFF"><b><%=matPrice%>&nbsp;</b></td>-->
						<td width="15%" align="center" valign=top style="background-color:#D6C7FC"><b><br><%=auctionHistoryValue%><br>&nbsp;</b></td>
<%
					}
					cell = new PdfPCell();
					cell.setBackgroundColor(java.awt.Color.decode("#D6C7FC"));
					cell.setPhrase(new Phrase(lowestBid+"\n"+LowestBidPDFVendor, new Font(Font.HELVETICA, 11, Font.BOLD)));	
					table.addCell(cell);	
%>

					<td width="35%" valign=top style="background-color:#D6C7FC"><b><br><%=lowestBid%><br> <font color="MAROON"><%=LowestBidfinalVendor%></font>&nbsp;</b></td>
			</tr>
					
<%
					//table.completeRow(); 
				}
%>
				
			</Table>
			</Div>
			
	<%	
		document.add(table);
		document.close();
		
		}	
%>
		<div id="buttonDiv" align=center style="position:absolute;width:92%;top:90%;left:7.5%">
	
<%
			buttonName = new ArrayList();
			buttonMethod = new ArrayList();
			
			buttonName.add("Back");
			buttonMethod.add("ezBackCall()");
	
			buttonName.add("Download PDF");
			buttonMethod.add("ezDownloadPDF()");
		
			out.println(getButtonStr(buttonName,buttonMethod));
%>
		</div>
<%	
		}
		else
		{
		
			noDataStatement="No Biddings available for this Auction";
%>
			<%@ include file="../Misc/ezDisplayNoData.jsp" %>
			<div id="buttonDiv" align=center style="position:absolute;width:92%;top:90%;left:5%">
<%
			buttonName = new ArrayList();
			buttonMethod = new ArrayList();

			buttonName.add("Back");
			buttonMethod.add("ezBackCall()");
			
			out.println(getButtonStr(buttonName,buttonMethod));
%>
			</div>
<%	
		}
		
	}

}
else
{

		
	noDataStatement="There are no auctions to list to view History";
		
%>
	<%@ include file="../Misc/ezDisplayNoData.jsp" %>
	<div id="buttonDiv" align=center style="position:absolute;width:92%;top:90%;left:5%">
	
<%
	buttonName = new ArrayList();
	buttonMethod = new ArrayList();

	buttonName.add("Back");
	buttonMethod.add("ezBackCall()");
	
	out.println(getButtonStr(buttonName,buttonMethod));
%>
	</div>
<%
}
%>
<Div id="MenuSol"></Div>
</form>
</body>
</html>

