<div class='modal-header'><span class="modalHeading"><h4><g:message code="wschat.view.users.label" default="view users"/></h4></span>
	<button type='button' class='close' data-dismiss='modal'
			aria-hidden='true'>×</button>
</div>
<div class="modal-body">
	<div class=heading1>
		<g:message code="wschat.search.label" default="Search"/>:
		<g:remoteField name="mq"  id="searchform"  update="resultSet" paramName="mq" url="[controller:'wsChat', action:'search']"></g:remoteField>
	</div>

	<div id="resultSet">
		<g:render template="/admin/userList" model="${[bean:bean]}"/>
	</div>

	<div class="pagination">
		<util:remotePaginate controller="wsChat" action="viewUsers" update="${bean.divupdate}"
             params="[max: bean.max,
                      divupdate:bean.divupdate,
                      id:bean.inputid,
                      s:bean.s,
                      order:bean.order,
                      sortby:bean.sortby,
                      offset:bean.offset,  viewtype: 'na']"
             total="${bean.userListCount}"
             pageSizes="[2: '2', 10:'10 Per Page', 20: '20 Per Page', 50:'50 Per Page',
                         100:'100 Per Page',250:'250 Per Page',500:'500 Per Page',1000:'1000 Per Page']" />
	</div>
</div>

