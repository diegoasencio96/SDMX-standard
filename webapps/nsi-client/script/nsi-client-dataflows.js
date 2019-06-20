/* ------------------------------------------------------------------------------------------------------------------ *\
 * CONSTANTS                                                                                                          *
\* ------------------------------------------------------------------------------------------------------------------ */

var NSIC_DATAFLOWS_TREE_SELECTOR = "#dataflows-tree";

/* ------------------------------------------------------------------------------------------------------------------ *\
 * GLOBALS                                                                                                            *
\* ------------------------------------------------------------------------------------------------------------------ */

// Specifies if the change of selected dataflow should be ignored and allowed.
var g_nsicIgnoreAndAllowDataflowChange = false;

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Setups the dataflows panel.                                                                                        *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicSetupDataflowsPanel() {
    var options = {
        plugins: [ "themes", "html_data", "ui", "types", "cookies" ],
        themes : { "theme" : "apple" },
        ui : { select_limit : 1 },
        types : {
            types : {
                "category-scheme": { "icon" : { "image" : g_nsicOptions.baseURL + "image/category-scheme.jpg" } },
                "category": { "icon" : { "image" : g_nsicOptions.baseURL + "image/category.png" } },
                "dataflow": {
                    "icon" : { "image" : g_nsicOptions.baseURL + "image/dataflow.png" },
                    "select_node" : nsicOnDataflowsTreeNodeSelected
                },
                "xs-dataflow": {
                    "icon" : { "image" : g_nsicOptions.baseURL + "image/xs-dataflow.png" },
                    "select_node" : nsicOnDataflowsTreeNodeSelected
                },
                "default": { "select_node" : false }
            }
        },
        cookies: {
            save_selected: false
        }
    };

    if (g_nsicOptions.currentDataflowElmId.length > 0) {
        options["ui"]["initially_select"] = g_nsicOptions.currentDataflowElmId;
    }

    $(NSIC_DATAFLOWS_TREE_SELECTOR).jstree(options);

    $(NSIC_DATAFLOWS_TREE_SELECTOR).bind("close_node.jstree", function(e, data) {
        if (g_nsicOptions.currentDataflowElmId.length > 0) {
            var elmObj = data.args[0];
            var childObjs = elmObj.find("li#" + nsicEscapeJQuerySelector(g_nsicOptions.currentDataflowElmId));
            if (childObjs.length > 0) {
                childObjs.children("a").first().addClass("jstree-clicked");
            }
        }
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Returns TRUE if a dataflow is selected, FALSE otherwise.                                                           *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicIsDataflowSelected() {
    return $(NSIC_DATAFLOWS_TREE_SELECTOR + " a.jstree-clicked").length > 0;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the current dataflow is changed.                                                                   *
 *                                                                                                                    *
 * This is actually a wrapper for "nsicOnCurrentDataflowChanged", but which makes sure that no error occurs           *
 * if is called before all elements are setup.                                                                        *
 *                                                                                                                    *
 * @anchorElm               the anchor element (as a DOM object)                                                      *
 *                                                                                                                    *
 * Returns TRUE if the change of selected dataflow is allowed, FALSE otherwise.                                       *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnDataflowsTreeNodeSelected(anchorElm) {
    if (g_nsicIgnoreAndAllowDataflowChange) {
        return true;
    }

    var obj = $(anchorElm);

    var agency = obj.find(".dataflow-agency").text();
    var id = obj.find(".dataflow-id").text();
    var version = obj.find(".dataflow-version").text();

    if ((agency.length > 0) && (id.length > 0) && (version.length > 0)) {
        return nsicOnCurrentDataflowChanged(anchorElm, agency, id, version);
    } else {
        // Something went wrong...
        return false;
    }
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user selects a dataflow.                                                                       *
 *                                                                                                                    *
 * This will send a request to server to see if the change is possible. If so, then the Criteria tab is reloaded      *
 * and selected, while the View Results tab will be made selectable, otherwise nothing changes.                       *
 *                                                                                                                    *
 * @agency                  the agency                                                                                *
 * @id                      the dataflow id                                                                           *
 * @version                 dataflow's version                                                                        *
 *                                                                                                                    *
 * Returns TRUE if the change of selected dataflow is allowed, FALSE otherwise.                                       *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCurrentDataflowChanged(anchorElm, agency, id, version) {
    $.get(g_nsicOptions.baseURL + "ajax/dataflow-change.htm", { agency: agency, id: id, version: version },
            function(data) {
                // If the server sent back a response then the change is not allowed (and the response is actually
                // an error message describing the reason). An empty response message specifies that
                // the change is allowed...
                if (data.length == 0) {
                    g_nsicIgnoreAndAllowDataflowChange = true;
                    $(NSIC_DATAFLOWS_TREE_SELECTOR).jstree("select_node", anchorElm, true);
                    g_nsicIgnoreAndAllowDataflowChange = false;

                    g_nsicOptions.currentDataflowElmId = anchorElm.parent().attr("id");
                    
                    nsicReloadWorkAreaPage(NSIC_WORKAREA_PAGE_CRITERIA);
                    nsicEnableWorkAreaPage(NSIC_WORKAREA_PAGE_RESULTS, true);
                } else {
                    alert(data);
                }
            }
    );

    return false;
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user clicks "Expand All".                                                                      *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnDataflowsExpandAllClicked() {
    $(NSIC_DATAFLOWS_TREE_SELECTOR).jstree("open_all");
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user clicks "Expand Categories".                                                               *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnDataflowsExpandCategoriesClicked() {
    var treeObj = $(NSIC_DATAFLOWS_TREE_SELECTOR);

    treeObj.find("li").each(function() {
        treeObj.jstree($(this).find("li[rel='category']").length > 0 ? "open_node" : "close_node", this);
    });
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever the user clicks "Collapse All".                                                                    *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnDataflowsCollapseAllClicked() {
    $(NSIC_DATAFLOWS_TREE_SELECTOR).jstree("close_all");
}

/* ------------------------------------------------------------------------------------------------------------------ *\
 * Called whenever a Category Scheme or Category is selected.                                                         *
 *                                                                                                                    *
 *                                                                                                                    *
 * @anchorElm               the anchor element (as a DOM object)                                                      *
 *                                                                                                                    *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicOnCategoryTreeNodeSelected(anchorElm) {
	var treeObj = $(anchorElm).parent("li");
	
	if (treeObj.hasClass("jstree-closed")) {
		treeObj.removeClass("jstree-closed").addClass("jstree-open");
	} else if (treeObj.hasClass("jstree-open")) {
		treeObj.removeClass("jstree-open").addClass("jstree-closed");
	} 	
	treeObj.children("a").eq(0).removeClass("jstree-clicked jstree-hovered").addClass("jstree-hovered");
}