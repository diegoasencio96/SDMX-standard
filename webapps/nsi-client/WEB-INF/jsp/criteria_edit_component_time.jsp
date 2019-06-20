<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="tags" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Date" %>

<%-- this are used for passing data to "nsi-client.js" functions --%>
<div style="display:none">
    <div id="criteria-edit-form-type">time</div>
    <div id="criteria-edit-concept"><c:out value="${queryComponent.concept}"/></div>
    <div id="criteria-update-warning"><c:out value="${warnOnUpdate}"/></div>    
</div>

<%-- the help message --%>
<div class="help-message"><spring:message code="html.criteria.help.time" htmlEscape="false"/></div>

<%
    Date minStartDate = (Date) pageContext.findAttribute("minStartDate");
    Date maxEndDate = (Date) pageContext.findAttribute("maxEndDate");    
    
    String selStartDate = (String) pageContext.findAttribute("selectedStartDate");
    String selEndDate = (String) pageContext.findAttribute("selectedEndDate");
    
    long startDateLong = minStartDate.getTime();
    long endDateLong = maxEndDate.getTime();
%>

<form action="" id="criteria-time-form">

<table id="criteria-edit-time">
    <tr>
        <td class="time-label"><spring:message code="label.time_start"/></td>
        <td>
        	<input name="startDate" id="start-date-picker" class="date-picker" onchange="onTimeComponentChange();"/>
        </td>
    </tr>
    <tr>
        <td class="time-label"><spring:message code="label.time_end"/></td>
        <td>
        	<input name="endDate" id="end-date-picker" class="date-picker" onmouseover="onEndDateClick();" onchange="onTimeComponentChange();"/>
        </td>
    </tr>
</table>

</form>

<%-- used for clearing the elements with data --%>
<script type="text/javascript">
    var startDateObj = $("#start-date-picker");
    var endDateObj = $("#end-date-picker");    
    
    var stDate = <%=startDateLong%>;
    var enDate = <%=endDateLong%>;      

    <%-- --%>
	$(function() {
		$('#start-date-picker').datepicker({
			defaultDate: new Date(stDate),
			minDate: new Date(stDate),
			maxDate: new Date(enDate),
			dateFormat: 'yy-mm-dd',
			constrainInput: true
		});
	});
	
	$(function() {
		$('#end-date-picker').datepicker({
			defaultDate: new Date(enDate),
			minDate: new Date(stDate),
			maxDate: new Date(enDate),
			dateFormat: 'yy-mm-dd',
			constrainInput: true
		});
	});
	
	function onEndDateClick() {
		var startDate = "", endDate = "";
		
		startDate = $("#start-date-picker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		endDate = $("#end-date-picker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	
		if (startDate != "") {
			$("#end-date-picker").datepicker("option", "minDate", startDate);
			$("#end-date-picker").datepicker('enable');
		} else {    	
			$("#end-date-picker").val('');
			$("#end-date-picker").datepicker('disable');
		}
	};
	
    function onTimeComponentChange() {
        if (!nsicOnCriteriaComponentChanged(false)) {
            // reset
        }
    }
    
    function setupElements() {    	
    	if (<%=selStartDate != null && !"".equals(selStartDate)%>) { 
    		startDateObj.val("<%=selStartDate%>");
    	}
    	
    	if (<%=selEndDate != null && !"".equals(selEndDate)%>) { 
    		endDateObj.val("<%=selEndDate%>");
    	}
    }
    
    <%-- Setups the time elements for the first time. --%>
    setupElements();

</script>
