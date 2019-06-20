/* ------------------------------------------------------------------------------------------------------------------ *\
 * CONSTANTS                                                                                                          *
\* ------------------------------------------------------------------------------------------------------------------ */

// The status code sent by server when the current HTTP session is invalid.
var NSIC_HTTP_SC_AJAX_INVALID_SESSION = 599;
//The status code sent by server when the error is no data found.
var HTTP_SC_AJAX_ERROR_NO_DATA_FOUND = 9000;

// Main page elements.
var NSIC_PAGE_CONTENT_SELECTOR = "#page-content";
var NSIC_PAGE_CONTENT_INNER_SELECTOR = "#page-content-inner";
var NSIC_PAGE_CONTENT_BODY_SELECTOR = "#page-body";

// Main page body elements.
var NSIC_PAGE_BODY_CONTENT_SELECTOR = "#pb-content";
var NSIC_PAGE_BODY_DATAFLOWS_SELECTOR = "#pb-dataflows";
var NSIC_PAGE_BODY_WORKAREA_SELECTOR = "#pb-workarea";

// The selectors for elements used for changing current language.
var NSIC_CHANGE_LOCALE_FORM_SELECTOR = "#change-locale-form";
var NSIC_CHANGE_LOCALE_WORK_PAGE_IDX_SELECTOR = "#change-locale-work-page-idx";
var NSIC_CHANGE_LOCALE_CRITERIA_COMPONENT_IDX_SELECTOR = "#change-locale-criteria-component-idx";
var NSIC_CHANGE_LOCALE_COMBOBOX_SELECTOR = "#change-locale-combobox";

// This must be updated whenever the version of the jsTree library is changed.
var NSIC_JSTREE_THEMES_PATH = 'jstree_pre1.0_stable/themes/';

// Main work area pages.
var NSIC_WORKAREA_PAGE_CRITERIA = 0;
var NSIC_WORKAREA_PAGE_RESULTS = 1;

/* ------------------------------------------------------------------------------------------------------------------ *\
 * GLOBALS                                                                                                            *
\* ------------------------------------------------------------------------------------------------------------------ */

/**
 * The options and their default values.
 */
var g_nsicOptions = {
    baseURL: "http://localhost:8080/nsi-client/",
    ajaxErrorMessage: "(default) Failed to send/receive data to/from server!",
    currentDataflowElmId: "",
    clearCriteriaQuestionMessage: "(default) Are you sure?",
    updateCriteriaQuestionMessage: "(default) Update?",
    startWorkPageIdx: -1,
    startCriteriaComponentIdx: -1,
    labelDownload: "(default) Download",
    labelCancel: "(default) Cancel",
    dragSingleSliceComponentError: "(default) Drag Single Slice Component",
    errorMessageText: "(default) No results found"
};

