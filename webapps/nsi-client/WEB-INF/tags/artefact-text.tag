<% out = ((PageContext)jspContext).pushBody(); %>

<%@ tag body-content="empty" %>

<%@attribute name="artefact" type="org.estat.nsi.client.model.data.IdentifiableContainerClient"
             required="true" rtexprvalue="true" %>
<%@attribute name="type" type="java.lang.String" required="false" rtexprvalue="true" %>

<%@ tag import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ tag import="org.apache.commons.lang.StringUtils" %>
<%@ tag import="org.apache.commons.lang.StringEscapeUtils" %>

<%
    out = jspContext.popBody();
    String text, lang = RequestContextUtils.getLocale(request).getLanguage();

    if (StringUtils.equals(type, "name")) {
        text = artefact.getName(lang);
    } else if (StringUtils.equals(type, "description")) {
        text = artefact.getDescription(lang);
    } else if ((type == null) || StringUtils.equals(type, "display")) {
        text = artefact.getDisplayText(lang);
    } else {
        throw new IllegalArgumentException("Invalid artefact text type: " + type);
    }

    text = StringUtils.trimToEmpty(text);

    // maybe this should be executed only for categories...
    if (text.isEmpty() && ((type == null) || (StringUtils.equals(type, "display")))) {
        text = StringUtils.trimToEmpty(artefact.getId());
    }

    out.write(StringEscapeUtils.escapeHtml(text));
    return;
%>