<% out = ((PageContext)jspContext).pushBody(); %>

<%@ tag body-content="empty" %>

<%@ attribute name="id" type="java.lang.String" required="true" rtexprvalue="true" %>
<%@ attribute name="var" type="java.lang.String" required="true" rtexprvalue="false" %>

<%@ variable name-from-attribute="var" alias="result" scope="AT_END"
             variable-class="org.sdmxsource.sdmx.api.model.mutable.conceptscheme.ConceptMutableBean" %>

<%@ tag import="org.estat.nsi.client.util.Utils" %>
<%@ tag import="org.estat.nsi.client.web.SessionQueryMgr" %>

<%
    out = jspContext.popBody();
    jspContext.setAttribute("result", Utils.findConcept(SessionQueryMgr.getSessionQuery(session).getStructure(), id));

    return;
%>