<%
/*response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-cache");
java.util.Date myDate=new java.util.Date();
int year=myDate.getYear()+1900;
int month=myDate.getMonth();
int date=myDate.getDate();
int hours=myDate.getHours();
int minutes=myDate.getMinutes();
int seconds=myDate.getSeconds();
String userId = (String)Session.getUserId();*/
//out.println("userId=="+userId);
%>
      <html>
	<!--<body onLoad="show_clock(<%=year%>,<%=month%>,<%=date%>,<%=hours%>,<%=minutes%>,<%=seconds%>),ezAutoLogout()" style="background-color:#BDD7E6" text="#000000" topmargin="0" marginheight="0" marginwidth="5"> -->
	
      <!-- Main Footer -->
      <footer class="main-footer no-print">
        <!-- To the right -->
        <div class="pull-right hidden-xs">
         
        </div>
        <!-- Default to the left -->
        <strong>Copyright &copy; 2021 <a href="http://www.thehackettgroup.com/">The Hackett Group</a>.</strong> All rights reserved.
      </footer>
 
      <!-- Control Sidebar -->
      <aside class="control-sidebar control-sidebar-dark">
        <!-- Create the tabs -->
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
          <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
          <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
        </ul>
        <!-- Tab panes -->
        <div class="tab-content">
          <!-- Home tab content -->
          <div class="tab-pane active" id="control-sidebar-home-tab">
            <h3 class="control-sidebar-heading">&nbsp;</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-birthday-cake bg-red"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">&nbsp;</h4>
                    <p>&nbsp;</p>
                  </div>
                </a>
              </li> 
            </ul><!-- /.control-sidebar-menu -->

            <h3 class="control-sidebar-heading">&nbsp;</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    &nbsp;
                    <span class="label label-danger pull-right">&nbsp;</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
                  </div>
                </a>
              </li>
            </ul><!-- /.control-sidebar-menu -->

          </div><!-- /.tab-pane -->
          <!-- Stats tab content -->
          <div class="tab-pane" id="control-sidebar-stats-tab">&nbsp;</div><!-- /.tab-pane -->
          <!-- Settings tab content -->
          <div class="tab-pane" id="control-sidebar-settings-tab">
            <form method="post">
            <input type='hidden' name='userId' value='<%=userId%>'>
              <h3 class="control-sidebar-heading">&nbsp;</h3>
              <div class="form-group">
                <label class="control-sidebar-subheading">
                  &nbsp;
                  
                </label>
                <p>
                 &nbsp;
                </p>
              </div><!-- /.form-group -->
            </form>
          </div><!-- /.tab-pane -->
        </div>
      </aside><!-- /.control-sidebar -->
      <!-- Add the sidebar's background. This div must be placed
           immediately after the control sidebar -->
      <div class="control-sidebar-bg"></div>
    </div><!-- ./wrapper -->
	<div class="modal fade" id="pleaseWaitDialog">
		 <div class="modal-dialog" style="padding-top: 15%;">
   		<div class="modal-content" style="background: transparent;">
		<div class="modal-body">
		    <img src="../img/newloading.gif" style="margin-left:55%;"/>
		</div>
		</div>
		</div>
	</div>
    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.1.4 -->
    <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
    
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/plugins/daterangepicker/moment.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/daterangepicker/daterangepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
<script>

function allowOnlyNumeric(txt, evt) {
      var charCode = (evt.which) ? evt.which : evt.keyCode;
      if (charCode == 46) {
        //Check if the text already contains the . character
        if (txt.value.indexOf('.') === -1) {
          return true;
        } else {
          return false;
        }
      } else {
        if (charCode > 31 &&
          (charCode < 48 || charCode > 57))
          return false;
      }
      return true;
    }
