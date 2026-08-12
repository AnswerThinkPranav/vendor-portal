<%@ page import="java.util.*,ezc.ezbasicutil.*" %>
<%!

	public boolean closeAuction(ezc.session.EzSession Session,String auctionId)
	{
		ezc.ezparam.ReturnObjFromRetrieve retAuctionDet= ezMiscSelect(Session,"SELECT A.*,EAH_END_DATE >= NOW() AS IS_LIVE FROM EZC_AUCTION_HEADER A WHERE EAH_AUCTION_ID='"+auctionId+"'");
		if("C".equals(retAuctionDet.getFieldValueString(0,"EAH_AUCTION_STATUS")))
		{
			return true;
		}
		else if("0".equals(retAuctionDet.getFieldValueString(0,"IS_LIVE")))
		{
			java.util.ArrayList<String> queryList=new java.util.ArrayList<String>();
			queryList.add("UPDATE  EZC_AUCTION_HEADER SET EAH_AUCTION_STATUS='C' WHERE EAH_AUCTION_ID='"+auctionId+"'");
			ezMiscInsert(Session,queryList);
			return true;
		}
		else
		{
			return false;
		}
		
	}
	public void autoExtendAuction(ezc.session.EzSession Session,String auctionId)
	{
		ezc.ezparam.ReturnObjFromRetrieve retAuctionDet= ezMiscSelect(Session,"SELECT A.* FROM EZC_AUCTION_HEADER A WHERE EAH_AUCTION_ID='"+auctionId+"'");
		String tempStatus = retAuctionDet.getFieldValueString(0,"EAH_AUCTION_STATUS");
		int extTime = 0;
		int noOfExt = 0;
		int extCheck = 0;
		
		extTime 	= Integer.parseInt(retAuctionDet.getFieldValueString(0,"EAH_EXTENSION_TIME"));
			noOfExt 	= Integer.parseInt(retAuctionDet.getFieldValueString(0,"EAH_EXTENSIONS"));
		//noOfExt=1;
		if(retAuctionDet.getFieldValueString(0,"EAH_EXT1") != null && !"null".equals(retAuctionDet.getFieldValueString(0,"EAH_EXTENSIONS")) && !"".equals(retAuctionDet.getFieldValueString(0,"EAH_EXTENSIONS")))
			extCheck = Integer.parseInt(retAuctionDet.getFieldValueString(0,"EAH_EXT1"));
		ezc.ezcommon.EzLog4j.log("auctionId::::"+auctionId,"I");
		ezc.ezcommon.EzLog4j.log("extTime::::"+extTime,"I");
		ezc.ezcommon.EzLog4j.log("noOfExt::::"+noOfExt,"I");
		ezc.ezcommon.EzLog4j.log("extCheck::::"+extCheck,"I");
		
		if(!"C".equals(retAuctionDet.getFieldValueString(0,"EAH_AUCTION_STATUS")) && extTime > 0 && noOfExt > 0 && extCheck > 0)
		{
			//ezc.ezparam.ReturnObjFromRetrieve retLastBidDetails = ezMiscSelect(Session,"SELECT TIMESTAMPDIFF(MINUTE,MAX(EAH_TIME_STAMP),NOW()) AS LAST_BID FROM EZC_AUCTION_HISTORY  WHERE EAH_AUCTION_ID='"+auctionId+"'");
			ezc.ezparam.ReturnObjFromRetrieve retLastBidDetails = ezMiscSelect(Session,"SELECT TIMESTAMPDIFF(MINUTE,MAX(EAH_TIME_STAMP),(select b.eah_end_date from ezc_auction_header b where b.eah_auction_id='"+auctionId+"')) AS LAST_BID FROM EZC_AUCTION_HISTORY  WHERE EAH_AUCTION_ID='"+auctionId+"'");
			Long lastBidDiffTime = Long.parseLong(retLastBidDetails.getFieldValueString(0,"LAST_BID"));
			ezc.ezcommon.EzLog4j.log("lastBidDiffTime::::"+lastBidDiffTime,"I");
			ezc.ezcommon.EzLog4j.log("LAST_BID::::"+retLastBidDetails.getFieldValueString(0,"LAST_BID"),"I");
			if(lastBidDiffTime <= extCheck)
			{
				java.util.ArrayList<String> queryList=new java.util.ArrayList<String>();
				//queryList.add("UPDATE  EZC_AUCTION_HEADER SET EAH_END_DATE=DATE_ADD(EAH_END_DATE,INTERVAL "+extTime+" MINUTE) WHERE EAH_AUCTION_ID='"+auctionId+"'");
				queryList.add("UPDATE  EZC_AUCTION_HEADER SET EAH_END_DATE=DATE_ADD(EAH_END_DATE,INTERVAL "+extTime+" MINUTE),EAH_EXTENSIONS=EAH_EXTENSIONS-1 WHERE EAH_AUCTION_ID='"+auctionId+"'");
				ezMiscInsert(Session,queryList);
				//addAuctionAuditTrail(Session,auctionId,"EXTEND","Auction extended for - "+extTime+"[MIN]");
			}
		}
	
	}
	
	public boolean isAuctionLive(ezc.session.EzSession Session,String auctionId)
	{
		ezc.ezparam.ReturnObjFromRetrieve retTemp= ezMiscSelect(Session,"SELECT EAH_AUCTION_ID FROM EZC_AUCTION_HEADER WHERE EAH_AUCTION_ID='"+auctionId+"' AND EAH_AUCTION_STATUS <> 'C' AND EAH_END_DATE >= NOW()");
		if(retTemp == null || retTemp.getRowCount() <= 0)
			return false;
		else
			return true;
	}
	
	public void addAuctionAuditTrail(ezc.session.EzSession Session,String auctionId,String type,String comments)
	{
		java.util.ArrayList<String> queryList=new java.util.ArrayList<String>();
		queryList.add("INSERT INTO EZC_AUCTION_AUDIT_TRAIL(EAAT_DOC_ID,EAAT_TYPE,EAAT_USER_ID,EAAT_COMMENTS,EAAT_DATE) VALUES('"+auctionId+"','"+type+"','"+Session.getUserId()+"','"+comments+"',NOW())");
		ezMiscInsert(Session,queryList);
				
	}
	public void addAuctionEntry(ezc.session.EzSession Session,String auctionId)
	{
		ezc.ezparam.ReturnObjFromRetrieve retTemp= ezMiscSelect(Session,"SELECT * FROM EZC_AUCTION_AUDIT_TRAIL WHERE EAAT_DOC_ID='"+auctionId+"' AND EAAT_USER_ID='"+Session.getUserId()+"' AND EAAT_TYPE='ENTRY'");
		if(retTemp == null || retTemp.getRowCount() == 0)
		{
			addAuctionAuditTrail(Session,auctionId,"ENTRY","Entered the auction");
		}
					
	}
	/*
	public void schdAuctReminder(String auctionId,String site)
	{
		try
		{
			StdSchedulerFactory stdschedulerfactory  = new StdSchedulerFactory();
			Scheduler scheduler = stdschedulerfactory.getScheduler();
			ezc.ezparam.ReturnObjFromRetrieve retAuctDet= ezMiscSelect(Session,"SELECT EAH_END_DATE,TIMESTAMPDIFF(HOUR,NOW(),EAH_END_DATE) AS HOURDIFF,TIMESTAMPDIFF(MINUTE,NOW(),EAH_END_DATE) AS MINDIFF FROM EZC_AUCTION_HEADER WHERE EAH_AUCTION_ID='"+auctionId+"'");
			if(retTemp == null || retTemp.getRowCount() == 0)
			{
				int hoursDiff=Integer.parseInt(retAuctDet.getFieldValueString(0,"HOURDIFF"));
				int minsDiff=Integer.parseInt(retAuctDet.getFieldValueString(0,"MINDIFF"));
				Date endDate=(Date)retAuctDet.getFieldValue(0,"EAH_END_DATE");
				if(hoursDiff > 24)
				{
					JobDetail jobDetail = new JobDetail("AUCTREM_"+auctionId+"_24H_"+site, "DEFAULT", ezc.scheduler.job.EzAuctionReminderJob.class);
					SimpleTrigger simpleTrigger = new SimpleTrigger("AUCTREM_"+auctionId+"_24H_"+site,"DEFAULT",new java.util.Date(),null,SimpleTrigger.REPEAT_INDEFINITELY,5*60L*1000L);
					scheduler.scheduleJob(jobDetail, simpleTrigger);
				}
				if(minsDiff > 30)
				{
					JobDetail jobDetail = new JobDetail("AUCTREM_"+auctionId+"_30M_"+site, "DEFAULT", ezc.scheduler.job.EzAuctionReminderJob.class);
					SimpleTrigger simpleTrigger = new SimpleTrigger("AUCTREM_"+auctionId+"_30M_"+site,"DEFAULT",new java.util.Date(),null,SimpleTrigger.REPEAT_INDEFINITELY,5*60L*1000L);
					scheduler.scheduleJob(jobDetail, simpleTrigger);
				}
			}
		}catch(Exception e){}
		
	}*/

%>