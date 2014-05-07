<%@page import="com.sogou.qadev.service.cynthia.util.CynthiaUtil"%>
<%@ page contentType="text/xml; charset=UTF-8" %>

<%@ page import="com.sogou.qadev.service.cynthia.factory.DataAccessFactory"%>
<%@ page import="com.sogou.qadev.service.cynthia.service.DataAccessSession"%>
<%@ page import="com.sogou.qadev.service.cynthia.bean.UUID"%>
<%@ page import="com.sogou.qadev.service.login.bean.Key"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.Document"%>
<%@ page import="com.sogou.qadev.service.cynthia.util.ConfigUtil"%>

<%@ include file="initMain.function.jsp"%>

<%
	out.clear();
	
	Key key = (Key)session.getAttribute("key");
	Long keyId = (Long)session.getAttribute("kid");
	
	if(keyId == null || keyId <= 0 || key == null){
		response.sendRedirect(ConfigUtil.getCynthiaWebRoot());
		return;
	}
	
	DataAccessSession das = DataAccessFactory.getInstance().createDataAccessSession(key.getUsername(), keyId);
	
	String templateTypeIdStr = request.getParameter("templateTypeId");
	String[] templateIdStrArray = request.getParameterValues("templateId");
	
	StringBuffer xmlb = new StringBuffer(64);
	xmlb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	xmlb.append("<root>");
	xmlb.append("<isError>false</isError>");
	xmlb.append("</root>");

	Document doc = XMLUtil.string2Document(xmlb.toString(), "UTF-8");
	
	Node rootNode = XMLUtil.getSingleNode(doc, "root");
	
	//template type
	if(templateTypeIdStr != null)
	{
		Node templateTypeNode = doc.createElement("templateType");
		rootNode.appendChild(templateTypeNode);
		
		XMLUtil.setAttribute(templateTypeNode, "id", templateTypeIdStr);
		
		UUID templateTypeId = DataAccessFactory.getInstance().createUUID(templateTypeIdStr);
		String content = queryTemplateTypeHTML(das, templateTypeId, null, null, null, 0);
		if(content != null)
		templateTypeNode.setTextContent(content);
	}
	//templates
	else
	{
		Node templatesNode = doc.createElement("templates");
		rootNode.appendChild(templatesNode);
		Set<String> allUsersSet = new HashSet<String>();
		
		for(String templateIdStr : templateIdStrArray)
		{ 
			Node templateNode = doc.createElement("template");
			templatesNode.appendChild(templateNode);
			
			XMLUtil.setAttribute(templateNode, "id", templateIdStr);
			
			UUID templateId = DataAccessFactory.getInstance().createUUID(templateIdStr);
			String content = queryTemplateNodeHTML(das, templateId, null, null, null, 0);
			String[] users = queryFlowUsersByTemplateId(das,templateId);
			if(users!=null)
				allUsersSet.addAll(Arrays.asList(users));
				
			if(content != null)
				templateNode.setTextContent(content);
		}
		
		Node relatedUsers = doc.createElement("relatedusers");
		for(String user : allUsersSet)
		{
			Node userNode = doc.createElement("user");
			Node userNameNode = doc.createElement("username");
			Node userAliasNode = doc.createElement("useralias");
			userNameNode.setTextContent(user);
			String userAlias = CynthiaUtil.getUserAlias(user, das);
			userNameNode.setTextContent(user);
			userAliasNode.setTextContent(userAlias);
			userNode.appendChild(userNameNode);
			userNode.appendChild(userAliasNode);	
			relatedUsers.appendChild(userNode);
		}
		
		rootNode.appendChild(relatedUsers);
	}
	
	out.clear();
	out.println(XMLUtil.document2String(doc, "UTF-8"));
%>