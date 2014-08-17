<cfoutput>
	<div class="alert alert-success">
		<h3>League Final Rankings</h3>
	</div>	
	
	<div style="font-size:12px;">
		<i class="icon-star"></i>CHAMPION!<br>
		<i class="icon-remove"></i>No Longer in the League
	</div>
   	<div class="row">
		<cfloop query="variables.seasons">
		
		<cfquery dbtype="query" name="variables.standingsOverall">
			SELECT
				*
			FROM
				variables.rankingsByYear
			WHERE
				season = #variables.seasons.season#
			ORDER BY
				winPct DESC
		</cfquery>
   		<div class="span4 offset1">
			<div class="alert alert-info">
				<strong>Season #variables.seasons.season#</strong>
			</div>
	    	<table class="table table-striped table-hover">
	    	<thead>
	    		<tr>
		    		<th></th>
					<th>Name</th>
					<th>Win</th>
					<th>Loss</th>
					<th>Tie</th>
					<th nowrap="nowrap">Win %</th>
				</tr>
			</thead>		
			<tbody>
				<cfloop query="variables.standingsOverall">
					<tr<cfif variables.standingsOverall.userID EQ session.user.userID> class="error"</cfif>>
						<td>#variables.standingsOverall.currentRow#</td>
						<td class="span2" nowrap="nowrap" <cfif variables.standingsOverall.currentRow EQ 1>style="color:red;"</cfif>>
							<cfif variables.standingsOverall.currentRow EQ 1><i class="icon-star"></i></cfif>
							<cfif variables.standingsOverall.isActive EQ 0><i class="icon-remove"></i></cfif>
							#variables.standingsOverall.userFullName#
						</td>
						<td>#variables.standingsOverall.win#</td>
						<td>#variables.standingsOverall.loss#</td>
						<td>#variables.standingsOverall.tie#</td>
						<td><span class="label label-warning">#numberFormat(variables.standingsOverall.winPct,"99.99")# %</span></td>
					</tr>	
				</cfloop>
			</tbody>
			</table>	
		</div>
		</cfloop>
	</div>
</cfoutput>
