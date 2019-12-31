<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var DynamicForm_JspConfig;
    var ConfigTypes_JspConfig = [];
    var Wait_JspConfig;
    var temp;

    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-types-list", "GET", null, setConfigTypes));

    //--------------------------------------------------------------------------------------------------------------------//
    /*Form*/
    //--------------------------------------------------------------------------------------------------------------------//

    TabSet_JspConfig = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        titleEditorTopOffset: 2,
        tabSelected: function () {
            DynamicForm_JspConfig = (TabSet_JspConfig.getSelectedTab().pane);
        }
    });

    IButton_Save_JspConfig = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspConfig.valuesHaveChanged() || !DynamicForm_JspConfig.validate())
                return;
            DynamicForm_Config_edit();
        }
    });

    HLayout_SaveOrExit_JspConfig = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspConfig]
    });

    ToolStripButton_Refresh_JspConfig = isc.ToolStripButtonRefresh.create({
        click: function () {
            DynamicForm_Config_refresh();
        }
    });

    ToolStrip_Actions_JspConfig = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Refresh_JspConfig
        ]
    });

    VLayout_JspConfig = isc.TrVLayout.create({
        members: [ToolStrip_Actions_JspConfig, TabSet_JspConfig, HLayout_SaveOrExit_JspConfig]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function DynamicForm_Config_refresh() {
        for (var i = TabSet_JspConfig.tabs.length - 1; i > -1; i--) {
            TabSet_JspConfig.removeTab(i);
        }
        isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-types-list", "GET", null, setConfigTypes));
    }

    function setConfigTypes(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ConfigTypes_JspConfig = (JSON.parse(resp.data)).list;
            ConfigTypes_JspConfig.forEach(addTab);
        } else {

        }
    }


    function addTab(item) {
        var newTab = {title: item.title, pane: newDynamicForm(item)};
        TabSet_JspConfig.addTab(newTab);
    }

    function newDynamicForm(item) {
        var DF = isc.DynamicForm.create({
            height: "100%",
            width: "90%",
            title: item.title,
            titleAlign: "left",
            align: "center",
            canSubmit: true,
            showInlineErrors: true,
            showErrorText: false,
            margin: 20,
            numCols: 4
        });
        for (var i = 0; i < item.parameterValueList.length; i++) {
            DF.addField({
                ID: item.parameterValueList[i].id + "_JspConfig",
                name: item.parameterValueList[i].title,
                title: item.parameterValueList[i].title,
                value: item.parameterValueList[i].code,
                prompt: item.parameterValueList[i].description,
                required: true
            })
        }
        return DF;
    }

    function DynamicForm_Config_edit() {
        var fields = DynamicForm_JspConfig.getAllFields();
        var toUpdate = [];
        for (var i = 0; i < fields.length; i++) {
            toUpdate.add({
                "id": ((fields[i].getID()).split('_'))[0],
                "code": fields[i].getValue()
            });
        }
        if (toUpdate.length > 0) {
            Wait_JspConfig = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/edit-config-list",
                "PUT", JSON.stringify(toUpdate), Edit_Result_JspConfig));
        }
    }

    function Edit_Result_JspConfig(resp) {
        Wait_JspConfig.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    //</script>