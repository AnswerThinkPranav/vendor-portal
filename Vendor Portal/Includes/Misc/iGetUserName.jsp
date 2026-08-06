<%!
	private String getUserName(ezc.session.EzSession Session,String participant,String participantType,String syskey)
	{
		ezc.ezworkflow.client.EzWorkFlowManager EzWorkFlow = new ezc.ezworkflow.client.EzWorkFlowManager();
		String userName = "";
		if("O".equals(participantType))
		{
			try{
				ezc.client.EzUserAdminManager UserManager = new ezc.client.EzUserAdminManager();
				ezc.ezparam.EzcUserParams uparams1= new ezc.ezparam.EzcUserParams();
				ezc.ezparam.EzcUserNKParams ezcUserNKParams1 = new ezc.ezparam.EzcUserNKParams();
				uparams1.setUserId(participant);
				boolean result_flag1 = uparams1.setObject(ezcUserNKParams1);
				Session.prepareParams(uparams1);
				ezc.ezparam.ReturnObjFromRetrieve wgRet = (ezc.ezparam.ReturnObjFromRetrieve)UserManager.getUserData(uparams1);	
				String lname="";
				lname = wgRet.getFieldValueString(0,"EU_LAST_NAME");
				if(lname.length()>0){
					lname=lname.substring(0,1);
					lname=lname.toUpperCase();
				}	
				userName = wgRet.getFieldValueString(0,"EU_FIRST_NAME")+" "+lname;
			}catch(Exception ex){}	
		}
		if("U".equals(participantType))
		{
			try{
				ezc.client.EzUserAdminManager UserManager = new ezc.client.EzUserAdminManager();
				ezc.ezparam.EzcUserParams uparams1= new ezc.ezparam.EzcUserParams();
				ezc.ezparam.EzcUserNKParams ezcUserNKParams1 = new ezc.ezparam.EzcUserNKParams();
				uparams1.setUserId(participant);
				boolean result_flag1 = uparams1.setObject(ezcUserNKParams1);
				Session.prepareParams(uparams1);
				ezc.ezparam.ReturnObjFromRetrieve wgRet = (ezc.ezparam.ReturnObjFromRetrieve)UserManager.getUserData(uparams1);		
				userName = wgRet.getFieldValueString(0,"EU_FIRST_NAME")+" "+wgRet.getFieldValueString(0,"EU_MIDDLE_INITIAL")+" "+wgRet.getFieldValueString(0,"EU_LAST_NAME");
			}catch(Exception ex){}	
		}
		if("G".equals(participantType) || participantType.endsWith("¥ID") || participantType.endsWith("¥NOSYS"))
		{
			ezc.ezworkflow.params.EziWorkGroupUsersParams wgParams = new ezc.ezworkflow.params.EziWorkGroupUsersParams();
			wgParams.setGroupId("'"+participant+"'");
			ezc.ezparam.EzcParams wgMainParams = new ezc.ezparam.EzcParams(false);
			wgMainParams.setObject(wgParams);
			Session.prepareParams(wgMainParams);
			ezc.ezparam.ReturnObjFromRetrieve wgRet =(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlow.getWorkGroupUsers(wgMainParams);
			
			if(!participantType.endsWith("¥NOSYS"))
			{
				if(syskey.equals(wgRet.getFieldValueString(0,"SYSKEY")))
				{
					if(participantType.endsWith("¥ID"))
						userName = wgRet.getFieldValueString(0,"USERID");
					else
						userName = "<BR>"+wgRet.getFieldValueString(0,"FIRSTNAME")+" "+wgRet.getFieldValueString(0,"MIDDLENAME")+" "+wgRet.getFieldValueString(0,"LAST_NAME");
				}	
				for(int j=1;j<wgRet.getRowCount();j++)
				{
					if(syskey.equals(wgRet.getFieldValueString(j,"SYSKEY")))
					{
						if(participantType.endsWith("¥ID"))
							userName = wgRet.getFieldValueString(j,"USERID");
						else
							userName += ",<BR>" + wgRet.getFieldValueString(j,"FIRSTNAME")+" "+wgRet.getFieldValueString(j,"MIDDLENAME")+" "+wgRet.getFieldValueString(j,"LAST_NAME");
					}	
				}
			}
			else
			{
				userName = wgRet.getFieldValueString(0,"USERID");
			}
			if(userName.startsWith(","))
			userName = userName.substring(1,userName.length());
		}	
		if("R".equals(participantType) || participantType.endsWith("¥ID"))
		{
			ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
			ezc.ezworkflow.params.EziWorkGroupsParams params= new ezc.ezworkflow.params.EziWorkGroupsParams();
			params.setRoleNo(participant);
			mainParams.setObject(params);
			Session.prepareParams(mainParams);
			ezc.ezparam.ReturnObjFromRetrieve listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlow.getWorkGroupsList(mainParams);
			if(listRet != null)
			{
				for(int i=0;i<listRet.getRowCount();i++)
				{
					String groupId = "'"+listRet.getFieldValueString(i,"GROUP_ID")+"'";
					ezc.ezworkflow.params.EziWorkGroupUsersParams wgParams = new ezc.ezworkflow.params.EziWorkGroupUsersParams();
					wgParams.setGroupId(groupId);
					ezc.ezparam.EzcParams wgMainParams = new ezc.ezparam.EzcParams(false);
					wgMainParams.setObject(wgParams);
					Session.prepareParams(wgMainParams);
					ezc.ezparam.ReturnObjFromRetrieve wgRet =(ezc.ezparam.ReturnObjFromRetrieve)EzWorkFlow.getWorkGroupUsers(wgMainParams);
					if(syskey.equals(wgRet.getFieldValueString(0,"SYSKEY")))
					{
						if(participantType.endsWith("¥ID"))
							userName = wgRet.getFieldValueString(0,"USERID");
						else					
							userName = wgRet.getFieldValueString(0,"FIRSTNAME")+" "+wgRet.getFieldValueString(0,"MIDDLENAME")+" "+wgRet.getFieldValueString(0,"LAST_NAME");
					}	
					for(int j=1;j<wgRet.getRowCount();j++)
					{
						if(syskey.equals(wgRet.getFieldValueString(j,"SYSKEY")))
						{
							if(participantType.endsWith("¥ID"))
								userName = wgRet.getFieldValueString(j,"USERID");
							else
								userName += ",<BR>" + wgRet.getFieldValueString(j,"FIRSTNAME")+" "+wgRet.getFieldValueString(j,"MIDDLENAME")+" "+wgRet.getFieldValueString(j,"LAST_NAME");
						}	
					}
					if(userName.startsWith(","))
						userName = userName.substring(1,userName.length());					
				}	
			}
		}	
		return userName;
	}	
%>	