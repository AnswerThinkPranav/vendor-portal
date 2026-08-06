<%@ page import="java.util.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import="ezc.ezupload.params.*" %>
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%

	ezc.ezparam.EzcParams uploadMainParams = new ezc.ezparam.EzcParams(false);
	ezc.ezupload.params.EziUploadDocsParams params= new ezc.ezupload.params.EziUploadDocsParams();
	ezc.ezparam.ReturnObjFromRetrieve listRet=null;	

	int docsListCnt = 0;
	String fstring="";
	String sfstr="";
	String uploadedBy="";
	
	params.setObjectNo(docsKeyStr);
	uploadMainParams.setObject(params);
	Session.prepareParams(uploadMainParams);
	listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzUploadManager.getUploadedDocs(uploadMainParams);
	
	if(listRet!=null)
		docsListCnt = listRet.getRowCount();
	
	if(docsListCnt>0)
	{
		for(int c=0;c<docsListCnt;c++)
		{
			ReturnObjFromRetrieve shfileret=(ReturnObjFromRetrieve)listRet.getFieldValue(c,"FILES");
			
			ezc.ezcommon.EzLog4j.log(":::::shfileret:::::::::::"+shfileret.toEzcString(),"I");
			//out.println("shfileret.toEzcString()=="+shfileret.toEzcString());
			//out.println("shfileret.getRowCount()==="+shfileret.getRowCount());

			for(int p=0;p<shfileret.getRowCount();p++)
			{
				fstring=fstring+shfileret.getFieldValueString(p,"CLIENTFILENAME")+"§";
				sfstr=sfstr+shfileret.getFieldValueString(p,"SERVERFILENAME")+"µ";
				uploadedBy=uploadedBy+shfileret.getFieldValueString(p,"TYPE")+"µ";
			}
		}	
		fstring=fstring.substring(0,fstring.length()-1);
		sfstr=sfstr.substring(0,sfstr.length()-1);
		
		ezc.ezcommon.EzLog4j.log(":::::fstring:::::::::::"+fstring,"I");
		ezc.ezcommon.EzLog4j.log(":::::sfstr:::::::::::"+sfstr,"I");
	}
	
%>
<script>
	function openViewUploadWindow()
	{
		var filestring=document.myForm.shipuploads.value
		var serverfiles=document.myForm.shipserverfiles.value;
		var uploadedBy=document.myForm.uploadedBy.value;
		//alert("uploadedBy=="+uploadedBy);
		attach=window.open("../Misc/ezViewUploadedDocs.jsp?filestring="+filestring+"&serverfiles="+serverfiles+"&uploadedBy="+uploadedBy,"UserWindow1","width=420,height=330,left=150,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no");
	}
</script>
<%
String temArray[]=sfstr.split("µ");
//out.println("temArray.length=="+temArray.length);
uploadedBy="";
for(int i=1;i<=temArray.length;i++)
{
//out.println("temArray=="+temArray[i-1].split("\\*")[0]);
uploadedBy+=temArray[i-1].split("\\*")[0]+"µ";
}

%>
<input type="hidden" name="shipuploads" value="<%=fstring%>" >
<input type="hidden" name="shipserverfiles" value="<%=sfstr%>">
<input type="hidden" name="uploadedBy" value="<%=uploadedBy%>">