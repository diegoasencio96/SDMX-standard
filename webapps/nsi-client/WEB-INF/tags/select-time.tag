<%@ tag body-content="empty" %>

<%@ attribute name="id" type="java.lang.String" required="true" rtexprvalue="true" %>
<%@ attribute name="currentValue" type="java.lang.String" required="false" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ tag import="java.util.GregorianCalendar" %>
<%@ tag import="java.util.Calendar" %>
<%@ tag import="java.util.ArrayList" %>
<%@ tag import="java.util.List" %>
<%@ tag import="org.estat.nsi.client.web.Constants" %>

<%
    List<String> valuesList = new ArrayList<String>();

    Calendar calendar = GregorianCalendar.getInstance();
    int currentYear = calendar.get(Calendar.YEAR);
    int currentMonth = calendar.get(Calendar.MONTH);
    int count = Constants.SELECT_YEARS_COUNT / 2;

    for (int year = currentYear - count; year <= currentYear + count; year++) {
        for (int month = 0; month < 12; month++) {
            if ((year == currentYear) && (month == currentMonth)) {
                valuesList.add("");
            }

            String value = year + "-" + (month < 9 ? "0" : "") + (month + 1);
            valuesList.add(value);
        }
    }

    jspContext.setAttribute("selectedValue", currentValue != null ? currentValue : "");
%>

<select id="${id}">
    <c:forEach var="value" items="<%=valuesList%>">
        <option<c:if test="${value eq selectedValue}"> selected="selected"</c:if>><c:out value="${value}"/></option>
    </c:forEach>
</select>