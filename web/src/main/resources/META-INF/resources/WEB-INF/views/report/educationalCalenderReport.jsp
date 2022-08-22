<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Default Rest--------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_educationalCalenderReport = isc.TrDS.create({

        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"}



        ],
        fetchDataURL: educationalCalenderUrl + "spec-list",
        autoFetchData: true,
    });
    var RestDataSource_JspCalenderBasicGoals = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "mainGoal"},
                {name: "classCode"},
                {name: "calenderId"}
            ],
        fetchDataURL: educationalCalenderUrl + "/mainGoals/iscList"
    });

    //----------------------------------------------------Criteria Form------------------------------------------------


    DynamicForm_Calender_Report= isc.DynamicForm.create({
        width: "600",
        height: 10,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "calenderFilter",
                title: "<spring:message code='calender'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_educationalCalenderReport,
                autoFetchData: false,
                displayField: "titleFa",
                valueField: "id",
                // valueField: "title",
                textAlign: "center",
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }
                ],
                pickListFields: [
                    {
                        name: "titleFa",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_details_by_calender(value);

                },
            },
        ]
    });

    DynamicForm_Calender_BasicGoals = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            <%--{--%>
            <%--    name: "id",--%>
            <%--    title: "id",--%>
            <%--    primaryKey: true,--%>
            <%--    canEdit: false,--%>
            <%--    hidden: true--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemFromDate",--%>
            <%--    ID: "date_itemFromDate_history",--%>
            <%--    title: "تاریخ شروع",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemFromDate_history', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemToDate",--%>
            <%--    ID: "date_itemToDate_history",--%>
            <%--    title: "تاریخ پایان ",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemToDate_history', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "educationalHistoryCoefficient",--%>
            <%--    title: "ضريب",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "educationalHistoryFrom",--%>
            <%--    title: "از سال",--%>
            <%--    length: 5,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "educationalHistoryTo",--%>
            <%--    title: "تا سال",--%>
            <%--    length: 5,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true}--%>
        ]
    });
    DynamicForm_Calender_Prerequires = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            <%--{--%>
            <%--    name: "id",--%>
            <%--    title: "id",--%>
            <%--    primaryKey: true,--%>
            <%--    canEdit: false,--%>
            <%--    hidden: true--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemFromDate",--%>
            <%--    ID: "date_itemFromDate_base",--%>
            <%--    title: "تاریخ شروع",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemFromDate_base', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemToDate",--%>
            <%--    ID: "date_itemToDate_base",--%>
            <%--    title: "تاریخ پایان ",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemToDate_base', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "baseTuitionFee",--%>
            <%--    title: "پايه",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "professorTuitionFee",--%>
            <%--    title: "استاد",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "knowledgeAssistantTuitionFee",--%>
            <%--    title: "دانشيار",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "teacherAssistantTuitionFee",--%>
            <%--    title: "استاديار",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "instructorTuitionFee",--%>
            <%--    title: "مربي",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true},--%>
            <%--{--%>
            <%--    name: "educationalAssistantTuitionFee",--%>
            <%--    title: "مربي آموزشيار",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true}--%>
        ]
    });
    DynamicForm_Calender_Headlines = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
        <%--    {--%>
        <%--        name: "id",--%>
        <%--        title: "id",--%>
        <%--        primaryKey: true,--%>
        <%--        canEdit: false,--%>
        <%--        hidden: true--%>
        <%--    },--%>
        <%--    {--%>
        <%--        name: "itemFromDate",--%>
        <%--        ID: "date_itemFromDate_teaching_method",--%>
        <%--        title: "تاریخ شروع",--%>
        <%--        required: true,--%>
        <%--        defaultValue: todayDate,--%>
        <%--        keyPressFilter: "[0-9/]",--%>
        <%--        length: 10,--%>
        <%--        icons: [{--%>
        <%--            src: "<spring:url value="calendar.png"/>",--%>
        <%--            click: function () {--%>
        <%--                closeCalendarWindow();--%>
        <%--                displayDatePicker('date_itemFromDate_teaching_method', this, 'ymd', '/');--%>
        <%--            }--%>
        <%--        }],--%>
        <%--        changed: function (form, item, value) {--%>
        <%--            if (value == null || value === "" || checkDate(value))--%>
        <%--                item.clearErrors();--%>
        <%--            else--%>
        <%--                item.setErrors("<spring:message code='msg.correct.date'/>");--%>
        <%--        }--%>
        <%--    },--%>
        <%--    {--%>
        <%--        name: "itemToDate",--%>
        <%--        ID: "date_itemToDate_teaching_method",--%>
        <%--        title: "تاریخ پایان ",--%>
        <%--        required: true,--%>
        <%--        defaultValue: todayDate,--%>
        <%--        keyPressFilter: "[0-9/]",--%>
        <%--        length: 10,--%>
        <%--        icons: [{--%>
        <%--            src: "<spring:url value="calendar.png"/>",--%>
        <%--            click: function () {--%>
        <%--                closeCalendarWindow();--%>
        <%--                displayDatePicker('date_itemToDate_teaching_method', this, 'ymd', '/');--%>
        <%--            }--%>
        <%--        }],--%>
        <%--        changed: function (form, item, value) {--%>
        <%--            if (value == null || value === "" || checkDate(value))--%>
        <%--                item.clearErrors();--%>
        <%--            else--%>
        <%--                item.setErrors("<spring:message code='msg.correct.date'/>");--%>
        <%--        }--%>
        <%--    },--%>
        <%--    {--%>
        <%--        optionDataSource: RestDataSource_teaching_methods,--%>
        <%--        displayField: "title",--%>
        <%--        autoFetchData: false,--%>
        <%--        valueField: "title",--%>
        <%--        textAlign: "center",--%>
        <%--        required: true,--%>
        <%--        textMatchStyle: "substring",--%>
        <%--        pickListFields: [--%>
        <%--            {name: "title", autoFitWidth: true, autoFitWidthApproach: true}--%>
        <%--        ],--%>
        <%--        pickListProperties: {--%>
        <%--            sortField: 0,--%>
        <%--            showFilterEditor: false--%>
        <%--        },--%>
        <%--        name: "teachingMethod",--%>
        <%--        title: "روش آموزش",--%>
        <%--        type: "ComboBoxItem",--%>

        <%--    },--%>
        <%--    {--%>
        <%--        optionDataSource: RestDataSource_course_type,--%>
        <%--        displayField: "titleFa",--%>
        <%--        autoFetchData: false,--%>
        <%--        valueField: "titleFa",--%>
        <%--        textAlign: "center",--%>
        <%--        textMatchStyle: "substring",--%>
        <%--        pickListFields: [--%>
        <%--            {name: "titleFa", autoFitWidth: true, autoFitWidthApproach: true}--%>
        <%--        ],--%>
        <%--        pickListProperties: {--%>
        <%--            sortField: 0,--%>
        <%--            showFilterEditor: false--%>
        <%--        },--%>
        <%--        type: "ComboBoxItem",--%>
        <%--        name: "courseTypeTeachingMethod",--%>
        <%--        title: "نوع دوره",--%>
        <%--        required: false--%>
        <%--    },{--%>
        <%--        name: "coefficientOfTeachingMethod",--%>
        <%--        title: "ضریب روش تدریس",--%>
        <%--        length: 20,--%>
        <%--        keyPressFilter: "[0-9.]",--%>
        <%--        required: true--%>
        <%--    },--%>

        ]
    });
    DynamicForm_Calender_Sessions = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            <%--{--%>
            <%--    name: "id",--%>
            <%--    title: "id",--%>
            <%--    primaryKey: true,--%>
            <%--    canEdit: false,--%>
            <%--    hidden: true--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemFromDate",--%>
            <%--    ID: "date_itemFromDate_course_type",--%>
            <%--    title: "تاریخ شروع",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemFromDate_course_type', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "itemToDate",--%>
            <%--    ID: "date_itemToDate_course_type",--%>
            <%--    title: "تاریخ پایان ",--%>
            <%--    required: true,--%>
            <%--    defaultValue: todayDate,--%>
            <%--    keyPressFilter: "[0-9/]",--%>
            <%--    length: 10,--%>
            <%--    icons: [{--%>
            <%--        src: "<spring:url value="calendar.png"/>",--%>
            <%--        click: function () {--%>
            <%--            closeCalendarWindow();--%>
            <%--            displayDatePicker('date_itemToDate_course_type', this, 'ymd', '/');--%>
            <%--        }--%>
            <%--    }],--%>
            <%--    changed: function (form, item, value) {--%>
            <%--        if (value == null || value === "" || checkDate(value))--%>
            <%--            item.clearErrors();--%>
            <%--        else--%>
            <%--            item.setErrors("<spring:message code='msg.correct.date'/>");--%>
            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    textAlign: "center",--%>
            <%--    required: true,--%>
            <%--    displayField: "titleFa",--%>
            <%--    valueField: "titleFa",--%>
            <%--    //optionDataSource: RestDataSource_eTechnicalType,--%>
            <%--    sortField: ["id"],--%>
            <%--    // titleOrientation: "top",--%>
            <%--    width: "*",--%>
            <%--    // height: "30",--%>
            <%--    pickListProperties:{--%>
            <%--        showFilterEditor: false--%>
            <%--    },--%>
            <%--    valueMap: {--%>
            <%--        "1": "عمومي",--%>
            <%--        "2": "تخصصی",--%>
            <%--        "3": "مديريتي",--%>
            <%--    },--%>
            <%--    name: "typeOfSpecializationCourseType",--%>
            <%--    title: "نوع تخصص",--%>
            <%--    type: "ComboBoxItem",--%>

            <%--},--%>
            <%--{--%>
            <%--    optionDataSource: RestDataSource_e_level_type_decision,--%>
            <%--    displayField: "titleFa",--%>
            <%--    autoFetchData: false,--%>
            <%--    valueField: "titleFa",--%>
            <%--    textAlign: "center",--%>
            <%--    textMatchStyle: "substring",--%>
            <%--    pickListFields: [--%>
            <%--        {name: "titleFa", autoFitWidth: true, autoFitWidthApproach: true}--%>
            <%--    ],--%>
            <%--    pickListProperties: {--%>
            <%--        sortField: 0,--%>
            <%--        showFilterEditor: false--%>
            <%--    },--%>
            <%--    type: "ComboBoxItem",--%>
            <%--    name: "courseLevelCourseType",--%>
            <%--    title: "سطح دوره",--%>
            <%--    required: false--%>
            <%--},--%>
            <%--{--%>
            <%--    optionDataSource: RestDataSource_e_for_course_type_decision,--%>
            <%--    displayField: "title",--%>
            <%--    autoFetchData: false,--%>
            <%--    valueField: "title",--%>
            <%--    textAlign: "center",--%>
            <%--    textMatchStyle: "substring",--%>
            <%--    pickListFields: [--%>
            <%--        {name: "title", autoFitWidth: true, autoFitWidthApproach: true}--%>
            <%--    ],--%>
            <%--    pickListProperties: {--%>
            <%--        sortField: 0,--%>
            <%--        showFilterEditor: false--%>
            <%--    },--%>
            <%--    type: "ComboBoxItem",--%>
            <%--    name: "courseForCourseType",--%>
            <%--    title: "دوره ویژه ی",--%>
            <%--    required: false--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "coefficientOfCourseType",--%>
            <%--    title: "ضریب نوع دوره",--%>
            <%--    length: 20,--%>
            <%--    keyPressFilter: "[0-9.]",--%>
            <%--    required: true--%>
            <%--},--%>

        ]
    });



    // Save_Button_Add_Decision = isc.IButtonSave.create({
    //     top: 260,
    //     layoutMargin: 5,
    //     membersMargin: 5,
    //     click: function () {
    //         saveDecisionHeader();
    //     }
    // });
    //
    // Cancel_Button_Add_Decision = isc.IButtonCancel.create({
    //     layoutMargin: 5,
    //     membersMargin: 5,
    //     width: 120,
    //     click: function () {
    //         Window_header_Decision.close();
    //     }
    // });



    //------------------------------------------------------List Grids--------------------------------------------------

    // ListGrid_Calender_Report = isc.ListGrid.create({
    //     sortDirection: "descending",
    //     showFilterEditor: true,
    //     filterOnKeypress: true,
    //     canAutoFitFields: true,
    //     width: "100%",
    //     height: "100%",
    //     dataSource: RestDataSource_Decision_Header,
    //     autoFetchData: true,
    //     initialSort: [
    //         {property: "id", direction: "descending"}
    //     ],
    //     recordClick: function () {
    //         selectionUpdated_Tabs();
    //     },
    //     fields: [
    //         {
    //             name: "id",
    //             hidden: true,
    //             primaryKey: true,
    //             canEdit: false,
    //             align: "center"
    //         },
    //         {
    //             name: "complex",
    //             title: "مجتمع",
    //             width: "10%",
    //             align: "center"
    //         },
    //         {
    //             name: "itemFromDate",
    //             title: "تاریخ شروع",
    //             width: "10%",
    //             align: "center",
    //             canFilter: false
    //         },
    //         {
    //             name: "itemToDate",
    //             title: "تاریخ پایان",
    //             width: "10%",
    //             align: "center",
    //             canFilter: false
    //         }
    //     ],
    //
    // });

    basicGoals_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
          isc.ToolStripButtonExcel.create({

                    click: function () {
                        makeExcelOutput();
                    }

            })
        ]
    });
    prerequauires_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutput();
                }

            })
        ]
    });
    headlines_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutput();
                }

            })
        ]
    });
    sessions_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutput();
                }

            })
        ]
    });


    ListGrid_Calender_BasicGoals = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderBasicGoals,
        // contextMenu: Menu_JspOperationalChart,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "mainGoal",
                title: "هدف اصلی",
                filterOperator: "iContains"
            },
            {
                name: "classCode",
                title: "کد کلاس",
                filterOperator: "iContains"
            }

        ],
        gridComponents: [basicGoals_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
           ListGrid_Calender_BasicGoals.invalidateCache();
        }



    });
    ListGrid_Calender_Prerequaires = isc.ListGrid.create({
        // dataSource: RestDataSource_Decision_teaching_method,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            // {
            //     name: "id",
            //     hidden: true,
            //     primaryKey: true,
            //     canEdit: false,
            //     align: "center"
            // },
            // {
            //     name: "itemFromDate",
            //     title: "تاریخ شروع",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "itemToDate",
            //     title: "تاریخ پایان",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "teachingMethod",
            //     title: "روش آموزش",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "courseTypeTeachingMethod",
            //     title: "نوع دوره",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "coefficientOfTeachingMethod",
            //     title: "ضریب روش تدریس",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            //

        ],
        gridComponents: [prerequauires_actions, "filterEditor", "header", "body", "summaryRow"]


    });
    ListGrid_Calender_Headlines = isc.ListGrid.create({
        // dataSource: RestDataSource_Decision_course_type,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            // {
            //     name: "id",
            //     hidden: true,
            //     primaryKey: true,
            //     canEdit: false,
            //     align: "center"
            // },
            // {
            //     name: "itemFromDate",
            //     title: "تاریخ شروع",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "itemToDate",
            //     title: "تاریخ پایان",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "typeOfSpecializationCourseType",
            //     title: "نوع تخصص",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "courseLevelCourseType",
            //     title: "سطح دوره",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "courseForCourseType",
            //     title: "دوره ویژه ی",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "coefficientOfCourseType",
            //     title: "ضریب نوع دوره",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            //

        ],
        gridComponents: [headlines_actions, "filterEditor", "header", "body", "summaryRow"]


    });
    ListGrid_Calender_Sessions = isc.ListGrid.create({
        // dataSource: RestDataSource_Decision_distance,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            // {
            //     name: "id",
            //     hidden: true,
            //     primaryKey: true,
            //     canEdit: false,
            //     align: "center"
            // },
            // {
            //     name: "itemFromDate",
            //     title: "تاریخ شروع",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "itemToDate",
            //     title: "تاریخ پایان",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            //
            // {
            //     name: "residence",
            //     title: "محل سکونت",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },
            // {
            //     name: "distance",
            //     title: "مسافت",
            //     width: "10%",
            //     align: "center",
            //     canFilter: false
            // },



        ],
        gridComponents: [sessions_actions, "filterEditor", "header", "body", "summaryRow"]


    });


    //----------------------------------------------------Actions --------------------------------------------------

    // ToolStripButton_Add_Decision = isc.ToolStripButtonCreate.create({
    //     title: "افزودن هدر تصمیم گیری",
    //     click: function () {
    //         addHeaderDecision();
    //     }
    // });
    //
    // ToolStripButton_Delete_Decision = isc.ToolStripButtonRemove.create({
    //     click: function () {
    //         deleteDecisionHeader();
    //     }
    // });
    //
    // ToolStripButton_Refresh_Decision = isc.ToolStripButtonRefresh.create({
    //     click: function () {
    //         ListGrid_Decision_Header.invalidateCache();
    //     }
    // });



    //////////////////// tab ////////////////////////////////////////////


    EducationalCalenderReport_Tabs = isc.TabSet.create({
        height : "100%",
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_BasicGoals", title: "اهداف اصلی", pane: ListGrid_Calender_BasicGoals},
            {name: "TabPane_prerequires", title: "پیشنیازها", pane: ListGrid_Calender_Prerequaires},
            {name: "TabPane_Headlines", title: "سرفصل ها", pane: ListGrid_Calender_Headlines},
            {name: "TabPane_sessions", title: "جلسات", pane: ListGrid_Calender_Sessions},

        ],
        tabSelected: function () {
            selectionUpdatedCalender_Tabs();
        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------

    // HLayout_IButtons_Decision = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         Save_Button_Add_Decision,
    //         Cancel_Button_Add_Decision
    //     ]
    // });
    // HLayout_IButtons_BasicGoals = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         isc.IButtonSave.create({
    //             top: 260,
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             click: function () {
    //                 saveChildDecision(ListGrid_Decision_Educational_history,DynamicForm_Decision_history,Window_history_Decision,"history")
    //             }
    //         }),
    //         isc.IButtonCancel.create({
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             width: 120,
    //             click: function () {
    //                 Window_history_Decision.close();
    //             }
    //         })
    //     ]
    // });
    // HLayout_IButtons_Decision_base = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         isc.IButtonSave.create({
    //             top: 260,
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             click: function () {
    //                 saveChildDecision(ListGrid_Basic_Tuition,DynamicForm_Decision_base,Window_base_Decision,"base")
    //             }
    //         }),
    //         isc.IButtonCancel.create({
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             width: 120,
    //             click: function () {
    //                 Window_base_Decision.close();
    //             }
    //         })
    //     ]
    // });
    // HLayout_IButtons_teaching_method = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         isc.IButtonSave.create({
    //             top: 260,
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             click: function () {
    //                 saveChildDecision(ListGrid_Decision_teaching_method,DynamicForm_teaching_method,Window_teaching_method,"teaching-method")
    //             }
    //         }),
    //         isc.IButtonCancel.create({
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             width: 120,
    //             click: function () {
    //                 Window_teaching_method.close();
    //             }
    //         })
    //     ]
    // });
    // HLayout_IButtons_course_type = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         isc.IButtonSave.create({
    //             top: 260,
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             click: function () {
    //                 saveChildDecision(ListGrid_Decision_course_type,DynamicForm_course_type,Window_course_type,"course-type")
    //             }
    //         }),
    //         isc.IButtonCancel.create({
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             width: 120,
    //             click: function () {
    //                 Window_course_type.close();
    //             }
    //         })
    //     ]
    // });
    // HLayout_IButtons_distance = isc.HLayout.create({
    //     layoutMargin: 5,
    //     membersMargin: 15,
    //     width: "100%",
    //     height: "100%",
    //     align: "center",
    //     members: [
    //         isc.IButtonSave.create({
    //             top: 260,
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             click: function () {
    //                 saveChildDecision(ListGrid_Decision_distance,DynamicForm_distance,Window_distance,"distance")
    //             }
    //         }),
    //         isc.IButtonCancel.create({
    //             layoutMargin: 5,
    //             membersMargin: 5,
    //             width: 120,
    //             click: function () {
    //                 Window_distance.close();
    //             }
    //         })
    //     ]
    // });
    // Window_header_Calender = isc.Window.create({
    //     title: "تقویم",
    //     width: 450,
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: true,
    //     items: [
    //         DynamicForm_Calender_Report
    //     ]
    // });
    //
    // Window_Basic_Goals = isc.Window.create({
    //     title: "اهداف اصلی",
    //     width: 450,
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: true,
    //     items: [
    //         DynamicForm_Calender_BasicGoals
    //     ]
    // });
    // Window_Prerequires = isc.Window.create({
    //     title: "پیشنیازها",
    //     width: 450,
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: true,
    //     items: [
    //         DynamicForm_Calender_Prerequires
    //     ]
    // });
    //
    // Window_Headlines = isc.Window.create({
    //     title: "سرفصل ها",
    //     width: 450,
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: true,
    //     items: [
    //         DynamicForm_Calender_Headlines
    //     ]
    // });
    // Window_course_type = isc.Window.create({
    //     title: "جلسات",
    //     width: 450,
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: true,
    //     items: [
    //         DynamicForm_Calender_Sessions
    //     ]
    // });



    // ToolStrip_Actions_Decision = isc.ToolStrip.create({
    //     width: "100%",
    //     border: '0px',
    //     membersMargin: 5,
    //     members: [
    //         ToolStripButton_Add_Decision,
    //         ToolStripButton_Delete_Decision,
    //         isc.ToolStrip.create({
    //             align: "left",
    //             border: '0px',
    //             members: [
    //                 ToolStripButton_Refresh_Decision
    //             ]
    //         })
    //     ]
    // });

    let ToolStrip_Actions_calenderFilter = isc.ToolStrip.create({
        width: "100%",
        align : "right",
        membersMargin: 5,
        members:
            [

                DynamicForm_Calender_Report

            ]
    });
    VLayout_Body_Calender = isc.TrVLayout.create({
        height : "10%",
        members: [
            // ToolStrip_Actions_Decision,
           ToolStrip_Actions_calenderFilter
        ]
    });

    HLayout_Tabs_Calender = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "90%",
        members: [EducationalCalenderReport_Tabs]
    });

    VLayout_Body_Decision_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_Calender,
            HLayout_Tabs_Calender
        ]
    });


    //------------------------------------------------- Functions ------------------------------------------------------
    // function addHeaderDecision() {
    //
    //     DynamicForm_Decision.clearValues();
    //     DynamicForm_Decision.clearErrors();
    //     Window_header_Decision.show();
    // }



    <%--function saveDecisionHeader() {--%>

    <%--    if (!DynamicForm_Decision.validate())--%>
    <%--        return;--%>
    <%--    if(DynamicForm_Decision.getValue("itemToDate") < DynamicForm_Decision.getValue("itemFromDate")) {--%>
    <%--        createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    let data = DynamicForm_Decision.getValues();--%>

    <%--    wait.show();--%>
    <%--    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl, "POST", JSON.stringify(data), function (resp) {--%>
    <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--            Window_header_Decision.close();--%>
    <%--            ListGrid_Decision_Header.invalidateCache();--%>
    <%--        } else {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "خطایی رخ داده است");--%>
    <%--        }--%>
    <%--    }));--%>


    <%--}--%>

    <%--function addChildDecision(dynamicForm,window) {--%>
    <%--    dynamicForm.clearValues();--%>
    <%--    dynamicForm.clearErrors();--%>
    <%--    window.show();--%>
    <%--}--%>
    <%--function saveChildDecision(listGrid,dynamicForm,window,ref) {--%>
    <%--    let record = ListGrid_Decision_Header.getSelectedRecord();--%>
    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    if (!dynamicForm.validate())--%>
    <%--        return;--%>
    <%--    if(dynamicForm.getValue("itemToDate") < dynamicForm.getValue("itemFromDate")) {--%>
    <%--        createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    let data = dynamicForm.getValues();--%>
    <%--    data.ref =ref--%>
    <%--    data.educationalDecisionHeaderId =record.id--%>
    <%--    wait.show();--%>
    <%--    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl, "POST", JSON.stringify(data), function (resp) {--%>
    <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--            window.close();--%>
    <%--            listGrid.invalidateCache();--%>
    <%--        } else {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "خطایی رخ داده است");--%>
    <%--        }--%>
    <%--    }));--%>


    <%--}--%>
    <%--function deleteChildDecision(listGrid) {--%>
    <%--    let record = listGrid.getSelectedRecord();--%>
    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>
    <%--        let Dialog_dec_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",--%>
    <%--            "<spring:message code="verify.delete"/>");--%>
    <%--        Dialog_dec_remove.addProperties({--%>
    <%--            buttonClick: function (button, index) {--%>
    <%--                this.close();--%>
    <%--                if (index === 0) {--%>
    <%--                    wait.show();--%>
    <%--                    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl + "/" + record.id, "DELETE", null, function (resp) {--%>
    <%--                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--                            listGrid.invalidateCache();--%>

    <%--                        } else {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "خطایی رخ داده است");--%>
    <%--                        }--%>
    <%--                    }));--%>
    <%--                }--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>

    <%--function deleteDecisionHeader() {--%>
    <%--    let record = ListGrid_Decision_Header.getSelectedRecord();--%>
    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>
    <%--        let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",--%>
    <%--            "<spring:message code="verify.delete"/>");--%>
    <%--        Dialog_Competence_Request_remove.addProperties({--%>
    <%--            buttonClick: function (button, index) {--%>
    <%--                this.close();--%>
    <%--                if (index === 0) {--%>
    <%--                    wait.show();--%>
    <%--                    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl + "/" + record.id, "DELETE", null, function (resp) {--%>
    <%--                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--                            ListGrid_Decision_Header.invalidateCache();--%>

    <%--                        } else {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "رکورد مورد نظر دارای زیر مجموعه می باشد");--%>
    <%--                        }--%>
    <%--                    }));--%>
    <%--                }--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>

    function selectionUpdatedCalender_Tabs() {

        let record =  DynamicForm_Calender_Report.getField("calenderFilter").getValue();
        let tab = EducationalCalenderReport_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }
        // switch (tab.name) {
        //     case "TabPane_BasicGoals": {
        //         RestDataSource_Basic_Tuition.fetchDataURL = educationalDecisionRequestUrl + "/list/base/"+record.id;
        //         ListGrid_Basic_Tuition.invalidateCache();
        //         ListGrid_Basic_Tuition.fetchData();
        //         break;
        //     }
        //     case "TabPane_prerequires": {
        //         RestDataSource_Decision_Educational_history.fetchDataURL = educationalDecisionRequestUrl + "/list/history/"+record.id;
        //         ListGrid_Decision_Educational_history.invalidateCache();
        //         ListGrid_Decision_Educational_history.fetchData();
        //         break;
        //     }
        //     case "TabPane_Headlines": {
        //         RestDataSource_Decision_teaching_method.fetchDataURL = educationalDecisionRequestUrl + "/list/teaching-method/"+record.id;
        //         ListGrid_Decision_teaching_method.invalidateCache();
        //         ListGrid_Decision_teaching_method.fetchData();
        //         break;
        //     }
        //     case "TabPane_sessions": {
        //         RestDataSource_Decision_course_type.fetchDataURL = educationalDecisionRequestUrl + "/list/course-type/"+record.id;
        //         ListGrid_Decision_course_type.invalidateCache();
        //         ListGrid_Decision_course_type.fetchData();
        //         break;
        //     }
        //

        // }
    }
    function makeExcelOutput() {
//zaza print excel
//         if (ListGrid_CER.getOriginalData().localData === undefined)
//             createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
//         else
//             ExportToFile.downloadExcelRestUrl(null, ListGrid_CER, viewCoursesEvaluationReportUrl + "/iscList", 0, null, '',"گزارش ارزیابی دوره ها"  , reportCriteria_CER, null);
    }

    function createMainCriteriaInCalender(value) {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria =
            [
                {
                    fieldName: "calenderId", operator: "inSet", value: value
                }
            ];

        return mainCriteria;
    }

    function load_details_by_calender(value) {
        if (value !== undefined) {
            RestDataSource_JspCalenderBasicGoals.fetchDataURL = educationalCalenderReportUrl + "/mainGoals/iscList";
            let mainCriteria = createMainCriteriaInCalender(value);
            ListGrid_Calender_BasicGoals.invalidateCache();
            ListGrid_Calender_BasicGoals.fetchData(mainCriteria);
        } else {
            createDialog("info", "<spring:message code="msg.select.calender.ask"/>", "<spring:message code="message"/>")
        }

    }

    // </script>