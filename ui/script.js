$(function() {
	window.addEventListener('message', function(event) {
		switch (event.data.action) {
			case 'enable':
				$('#wrap').fadeIn();
				break;
			case 'disable':
				$('#wrap').fadeOut();
				break;
			case 'enablemenu':
				bell = "";
				if (event.data.anansweredwars > 0){
					bell = bell+'<span style="float:right;color:yellow;padding-right:5%;">🔔</span>';
				}
				$("#criminalmenu").html(`
					<center>
						<div id="scoreboard" class="scoreboard">
						
							<div class="mafia-content">
								<center>
								<span class="mafia-name">`+event.data.job.toUpperCase()+`</span>
								</center>
							</div>
					
							<table class="rwd-table">
								<tr>
									<td style="width:195px;padding:5px !important;">
										<div class="mafia-rank-bg">
											<div class="mafia-rank-title">
											<i class="fab fa-redhat mafia-rank-icon"></i>
											Mafia Rank: <span class="rank">`+event.data.rank+`</span>
											</div>
										</div>
									</td>
									<td style="width:195px;padding:5px !important;">
										<div class="mafia-points-bg">
											<div class="mafia-points-title">
											<i class="fas fa-star mafia-points-icon"></i>
											Mafia Points: <span class="points">`+event.data.points+`</span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('view_members')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="view-members"><i class="far fa-eye mafia-icon" style="padding:8px 7px"></i> View Members</span>
												</div>
											</div>
										</a>
									</td>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('add_members')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="add-members"><i class="fa fa-user-plus mafia-icon" style="padding:8px 7px"></i> Add Members</span>
												</div>
											</div>
										</a>
									</td>
								</tr>
								<tr>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('check_members')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="check-members"><i class="fa fa-user-cog mafia-icon" style="padding:8px 6px"></i> Check Members</span>
												</div>
											</div>
										</a>
									</td>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('rank_up')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="rank-up"><i class="fas fa-medal mafia-icon" style="padding:8px 9px"></i> Rank Up</span>
												</div>
											</div>
										</a>
									</td>
								</tr>
								<tr>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('view_alliances')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="alliances"><i class="fa fa-handshake mafia-icon" style="padding:8px 6.5px;"></i> Alliances</span>
												</div>
											</div>
										</a>
									</td>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('view_wars')" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="wars"><i class="fas fa-bomb mafia-icon" style="padding:8px 9px;background:#f32200"></i>Wars`+bell+`</span>
												</div>
											</div>
										</a>
									</td>
								</tr>
								<tr>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('create_alliance')" href="" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="alliances"><i class="fas fa-hands-helping mafia-icon" style="padding:8px 6.5px;background:#9624ec"></i> Create Alliance</span>
												</div>
											</div>
										</a>
									</td>
									<td style="width:195px;padding:5px !important;">
										<a onClick= "setAction('create_war')" href="" class="mafia-action">
											<div class="mafia-bg">
												<div class="mafia-title">
												<span class="wars"><i class="fas fa-book-dead mafia-icon" style="padding:8px 9px;background:#ce0000"></i> Declare War</span>
												</div>
											</div>
										</a>
									</td>
								</tr>
							</table>
							<br/>
							<a onClick= "exit()" class="closeBtn hvr-pop mafia-action"><i class="fas fa-undo" style="margin-right:5px;"></i> Go Back</a>
							

							
						</div>
					</center>
				`)
				//$(".wars-but").css("border-left","5px solid red")
				break;
			default:
				break;
		}
	});

	document.onkeyup = function(event) {
		if (event.key == 'Escape') {
			$('#wrap').fadeOut();
			$("#criminalmenu").html('');
			$.post('http://esx_CreateMafia/onCloseMenu');
		}
	};
});

function exit(){

	$.post('http://esx_CreateMafia/onCloseMenu');
	$("#criminalmenu").html("");
}

function setAction(myaction){

	$.post('http://esx_CreateMafia/'+myaction);
	$("#criminalmenu").html('');
}