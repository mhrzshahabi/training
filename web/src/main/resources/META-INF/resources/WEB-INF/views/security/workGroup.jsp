<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var DynamicForm_JspWorkGroup;
    var entityList_JspWorkGroup = [
        "com.nicico.training.model.Job",
        "com.nicico.training.model.PostGrade",
        "com.nicico.training.model.Skill",
        "com.nicico.training.model.PostGroup",
        "com.nicico.training.model.JobGroup",
        "com.nicico.training.model.PostGradeGroup",
        "com.nicico.training.model.SkillGroup"
    ];
    // var entityList_JspWorkGroup = ["Job", "PostGrade", "Skill", "PostGroup", "JobGroup", "PostGradeGroup", "SkillGroup"];
    // var entityList_JspWorkGroup = ["Post", "Job", "PostGrade", "Skill", "PostGroup", "JobGroup", "PostGradeGroup", "SkillGroup"];
    var FormDataList_JspWorkGroup;
    var Wait_JspWorkGroup;
    var temp;

    isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/form-data", "POST", JSON.stringify(entityList_JspWorkGroup), setFormData));

    //--------------------------------------------------------------------------------------------------------------------//
    /*Form*/
    //--------------------------------------------------------------------------------------------------------------------//

    TabSet_JspWorkGroup = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        titleEditorTopOffset: 2,
        tabSelected: function () {
            DynamicForm_JspWorkGroup = (TabSet_JspWorkGroup.getSelectedTab().pane);
        }
    });

    IButton_Save_JspWorkGroup = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspWorkGroup.valuesHaveChanged() || !DynamicForm_JspWorkGroup.validate())
                return;
            DynamicForm_WorkGroup_edit();
        }
    });

    HLayout_SaveOrExit_JspWorkGroup = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspWorkGroup]
    });

    ToolStripButton_Refresh_JspWorkGroup = isc.ToolStripButtonRefresh.create({
        click: function () {
            DynamicForm_WorkGroup_refresh();
        }
    });

    ToolStrip_Actions_JspWorkGroup = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Refresh_JspWorkGroup
        ]
    });

    VLayout_JspWorkGroup = isc.TrVLayout.create({
        members: [ToolStrip_Actions_JspWorkGroup, TabSet_JspWorkGroup, HLayout_SaveOrExit_JspWorkGroup]
    });

    <%--//--------------------------------------------------------------------------------------------------------------------//--%>
    <%--/*functions*/--%>
    <%--//--------------------------------------------------------------------------------------------------------------------//--%>

    function DynamicForm_WorkGroup_refresh() {
        for (var i = TabSet_JspWorkGroup.tabs.length - 1; i > -1; i--) {
            TabSet_JspWorkGroup.removeTab(i);
        }
        isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-list", "GET", null, setConfigTypes));
    }

    function setFormData(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            FormDataList_JspWorkGroup = (JSON.parse(resp.data));
            FormDataList_JspWorkGroup.forEach(addTab);
        } else {

        }
    }


    function addTab(item) {
        var newTab = {
            title: item.entityName.split('.').last(),
            <%--title: "<spring:message code=code/>","code":item.entityName.split('.').last(),--%>
            pane: newDynamicForm(item)};
        TabSet_JspWorkGroup.addTab(newTab);
    }

    function newDynamicForm(item) {
        var DF = isc.DynamicForm.create({
            height: "100%",
            width: "90%",
            title: item.entityName,
            titleAlign: "left",
            align: "center",
            canSubmit: true,
            showInlineErrors: true,
            showErrorText: false,
            margin: 20,
            numCols: 8
        });
        for (var i = 0; i < item.columnDataList.length; i++) {
            // if (item.parameterValueList[i].value === "false")
            //     item.parameterValueList[i].value = false;
            // if (i > 0 && item.parameterValueList[i].type !== item.parameterValueList[i - 1].type)
            //     DF.addField({type: "RowSpacerItem"});
            DF.addField({
                ID: item.entityName + "_" + item.columnDataList[i].filedName + "_JspWorkGroup",
                name: item.entityName + "_" + item.columnDataList[i].filedName + "_JspWorkGroup",
                title: item.columnDataList[i].filedName,
                // value: item.columnDataList[i].values,
                valueMap: item.columnDataList[i].values,
                type: "selectItem",
                textAlign: "center",
                multiple: true,
                colSpan: 8
                // prompt: item.parameterValueList[i].description,
                // required: true,
                // keyPressFilter: setKeyPressFilter(item.parameterValueList[i].type),
                // colSpan: setColSpan(item.parameterValueList[i].type),
                // titleOrientation: "top"
            })
        }
        return DF;
    }

    <%--function setKeyPressFilter(type) {--%>
    <%--    switch (type) {--%>
    <%--        case "text":--%>
    <%--        case "TextItem":--%>
    <%--            return "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]";--%>
    <%--        case "IntegerItem":--%>
    <%--        case "integer":--%>
    <%--            return "[0-9]";--%>
    <%--        // case "float":--%>
    <%--        // case "FloatItem":--%>
    <%--        // case "DoubleItem":--%>
    <%--        //     return "/^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/";--%>
    <%--        case "boolean":--%>
    <%--        case "BooleanItem":--%>
    <%--            return null;--%>
    <%--        default:--%>
    <%--            return null;--%>
    <%--    }--%>
    <%--}--%>

    <%--function setColSpan(type) {--%>
    <%--    switch (type) {--%>
    <%--        case "text":--%>
    <%--        case "textArea":--%>
    <%--        case "TextItem":--%>
    <%--            return 4;--%>
    <%--        case "IntegerItem":--%>
    <%--        case "integer":--%>
    <%--            return 2;--%>
    <%--        case "float":--%>
    <%--        case "FloatItem":--%>
    <%--        case "DoubleItem":--%>
    <%--            return 2;--%>
    <%--        case "boolean":--%>
    <%--        case "BooleanItem":--%>
    <%--            return 1;--%>
    <%--        default:--%>
    <%--            return 1;--%>
    <%--    }--%>
    <%--}--%>

    function DynamicForm_WorkGroup_edit() {
        var fields = DynamicForm_JspWorkGroup.getAllFields();
        var toUpdate = [];
        for (var i = 0; i < fields.length; i++) {
            if (fields[i].getValue() == null)
                continue;
            toUpdate.add({
                "entityName": ((fields[i].getID()).split('_'))[0],
                "columnName": ((fields[i].getID()).split('_'))[1],
                "values": fields[i].getValue()
            });
        }
        if (toUpdate.length > 0) {
            Wait_JspWorkGroup = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/edit-permission-list",
                "PUT", JSON.stringify(toUpdate), Edit_Result_JspWorkGroup));
        }
    }

    function Edit_Result_JspWorkGroup(resp) {
        Wait_JspWorkGroup.close();
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