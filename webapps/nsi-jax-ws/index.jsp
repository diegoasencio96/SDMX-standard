<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>

<%
String ip = request.getLocalAddr();
boolean internal = false;
if (ip.indexOf(":")>0) {
	//ip6
}
if ("10.".equals(ip.substring(0, 3))) {
	internal = true;
} else if ("192.".equals(ip.substring(0, 4)) && "168.".equals(ip.substring(4,8))) {
	internal = true;
} else if ("169.".equals(ip.substring(0, 4)) && "254.".equals(ip.substring(4,8))) {
	internal = true;
} else if ("127.".equals(ip.substring(0, 4))) {
	internal = true;
}
request.getSession().setAttribute("internal", internal);
String style = (internal ? "private": "external"); 
request.getSession().setAttribute("style", style);

String service21 = "NSIStdV21Service";
String version = "0.0.0";
InputStream is = request.getSession().getServletContext().getResourceAsStream("/META-INF/maven/org.estat/nsiws-metro/pom.properties");

// get version from pom build file depending the JAX-WS impl used in maven build.
if ( is == null) {
    is = request.getSession().getServletContext().getResourceAsStream("/META-INF/maven/org.estat/nsiws-cxf/pom.properties");
    if (is == null) {
        is = request.getSession().getServletContext().getResourceAsStream("/META-INF/maven/org.estat/nsiws-axis2-jar/pom.properties");
        if (is == null) {
            is = request.getSession().getServletContext().getResourceAsStream("/META-INF/maven/org.estat/nsiws-axis2/pom.properties");
        }
    }
}
//in case thin war is built (no WS stack)
if ( is == null) {
	is = request.getSession().getServletContext().getResourceAsStream("/META-INF/maven/org.estat/nsiws/pom.properties");
	service21 = "SdmxServiceService";
}

Properties props = new Properties();
try
{
  props.load(is);
} catch (Exception e)
{

} finally
{
  try { is.close(); } catch (Exception ex){/*ignore*/}
}

version = props.getProperty("version");

%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head >
         <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
        <meta http-equiv="PRAGMA" content="NO-CACHE" />
        <!-- common styles -->
        <link href="style/main.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div id="page-content">
        <div id="page-content-inner">
            <div id="page-header">
                <div id="page-header-left">
                </div>
                <div id="page-header-right">
                </div>
            </div>
            <div id="page-body">
                <div id="pb-workarea-pages">
                    <div id="pb-host">
                    	<h1>Request information</h1>
                        <table class="results-table">
                            <thead>
                                <tr>
                                    <th>Property</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>Root URL</th>
                                    <td><%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %></td>
                                </tr>
                                <tr>
                                    <th>Requested Host/IP</th>
                                    <td><%= request.getServerName() %></td>
                                    </tr>
                                <tr>
                                    <th>Port</th>
                                    <td><%= request.getServerPort() %></td>
                                    </tr>
                                <tr>
                                    <th>Is usable from external users</th>
                                    <td class="${style}">
	                                    <c:if test="${internal}">
	                                    	internal
	                                    </c:if>
	                                    <c:if test="${!internal}">
	                                    	external
	                                    </c:if>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div id="pb-endpoints">
                    	<h1>Endpoints</h1>
                        <table class="results-table">
                            <thead>
                             <tr>
                                 <th>Service name</th>
                                 <th>Endpoint path</th>
                                 <th>Namespace</th>
                                 <th>WSDL link</th>
                                 <th>XSD link</th>
                             </tr>
                           </thead>
                           <tbody>
                             <tr>
								<td>Standard SDMX v2.0</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIStdV20Service'>
								<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIStdV20Service</a></td>
								<td><a href="http://ec.europa.eu/eurostat/sri/service/2.0/">http://ec.europa.eu/eurostat/sri/service/2.0/</a></td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIStdV20Service?WSDL'>
								WSDL</a>
								</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIStdV20Service?SDMXMessage.xsd'>
								SDMXMessage.xsd</a>
								</td>
                	         </tr>
                             <tr>
								<td>SDMX v2.0 with Eurostat extensions</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIEstatV20Service'>
								<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIEstatV20Service</a></td>
								<td><a href="http://ec.europa.eu/eurostat/sri/service/2.0/extended">http://ec.europa.eu/eurostat/sri/service/2.0/extended</a></td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIEstatV20Service?WSDL'>
								WSDL</a>
								</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/NSIEstatV20Service?SDMXMessage.xsd'>
								SDMXMessage.xsd</a>
								</td>
                	         </tr>                	         
                	      	 <tr>
								<td>Standard SDMX v2.1</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/<%= service21 %>'>
								<jsp:expression> request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() </jsp:expression>/<%= service21 %></a></td>
								<td><a href="http://ec.europa.eu/eurostat/sri/service/2.1/">http://ec.europa.eu/eurostat/sri/service/2.1/</a></td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/<%= service21 %>?WSDL'>
								WSDL</a>
								</td>
								<td><a href='<%= request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() %>/<%= service21 %>?SDMXMessage.xsd'>
								SDMXMessage.xsd</a>
								</td>
                	         </tr>
                	      </tbody>
                	   </table>
                    </div>
                    
                </div>
                <div id="pb-help" class="help-message">
                    <h1>Remarks</h1>
                    <p>
                    	<c:if test="${internal}">
                    		This page appears to have been requested using a local or internal host name or IP. The above endpoints are not accessible from external users. Please contact your network administrator to retrieve the external hostname or IP for this web service.
                    	</c:if>
                    	<c:if test="${!internal}">
                    		This page appears to be have been requested using an external (internet) host name or IP address. External should be able to access the endpoints configured for NSI Web Service using one of the above URLs.
                    	</c:if>
                    </p>
                </div>
            </div>
            <div id="page-footer">
                <div id="page-footer-copyright">
                    Copyright (c) 2009 by the European Commission, represented by Eurostat.
                </div>
                <div id="page-footer-version">
                    v<%= version %>
                </div>
            </div>
        </div>
    </div>
    </body>
</html>
