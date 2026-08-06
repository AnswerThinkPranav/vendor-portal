<html>
 <div id='loadingmessage' style='position:absolute;bottom:150px;left:700px;display:none'>
       		  <img src='../Invoice/gcloading.gif'/> 
       	</div>
<script> 
document.getElementById("loadingmessage").style.display="block";
</script>       	   
<jsp:useBean id="Session" class="ezc.session.EzSession" scope="session"></jsp:useBean>
<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%@ include file="../../../Includes/JSPs/Misc/iCacheControl.jsp" %>
<%//@ include file="../../../Includes/JSPs/Misc/iAddWebStats.jsp"%> 

<%//@ include file="../../../../EzAdmin/EzAdmin4/Admin1/JSPs/User/ezTestVendSync.jsp" %>    

<head>
<link href="../../../../EzCommon/CSS/dataurl.css" rel="stylesheet" /> 
<script src="../../../../EzCommon/CSS/pace.min.js"></script>
</head>    
<body>
<script>
//	 top.location.replace("ezMenuframeset.jsp")
top.location.replace("ezWelcome_New.jsp")

document.getElementById("loadingmessage").style.display="none";

</script>
   
      
<Div id="MenuSol"></Div>
</body>  
</html>
 