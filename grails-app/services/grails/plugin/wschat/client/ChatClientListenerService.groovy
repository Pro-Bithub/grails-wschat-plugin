package grails.plugin.wschat.client

import grails.converters.JSON
import grails.plugin.wschat.interfaces.ClientSessions

import javax.websocket.ContainerProvider
import javax.websocket.Session

public class ChatClientListenerService implements ClientSessions {

	def grailsApplication
	def wsChatRoomService
	def wsChatUserService
	def chatClientOverrideService

	def sendArrayPM(Session userSession, ArrayList user,String message) {
		user.each { cuser ->
			boolean found
			found=wsChatUserService.findUser(cuser)
			if (found) {
				userSession.basicRemote.sendText("/pm ${cuser},${message}")
			}
			if (!cuser.toString().endsWith(frontend)) {
				found=wsChatUserService.findUser(cuser+frontend)
				if (found) {
					userSession.basicRemote.sendText("/pm ${cuser+frontend},${message}")
				}
			}
		}
	}
	
	def sendPM2(Session userSession, String user,String message) {
		println "--- 0 "
		String username = userSession.userProperties.get("username") as String
		boolean found=false
		println "--- 1 "
		found=wsChatUserService.findUser(user)
		println "--- 3 "+user
		if (found) {
			println "--- 4 "+user
			println username+ " Trying to send to : "+user+" : "+message
			userSession.basicRemote.sendText("/pm ${user},${message}")
		}
		sleep(300)
		if (!user.endsWith(frontend)) {
			println "--- 5 "+user+frontend
			found=wsChatUserService.findUser(user+frontend)
			if (found) {
				println "--- 7 "+user+frontend
				userSession.basicRemote.sendText("/pm ${user+frontend},${message}")
				println username+ " Trying to send to : "+user+frontend+" : "+message
			}
		}

	}
	
	def sendPM(Session userSession, String user,String message) {
		String username = userSession.userProperties.get("username") as String
		boolean found

		found=wsChatUserService.findUser(user)
		if (found) {
			userSession.basicRemote.sendText("/pm ${user},${message}")
		}
		if (!user.endsWith(frontend)) {
			found=wsChatUserService.findUser(user+frontend)
			if (found) {
				userSession.basicRemote.sendText("/pm ${user+frontend},${message}")
			}
		}
	}

	public void sendMessage(Session userSession,final String message) {
		userSession.basicRemote.sendText(message)
	}

	public connectUserRoom  = {  String user, String room,  Closure closure ->

		String wshostname = config.hostname ?: 'localhost:8080'
		String uri="ws://${wshostname}/${appName}/${CHATAPP}/"


		Session oSession = p_connect( uri, user, room)

		try{
			closure(oSession)
		}catch(e){
			throw e
		}
		finally {
			disconnect(oSession)
		}
	}

	public connectRoom  = { String room,  Closure closure ->

		String wshostname = config.hostname ?: 'localhost:8080'
		String uri="ws://${wshostname}/${appName}/${CHATAPP}/"

		String oUsername = config.app.id ?: "[${(Math.random()*1000).intValue()}]-$room";
		Session oSession = p_connect( uri, oUsername, room)

		try{
			closure(oSession)
		}catch(e){
			throw e
		}
		finally {
			disconnect(oSession)
		}
	}

	Session connect() {
		String dbSupport = config.dbsupport ?: 'yes'
		String wshostname = config.hostname ?: 'localhost:8080'
		String uri = "ws://${wshostname}/${appName}/${CHATAPP}/"
		def room = wsChatRoomService.returnRoom(dbSupport as String)
		String oUsername = config.app.id ?: "[${(Math.random()*1000).intValue()}]-$room";
		Session csession = p_connect( uri, oUsername, room)
		return csession
	}

	Session p_connect(String _uri, String _username, String _room){
		//WsChatClientEndpoint wsChatClientEndpoint=new WsChatClientEndpoint()
		String oRoom = _room ?: config.room
		URI oUri
		if(_uri){
			oUri = URI.create(_uri+oRoom);
		}
		def container = ContainerProvider.getWebSocketContainer()
		Session oSession
		try{
			oSession = container.connectToServer(ChatClientEndpoint.class, oUri)
			oSession.basicRemote.sendText(CONNECTOR+_username)
		}catch(Exception e){
			e.printStackTrace()
			if(oSession && oSession.isOpen()){
				oSession.close()
			}
			return null
		}
		oSession.userProperties.put("username", _username)
		return  oSession
	}


	public Session disconnect(Session _oSession){
		try{
			if(_oSession && _oSession.isOpen()){
				sendMessage(_oSession, DISCONNECTOR)
			}
		}catch (Exception e){
			e.printStackTrace()
		}
		return _oSession
	}

	public void alertEvent(def _oSession,  String _event, String _context, JSON _data,
			ArrayList cusers, boolean masterNode, boolean strictMode, boolean autodisco,
			boolean frontenduser){

		def oSession = _oSession ?: connect()
		String sMessage = """{
                        "command":"event",
                        "arguments":[
                                        {
                                        "event":"$_event",
										"strictMode" : "${strictMode as String}",
										"masterNode" : "${masterNode as String}",
										"autodisco" : "${autodisco as String}",
										"frontenduser" : "${frontenduser as String}",
                                        "context":"$_context",
										"data":[${_data as String}]
                                        }
                                    ]
                        }
                    """
		//println "------------ BOOT> ${cusers} ${sMessage}"
		cusers.each { userId ->
			sendPM(oSession,
					chatClientOverrideService.getGlobalReceiverNameFromUserId(userId as String),
					sMessage.replaceAll("\t","").replaceAll("\n",""))
		}
		if (_oSession == null) {
			disconnect(oSession)
		}
	}

	private String getFrontend() {
		def cuser=config.frontenduser ?: '_frontend'
		return cuser
	}

	private getAppName(){
		grailsApplication.metadata['app.name']
	}

	private getConfig() {
		grailsApplication?.config?.wschat
	}


}
