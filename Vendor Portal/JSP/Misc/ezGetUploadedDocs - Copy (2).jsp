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
	
	params.setObjectNo(docsKeyStr);
	uploadMainParams.setObject(params);
	Session.prepareParams(uploadMainParams);
	listRet=(ezc.ezparam.ReturnObjFromRetrieve)EzUploadManager.getUploadedDocs(uploadMainParams);
	
	if(listRet!=null)
		docsListCnt = listRet.getRowCount();
	
	if(docsListCnt>0)
	{
		for(int c=0;c<shfileret.getRowCount();c++)
		{
			ReturnObjFromRetrieve shfileret=(ReturnObjFromRetrieve)listRet.getFieldValue(c,"FILES");

			Vector v= new Vector();
			v.addElement(uploadKey);

			for(int p=0;p<shfileret.getRowCount();p++)
			{
				fstring=fstring+shfileret.getFieldValueString(p,"CLIENTFILENAME")+"¤"+uploadKey+"§";
				sfstr=sfstr+shfileret.getFieldValueString(p,"SERVERFILENAME")+"µ";
			}

			out.println(":::::fstring:::::::::::"+fstring);
			out.println(":::::sfstr:::::::::::"+sfstr);

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
		}	
		fstring=fstring.substring(0,fstring.length()-1);
		sfstr=sfstr.substring(0,sfstr.length()-1);
	}
	
%>
<script>
	function openViewUploadWindow()
	{
		var filestring=document.myForm.shipuploads.value
		var serverfiles=document.myForm.shipserverfiles.value;
		attach=window.open("../Misc/ezViewUploadedDocs.jsp?filestring="+filestring+"&serverfiles="+serverfiles,"UserWindow1","width=420,height=330,left=150,top=100,resizable=yes,scrollbars=no,toolbar=no,menubar=no");
	}
</script>
<input type="hidden" name="shipuploads" value="<%=fstring%>" >
<input type="hidden" name="shipserverfiles" value="<%=sfstr%>">