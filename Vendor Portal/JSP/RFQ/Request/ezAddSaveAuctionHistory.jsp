<%@page isThreadSafe="false"%>

<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<jsp:useBean id="AuctionManager" class="ezc.ezreverseauction.client.EzReverseAuctionManager" scope="session"></jsp:useBean>
<%@page import="java.util.*"%>
<%@page import="ezc.ezreverseauction.params.*"%>
<%@page import="ezc.ezparam.*"%>
<%

   String auctionId = request.getParameter("auctionId");
   String auctionName = request.getParameter("auctionName");

   EzcParams mainParams = new EzcParams(false);
   mainParams.setLocalStore("Y");

   EziAuctionParams iParams = new EziAuctionParams();
   iParams.setAuctionId(auctionId);

   mainParams.setObject(iParams);
   Session.prepareParams(mainParams);
   ReturnObjFromRetrieve ret = (ReturnObjFromRetrieve)AuctionManager.getAuctionHeaderDetails(mainParams);

   if(!ret.getFieldValueString(0,"AUCTION_STATUS").equals("C"))
   {


	String[] items=request.getParameterValues("items");
	String[] bidValue=request.getParameterValues("bidValue");
	String supplierId = request.getParameter("supplierId");

	String[] auctionCounter = request.getParameterValues("auctionCounter");

	ezc.ezutil.ezSaveReverseAuction bidSave = new ezc.ezutil.ezSaveReverseAuction();
	boolean flag = bidSave.ezSaveQuotation(Session,application,items,bidValue,supplierId,auctionId,auctionCounter[0]);

	if (flag)
	{
			String endDate = request.getParameter("endDate");
			String timeLag = request.getParameter("timeLag");
			String extensions = request.getParameter("extensions");

			String noExts="";
			if(application.getAttribute(auctionId)!=null)
			{
		   		noExts = (String)application.getAttribute(auctionId);
			}
			else
			{
		   		noExts="0";
			}
			int exts = Integer.parseInt(extensions);
			int noOfExtensions = Integer.parseInt(noExts);
			int extensionTime = Integer.parseInt(request.getParameter("extensionTime"));
			boolean update = false;

			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>Extensions  "+exts+" >>>>>>>>>>>>>>>>> No Of Extensions "+noOfExtensions);
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>ExtensionTime  "+extensionTime);

			System.out.println(Integer.parseInt(endDate.substring(0,4)));
			System.out.println(Integer.parseInt(endDate.substring(5,7))-1);
			System.out.println(Integer.parseInt(endDate.substring(8,10)));
			System.out.println(Integer.parseInt(endDate.substring(11,13)));
			System.out.println(Integer.parseInt(endDate.substring(14,16)));
			System.out.println(Integer.parseInt(endDate.substring(17,19)));

			GregorianCalendar gc = new GregorianCalendar(Integer.parseInt(endDate.substring(0,4)),Integer.parseInt(endDate.substring(5,7))-1,Integer.parseInt(endDate.substring(8,10)),Integer.parseInt(endDate.substring(11,13)),Integer.parseInt(endDate.substring(14,16)),Integer.parseInt(endDate.substring(17,19)));
			Date d = gc.getTime();

			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>Gregorian Calendar  "+gc);

			if(noOfExtensions < exts)
			{
		     		update=true;
			}
			else if(noOfExtensions >= exts)
			{
				int extensionMinutes = noOfExtensions*extensionTime;
		    		Date curDate = new Date();
		    		GregorianCalendar gig=new GregorianCalendar();
		    		gig.setTime(curDate);
		    		gig.set(Calendar.MINUTE, curDate.getMinutes()+extensionMinutes);
       		    		curDate = gig.getTime();

	       		    	System.out.println(">>>>>>>>>>>>>>>curDate>>>>>>>>>>>>>>>>"+curDate);
       		    		if(!curDate.after(d))
       		    		{
       		    			update = true;
       		    		}
		    	}

			if(update)
			{
				Date d1 = new Date();
				long milliSeconds = d.getTime() - d1.getTime();
				long timeLagMilliSeconds = Integer.parseInt(timeLag)*60*1000;

				if(milliSeconds < timeLagMilliSeconds)
				{
				    	if(application.getAttribute(auctionId)==null)
				    	{
			               		application.setAttribute(auctionId,"1");
		            		}
		           		else
		            		{
		              			String noOfExt = (String)application.getAttribute(auctionId);
		              			int no = Integer.parseInt(noOfExt)+1;
		              			application.setAttribute(auctionId,""+no);
		            		}
				}
			}

			response.sendRedirect("ezViewAuction.jsp?auctionId="+auctionId+"&status=O&auctionName="+auctionName+"&supplierId="+supplierId+"&evalFactor="+request.getParameter("evalFactor"));

		}
		else
		{
		%>
			<html>
			<head>
			<%@ include file="../../../Includes/Lib/AddButtonDir.jsp" %>
			</script>
			</head>
			<body>
			<br>
			<br>
			<br>
			<table width="60%" align="center" border=0>
  			<tr align="center">
    			<th>The last bid has been Updated by another Supplier. Please enter your bid again.</th>
  			</tr>
			</table>
			<br><br>
			<center><a href="ezViewAuction.jsp?auctionId=<%=auctionId%>&status=O&auctionName=<%=auctionName%>&supplierId=<%=supplierId%>&evalFactor=<%=request.getParameter("evalFactor")%>"><img src="../../Images/Buttons/<%=ButtonDir%>/ok.gif" style="cursor:hand" border=none></center>
			</body>
			</html>
		<%
		}
	}
  	else
  	{
    		response.sendRedirect("../Misc/ezMessage.jsp?Msg=Auction closed due to unexpected reasons.Please contact Administrator for Further details");
  	}
%>
<Div id="MenuSol"></Div>