var g_nsicPageBodyLayout = null;

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Initialization.                                                                                                    *
 *                                                                                                                    *
 * This must be the first function called. There's no need to be called before the page is fully loaded, instead      *
 * it should be called as soon as possible, but after jQuery is included.                                             *
 *                                                                                                                    *
 * @options                 the options (see g_nsicOptions global var)                                                *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicSetup(options) {
    $.extend(g_nsicOptions, options);

    // The URL must end with a '/' character...
    if (g_nsicOptions.baseURL[g_nsicOptions.baseURL.length - 1] != '/') {
        g_nsicOptions.baseURL += "/";
    }

    // All Ajax request must be asynchronous to allow the browser to update the UI during calls, but they
    // must not be cached...
    $.ajaxSetup({
        async: true, cache: false, timeout: 0
    });

    // The Ajax error handler...
    $(document).ajaxError(nsicOnAjaxError);

    // The user must not be able to use the GUI during an Ajax request...
    $(document).ajaxStart(nsicOnAjaxStart).ajaxStop(nsicOnAjaxStop);

    // The overlay should be invisible, otherwise it is annoying...
    $.blockUI.defaults.overlayCSS.opacity = 0;

    // The jsTree plugin does not always detect the correct path for available themes...
    $.jstree._themes = g_nsicOptions.baseURL + NSIC_JSTREE_THEMES_PATH;

    $(function() {
        nsicSetupPageLayout();
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * jQuery event handler called whenever an Ajax request completes with an error.                                      *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnAjaxError(event, req, options, error) {
    if (req.status == NSIC_HTTP_SC_AJAX_INVALID_SESSION) {
        window.location = g_nsicOptions.baseURL + "invalid-session.htm?_=" + Math.random();
    } else if (req.status == HTTP_SC_AJAX_ERROR_NO_DATA_FOUND){
			alert(g_nsicOptions.errorMessageText);
			window.location = g_nsicOptions.baseURL + "start.htm";
    } else {
		alert(g_nsicOptions.ajaxErrorMessage);
	}
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * jQuery event handler called before an Ajax request is sent to server.                                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnAjaxStart() {
    $.unblockUI({ fadeOut: 0 });

    $.blockUI({
        message: $("#dialog-wait"), fadeIn: 0, fadeOut: 100, showOverlay: true,
        css: { border: 0 }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * jQuery event handler called after an Ajax request completes (successfully or with an error).                       *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnAjaxStop() {
    $.unblockUI();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Pings the server.                                                                                                  *
 *                                                                                                                    *
 * This function may look useless, but actually it can be used for displaying the "Please wait..." message            *
 * if the server is already processing a request for this session, because theoretically the ping request will be     *
 * queued (as long as the server accepts only one request per session).                                               *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicPingServer() {
    $.ajax({
        type: 'POST',
        url: g_nsicOptions.baseURL + "ajax/ping.htm",
        data: {}
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Setups the main page layout (with header, toolbar, body and footer elements).                                      *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicSetupPageLayout() {
    $(NSIC_PAGE_CONTENT_SELECTOR).layout({
        applyDefaultStyles: false,
        center__paneSelector: NSIC_PAGE_CONTENT_INNER_SELECTOR,
        center__contentSelector: NSIC_PAGE_CONTENT_BODY_SELECTOR
    });

    nsicSetupPageBodyContent();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Setups the layout for main page body: the dataflow tree on the left panel, the criteria and results                *
 * pages into right panel.                                                                                            *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicSetupPageBodyContent() {
    nsicSetupDataflowsPanel();

    var openCloseFunc = function(panelName) {
        // if the west panel is closed (the one with dataflows) then the right
        // panel is resized; I'm smart, huh? :D
        if (panelName == "west") {
            nsicOnWorkAreaPanelResized();
        }
    };

    // the layout (west panel = dataflows, center panel = criteria & view results pages
    g_nsicPageBodyLayout = $(NSIC_PAGE_BODY_CONTENT_SELECTOR).layout({
        applyDefaultStyles: false,
        center__paneSelector: NSIC_PAGE_BODY_WORKAREA_SELECTOR,
        west__paneSelector: NSIC_PAGE_BODY_DATAFLOWS_SELECTOR,
        west__size: 431, /* the right pane has 525px by default */
        onresize: function(name) {
            if (name == "center") {
                nsicOnWorkAreaPanelResized();
            }
        },
        onopen: openCloseFunc,
        onclose: openCloseFunc
    });

    var firstTimeLoad = true;

    // the tabs for center panel...
    $(NSIC_PAGE_BODY_WORKAREA_SELECTOR).tabs({
        cache: false,
        selected: Math.min(Math.max(0, g_nsicOptions.startWorkPageIdx), NSIC_WORKAREA_PAGE_RESULTS),
        select: function(event, ui) {
            return nsicOnWorkAreaPageSelected(ui.index);
        },
        load: function(event, ui) {
            nsicOnWorkAreaPageLoaded(ui.index, firstTimeLoad && (g_nsicOptions.startWorkPageIdx == ui.index));
            firstTimeLoad = false;
        }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Closes the dataflows panel.                                                                                        *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicCloseDataflowsPanel() {
    g_nsicPageBodyLayout.close("west");
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user selects a tab page.                                                                       *
 *                                                                                                                    *
 * This is not called for the work area page which is displayed for the first time (when the tab control is created). *
 *                                                                                                                    *
 * Returns TRUE to allow the change, FALSE to keep the current page as the selected one.                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnWorkAreaPageSelected(idx) {
    if ((idx == NSIC_WORKAREA_PAGE_RESULTS) && !nsicOnResultsPageSelected()) {
        return false;
    }

    $(NSIC_PAGE_BODY_WORKAREA_SELECTOR + " div.ui-widget-content").children().remove();
    return true;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever a page from work area is loaded.                                                                   *
 *                                                                                                                    *
 * @idx                     the index of the work area page (one of NSIC_WORKAREA_PAGE_??? constants)                 *
 * @refreshed               if TRUE then the work area page is actually reloaded without any user interaction         *
 *                          because the entire HTML page was refreshed (because current language has changed for      *
 *                          example); this has nothing to do with browser's reload/refresh operation                  *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnWorkAreaPageLoaded(idx, refreshed) {
    if (idx == NSIC_WORKAREA_PAGE_CRITERIA) {
        nsicOnCriteriaPageLoaded(refreshed);
    } else {
        nsicOnResultsPageLoaded(refreshed);
    }

    nsicOnWorkAreaPanelResized();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Reloads and selects a page from work area panel.                                                                   *
 *                                                                                                                    *
 * @idx                     the index of the page to reload (one of NSIC_WORKAREA_PAGE_??? constants)                 *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicReloadWorkAreaPage(idx) {
    var tabObj = $(NSIC_PAGE_BODY_WORKAREA_SELECTOR);

    if (tabObj.tabs("option", "selected") == idx) {
        tabObj.tabs("load", idx);
    } else {
        tabObj.tabs("select", idx);
    }
}
/* ------------------------------------------------------------------------------------------------------------------ *\
 * Enables or disables a page from work area panel.                                                                   *
 *                                                                                                                    *
 * @idx                     the index of the page to enable/disable (one of NSIC_WORKAREA_PAGE_??? constants)         *
 * @enable                  if TRUE the page will be enabled, if FALSE it will be disabled                            *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicEnableWorkAreaPage(idx, enable) {
    $(NSIC_PAGE_BODY_WORKAREA_SELECTOR).tabs(enable ? "enable" : "disable", idx);
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the size of the current work area panel have changed.                                              *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnWorkAreaPanelResized() {
    if ($(NSIC_PAGE_BODY_WORKAREA_SELECTOR).tabs("option", "selected") == NSIC_WORKAREA_PAGE_CRITERIA) {
        nsicOnCriteriaPanelResized();
    } else {
        nsicOnResultsPanelResized();
    }
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user changes current language.                                                                 *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnLanguageChange() {
    if (nsicIsDataflowSelected()) {
        workPageIdx = $(NSIC_PAGE_BODY_WORKAREA_SELECTOR).tabs("option", "selected");
        currentComponentIdx = workPageIdx == NSIC_WORKAREA_PAGE_CRITERIA ? nsicGetCriteriaCurrentComponentIdx() : -1;
    } else {
        workPageIdx = -1;
        currentComponentIdx = -1;
    }

    $(NSIC_CHANGE_LOCALE_WORK_PAGE_IDX_SELECTOR).val(workPageIdx);
    $(NSIC_CHANGE_LOCALE_CRITERIA_COMPONENT_IDX_SELECTOR).val(currentComponentIdx);

    $(NSIC_CHANGE_LOCALE_FORM_SELECTOR).submit();
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called when the user clicks a download link.                                                                       *
 *                                                                                                                    *
 * @type                    the type of the download                                                                  *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicStartDownload(type, title) {
    if (typeof(nsicStartDownload.widths) == 'undefined') {
        nsicStartDownload.widths = new Object();
    }

    if (type != "html") {
        var elm = $("#dl-" + type);
        if (typeof(nsicStartDownload.widths[type]) == 'undefined') {
            nsicStartDownload.widths[type] = Math.min(600, Math.max(300, elm.width()));
        }

        $("#dl-" + type).dialog({
            modal: true,
            resizable: false,
            title: typeof(title) == "string" ? title : "Download",
            width: nsicStartDownload.widths[type],
            buttons: [
                {
                    text: g_nsicOptions.labelDownload,
                    click: function() {
                        $("#dl-" + type).dialog("close");
                        $("#dl-form-" + type).submit();
                        nsicPingServer();
                    }
                },
                {
                    text: g_nsicOptions.labelCancel,
                    click: function() {
                        $("#dl-" + type).dialog("close");
                    }
                }
            ]
        });
    } else {
        $("#dl-form-" + type).submit();
        nsicPingServer();
    }
}
