<%@ tag %>

<%@ attribute name="type" type="java.lang.String" required="true" rtexprvalue="true" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div id="dl-${type}" style="display:none">
    <form id="dl-form-${type}" method="POST" target="dl-frame" action="<c:url value="/download/results-${type}.htm"/>">
        <jsp:doBody/>
    </form>
</div>
