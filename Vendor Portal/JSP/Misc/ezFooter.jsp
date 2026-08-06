<%@ include file="../../Library/Globals/errorPagePath.jsp"%>
<%
	session.setMaxInactiveInterval(60*60);
%> 
      <!-- Main Footer -->
      <footer class="main-footer no-print">
        <!-- To the right -->
        <div class="pull-right hidden-xs">
         
        </div>
        <!-- Default to the left -->
        <strong>Copyright &copy; 2025 <a href="http://www.thehackettgroup.com/">The Hackett Group</a>.</strong> All rights reserved.
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
   <script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-3.5.1.min.js"></script>
   <!--<script src="../../../../EzCommon/Library/plugins/jQuery/jQuery-2.1.4.min.js"></script>-->
    <script src="../../../../EzCommon/Library/plugins/jQueryUI/jquery-ui.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/jQuery/jquery.form.js"></script>
    
    <!-- Bootstrap 3.3.5 -->
    <script src="../../../../EzCommon/Library/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../../EzCommon/Library/js/datepicker.js"></script>
    <script src="../../../../EzCommon/Library/plugins/daterangepicker/moment.min.js"></script>
    <script src="../../../../EzCommon/Library/plugins/daterangepicker/daterangepicker.js"></script>
    <script src="../../../../EzCommon/Library/js/alert_confirm.js"></script>
    
    <!--Auto Suggestion-->
    <script src="../../../../EzCommon/Library/plugins/fuse/dist/fuse.js"></script>
    <script src="../../../../EzCommon/Library/dist/js/fuzzycomplete.js"></script>
    
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

</script> 
// CSRF Scripts                Dated.31.01.2026
<script>
	$(document).ajaxSend(function (event, xhr, settings) {
	    if (!settings || !settings.type) return;
	
	    if (settings.type.toUpperCase() === "POST") {
	        var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
	
	        // ? FormData (file upload / ajaxForm) ? SAFE append
	        if (settings.data instanceof FormData) {
	            settings.data.append("csrfToken", csrfToken);
	            return;
	        }
	
	        // ? URL-encoded string
	        if (typeof settings.data === "string" && settings.data.length > 0) {
	            settings.data += "&csrfToken=" + encodeURIComponent(csrfToken);
	        } 
	        else if (typeof settings.data === "string") {
	            settings.data = "csrfToken=" + encodeURIComponent(csrfToken);
	        }
	    }
	});
	(function (open, send) {
	
	    XMLHttpRequest.prototype.open = function (method, url, async, user, pass) {
	        this._method = method;
	        open.call(this, method, url, async, user, pass);
	    };
	
	    XMLHttpRequest.prototype.send = function (body) {
	        try {
	            if (this._method && this._method.toUpperCase() === "POST") {
	                var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
	
	                // ? FormData (multipart)
	                if (body instanceof FormData) {
	                    body.append("csrfToken", csrfToken);
	                }
	                // URL-encoded string
	                else if (typeof body === "string") {
	                    body += "&csrfToken=" + encodeURIComponent(csrfToken);
	                }
	                // Do NOT create or overwrite multipart bodies
	            }
	        } catch (e) {
	            console.error("CSRF token append failed", e);
	        }
	
	        send.call(this, body);
	    };
	
	})(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send);
	
	(function (originalFetch) {
	
	    window.fetch = function (resource, options = {}) {
	        try {
	            if (options.method && options.method.toUpperCase() === "POST") {
	                var csrfToken = '<%= session.getAttribute("CSRF_TOKEN") %>';
	                options.headers = options.headers || {};
	
	                // ? JSON body
	                if (options.headers["Content-Type"] &&
	                    options.headers["Content-Type"].includes("application/json")) {
	
	                    var bodyObj = options.body ? JSON.parse(options.body) : {};
	                    bodyObj.csrfToken = csrfToken;
	                    options.body = JSON.stringify(bodyObj);
	                }
	
	                // ? URL encoded
	                else if (options.headers["Content-Type"] &&
	                         options.headers["Content-Type"].includes("application/x-www-form-urlencoded")) {
	
	                    var bodyText = options.body ? options.body.toString() : "";
	                    options.body = bodyText +
	                        (bodyText ? "&" : "") +
	                        "csrfToken=" + encodeURIComponent(csrfToken);
	                }
	
	                // ? FormData (multipart / file upload)
	                else if (options.body instanceof FormData) {
	                    options.body.append("csrfToken", csrfToken);
	                }
	            }
	        } catch (e) {
	            console.error("CSRF token injection failed for fetch", e);
	        }
	
	        return originalFetch(resource, options);
	    };
	
	})(window.fetch);
	
</script>
    

    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->  
  </body>
</html>
