/* ------------------------------------------------------------------------------------------------------------------ *\
 * CONSTANTS                                                                                                          *
\* ------------------------------------------------------------------------------------------------------------------ */

var NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR = "#criteria-component-tabs";
var NSIC_CRITERIA_TAB_COMPONENTS_CONTENT_SELECTOR = "#criteria-component-tabs div.ui-widget-content";
var NSIC_CRITERIA_COMPONENT_CONCEPT_SELECTOR = "#criteria-edit-concept";
var NSIC_CRITERIA_COMPONENT_TYPE_SELECTOR = "#criteria-edit-form-type";
var NSIC_CRITERIA_COMPONENT_UPDATE_WARNING_SELECTOR = "#criteria-update-warning";
var NSIC_CRITERIA_CODES_TREE_SELECTOR = "#criteria-codes-tree";
var NSIC_CRITERIA_UNCODED_VALUE = "#criteria-component-value";

// The types of pages used for editing the filter for components.
var NSIC_CRITERIA_EDIT_FORM_TIME = "time";
var NSIC_CRITERIA_EDIT_FORM_SIMPLE = "simple";
var NSIC_CRITERIA_EDIT_FORM_CODES = "codes";

// Operations for "nsicUpdateAllCodes" function.
var NSIC_OP_SELECT_ALL = 0;
var NSIC_OP_INVERT_SELECTION = 1;
var NSIC_OP_DESELECT_ALL = 2;

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the Criteria page is loaded from server.                                                               *
 *                                                                                                                    *
 * @refreshed               if TRUE then the work area page is actually reloaded without any user interaction         *
 *                          because the entire HTML page was refreshed                                                *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCriteriaPageLoaded(refreshed) {
    var startIdx = refreshed ? Math.max(0, g_nsicOptions.startCriteriaComponentIdx) : 0;

    // The tabs used for specifying the values for components. This may be useless if the user did not
    // select a dataflow yet, but won't trigger an error...
    $(NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR).tabs({
        cache: false,
        selected: startIdx,
        select: function(event, ui) {
            $(NSIC_CRITERIA_TAB_COMPONENTS_CONTENT_SELECTOR).children().remove();
        },
        load: function(event, ui) {
            nsicOnCriteriaComponentTabLoaded();
        }
    });

    // To fix a display glitch the tabs are not visible initially...
    $(NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR).show();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the size of Criteria page is changed.                                                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCriteriaPanelResized() {
    $(NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR).tabs('paging', {});
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Getter for the index of current component (starting from 0).                                                       *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicGetCriteriaCurrentComponentIdx() {
    return $(NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR).tabs("option", "selected");
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user clicks the Clear Criteria link/button.                                                        *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCriteriaClear() {
    var onResponseReceived = function(message) {
        if (message && (message.length > 0)) {
            alert(message);
        }
        nsicReloadWorkAreaPage(NSIC_WORKAREA_PAGE_CRITERIA);
    }

    if (confirm(g_nsicOptions.clearCriteriaQuestionMessage)) {
        $.ajax({
            type: 'POST',
            url: g_nsicOptions.baseURL + "ajax/criteria-clear.htm",
            data: {},
            success: function(data) {
                onResponseReceived(data);
            },
            error: function() {
                onResponseReceived();
            }
        });
    }
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called after a component tab page is loaded from server and displayed to user.                                     *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCriteriaComponentTabLoaded() {
    var index = nsicGetCriteriaCurrentComponentIdx();
    var concept = $(NSIC_CRITERIA_COMPONENT_CONCEPT_SELECTOR).html();
    var type = $(NSIC_CRITERIA_COMPONENT_TYPE_SELECTOR).html();

    // If the mandatory elements are missing then something is wrong, probably the request has failed...
    if ((concept == null) || (type == null)) {
        return;
    }

    if (type == NSIC_CRITERIA_EDIT_FORM_TIME) {
        // nothing
    } else if (type == NSIC_CRITERIA_EDIT_FORM_CODES) {
        var options = {
            plugins: [ "themes", "html_data", "ui", "checkbox", "types" ],
            themes : { theme : "apple", icons : false },
            checkbox : { two_state: true },
            "types" : {
                "types" : {
                    "disabled": {
                        "check_node" : false,
                        "uncheck_node" : false
                    },
                    "default": { "select_node" : false }
                }
            }
        };

        var nodesObj = $(NSIC_CRITERIA_CODES_TREE_SELECTOR + " li");
        if (nodesObj.length == 1) {
            nodesObj.addClass("ui-state-disabled").addClass("jstree-checked");
            nodesObj.attr("rel", "disabled");
        }

        $(NSIC_CRITERIA_CODES_TREE_SELECTOR).jstree(options);
        $(NSIC_CRITERIA_CODES_TREE_SELECTOR).show();        

        var ignoreNextEvent = false;
        $(NSIC_CRITERIA_CODES_TREE_SELECTOR).bind("change_state.jstree", function(e, data) {
            if (!ignoreNextEvent) {
                if (!nsicOnCriteriaComponentChanged(false)) {
                    var node = $(data.args[0]).parent().parent();
                    ignoreNextEvent = true;
                    data.inst.change_state(node);
                    ignoreNextEvent = false;
                }
            }
        });
    } else {
        // nothing
    }

    $(".button").button();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Reloads current components tab page.                                                                               *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicReloadCurrentCriteriaComponent() {
    var tabObj = $(NSIC_CRITERIA_TAB_COMPONENTS_SELECTOR);
    var selectedIdx = tabObj.tabs("option", "selected");
    if (selectedIdx >= 0) {
        $(NSIC_CRITERIA_TAB_COMPONENTS_CONTENT_SELECTOR).children().remove();
        tabObj.tabs("load", selectedIdx);
    }
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user changes the value of current component.                                                       *
 *                                                                                                                    *
 * Note that because asynchronous Ajax requests are used for communicating with the server, even if the function      *
 * returns TRUE the change may still be rejected by server. If this happens component's tab page will                 *
 * be simply reloaded.                                                                                                *
 *                                                                                                                    *
 * @disableWarning          if TRUE then no warning message regarding the update will be displayed to user            *
 *                                                                                                                    *
 * Returns TRUE to allow the change, FALSE otherwise.                                                                 *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCriteriaComponentChanged(disableWarning) {
    var type = $(NSIC_CRITERIA_COMPONENT_TYPE_SELECTOR).html();

    if (!disableWarning) {
        if ($(NSIC_CRITERIA_COMPONENT_UPDATE_WARNING_SELECTOR).html() != "false") {
            if (!confirm(g_nsicOptions.updateCriteriaQuestionMessage)) {
                return false;
            }
        }
    }

    var succeeded = true;

    if (type == NSIC_CRITERIA_EDIT_FORM_CODES) {
        succeeded = nsicCriteriaUpdateCodes();
    } else if (type == NSIC_CRITERIA_EDIT_FORM_SIMPLE) {
        succeeded = nsicCriteriaUpdateUncoded();
    } else {
        succeeded = nsicCriteriaUpdateTime();
    }

    if (succeeded) {
        $(NSIC_CRITERIA_COMPONENT_UPDATE_WARNING_SELECTOR).html("false");
    }

    return succeeded;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Sends an Ajax request to server for updating the data for a component.                                             *
 *                                                                                                                    *
 * If fails the tab page for current component will be reloaded from server.                                          *
 *                                                                                                                    *
 * @relativeURL             the URL where to send the request; it is relative to baseURL                              *
 * @postData                the data to send to server                                                                *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCriteriaUpdateComponent(relativeURL, postData) {
    $.ajax({
        type: 'POST',
        url: g_nsicOptions.baseURL + relativeURL,
        data: postData,
        success: function(data) {
            if (data.length > 0) {
                alert(data);
                nsicReloadCurrentCriteriaComponent();
            }
        },
        error: function() {
            nsicReloadCurrentCriteriaComponent();
        }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Sends a request to server to save the new codes for a component.                                                   *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCriteriaUpdateCodes() {
    var ids = [];
    $(NSIC_CRITERIA_CODES_TREE_SELECTOR).find("li.jstree-checked").each(function(index) {
        ids.push(this.id.substr(4));
    });

    nsicCriteriaUpdateComponent("ajax/criteria-component-save.htm", {
        concept: $(NSIC_CRITERIA_COMPONENT_CONCEPT_SELECTOR).html(),
        ids: ids
    });
    
    return true;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when select all, deselect all or toggle current selection for a list of codes.                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCriteriaUpdateAllCodes(operation) {
    var treeObj = $("#criteria-codes-tree");

    var items = [];

    if (operation == NSIC_OP_SELECT_ALL) {
        treeObj.find("li.jstree-unchecked").each(function(index) {
            items.push(this);
        });
    } else if (operation == NSIC_OP_DESELECT_ALL) {
        treeObj.find("li.jstree-checked").each(function(index) {
            items.push(this);
        });
    } else if (operation == NSIC_OP_INVERT_SELECTION) {
        treeObj.find("li").each(function(index) {
            items.push(this);
        });
    }

    if (items.length == 0) {
        return;
    }

    if ($(NSIC_CRITERIA_COMPONENT_UPDATE_WARNING_SELECTOR).html() != "false") {
        if (!confirm(g_nsicOptions.updateCriteriaQuestionMessage)) {
            return;
        }
    }

    for (var i in items) {
        var obj = $(items[i]);
        if (obj.hasClass("jstree-unchecked")) {
            obj.removeClass("jstree-unchecked").addClass("jstree-checked");
        } else if (obj.hasClass("jstree-checked")) {
            obj.removeClass("jstree-checked").addClass("jstree-unchecked");
        }
    }

    nsicOnCriteriaComponentChanged(true);
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Saves a simple/un-coded component.                                                                                          *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCriteriaUpdateUncoded() {
    nsicCriteriaUpdateComponent("ajax/criteria-simple-component-save.htm", {
        concept: $(NSIC_CRITERIA_COMPONENT_CONCEPT_SELECTOR).html(),
        value: $(NSIC_CRITERIA_UNCODED_VALUE).val()
    });
    
    return true;
}
/* ------------------------------------------------------------------------------------------------------------------ *\
 * Saves a time component.                                                                                            *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCriteriaUpdateTime() {
	var startDate = "", endDate = "";
	
	startDate = $("#start-date-picker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	endDate = $("#end-date-picker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	
    if (startDate != "") {
        $("#end-date-picker").datepicker("option", "minDate", startDate);
        $("#end-date-picker").datepicker("option", "disable", false);
    } else {    	
        $("#end-date-picker").val('');
        $("#end-date-picker").datepicker("option", "disable", true);
    }

    nsicCriteriaUpdateComponent("ajax/criteria-time-component-save.htm", {
        start: startDate,
        end: endDate
    });

    return true;
}
