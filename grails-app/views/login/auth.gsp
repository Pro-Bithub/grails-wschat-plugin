<html>
<head>
	<title><g:message code="springSecurity.login.title"/></title>
	<meta name='layout' content="achat"/>
	<asset:javascript src="jquery.min.js" />
	<asset:javascript src="jquery-ui.min.js" />
    <asset:stylesheet src="jquery-ui.min.css" />
    <asset:stylesheet src="font-awesome.css"/>
	<asset:javascript src="bootstrap.min.js" />
    <asset:stylesheet href="bootstrap.min.css" />
    <asset:stylesheet href="chat.css" id="chat_theme" />
    <asset:stylesheet href="chat-ui.css" />
</head>
<body>
 <div class="container">

   <div class="col-md-6 col-md-offset-2" >
        <div class="panel panel-default">
           <div class="panel-body">
              <g:set var="lang" value="${session.'org.springframework.web.servlet.i18n.SessionLocaleResolver.LOCALE' ?: org.springframework.web.servlet.support.RequestContextUtils.getLocale(request).toString().substring(0,2)}"/>
          		<nav id="Navbar" class="navbar" role="navigation" >
      				<ul class="nav navbar-nav">
           				<li class="controller">
        					 <h2><g:message code="springSecurity.login.header"/></h2>
        				</li>
        				<li class="controller">
        				     <g:if test='${flash.message}'>
                         		<div class='login_message'>${flash.message}</div>
                            </g:if>
        				</li>
           			</ul>
        		</nav>
        <g:form  class="form-horizontal"name="form1"  method="post" controller="wsChat" action="signup">
            <g:submitButton name="${g.message(code:'wschat.signup.label', default:'Signup')}" class="btn btn-success btn-block"/>
        </g:form>
        <br/>
        <form action='${postUrl}' method='POST' id='loginForm' class='cssform' autocomplete='off'>
            <div style="clear:both;"></div>
    	    <div class="form-group">
			    <label for='username' class="col-sm-2 control-label"><g:message code="springSecurity.login.username.label"/>:</label>
			    <div class="col-sm-4" >
			        <input type='text' name='j_username' id='username'/>
                </div>
            </div>
            <div style="clear:both;"></div>
	        <div class="form-group">
			    <label for='password' class="col-sm-2 control-label"><g:message code="springSecurity.login.password.label"/>:</label>
				<div class="col-sm-4" >
				    <input type='password'  name='j_password' id='password'/>
				</div>
			</div>
            <div style="clear:both;"></div>
			<div class="form-group">
			    <label for='remember_me' class="col-sm-2 control-label"><g:message code="springSecurity.login.remember.me.label"/></label>
			    <div class="col-sm-4" >
				    <input type='checkbox' class='chk' name='${rememberMeParameter}' id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if>/>
				 </div>
			</div>
			<div style="clear:both;"></div>
			<div class="form-group">
                  <label for="submit" class="col-sm-2 control-label"></label>
                 <div class="col-sm-4">
				    <input type='submit' class="btn btn-primary" id="submit" value="${message(code: 'springSecurity.login.button')}"/>
			    </div>
			</div>
		</form>
    </div></div></div>
</div>



<script type='text/javascript'>
(function() {
	document.forms['loginForm'].elements['j_username'].focus();
})();
</script>
</body>
</html>
