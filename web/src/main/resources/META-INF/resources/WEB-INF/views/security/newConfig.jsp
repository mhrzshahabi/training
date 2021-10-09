<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    let configComplexTitle=null;

    //----------------------------------------------------RestDataSource------------------------------------------------


    let RestDataSource_config_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });

    //
    let config_tabs = isc.TabSet.create({
        //ID: "PersonnelInfo_ClassInfo_Tab",
        width: "100%",
        height: 500,
        tabBarPosition: "top",
        tabs: [
            {
                id: "Config_Tab_Course",
                title: "تنظیمات دوره",
                // pane: this.DynamicForm_PersonnelInfo_CourseInfo
            }
        ],
        tabSelected: function () {
        }.bind(this)
    });


    //-------------------------------window-----------------------------------------------------------------------------

    window_edit_config = isc.Window.create({
        title: "",
        width: "70%",
        minWidth: 500,
        height: 500,
        visibility: "hidden",
        items: [config_tabs]
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    //



    DynamicForm_V2_edit_config = isc.DynamicForm.create({
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        width: "100%",
        align: "right",
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " نمایش و تغییر تنظیمات مجتمع مورد نظر:"
            },
            {
                name: "editConfigDepartmentFilter",
                title: " مجتمع :",
                colSpan: 2,
                optionDataSource: RestDataSource_config_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    debugger
                    configComplexTitle=value;
                },

            },
            {
                colSpan: 2,
                name: "configBtn",
                title: "<spring:message code="configurations"/>",
                type: "Button",
                width: 100,
                startRow: false,
                endRow: false,
                click() {
                    if (configComplexTitle!==null){
                        window_edit_config.setTitle(configComplexTitle);
                        window_edit_config.show();
                    }else {
                        createDialog("info", "مجتمع را انتخاب کنید");
                    }

                }
            },
        ]
    });


    DynamicForm_V2_set_config = isc.DynamicForm.create({
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        width: "100%",
        align: "right",
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " کل تنظیمات اپلیکیشن برای شما بر اساس مجتمع زیر است:(برای ثبت تغییر ذخیره را انتخاب کنید)"
            },
            {
                name: "setConfigDepartmentFilter",
                title: " مجتمع :",
                colSpan: 2,
                optionDataSource: RestDataSource_config_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {


                },

            }

        ]
    });

    IButton_V2_Config = isc.IButtonSave.create({
        top: 260,
        title: "ذخیره",
        width: 300,
        click: function () {

        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_V2_Config = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_V2_edit_config,
            DynamicForm_V2_set_config
        ]
    });
    var HLayOut_Confirm_V2_Config = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_V2_Config
        ]
    });

    var VLayout_Body_V2_Config = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            VLayOut_CriteriaForm_V2_Config,
            HLayOut_Confirm_V2_Config
        ]
    });


    <%--var DynamicForm_JspConfig;--%>
    <%--var ConfigTypes_JspConfig = [];--%>
    <%--var Wait_JspConfig;--%>
    <%--var temp;--%>

    <%--isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-list", "GET", null, setConfigTypes));--%>

    <%--//--------------------------------------------------------------------------------------------------------------------//--%>
    <%--/*Form*/--%>
    <%--//--------------------------------------------------------------------------------------------------------------------//--%>

    <%--TabSet_JspConfig = isc.TabSet.create({--%>
    <%--    tabBarPosition: "right",--%>
    <%--    tabBarThickness: 100,--%>
    <%--    titleEditorTopOffset: 2,--%>
    <%--    tabSelected: function () {--%>
    <%--        DynamicForm_JspConfig = (TabSet_JspConfig.getSelectedTab().pane);--%>
    <%--    }--%>
    <%--});--%>

    <%--IButton_Save_JspConfig = isc.TrSaveBtn.create({--%>
    <%--    top: 260,--%>
    <%--    click: function () {--%>
    <%--        if (!DynamicForm_JspConfig.valuesHaveChanged() || !DynamicForm_JspConfig.validate())--%>
    <%--            return;--%>
    <%--        DynamicForm_Config_edit();--%>
    <%--    }--%>
    <%--});--%>

    <%--HLayout_SaveOrExit_JspConfig = isc.TrHLayoutButtons.create({--%>
    <%--    layoutMargin: 5,--%>
    <%--    showEdges: false,--%>
    <%--    edgeImage: "",--%>
    <%--    padding: 10,--%>
    <%--    members: [IButton_Save_JspConfig]--%>
    <%--});--%>

    <%--ToolStripButton_Refresh_JspConfig = isc.ToolStripButtonRefresh.create({--%>
    <%--    click: function () {--%>
    <%--        DynamicForm_Config_refresh();--%>
    <%--    }--%>
    <%--});--%>

    <%--ToolStrip_Actions_JspConfig = isc.ToolStrip.create({--%>
    <%--    width: "100%",--%>
    <%--    align: "left",--%>
    <%--    border: '0px',--%>
    <%--    members: [--%>
    <%--        ToolStripButton_Refresh_JspConfig--%>
    <%--    ]--%>
    <%--});--%>

    <%--VLayout_JspConfig = isc.TrVLayout.create({--%>
    <%--    members: [ToolStrip_Actions_JspConfig, TabSet_JspConfig, HLayout_SaveOrExit_JspConfig]--%>
    <%--});--%>

    <%--//--------------------------------------------------------------------------------------------------------------------//--%>
    <%--/*functions*/--%>
    <%--//--------------------------------------------------------------------------------------------------------------------//--%>

    <%--function DynamicForm_Config_refresh() {--%>
    <%--    for (var i = TabSet_JspConfig.tabs.length - 1; i > -1; i--) {--%>
    <%--        TabSet_JspConfig.removeTab(i);--%>
    <%--    }--%>
    <%--    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-list", "GET", null, setConfigTypes));--%>
    <%--}--%>

    <%--function setConfigTypes(resp) {--%>
    <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--        ConfigTypes_JspConfig = (JSON.parse(resp.data)).list;--%>
    <%--        ConfigTypes_JspConfig.forEach(addTab);--%>
    <%--    } else {--%>

    <%--    }--%>
    <%--}--%>


    <%--function addTab(item) {--%>
    <%--    var newTab = {title: item.title, pane: newDynamicForm(item)};--%>
    <%--    TabSet_JspConfig.addTab(newTab);--%>
    <%--}--%>

    <%--function newDynamicForm(item) {--%>
    <%--    var DF = isc.DynamicForm.create({--%>
    <%--        height: "100%",--%>
    <%--        width: "90%",--%>
    <%--        title: item.title,--%>
    <%--        titleAlign: "left",--%>
    <%--        align: "center",--%>
    <%--        canSubmit: true,--%>
    <%--        showInlineErrors: true,--%>
    <%--        showErrorText: false,--%>
    <%--        margin: 20,--%>
    <%--        numCols: 8--%>
    <%--    });--%>
    <%--    for (var i = 0; i < item.parameterValueList.length; i++) {--%>
    <%--        if (item.parameterValueList[i].value === "false")--%>
    <%--            item.parameterValueList[i].value = false;--%>
    <%--        if (i > 0 && item.parameterValueList[i].type !== item.parameterValueList[i - 1].type)--%>
    <%--            DF.addField({type: "RowSpacerItem"});--%>
    <%--        DF.addField({--%>
    <%--            ID: item.parameterValueList[i].id + "_JspConfig",--%>
    <%--            name: item.parameterValueList[i].id + "_JspConfig",--%>
    <%--            title: item.parameterValueList[i].title,--%>
    <%--            value: item.parameterValueList[i].value,--%>
    <%--            prompt: item.parameterValueList[i].description,--%>
    <%--            type: setType(item.parameterValueList[i].type),--%>
    <%--            keyPressFilter: setKeyPressFilter(item.parameterValueList[i].type),--%>
    <%--            colSpan: setColSpan(item.parameterValueList[i].type),--%>
    <%--            validators: setValidators(item.parameterValueList[i].type),--%>
    <%--            required: true,--%>
    <%--            titleOrientation: "top"--%>
    <%--        })--%>
    <%--    }--%>
    <%--    return DF;--%>
    <%--}--%>

    <%--function setValidators(type) {--%>
    <%--    switch (type) {--%>
    <%--        case "percent":--%>
    <%--            return [{--%>
    <%--                type: "regexp",--%>
    <%--                errorMessage: "<spring:message code="msg.field.percent"/>",--%>
    <%--                expression: /^(([0-9]?[0-9])|100)$/,--%>
    <%--            }];--%>
    <%--        default:--%>
    <%--            return null;--%>
    <%--    }--%>
    <%--}--%>

    <%--function setType(type) {--%>
    <%--    switch (type) {--%>
    <%--        case "percent":--%>
    <%--            return "IntegerItem";--%>
    <%--        default:--%>
    <%--            return type;--%>
    <%--    }--%>
    <%--}--%>

    <%--function setKeyPressFilter(type) {--%>
    <%--    switch (type) {--%>
    <%--        // case "text":--%>
    <%--        case "TextItem":--%>
    <%--            return "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]";--%>
    <%--        case "percent":--%>
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

    <%--function DynamicForm_Config_edit() {--%>
    <%--    if (DynamicForm_JspConfig.hasErrors())--%>
    <%--        return;--%>
    <%--    var fields = DynamicForm_JspConfig.getAllFields();--%>
    <%--    var toUpdate = [];--%>
    <%--    for (var i = 0; i < fields.length; i++) {--%>
    <%--        if (fields[i].getValue() == null)--%>
    <%--            continue;--%>
    <%--        toUpdate.add({--%>
    <%--            "id": ((fields[i].getID()).split('_'))[0],--%>
    <%--            "value": fields[i].getValue()--%>
    <%--        });--%>
    <%--    }--%>
    <%--    if (toUpdate.length > 0) {--%>
    <%--        Wait_JspConfig = createDialog("wait");--%>
    <%--        isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/edit-config-list",--%>
    <%--            "PUT", JSON.stringify(toUpdate), Edit_Result_JspConfig));--%>
    <%--    }--%>
    <%--}--%>

    <%--function Edit_Result_JspConfig(resp) {--%>
    <%--    Wait_JspConfig.close();--%>
    <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--        var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",--%>
    <%--            "<spring:message code="msg.command.done"/>");--%>
    <%--        setTimeout(function () {--%>
    <%--            OK.close();--%>
    <%--        }, 2000);--%>
    <%--    } else {--%>
    <%--        createDialog("info", "<spring:message code="msg.operation.error"/>",--%>
    <%--            "<spring:message code="message"/>");--%>
    <%--    }--%>
    <%--}--%>

    //</script>