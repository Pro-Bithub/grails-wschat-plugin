<!DOCTYPE html>
<html>
<head>

<g:if test="${enduser?.verifyAppVersion().equals('assets')}">
	<g:if test="${!request.xhr }">
    	<meta name='layout' content="achat"/>
    </g:if>
    <g:else>
    	<g:render template="/assets"/>
    </g:else>
</g:if>
<g:else>
	<g:if test="${!request.xhr }">
    	<meta name='layout' content="chat"/>
    </g:if>
    <g:else>
   		<g:render template="/resources"/>
   	 </g:else>
</g:else>    
    
   <title>${chatTitle }</title>
</head>
<body>
	<div  class="page-header">
	<h2>${chatHeader }</h2>
	<small>  
		${now}
	</small>
	</div>

    <div id="chat_div">
    </div>
    
    <div id="userList">
    </div>

	<div id="bannedconfirmation">
	</div>
	
	<div id="profileconfirmation">
	</div>

	<div id="banuser" style="display:none;">
		<g:render template="/banuser" />
	</div>
	
	<div id="userprofile" style="display:none;">
		<g:render template="/profile/profile" />
	</div>

	<div id="userphoto" style="display:none;">
		<g:render template="/profile/photomb" />
	</div>
	
	<div id="chatterBox">
		<div class="message-container">


		
			<div class="message-north" >
      			<div class="message-user-list" >
      	 			<div id="fixyflow"><div id="fixflow">
						<ul class="nav nav-tabs nav-stacked"  >
		 				<ul class="dropdown-menu" id='onlineUsers' style="display: block; position: static; margin-bottom: 5px; *">
						<span  id="onlineUsers" />
						</ul>
						</ul>
					</div></div>
				</div>
				
				<div class="message-thread" >
				<div id="sendMessage" >
				<textarea cols="20" rows="1" id="messageBox"  name="message"></textarea>
				<input type="button" id="sendBtn" value="send" class="btn btn-danger btn-lg" onClick="sendMessage();">
		</div></div>
	
				<div id="cmessage">
				<div id="fixyflow"><div id="fixflow">
					<div  id="chatMessages" ></div>
					
				</div>
			</div>
			</div>
			</div>
			
	</div>						
</div>
	

<g:javascript>
	if (!window.WebSocket) {
		var msg = "Your browser does not have WebSocket support";
		$("#pageHeader").html(msg);
		$("#chatterBox").html('');
	}
	
    var webSocket=new WebSocket("ws://${hostname}/${meta(name:'app.name')}/WsChatEndpoint");
     
    var chatMessages=document.getElementById("chatMessages");
    var onlineUsers=document.getElementById("onlineUsers");
    var messageBox=document.getElementById("messageBox");
    var user="${chatuser}";
    
    webSocket.onopen=function(message) {processOpen(message);};
    webSocket.onclose=function(message) {processClose(message);};
    webSocket.onerror=function(message) {processError(message);};
    webSocket.onmessage=function(message) {processMessage(message);	};
		
   function processOpen(message) {
    	<g:if test="${!chatuser}">
       		$('#chatMessages').append("Chat denied no username \n");
       		webSocket.send("DISCO:-"+user);
       	 	webSocket.close();
       	</g:if>
       	<g:else>
       		webSocket.send("CONN:-"+user);
           	scrollToBottom();
       </g:else>
 	}

	function getApp() {
		var baseapp="${meta(name:'app.name')}";
		return baseapp;
	}
	
	$('#messageBox').keypress(function(e){
	if (e.keyCode == 13 && !e.shiftKey) {
		e.preventDefault();
	}
	if(e.which == 13){
		var tmb=messageBox.value.replace(/^\s*[\r\n]/gm, "");
		if (tmb!="") {
			sendMessage();
			$("#messageBox").val().trim();
			messageBox.focus();
		}
	}
	});

     window.onbeforeunload = function() {
       	webSocket.send("DISCO:-"+user);
       	webSocket.onclose = function() { }
       	webSocket.close();
     }
</g:javascript>


</body>
</html>