function _init(){"use strict";$.AdminLTE.layout={activate:function(){var a=this;a.fix(),a.fixSidebar(),$(window,".wrapper").resize(function(){a.fix(),a.fixSidebar()})},fix:function(){var a=$(".main-header").outerHeight()+$(".main-footer").outerHeight(),b=$(window).height(),c=$(".sidebar").height();if($("body").hasClass("fixed"))$(".content-wrapper, .right-side").css("min-height",b-$(".main-footer").outerHeight());else{var d;b>=c?($(".content-wrapper, .right-side").css("min-height",b-a),d=b-a):($(".content-wrapper, .right-side").css("min-height",c),d=c);var e=$($.AdminLTE.options.controlSidebarOptions.selector);"undefined"!=typeof e&&e.height()>d&&$(".content-wrapper, .right-side").css("min-height",e.height())}},fixSidebar:function(){return $("body").hasClass("fixed")?("undefined"==typeof $.fn.slimScroll&&window.console&&window.console.error("Error: the fixed layout requires the slimscroll plugin!"),void($.AdminLTE.options.sidebarSlimScroll&&"undefined"!=typeof $.fn.slimScroll&&($(".sidebar").slimScroll({destroy:!0}).height("auto"),$(".sidebar").slimscroll({height:$(window).height()-$(".main-header").height()+"px",color:"rgba(0,0,0,0.2)",size:"3px"})))):void("undefined"!=typeof $.fn.slimScroll&&$(".sidebar").slimScroll({destroy:!0}).height("auto"))}},$.AdminLTE.pushMenu={activate:function(a){var b=$.AdminLTE.options.screenSizes;$(a).on("click",function(a){a.preventDefault(),$(window).width()>b.sm-1?$("body").hasClass("sidebar-collapse")?$("body").removeClass("sidebar-collapse").trigger("expanded.pushMenu"):$("body").addClass("sidebar-collapse").trigger("collapsed.pushMenu"):$("body").hasClass("sidebar-open")?$("body").removeClass("sidebar-open").removeClass("sidebar-collapse").trigger("collapsed.pushMenu"):$("body").addClass("sidebar-open").trigger("expanded.pushMenu")}),$(".content-wrapper").click(function(){$(window).width()<=b.sm-1&&$("body").hasClass("sidebar-open")&&$("body").removeClass("sidebar-open")}),($.AdminLTE.options.sidebarExpandOnHover||$("body").hasClass("fixed")&&$("body").hasClass("sidebar-mini"))&&this.expandOnHover()},expandOnHover:function(){var a=this,b=$.AdminLTE.options.screenSizes.sm-1;$(".main-sidebar").hover(function(){$("body").hasClass("sidebar-mini")&&$("body").hasClass("sidebar-collapse")&&$(window).width()>b&&a.expand()},function(){$("body").hasClass("sidebar-mini")&&$("body")&&$(window).width()>b&&a.collapse()})},expand:function(){$("body")},collapse:function(){$("body")&&$("body")}},$.AdminLTE.tree=function(a){var b=this,c=$.AdminLTE.options.animationSpeed;$(document).on("click",a+" li a",function(a){var d=$(this),e=d.next();if(e.is(".treeview-menu")&&e.is(":visible"))e.slideUp(c,function(){e.removeClass("menu-open")}),e.parent("li").removeClass("active");else if(e.is(".treeview-menu")&&!e.is(":visible")){var f=d.parents("ul").first(),g=f.find("ul:visible").slideUp(c);g.removeClass("menu-open");var h=d.parent("li");e.slideDown(c,function(){e.addClass("menu-open"),f.find("li.active").removeClass("active"),h.addClass("active"),b.layout.fix()})}e.is(".treeview-menu")&&a.preventDefault()})},$.AdminLTE.controlSidebar={activate:function(){var a=this,b=$.AdminLTE.options.controlSidebarOptions,c=$(b.selector),d=$(b.toggleBtnSelector);d.on("click",function(d){d.preventDefault(),c.hasClass("control-sidebar-open")||$("body").hasClass("control-sidebar-open")?a.close(c,b.slide):a.open(c,b.slide)});var e=$(".control-sidebar-bg");a._fix(e),$("body").hasClass("fixed")?a._fixForFixed(c):$(".content-wrapper, .right-side").height()<c.height()&&a._fixForContent(c)},open:function(a,b){b?a.addClass("control-sidebar-open"):$("body").addClass("control-sidebar-open")},close:function(a,b){b?a.removeClass("control-sidebar-open"):$("body").removeClass("control-sidebar-open")},_fix:function(a){var b=this;$("body").hasClass("layout-boxed")?(a.css("position","absolute"),a.height($(".wrapper").height()),$(window).resize(function(){b._fix(a)})):a.css({position:"fixed",height:"auto"})},_fixForFixed:function(a){a.css({position:"fixed","max-height":"100%",overflow:"auto","padding-bottom":"50px"})},_fixForContent:function(a){$(".content-wrapper, .right-side").css("min-height",a.height())}},$.AdminLTE.boxWidget={selectors:$.AdminLTE.options.boxWidgetOptions.boxWidgetSelectors,icons:$.AdminLTE.options.boxWidgetOptions.boxWidgetIcons,animationSpeed:$.AdminLTE.options.animationSpeed,activate:function(a){var b=this;a||(a=document),$(a).on("click",b.selectors.collapse,function(a){a.preventDefault(),b.collapse($(this))}),$(a).on("click",b.selectors.remove,function(a){a.preventDefault(),b.remove($(this))})},collapse:function(a){var b=this,c=a.parents(".box").first(),d=c.find("> .box-body, > .box-footer, > form  >.box-body, > form > .box-footer");c.hasClass("collapsed-box")?(a.children(":first").removeClass(b.icons.open).addClass(b.icons.collapse),d.slideDown(b.animationSpeed,function(){c.removeClass("collapsed-box")})):(a.children(":first").removeClass(b.icons.collapse).addClass(b.icons.open),d.slideUp(b.animationSpeed,function(){c.addClass("collapsed-box")}))},remove:function(a){var b=a.parents(".box").first();b.slideUp(this.animationSpeed)}}}if("undefined"==typeof jQuery)throw new Error("AdminLTE requires jQuery");$.AdminLTE={},$.AdminLTE.options={navbarMenuSlimscroll:!0,navbarMenuSlimscrollWidth:"3px",navbarMenuHeight:"200px",animationSpeed:500,sidebarToggleSelector:"[data-toggle='offcanvas']",sidebarPushMenu:!0,sidebarSlimScroll:!0,sidebarExpandOnHover:!1,enableBoxRefresh:!0,enableBSToppltip:!0,BSTooltipSelector:"[data-toggle='tooltip']",enableFastclick:!0,enableControlSidebar:!0,controlSidebarOptions:{toggleBtnSelector:"[data-toggle='control-sidebar']",selector:".control-sidebar",slide:!0},enableBoxWidget:!0,boxWidgetOptions:{boxWidgetIcons:{collapse:"fa-minus",open:"fa-plus",remove:"fa-times"},boxWidgetSelectors:{remove:'[data-widget="remove"]',collapse:'[data-widget="collapse"]'}},directChat:{enable:!0,contactToggleSelector:'[data-widget="chat-pane-toggle"]'},colors:{lightBlue:"#3c8dbc",red:"#f56954",green:"#00a65a",aqua:"#00c0ef",yellow:"#f39c12",blue:"#0073b7",navy:"#001F3F",teal:"#39CCCC",olive:"#3D9970",lime:"#01FF70",orange:"#FF851B",fuchsia:"#F012BE",purple:"#8E24AA",maroon:"#D81B60",black:"#222222",gray:"#d2d6de"},screenSizes:{xs:480,sm:768,md:992,lg:1200}},$(function(){"use strict";$("body").removeClass("hold-transition"),"undefined"!=typeof AdminLTEOptions&&$.extend(!0,$.AdminLTE.options,AdminLTEOptions);var a=$.AdminLTE.options;_init(),$.AdminLTE.layout.activate(),$.AdminLTE.tree(".sidebar"),a.enableControlSidebar&&$.AdminLTE.controlSidebar.activate(),a.navbarMenuSlimscroll&&"undefined"!=typeof $.fn.slimscroll&&$(".navbar .menu").slimscroll({height:a.navbarMenuHeight,alwaysVisible:!1,size:a.navbarMenuSlimscrollWidth}).css("width","100%"),a.sidebarPushMenu&&$.AdminLTE.pushMenu.activate(a.sidebarToggleSelector),a.enableBSToppltip&&$("body").tooltip({selector:a.BSTooltipSelector}),a.enableBoxWidget&&$.AdminLTE.boxWidget.activate(),a.enableFastclick&&"undefined"!=typeof FastClick&&FastClick.attach(document.body),a.directChat.enable&&$(document).on("click",a.directChat.contactToggleSelector,function(){var a=$(this).parents(".direct-chat").first();a.toggleClass("direct-chat-contacts-open")}),$('.btn-group[data-toggle="btn-toggle"]').each(function(){var a=$(this);$(this).find(".btn").on("click",function(b){a.find(".btn.active").removeClass("active"),$(this).addClass("active"),b.preventDefault()})})}),function(a){"use strict";a.fn.boxRefresh=function(b){function c(a){a.append(f),e.onLoadStart.call(a)}function d(a){a.find(f).remove(),e.onLoadDone.call(a)}var e=a.extend({trigger:".refresh-btn",source:"",onLoadStart:function(a){return a},onLoadDone:function(a){return a}},b),f=a('<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>');return this.each(function(){if(""===e.source)return void(window.console&&window.console.log("Please specify a source first - boxRefresh()"));var b=a(this),f=b.find(e.trigger).first();f.on("click",function(a){a.preventDefault(),c(b),b.find(".box-body").load(e.source,function(){d(b)})})})}}(jQuery),function(a){"use strict";a.fn.activateBox=function(){a.AdminLTE.boxWidget.activate(this)}}(jQuery),function(a){"use strict";a.fn.todolist=function(b){var c=a.extend({onCheck:function(a){return a},onUncheck:function(a){return a}},b);return this.each(function(){"undefined"!=typeof a.fn.iCheck?(a("input",this).on("ifChecked",function(){var b=a(this).parents("li").first();b.toggleClass("done"),c.onCheck.call(b)}),a("input",this).on("ifUnchecked",function(){var b=a(this).parents("li").first();b.toggleClass("done"),c.onUncheck.call(b)})):a("input",this).on("change",function(){var b=a(this).parents("li").first();b.toggleClass("done"),a("input",b).is(":checked")?c.onCheck.call(b):c.onUncheck.call(b)})})}}(jQuery);

