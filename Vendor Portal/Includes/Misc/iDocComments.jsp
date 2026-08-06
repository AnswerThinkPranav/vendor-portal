
<%!
		public void saveDocComments(ezc.session.EzSession Session,String docId,String docType,String comments)
		{
			ezc.ezparam.EzcParams commMainParams = new ezc.ezparam.EzcParams(false);
			
			ezc.vendorprofile.client.EzVendorProfileManager commManager = new ezc.vendorprofile.client.EzVendorProfileManager();
			ezc.vendorprofile.params.EziDocumentCommentsParams documentComments =  new ezc.vendorprofile.params.EziDocumentCommentsParams();
			ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();					
			
			keyParams.setKey("ADD_DOCUMENT_COMMENTS");
			documentComments.setDocId(docId);
			documentComments.setDocType(docType);
			documentComments.setComments(comments);
			documentComments.setUserId(Session.getUserId());
			documentComments.setExt1("");
			documentComments.setExt2("");
			documentComments.setExt3("");
			commMainParams.setLocalStore("Y");
			commMainParams.setObject(keyParams);
			commMainParams.setObject(documentComments);
			Session.prepareParams(commMainParams);
			commManager.ezSaveDetails(commMainParams);
		}
		public void saveDocComments(ezc.session.EzSession Session,String docId,String docType,String comments,String ext1)
		{
			ezc.ezparam.EzcParams commMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendorprofile.client.EzVendorProfileManager commManager = new ezc.vendorprofile.client.EzVendorProfileManager();
			ezc.vendorprofile.params.EziDocumentCommentsParams documentComments =  new ezc.vendorprofile.params.EziDocumentCommentsParams();
			ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();					
			keyParams.setKey("ADD_DOCUMENT_COMMENTS");
			documentComments.setDocId(docId);
			documentComments.setDocType(docType);
			documentComments.setComments(comments);
			documentComments.setUserId(Session.getUserId());
			documentComments.setExt1(ext1);
			documentComments.setExt2("");
			documentComments.setExt3("");
			commMainParams.setLocalStore("Y");
			commMainParams.setObject(keyParams);
			commMainParams.setObject(documentComments);
			Session.prepareParams(commMainParams);
			commManager.ezSaveDetails(commMainParams);
		}
		public void saveDocComments(ezc.session.EzSession Session,String docId,String docType,String comments,String ext1,String ext2)
		{
			ezc.ezparam.EzcParams commMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendorprofile.client.EzVendorProfileManager commManager = new ezc.vendorprofile.client.EzVendorProfileManager();
			ezc.vendorprofile.params.EziDocumentCommentsParams documentComments =  new ezc.vendorprofile.params.EziDocumentCommentsParams();
			ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();					
			keyParams.setKey("ADD_DOCUMENT_COMMENTS");
			documentComments.setDocId(docId);
			documentComments.setDocType(docType);
			documentComments.setComments(comments);
			documentComments.setUserId(Session.getUserId());
			documentComments.setExt1(ext1);
			documentComments.setExt2(ext2);
			documentComments.setExt3("");
			commMainParams.setLocalStore("Y");
			commMainParams.setObject(keyParams);
			commMainParams.setObject(documentComments);
			Session.prepareParams(commMainParams);
			commManager.ezSaveDetails(commMainParams);
		}
		public ezc.ezparam.ReturnObjFromRetrieve getDocComments(ezc.session.EzSession Session,String docId,String docType)
		{
			ezc.ezparam.EzcParams commMainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendorprofile.client.EzVendorProfileManager commManager = new ezc.vendorprofile.client.EzVendorProfileManager();
			ezc.vendorprofile.params.EziDocumentCommentsParams documentComments =  new ezc.vendorprofile.params.EziDocumentCommentsParams();
			ezc.vendorprofile.params.EziVendorProfileKeyParams keyParams = new ezc.vendorprofile.params.EziVendorProfileKeyParams();					
			keyParams.setKey("GET_DOC_COMMENTS");
			documentComments.setDocId(docId);
			documentComments.setDocType(docType);
			commMainParams.setLocalStore("Y");
			commMainParams.setObject(keyParams);
			commMainParams.setObject(documentComments);
			Session.prepareParams(commMainParams);
			ezc.ezparam.ReturnObjFromRetrieve outComRet=null;
			try
			{
				//outComRet = (ezc.ezparam.ReturnObjFromRetrieve)commManager.ezGetVendorProfile(commMainParams);
			}catch(Exception e)
			{
			}
			return outComRet;
		}
		public ezc.ezparam.ReturnObjFromRetrieve getJGLDocComments(ezc.session.EzSession Session,String docId,String docType)
		{
			ezc.vendortransactions.client.EzVendorTransactionsManager ezVendTransactions = new ezc.vendortransactions.client.EzVendorTransactionsManager();
			ezc.ezparam.EzcParams v_MainParams = new ezc.ezparam.EzcParams(false);
			ezc.vendortransactions.params.EzVendorTransactionsKeyParams v_KeyParams = new ezc.vendortransactions.params.EzVendorTransactionsKeyParams();
			ezc.vendortransactions.params.EzVendorParams  vendParams= new ezc.vendortransactions.params.EzVendorParams();

			v_KeyParams.setKey("GET_DOC_COMMENTS");
			vendParams.setType(docType);
			vendParams.setDocNo(docId);

			v_MainParams.setLocalStore("Y");
			v_MainParams.setObject(v_KeyParams);
			v_MainParams.setObject(vendParams);
			Session.prepareParams(v_MainParams);
			ezc.ezparam.ReturnObjFromRetrieve outComRet=null;
			try
			{
				outComRet = (ezc.ezparam.ReturnObjFromRetrieve)ezVendTransactions.ezGetVendorTransactions(v_MainParams);
			}catch(Exception e)
			{
			}
			return outComRet;
		}		

%>		