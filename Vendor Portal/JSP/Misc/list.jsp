<%@ page import="ezc.ezparam.*,ezc.ezmisc.params.*" %>
<jsp:useBean id="ezMiscManager" class="ezc.ezmisc.client.EzMiscManager" scope="session"/>
<!--<%@ include file="../../../Includes/Lib/ezSessionBean.jsp"%>-->

 <%  
 	String strMat = (String)request.getParameter("q");		 	
 	strMat = strMat.trim(); 
 	strMat = strMat.replaceAll("\\,","%");
 	strMat = strMat.replaceAll("\\.","%");
 	strMat = strMat.replaceAll("\\-","%");
 	strMat = strMat.replaceAll("\\/","%");
 	
 	if(strMat!=null && !"null".equals(strMat) && !"".equals(strMat))
	{
		try{
			strMat = Long.parseLong(strMat)+"";
		}catch(Exception e){strMat = strMat;}
	}
 	  	 	
 	EzcParams matSearchParamsMisc = new EzcParams(false);
	EziMiscParams matSearchParams = new EziMiscParams();
	ReturnObjFromRetrieve matSearchRetObj = null; 
	matSearchParams.setIdenKey("MISC_SELECT");
	String query="";

		query="select * from ezc_recon_account_group_mapping where ERAGM_ACCOUNT_GROUP like'%"+strMat+"%' or ERAGM_RECON_ACCOUNT like '%"+strMat+"%'";
		
	matSearchParams.setQuery(query);
	matSearchParamsMisc.setLocalStore("Y");
	matSearchParamsMisc.setObject(matSearchParams);
	Session.prepareParams(matSearchParamsMisc);
	
	try{ 
		matSearchRetObj = (ReturnObjFromRetrieve)ezMiscManager.ezSelect(matSearchParamsMisc);
	} 
	catch(Exception e)
	{ 
		e.printStackTrace(); 
	}	     
		 								
	if(matSearchRetObj!=null)
	{
		if(matSearchRetObj.getRowCount()>0)
		{
			for(int i=0;i<matSearchRetObj.getRowCount();i++)
			{				
				String prodCode = matSearchRetObj.getFieldValueString(i,"ERAGM_ACCOUNT_GROUP");
				String prodDesc = nullCheck(matSearchRetObj.getFieldValueString(i,"ERAGM_RECON_ACCOUNT")); 									
					
				try{
					prodCode = Long.parseLong(prodCode)+"";
				}catch(Exception e){
					prodCode = prodCode;
				}

				out.println(prodCode+", "+prodDesc+"""\n");
			}
		}
		else
		{
			out.println("Entered item is not found, invalid or impermissible");
		}
	}
%>