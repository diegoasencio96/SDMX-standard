<% out = ((PageContext)jspContext).pushBody(); %>

<%@ tag body-content="empty" %>

<%@ attribute name="dataflow" type="org.sdmxsource.sdmx.sdmxbeans.model.mutable.metadatastructure.DataflowMutableBeanImpl"
              required="true" rtexprvalue="true" %>
<%@ attribute name="htmlEscape" type="java.lang.Boolean" required="false" rtexprvalue="true" %>
<%@ attribute name="javaScriptEscape" type="java.lang.Boolean" required="false" rtexprvalue="true" %>
<%@ attribute name="jqueryEscape" type="java.lang.Boolean" required="false" rtexprvalue="true" %>

<%@ tag import="org.springframework.context.ApplicationContext" %>
<%@ tag import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ tag import="java.util.Locale" %>

<%
    out = jspContext.popBody();

    if (dataflow == null) {
        return;
    }
    
    PageContext pageCtx = (PageContext) jspContext;
    ApplicationContext appCtx =
            WebApplicationContextUtils.getWebApplicationContext(pageCtx.getServletContext());
    Locale locale = RequestContextUtils.getLocale(request);

    String result = appCtx.getMessage("format.dataflow.id", new Object[]{
            dataflow.getAgencyId(), dataflow.getId(), dataflow.getVersion().replace('.', '_')}, locale);

    if ((htmlEscape != null) && htmlEscape) {
        result = StringEscapeUtils.escapeHtml(result);
    }

    if ((jqueryEscape != null) && jqueryEscape) {
        result = result.replaceAll("([#;&,\\.\\+\\*~':\"!\\^\\$\\[\\]\\(\\)=>\\|/@ ])", "\\\\$1");
    }

    if ((jqueryEscape != null) && jqueryEscape && (javaScriptEscape != null) && javaScriptEscape) {
        result = StringEscapeUtils.escapeJavaScript(result);
    }

    out.write(result);
    return;
%>