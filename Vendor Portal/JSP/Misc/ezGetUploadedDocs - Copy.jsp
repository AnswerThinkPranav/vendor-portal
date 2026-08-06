<%@ page import="java.util.*" %>
<%@ page import = "ezc.ezparam.*" %>
<%@ page import = "ezc.ezshipment.client.*" %>
<%@ page import = "ezc.ezshipment.params.*" %>
<%@ page import = "ezc.ezcommon.*" %>
<%@ page import="ezc.ezupload.params.*" %>
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session" />
<jsp:useBean id="EzUploadManager" class="ezc.ezupload.client.EzUploadManager" scope="session" />
<%

	ezc.ezparam.EzcParams mainParams = new ezc.ezparam.EzcParams(false);
	ezc.ezupload.params.EziUploadDocsParams params= new ezc.ezupload.params.EziUploadDocsParams();
	ezc.ezparam.ReturnObjFromRetrieve listRet=null;
	
	String currSysKey = "999111";
	String shipid = "1234";
	String uploadKey = "CONTRACT";
	

	String fstr="'"+currSysKey+"CONTRACT"+shipid+"'";
	String fstring="";
	String sfstr="";
	
	

	params.setObjectNo(fstr);
	mainParams.setObject(params);
	Session.prepareParams(mainParams);
	listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzUploadManager.getUploadedDocs(mainParams);
	
	if(listRet.getRowCount()>0)
	{
		ReturnObjFromRetrieve shfileret=(ReturnObjFromRetrieve)listRet.getFieldValue(0,"FILES");
		
		Vector v= new Vector();
		v.addElement(uploadKey);
		
		for(int p=0;p<shfileret.getRowCount();p++)
		{
			//if(shfileret.getFieldValueString(p,"TYPE").equals(uploadKey))
			if(shfileret.getFieldValueString(p,"TYPE").equals("CON1"))
			{
				fstring=fstring+shfileret.getFieldValueString(p,"CLIENTFILENAME")+"¤"+uploadKey+"§";
				sfstr=sfstr+shfileret.getFieldValueString(p,"SERVERFILENAME")+"µ";
			}
		}
		
		fstring=fstring.substring(0,fstring.length()-1);
		sfstr=sfstr.substring(0,sfstr.length()-1);
		
		Vector cv= new Vector();
		Vector ctypes=new Vector();
		Vector sv = new Vector();
		Vector finalcfiles=new Vector();
		Vector finalsfiles=new Vector();
		
		StringTokenizer tempcfiles=new StringTokenizer(fstring,"§");
		StringTokenizer tempsfiles=new StringTokenizer(sfstr,"µ");
		
		while(tempcfiles.hasMoreElements())
		{
			StringTokenizer tcfiles=new StringTokenizer((String)tempcfiles.nextToken(),"¤");
			while(tcfiles.hasMoreElements())
			{

				cv.addElement(tcfiles.nextToken());;
				ctypes.addElement((String)tcfiles.nextToken());
			}
				sv.addElement(tempsfiles.nextToken());
		}
		for(int i=0;i<v.size();i++)
		{
			String cfiles="";
			String sfiles="";
			String bool="false";
			for(int j=0;j<ctypes.size();j++)
			{
				if(((String)v.elementAt(i)).equals(((String)ctypes.elementAt(j))))
				{
					cfiles=(String)cv.elementAt(j);
					sfiles=(String)sv.elementAt(j);
					bool="true";
				}
			}
			if(bool.equals("true"))
			{
				finalcfiles.addElement(cfiles);
				finalsfiles.addElement(sfiles);
			}
			else
			{
				finalcfiles.addElement("NA");
				finalsfiles.addElement("NA");
			}
		}
		fstring="";
		sfstr="";
		for(int i=0;i<finalcfiles.size();i++)
		{
			fstring=fstring+(String)finalcfiles.elementAt(i)+"§";
			sfstr=sfstr+(String)finalsfiles.elementAt(i)+"µ";
		}
		fstring=fstring.substring(0,fstring.length()-1);
		sfstr=sfstr.substring(0,sfstr.length()-1);
		
	}
	
%>
<html>
<head>
<script>
	function openViewUploadWindow()
	{
		var filestring=document.myForm.shipuploads.value
		var serverfiles=document.myForm.shipserverfiles.value;
		attach=window.open("ezViewUploadedDocs.jsp?filestring="+filestring+"&serverfiles="+serverfiles,"UserWindow1","width=420,height=330,left=150,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no");
	}
</script>
</head>
<Body>
<Form name='myForm'>
<input type="hidden" name="shipuploads" value="<%=fstring%>" >
<input type="hidden" name="shipserverfiles" value="<%=sfstr%>">
<a href="javascript:openViewUploadWindow()">View Attachments</a>
<%
	//buttonName.add("View Documents");
	//buttonMethod.add("openViewUploadWindow()");
	
%>

</Form>
</Body>