var processRequest;
var counter = 0;

function ezAutoLogout()
{

	try
	{
		processRequest = null;
		processRequest = new ActiveXObject("Msxml2.XMLHTTP");
	}
	catch(e)
	{
		try
		{
			processRequest=new ActiveXObject("Microsoft.XMLHTTP");
		}
		catch(oc)
		{
			processRequest=null;
		}
	}

	if(!processRequest&&typeof XMLHttpRequest!="undefined")
	{
		processRequest=new XMLHttpRequest();
	}

	var url="";
		url="http://"+location.host+"JUBL/EzCommerce/EzVendor/Vendor2/JSPs/Misc/ezLogout.jsp?AUTOLOGOUT=Y";
	
	if(processRequest!=null)
	{
		processRequest.onreadystatechange = Process;
		processRequest.open("GET", url, false);
		processRequest.send(null);
		counter++;
	}
}
function Process()
{
	if (processRequest.readyState == 4)
	{
		if (processRequest.status == 200)
		{
			if(processRequest.responseText!="")
			{
				performAutoLogout(processRequest.responseText)
			}
		}
	}
}
function performAutoLogout(duration)
{
	var checkDuration = '1'
	if(counter > 1)
		checkDuration = checkDuration-1

	if(duration >= checkDuration)
	{
		parent.location.href="ezLogout.jsp?AUTOLOGOUT=Y";
	}
	else
	{
		setTimeout("ezAutoLogout()",60000);
	}

}
[08-10-2021 13:55] Raj Gopal Nagabhairava
<Script>
function show_clock(syear,smonth,smday,shours,sminutes,sseconds)
{
/////////////// CONFIGURATION ///////////////////////////// // Set the clock's font face:
var myfont_face = "arial"; // Set the clock's font size (in point):
var myfont_size = "9"; // Set the clock's font color:
var myfont_color = "#00355D"; // Set the clock's background color:
var myback_color = "#FFFFFF"; // Set the text to display before the clock:
var mypre_text = ""; // Set the width of the clock (in pixels):
var mywidth = 300; // Display the time in 24 or 12 hour time?
// 0 = 24, 1 = 12
var my12_hour = 0; // How often do you want the clock updated?
// 0 = Never, 1 = Every Second, 2 = Every Minute
// If you pick 0 or 2, the seconds will not be displayed
var myupdate = 1; // Display the date?
// 0 = No, 1 = Yes
var DisplayDate = 1; /////////////// END CONFIGURATION /////////////////////////
/////////////////////////////////////////////////////////// // Browser detect code
var ie4=document.all
var ns4=document.layers
var ns6=document.getElementById&&!document.all
// Global varibale definitions: var dn = "";
var mn = "th";
var old = ""; // The following arrays contain data which is used in the clock's
// date function. Feel free to change values for Days and Months
// if needed (if you wanted abbreviated names for example).
var DaysOfWeek = new Array(7);
DaysOfWeek[0] = "Sunday";
DaysOfWeek[1] = "Monday";
DaysOfWeek[2] = "Tuesday";
DaysOfWeek[3] = "Wednesday";
DaysOfWeek[4] = "Thursday";
DaysOfWeek[5] = "Friday";
DaysOfWeek[6] = "Saturday"; var MonthsOfYear = new Array(12);
MonthsOfYear[0] = "Jan";
MonthsOfYear[1] = "Feb";
MonthsOfYear[2] = "Mar";
MonthsOfYear[3] = "Apr";
MonthsOfYear[4] = "May";
MonthsOfYear[5] = "Jun";
MonthsOfYear[6] = "Jul";
MonthsOfYear[7] = "Aug";
MonthsOfYear[8] = "Sep";
MonthsOfYear[9] = "Oct";
MonthsOfYear[10] = "Nov";
MonthsOfYear[11] = "Dec"; // This array controls how often the clock is updated,
// based on your selection in the configuration.
var ClockUpdate = new Array(3);
ClockUpdate[0] = 0;
ClockUpdate[1] = 1000;
ClockUpdate[2] = 60000;
// For Version 4+ browsers, write the appropriate HTML to the
// page for the clock, otherwise, attempt to write a static
// date to the page.
//if (ie4||ns6) { document.write('<span id="LiveClockIE" style="width:'+mywidth+'px; background-color:'+myback_color+'"></span>'); }
//else if (document.layers) { document.write('<ilayer bgColor="'+myback_color+'" id="ClockPosNS" visibility="hide"><layer width="'+mywidth+'" id="LiveClockNS"></layer></ilayer>'); }
//else { old = "true"; show_clock(); }
if (old == "die") { return; } //alert(syear)
//alert(smonth)
//alert(smday)
//alert(shours)
//alert(sminutes)
//alert(sseconds) //show clock in NS 4
if (ns4)
document.ClockPosNS.visibility="show"
// Get all our date variables:
var Digital = null;
if(syear == null)
Digital = new Date();
else
Digital = new Date(syear,smonth,smday,shours,sminutes,sseconds);
var day = Digital.getDay();
var mday = Digital.getDate();
var month = Digital.getMonth();
var year = Digital.getYear();
if(year<1900){ year=year+1900; }
var hours = Digital.getHours(); var minutes = Digital.getMinutes();
var seconds = Digital.getSeconds(); // Fix the "mn" variable if needed:
if (mday == 1) { mn = "st"; }
else if (mday == 2) { mn = "nd"; }
else if (mday == 3) { mn = "rd"; }
else if (mday == 21) { mn = "st"; }
else if (mday == 22) { mn = "nd"; }
else if (mday == 23) { mn = "rd"; }
else if (mday == 31) { mn = "st"; } // Set up the hours for either 24 or 12 hour display:
if (my12_hour) {
dn = "AM";
if (hours > 12) { dn = "PM"; hours = hours - 12; }
if (hours == 0) { hours = 12; }
} else {
dn = "";
}
if (minutes <= 9) { minutes = "0"+minutes; }
if (seconds <= 9) { seconds = "0"+seconds; }
// This is the actual HTML of the clock. If you're going to play around
// with this, be careful to keep all your quotations in tact.
myFontStart = '<font style="color:'+myfont_color+'; font-family:'+myfont_face+'; font-size:'+myfont_size+'pt;">';
myFontEnd = '</font>';
myclock = '';
myclock += mypre_text;
myclock += hours+':'+minutes;
if ((myupdate < 2) || (myupdate == 0)) { myclock += ':'+seconds; }
myclock += ' '+dn;
if (DisplayDate)
{
myclock = DaysOfWeek[day]+" "+mday+mn+' '+MonthsOfYear[month] + ","+year+" "+myclock;
}
myclock = myFontStart+myclock+myFontEnd; if (old == "true")
{
document.write(myclock);
old = "die";
return;
} 
if (myupdate != 0) { setTimeout("show_clock("+year+","+month+","+mday+","+hours+","+minutes+","+(++seconds)+")",ClockUpdate[myupdate]); 



</script>    
    

    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
  </body>
</html>
