<cfoutput>
      <footer class="offset5" style="padding-top:80px;">
        <p><span class="span4">&copy; Cedric Dupuy #year(now())#</span></p>
      </footer>

    </div> <!-- /container -->
</body>
	  
</html>


    <!-- Le javascript  -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jquery-ui.min.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap-tooltip.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/bootstrap-popover.js"></script>
    <script type="text/javascript" src="#application.appmap#/bootstrap/js/jqBootstrapValidation.js"></script>

	<cfset variables.popoverTemplate = '<div class="popover custom-popover-class span6"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'>
	<script>

	$(document).ready(function () 
	{  
    	$("[rel=tooltip]").tooltip({'placement':'top'});  
    	
		$("[rel=popover]").popover({
									'placement':'top',
									'trigger':'click',
									'template':'#variables.popoverTemplate#',
									'html':'true'
									}).click(get_data_for_popover_and_display).mouseleave(function(e){
									    var ref = $(this);
										ref.popover('destroy');});
 	});
 	
 	get_data_for_popover_and_display = function() {
 		var el = $(this);
	    var _data = el.attr('teamid');
	    $.ajax({
	         type: 'GET',
	         url: '#application.appmap#/cfc/footballDao.cfc?method=getTeamStatsHtmlTable&teamID='+_data,
	         dataType: 'html',
	         success: function(data) {
	         	var decoded = $('<div/>').html(data).text();
	             el.attr('data-content', decoded);
	             el.popover('show');
	         }
    	});
	}
	
	$(function () { $("input,select,textarea").not("[type=submit]").jqBootstrapValidation(); } );
 	
	</script>

</cfoutput>