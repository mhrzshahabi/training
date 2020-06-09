<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource  ----------------------------
    {
        var RestDataSource_Institute = isc.TrDS.create({
            fields: [
                {name: "institute", title: "<spring:message code="institute"/>"}
            ],
            // fetchDataURL:
        });

        var RestDataSource_Category = isc.TrDS.create({
            fields: [
                {name: "category", title: "<spring:message code="course_category"/>"}
            ],
            // fetchDataURL:
        });

        var RestDataSource_Sub_Category = isc.TrDS.create({
            fields: [
                {name: "sub_category", title: "<spring:message code="course_subcategory"/>"}
            ],
            // fetchDataURL:
        });

        var RestDataSource_Course = isc.TrDS.create({
            fields: [
                {name: "course", title: "<spring:message code="course"/>"}
            ],
            // fetchDataURL:
        });


        var RestDataSource_CPReport = isc.TrDS.create({
            fields:
                [
                    {name: "institute"},
                    {name: "category"},
                    {name: "sub_category"},
                    {name: "course"},
                    {name: "all_classes"},
                    {name: "planing_classes"},
                    {name: "processing_classes"},
                    {name: "finished_classes"},
                    {name: "all_students"},
                    {name: "na_students"},
                    {name: "present_students"},
                    {name: "overtimed_students"},
                    {name: "absent_students"},
                    {name: "unjustified_students"},
                    {name: "total_time"}
                ]
        });

    // ---------------------------------------- Create - RestDataSource -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {
        //*****report main dynamic form*****
        var DynamicForm_CPReport = isc.DynamicForm.create({
            numCols: 11,
            padding: 10,
            readOnlyDisplay: "readOnly",
            margin:0,
            titleAlign:"left",
            wrapItemTitles: true,
            colWidths:[50,150,50,150,50,150,150,50, 150, 150, 50],
            fields: [
                {
                    name: "sessionStartDate",
                    title: "<spring:message code="start.date"/>",
                    ID: "sessionStartDate",
                    colSpan: 2,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('sessionStartDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkStartDate();
                        CPReport_check_date();
                    }
                },
                {
                    name: "sessionFinishDate",
                    title: "<spring:message code="end.date"/>",
                    ID: "sessionFinishDate",
                    colSpan: 2,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('sessionFinishDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkFinishDate();
                        CPReport_check_date();
                    }

                },
                {
                    name: "institute",
                    ID: "institute",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="institute"/>",
                    colSpan: 2,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Institute,
                    displayField: "",
                    valueField: "",
                    textAlign: "center",
                    pickListFields: [
                        {name: ""}
                    ],
                    filterFields: [""]
                },
                {
                    name: "category",
                    ID: "category",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="course_category"/>",
                    colSpan: 2,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Category,
                    displayField: "",
                    valueField: "",
                    textAlign: "center",
                    pickListFields: [
                        {name: ""}
                    ],
                    filterFields: [""]
                },
                {
                    name: "subcategory",
                    ID: "subcategory",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="course_subcategory"/>",
                    colSpan: 2,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Sub_Category,
                    displayField: "",
                    valueField: "",
                    textAlign: "center",
                    pickListFields: [
                        {name: ""}
                    ],
                    filterFields: [""]
                },
                {
                    name: "course",
                    ID: "course",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="course"/>",
                    colSpan: 2,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Course,
                    displayField: "",
                    valueField: "",
                    textAlign: "center",
                    pickListFields: [
                        {name: ""}
                    ],
                    filterFields: [""]
                },
                {
                    name: "searchBtn",
                    ID: "searchBtnJspCPReport",
                    type: "ButtonItem",
                    colSpan: 1,
                    width:"*",
                    startRow:false,
                    endRow:false,
                    title: "<spring:message code="reporting"/>",
                    click: function () {
                        searchResult();
                    }
                }
            ]
        });
        // ----------------------------------- Create - DynamicForm & Window --------------------------->>
        // <<----------------------------------------------- List Grid --------------------------------------------

        var ListGrid_CPReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_CPReport,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            showGridSummary: true,
            initialSort: [
                {property: "institute", direction: "ascending"}
            ],
            gridComponents: [
                DynamicForm_CPReport,
                isc.ToolStripButtonExcel.create({
                    margin:5,
                    click: function() {

                        let criteria = DynamicForm_CPReport.getValuesAsAdvancedCriteria();

                        if(criteria != null && Object.keys(criteria).length != 0) {

                        }else{
                            return ;
                        }

                        ExportToFile.showDialog(null, ListGrid_CPReport, 'categoriesPerformanceReport', 0, null, '',  "عملکرد واحدهای آموزشی", criteria, null);
                    }
                })
                , "header", "filterEditor", "body"
            ],
            fields: [
                {
                    name: "institute",
                    title: "<spring:message code="institute"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    summaryFunction: "totalSummary()"
                },
                {
                    name: "category",
                    title: "<spring:message code="course_category"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalCategory(records)",
                },
                {
                    name: "sub_category",
                    title: "<spring:message code="course_subcategory"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalSubCategory(records)",
                },
                {
                    name: "course",
                    title: "<spring:message code="course"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalCourse(records)",
                },
                {
                    name: "all_classes",
                    title: "<spring:message code="classes.all"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "planing_classes",
                    title: "<spring:message code="classes.planing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "processing_classes",
                    title: "<spring:message code="classes.processing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "finished_classes",
                    title: "<spring:message code="classes.finished"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "all_students",
                    title: "<spring:message code="sum.of.justified.absence.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "na_students",
                    title: "<spring:message code="students.all"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "present_students",
                    title: "<spring:message code="students.all.present"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "overtimed_students",
                    title: "<spring:message code="students.all.overtime"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "absent_students",
                    title: "<spring:message code="students.all.absent"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "unjustified_students",
                    title: "<spring:message code="students.all.unjustified"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "total_time",
                    title: "<spring:message code="total.time"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                }
            ]
        });

    }
        // <<----------------------------------------------- List Grid --------------------------------------------
        // <<----------------------------------------------- Layout --------------------------------------------
        var Vlayout_Body_CPReport = isc.VLayout.create({
            width: "100%",
            height: "100%",
            overflow: "visible",
            members: [ListGrid_CPReport]
        })

    }
    // <<----------------------------------------------- Layout --------------------------------------------

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function checkStartDate() {

            DynamicForm_CPReport.clearFieldErrors("sessionStartDate", true);

            if (DynamicForm_CPReport.getValue("sessionStartDate") === undefined || !checkDate(DynamicForm_CPReport.getValue("sessionStartDate"))) {
                DynamicForm_CPReport.addFieldErrors("sessionStartDate", "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors("sessionStartDate", true);
            }
        }

        function checkFinishDate() {

            DynamicForm_CPReport.clearFieldErrors("sessionFinishDate", true);

            if (DynamicForm_CPReport.getValue("sessionFinishDate") === undefined || !checkDate(DynamicForm_CPReport.getValue("sessionFinishDate"))) {
                DynamicForm_CPReport.addFieldErrors("sessionFinishDate", "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors("sessionFinishDate", true);
            }
        }

        function CPReport_check_date() {

            if (DynamicForm_CPReport.getValue("sessionStartDate") !== undefined && DynamicForm_CPReport.getValue("sessionFinishDate") !== undefined) {
                if (DynamicForm_CPReport.getValue("sessionStartDate") > DynamicForm_CPReport.getValue("sessionFinishDate")) {
                    DynamicForm_CPReport.addFieldErrors("sessionStartDate", "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_CPReport.addFieldErrors("sessionFinishDate", "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_CPReport.clearFieldErrors("sessionStartDate", true);
                    DynamicForm_CPReport.clearFieldErrors("sessionFinishDate", true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            checkFinishDate();
            checkStartDate();
            CPReport_check_date();


        }

        //*****calculate total summary*****
        function totalSummary() {
            return "جمع کل :";
        }

        function totalCategory(records) {
            return null;
        }

        function totalSubCategory(records) {
            return null;
        }

        function totalCourse(records) {
            return null;
        }

        function totalClasses(records) {
            return null;
        }

        //***********************************

    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>