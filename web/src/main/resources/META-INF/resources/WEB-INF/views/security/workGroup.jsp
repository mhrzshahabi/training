<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

// <script>

    const userId = '<%= SecurityUtil.getUserId()%>';
    var DynamicForm_Permission;
    var entityList_Permission = [
        "com.nicico.training.model.Job",
        "com.nicico.training.model.PostGrade",
        "com.nicico.training.model.Skill",
        "com.nicico.training.model.PostGroup",
        "com.nicico.training.model.JobGroup",
        "com.nicico.training.model.PostGradeGroup",
        "com.nicico.training.model.SkillGroup"
    ];
    var FormDataList_Permission;
    var Wait_Permission;
    var temp;

    //--------------------------------------------------------------------------------------------------------------------//
    /*DS*/
    //--------------------------------------------------------------------------------------------------------------------//

    UserDS_JspWorkGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    WorkGroupDS_JspWorkGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "userIds", title: "<spring:message code="users"/>", filterOperator: "inSet"},
            <%--{name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            {name: "version", hidden: true}
        ],
        fetchDataURL: workGroupUrl + "/iscList"
    });

    // isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/form-data", "POST", JSON.stringify(entityList_Permission), setFormData));

    //--------------------------------------------------------------------------------------------------------------------//
    /*Permissions*/
    //--------------------------------------------------------------------------------------------------------------------//

    // TabSet_Permission = isc.TabSet.create({
    //     tabBarPosition: "right",
    //     tabBarThickness: 100,
    //     titleEditorTopOffset: 2,
    //     tabSelected: function () {
    //         DynamicForm_Permission = (TabSet_Permission.getSelectedTab().pane);
    //     }
    // });
    //
    // IButton_Save_Permission = isc.TrSaveBtn.create({
    //     top: 260,
    //     click: function () {
    //         if (!DynamicForm_Permission.valuesHaveChanged() || !DynamicForm_Permission.validate())
    //             return;
    //         DynamicForm_WorkGroup_edit();
    //     }
    // });
    //
    // HLayout_SaveOrExit_Permission = isc.TrHLayoutButtons.create({
    //     layoutMargin: 5,
    //     showEdges: false,
    //     edgeImage: "",
    //     padding: 10,
    //     members: [IButton_Save_Permission]
    // });
    //
    // ToolStripButton_Refresh_Permission = isc.ToolStripButtonRefresh.create({
    //     click: function () {
    //         DynamicForm_WorkGroup_refresh();
    //     }
    // });
    //
    // ToolStrip_Actions_Permission = isc.ToolStrip.create({
    //     width: "100%",
    //     align: "left",
    //     border: '0px',
    //     members: [
    //         ToolStripButton_Refresh_Permission
    //     ]
    // });
    //
    // VLayout_Permission = isc.TrVLayout.create({
    //     members: [ToolStrip_Actions_Permission, TabSet_Permission, HLayout_SaveOrExit_Permission]
    // });
    //
    // Windows_Permissions_Permission = isc.Window.create({
    //     placement: "fillScreen",
    //     title: "دسترسی ها",
    //     canDragReposition: true,
    //     align: "center",
    //     autoDraw: false,
    //     border: "1px solid gray",
    //     minWidth: 1024,
    //     items: [VLayout_Permission]
    // });

    //--------------------------------------------------------------------------------------------------------------------//
    /*WorkGroup DF*/
    //--------------------------------------------------------------------------------------------------------------------//

    <%--DynamicForm_JspWorkGroup = isc.DynamicForm.create({--%>
    <%--    width: "100%",--%>
    <%--    height: "100%",--%>
    <%--    titleAlign: "left",--%>
    <%--    fields: [--%>
    <%--        {name: "id", hidden: true},--%>
    <%--        {--%>
    <%--            name: "companyName",--%>
    <%--            title: "<spring:message code='company.name'/>",--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "jobTitle",--%>
    <%--            title: "<spring:message code='job.title'/>",--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "categories",--%>
    <%--            title: "<spring:message code='category'/>",--%>
    <%--            type: "selectItem",--%>
    <%--            textAlign: "center",--%>
    <%--            optionDataSource: RestDataSource_Category_JspWorkGroup,--%>
    <%--            valueField: "id",--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["titleFa"],--%>
    <%--            multiple: true,--%>
    <%--            filterLocally: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: true,--%>
    <%--                filterOperator: "iContains",--%>
    <%--            },--%>
    <%--            changed: function () {--%>
    <%--                isCategoriesChanged = true;--%>
    <%--                let subCategoryField = DynamicForm_JspWorkGroup.getField("subCategories");--%>
    <%--                if (this.getSelectedRecords() == null) {--%>
    <%--                    subCategoryField.clearValue();--%>
    <%--                    subCategoryField.disable();--%>
    <%--                    return;--%>
    <%--                }--%>
    <%--                subCategoryField.enable();--%>
    <%--                if (subCategoryField.getValue() === undefined)--%>
    <%--                    return;--%>
    <%--                let subCategories = subCategoryField.getSelectedRecords();--%>
    <%--                let categoryIds = this.getValue();--%>
    <%--                let SubCats = [];--%>
    <%--                for (let i = 0; i < subCategories.length; i++) {--%>
    <%--                    if (categoryIds.contains(subCategories[i].categoryId))--%>
    <%--                        SubCats.add(subCategories[i].id);--%>
    <%--                }--%>
    <%--                subCategoryField.setValue(SubCats);--%>
    <%--                subCategoryField.focus(this.form, subCategoryField);--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "subCategories",--%>
    <%--            title: "<spring:message code='subcategory'/>",--%>
    <%--            type: "selectItem",--%>
    <%--            textAlign: "center",--%>
    <%--            autoFetchData: false,--%>
    <%--            disabled: true,--%>
    <%--            optionDataSource: RestDataSource_SubCategory_JspWorkGroup,--%>
    <%--            valueField: "id",--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["titleFa"],--%>
    <%--            multiple: true,--%>
    <%--            filterLocally: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: true,--%>
    <%--                filterOperator: "iContains",--%>
    <%--            },--%>
    <%--            focus: function () {--%>
    <%--                if (isCategoriesChanged) {--%>
    <%--                    isCategoriesChanged = false;--%>
    <%--                    let ids = DynamicForm_JspWorkGroup.getField("categories").getValue();--%>
    <%--                    if (ids === []) {--%>
    <%--                        RestDataSource_SubCategory_JspWorkGroup.implicitCriteria = null;--%>
    <%--                    } else {--%>
    <%--                        RestDataSource_SubCategory_JspWorkGroup.implicitCriteria = {--%>
    <%--                            _constructor: "AdvancedCriteria",--%>
    <%--                            operator: "and",--%>
    <%--                            criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]--%>
    <%--                        };--%>
    <%--                    }--%>
    <%--                    this.fetchData();--%>
    <%--                }--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "persianStartDate",--%>
    <%--            ID: "employmentHistories_startDate_JspWorkGroup",--%>
    <%--            title: "<spring:message code='start.date'/>",--%>
    <%--            hint: todayDate,--%>
    <%--            keyPressFilter: "[0-9/]",--%>
    <%--            showHintInField: true,--%>
    <%--            icons: [{--%>
    <%--                src: "<spring:url value="calendar.png"/>",--%>
    <%--                click: function () {--%>
    <%--                    closeCalendarWindow();--%>
    <%--                    displayDatePicker('employmentHistories_startDate_JspWorkGroup', this, 'ymd', '/');--%>
    <%--                }--%>
    <%--            }],--%>
    <%--            validators: [{--%>
    <%--                type: "custom",--%>
    <%--                errorMessage: "<spring:message code='msg.correct.date'/>",--%>
    <%--                condition: function (item, validator, value) {--%>
    <%--                    if (value === undefined)--%>
    <%--                        return DynamicForm_JspWorkGroup.getValue("persianEndDate") === undefined;--%>
    <%--                    return checkBirthDate(value);--%>
    <%--                }--%>
    <%--            }]--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "persianEndDate",--%>
    <%--            ID: "employmentHistories_endDate_JspWorkGroup",--%>
    <%--            title: "<spring:message code='end.date'/>",--%>
    <%--            hint: todayDate,--%>
    <%--            keyPressFilter: "[0-9/]",--%>
    <%--            showHintInField: true,--%>
    <%--            icons: [{--%>
    <%--                src: "<spring:url value="calendar.png"/>",--%>
    <%--                click: function () {--%>
    <%--                    closeCalendarWindow();--%>
    <%--                    displayDatePicker('employmentHistories_endDate_JspWorkGroup', this, 'ymd', '/');--%>
    <%--                }--%>
    <%--            }],--%>
    <%--            validators: [{--%>
    <%--                type: "custom",--%>
    <%--                errorMessage: "<spring:message code='msg.correct.date'/>",--%>
    <%--                condition: function (item, validator, value) {--%>
    <%--                    if (value === undefined)--%>
    <%--                        return DynamicForm_JspWorkGroup.getValue("persianStartDate") === undefined;--%>
    <%--                    if (!checkDate(value))--%>
    <%--                        return false;--%>
    <%--                    if (DynamicForm_JspWorkGroup.hasFieldErrors("persianStartDate"))--%>
    <%--                        return true;--%>
    <%--                    let persianStartDate = JalaliDate.jalaliToGregori(DynamicForm_JspWorkGroup.getValue("persianStartDate"));--%>
    <%--                    let persianEndDate = JalaliDate.jalaliToGregori(DynamicForm_JspWorkGroup.getValue("persianEndDate"));--%>
    <%--                    return Date.compareDates(persianStartDate, persianEndDate) === 1;--%>
    <%--                }--%>
    <%--            }]--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>

    <%--IButton_Save_JspWorkGroup = isc.TrSaveBtn.create({--%>
    <%--    top: 260,--%>
    <%--    click: function () {--%>
    <%--        if (!DynamicForm_JspWorkGroup.valuesHaveChanged() || !DynamicForm_JspWorkGroup.validate())--%>
    <%--            return;--%>
    <%--        waitEmploymentHistory = createDialog("wait");--%>
    <%--        isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEmploymentHistory,--%>
    <%--            methodEmploymentHistory,--%>
    <%--            JSON.stringify(DynamicForm_JspWorkGroup.getValues()),--%>
    <%--            "callback: EmploymentHistory_save_result(rpcResponse)"));--%>
    <%--    }--%>
    <%--});--%>

    <%--IButton_Cancel_JspWorkGroup = isc.TrCancelBtn.create({--%>
    <%--    click: function () {--%>
    <%--        DynamicForm_JspWorkGroup.clearValues();--%>
    <%--        Window_JspWorkGroup.close();--%>
    <%--    }--%>
    <%--});--%>

    <%--HLayout_SaveOrExit_JspWorkGroup = isc.TrHLayoutButtons.create({--%>
    <%--    layoutMargin: 5,--%>
    <%--    showEdges: false,--%>
    <%--    edgeImage: "",--%>
    <%--    padding: 10,--%>
    <%--    members: [IButton_Save_JspWorkGroup, IButton_Cancel_JspWorkGroup]--%>
    <%--});--%>

    <%--Window_JspWorkGroup = isc.Window.create({--%>
    <%--    width: "500",--%>
    <%--    align: "center",--%>
    <%--    border: "1px solid gray",--%>
    <%--    title: "<spring:message code='employmentHistory'/>",--%>
    <%--    items: [isc.TrVLayout.create({--%>
    <%--        members: [DynamicForm_JspWorkGroup, HLayout_SaveOrExit_JspWorkGroup]--%>
    <%--    })]--%>
    <%--});--%>

    //--------------------------------------------------------------------------------------------------------------------//
    /*WorkGroup Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspWorkGroup = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_WorkGroup_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_WorkGroup_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_WorkGroup_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_WorkGroup_Remove();
            }
        }
        ]
    });

    ListGrid_JspWorkGroup = isc.TrLG.create({
        dataSource: WorkGroupDS_JspWorkGroup,
        contextMenu: Menu_JspWorkGroup,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains"
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                filterOperator: "iContains"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                filterOperator: "inSet",
                optionDataSource: UserDS_JspWorkGroup,
                valueField: "id",
                displayField: "lastName",
                filterField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true}
                ]
            }
        ],
        rowDoubleClick: function () {
            // ListGrid_WorkGroup_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspWorkGroup.invalidateCache();
        }
    });

    ToolStripButton_Refresh_JspWorkGroup = isc.ToolStripButtonRefresh.create({
        click: function () {
            // ListGrid_WorkGroup_refresh();
        }
    });

    ToolStripButton_Edit_JspWorkGroup = isc.ToolStripButtonEdit.create({
        click: function () {
            // ListGrid_WorkGroup_Edit();
        }
    });
    ToolStripButton_Add_JspWorkGroup = isc.ToolStripButtonAdd.create({
        click: function () {
            // ListGrid_WorkGroup_Add();
        }
    });
    ToolStripButton_Remove_JspWorkGroup = isc.ToolStripButtonRemove.create({
        click: function () {
            // ListGrid_WorkGroup_Remove();
        }
    });

    ToolStrip_Actions_JspWorkGroup = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspWorkGroup,
                ToolStripButton_Edit_JspWorkGroup,
                ToolStripButton_Remove_JspWorkGroup,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspWorkGroup
                    ]
                })
            ]
    });

    VLayout_Body_JspWorkGroup = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspWorkGroup,
            ListGrid_JspWorkGroup
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function DynamicForm_WorkGroup_refresh() {
        for (var i = TabSet_Permission.tabs.length - 1; i > -1; i--) {
            TabSet_Permission.removeTab(i);
        }
        isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-list", "GET", null, setConfigTypes));
    }

    function setFormData(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            FormDataList_Permission = (JSON.parse(resp.data));
            FormDataList_Permission.forEach(addTab);
        } else {

        }
    }


    function addTab(item) {
        var newTab = {
            title: item.entityName.split('.').last(),
            <%--title: "<spring:message code=code/>","code":item.entityName.split('.').last(),--%>
            pane: newDynamicForm(item)};
        TabSet_Permission.addTab(newTab);
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
                ID: item.entityName + "_" + item.columnDataList[i].filedName + "_Permission",
                name: item.entityName + "_" + item.columnDataList[i].filedName + "_Permission",
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
        var fields = DynamicForm_Permission.getAllFields();
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
            Wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/edit-permission-list",
                "PUT", JSON.stringify(toUpdate), Edit_Result_Permission));
        }
    }

    function Edit_Result_Permission(resp) {
        Wait_Permission.close();
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