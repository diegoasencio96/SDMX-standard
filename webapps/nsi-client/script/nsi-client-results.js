/* ------------------------------------------------------------------------------------------------------------------ *\
 * CONSTANTS                                                                                                          *
\* ------------------------------------------------------------------------------------------------------------------ */

var NSIC_RESULTS_CONTAINER_SELECTOR = "#results-container";
var NSIC_RESULTS_WAIT_MESSAGE_SELECTOR = "#results-wait";
var NSIC_RESULTS_ERROR_MESSAGE_SELECTOR = "#results-error";

// these must match the values defined into DataSetModel.KeyValueDisplayMode enumeration
var NSIC_RESULTS_DISPLAY_MODE_TEXT = 0;
var NSIC_RESULTS_DISPLAY_MODE_VALUE_AND_TEXT = 1;
var NSIC_RESULTS_DISPLAY_MODE_VALUE = 2;

var g_SkipCheckObsLimit = false;

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user selects the Results page.                                                                 *
 *                                                                                                                    *
 * Returns TRUE to allow the change, FALSE to keep the current page as the selected one.                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsPageSelected() {
    if (g_SkipCheckObsLimit) {
        return true;
    }
    
    $.get(g_nsicOptions.baseURL + "ajax/results/check-obs-limit.htm", function(data) {
            // If the server sent back a response then an warning message must be displayed to user...
            if (data.length > 0) {
 /*               if (!confirm(data)) {
                    return; // the change was denied by user
                }*/
            	alert(data);
            	return;
            }

            g_SkipCheckObsLimit = true;
            nsicReloadWorkAreaPage(NSIC_WORKAREA_PAGE_RESULTS);
            g_SkipCheckObsLimit = false;
        }
    );

    return false;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the Results page is loaded from server.                                                                *
 *                                                                                                                    *
 * First this gets the real content of the page from server, as the current one is a wait message. The request        *
 * may require lots of seconds or even minutes, because data needs to be retrieved, processed etc...                  *
 *                                                                                                                    *
 * @refreshed               if TRUE then the work area page is actually reloaded without any user interaction         *
 *                          because the entire HTML page was refreshed                                                *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsPageLoaded(refreshed) {
    var url = refreshed ? "ajax/results/refresh.htm" : "ajax/results/main.htm";

    $(NSIC_RESULTS_CONTAINER_SELECTOR).load(g_nsicOptions.baseURL + url, {},
        function(text, status, request) {
            // first hide any wait message (if any)...
            $(NSIC_RESULTS_WAIT_MESSAGE_SELECTOR).hide();

            // if failed show the error message and ... that's all...
            if (status != "success") {
                $(NSIC_RESULTS_ERROR_MESSAGE_SELECTOR).show();
            } else {
                nsicCloseDataflowsPanel();
                nsicSetupResultsPanel();
            }
        }
    );
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the size of Results page is changed.                                                                   *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsPanelResized() {
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 *                                                                                                                    *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicSetupResultsPanel() {
    var changesMade = false;

    // creates the sortable lists...
    $(".results-table .results-layout-axis").sortable({
        items: "li:not(.fixed)",
        connectWith: ".results-table .results-layout-axis",
        update: function(event, ui) {
            // This is called once if the user just sorted the elements, twice if the user moved an
            // element from a list to another. In the first case the call won't contain any sender information.
            // In the second case the first call will be for source list (without a sender), while the
            // second call will be the destination list (the sender being set).
            if (!ui.sender) {
                // The visibility for apply/cancel buttons is not changed here because the operation may be
                // cancelled in "receive" callback.
                changesMade = true;
            }
        },
        receive: function(event, ui) {
            var item = ui.item;
            if (item.hasClass("component-slice-single")) {
                // This is called only for the destination list of a drag&drop operation, after the update callback
                // was called for source list and before the update callback will be called for
                // destination list.

                ui.sender.sortable("cancel");
                alert(g_nsicOptions.dragSingleSliceComponentError);

                // Don't change the visibility of apply/cancel buttons.
                changesMade = false;
            }
        },
        stop: function(event, ui) {
            // This is called at the end of a sorting/drag&drop operation.
            if (changesMade) {
                $("#results-button-apply").show();
                $("#results-button-cancel").show();
            }
        }
    });

    // the buttons
    $(".button").button();

    $("#results-button-apply").hide();
    $("#results-button-cancel").hide();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Reloads the content of results page.                                                                               *
 *                                                                                                                    *
 * @relativeURL             the URL where to send the request; it is relative to baseURL                              *
 * @postData                the data to send to server                                                                *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicUpdateResultsPageContent(relativeURL, postData) {
    $(NSIC_RESULTS_CONTAINER_SELECTOR).load(g_nsicOptions.baseURL + relativeURL, postData,
        function(text, status, request) {
            if (status == "success") {
                nsicSetupResultsPanel();
                nsicOnResultsPanelResized();
            }
        }
    );
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user clicks the Apply button.                                                                      *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsApplyButtonClicked() {
    var z = [], h =[], v = [];
    $("#results-axis-slice .results-layout-axis div.component").each(function() {
        z.push(this.id.substr(4));
    });
    $("#results-axis-horizontal .results-layout-axis div.component").each(function() {
        h.push(this.id.substr(4));
    });
    $("#results-axis-vertical .results-layout-axis div.component").each(function() {
        v.push(this.id.substr(4));
    });

    nsicUpdateResultsPageContent("ajax/results/update-layout.htm", { 'z': z, 'h' : h, 'v' : v});
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user clicks the Cancel button.                                                                     *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsCancelButtonClicked() {
    nsicUpdateResultsPageContent("ajax/results/refresh.htm", {});
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user clicks the Reset Display Mode button.                                                         *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnResultsResetDisplayModeClicked() {
    nsicUpdateResultsPageContent("ajax/results/reset-display-mode.htm", {});
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user changes the value of a slice key.                                                         *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnSliceKeyValueChanged(selectElm) {
    nsicUpdateResultsPageContent("ajax/results/update-slice-key.htm", {
        'key': selectElm.id.substr(4),
        'value': $(selectElm).val()
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user clicks on a toggleable key title cell.                                                    *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnKeyTitleClick(cellElm) {
    var key = $(cellElm).attr("sdmx_key");

    $.ajax({
        type: 'POST',
        url: g_nsicOptions.baseURL + "ajax/results/toggle-key-display.htm",
        data: {key : key},
        success: function(data) {
            $("td[sdmx_key=\"" + key + "\"]").each(function() {
                if (this != cellElm) {
                    nsicToggleKeyValue(this);
                }
            });
        }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user clicks on a toggleable key value cell.                                                    *
 *                                                                                                                    *
 * @cellElm                 the table cell element which was clicked                                                  *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnKeyValueClick(cellElm) {
    var key = $(cellElm).attr("sdmx_key");
    var value = $(cellElm).attr("sdmx_value");

    $.ajax({
        type: 'POST',
        url: g_nsicOptions.baseURL + "ajax/results/toggle-value-display.htm",
        data: { key : key, value : value },
        success: function(data) {
            $("td[sdmx_key=\"" + key + "\"][sdmx_value=\"" + value + "\"]").each(function() {
                nsicToggleKeyValue(this);
            });
        }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Toggles the key value displayed into a cell.                                                                       *
 *                                                                                                                    *
 * @cellElm                 the table cell element for which to toggle the content                                    *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicToggleKeyValue(cellElm) {
    var cellObj = $(cellElm);

    var displayMode = cellObj.attr("display_mode");

    displayMode = (displayMode + 1) % 3;
    cellObj.attr("display_mode", displayMode);

    var newValue, newTitle;

    switch (displayMode) {
        case NSIC_RESULTS_DISPLAY_MODE_TEXT:
            newValue = cellObj.attr("sdmx_text");
            newTitle = cellObj.attr("sdmx_value");
            break;
        case NSIC_RESULTS_DISPLAY_MODE_VALUE_AND_TEXT:
            newValue = "[" + cellObj.attr("sdmx_value") + "] " + cellObj.attr("sdmx_text");
            newTitle = null;
            break;
        default:
            newValue = cellObj.attr("sdmx_value");
            newTitle = cellObj.attr("sdmx_text");
    }

    cellElm.firstChild.nodeValue = newValue;
    if (newTitle != null) {
        $(cellElm).attr("title", newTitle);
    } else {
        $(cellElm).removeAttr("title");
    }
}
