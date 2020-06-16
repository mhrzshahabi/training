<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource  ----------------------------
    {
        var RestDataSource_Institute = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "<spring:message code="institute"/>"}
            ],
            fetchDataURL: instituteUrl +"spec-list"
        });

        var RestDataSource_Category = isc.TrDS.create({
            fields: [{name: "id"},
                {name: "titleFa"}],
            fetchDataURL: categoryUrl + "spec-list"
        });

        var RestDataSource_Sub_Category = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", type: "text"}
            ],
            fetchDataURL: subCategoryUrl + "spec-list",
        });

        var RestDataSource_Term = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "code"},
            ],
            fetchDataURL: termUrl + "spec-list",
            autoFetchData: true
        });


        var RestDataSource_CPReport = isc.TrDS.create({
            fields:
                [
                    {name: "institute"},
                    {name: "category"},
                    {name: "planingClasses"},
                    {name: "processingClasses"},
                    {name: "finishedClasses"},
                    {name: "endedClasses"},
                    {name: "presentStudents"},
                    {name: "overtimedStudents"},
                    {name: "absentStudents"},
                    {name: "unjustifiedStudents"},
                ],
            fetchDataURL:  + "/iscList",
            autoFetchData: true
        });

    // ---------------------------------------- Create - RestDataSource -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {
        //*****report main dynamic form*****
        var DynamicForm_CPReport = isc.DynamicForm.create({
            numCols: 16,
            padding: 10,
            readOnlyDisplay: "readOnly",
            margin:0,
            titleAlign:"left",
            wrapItemTitles: true,
            colWidths:[100, 100, 100, 100, 25, 100, 100, 100, 150, 100, 100, 100, 25, 100, 100, 100],
            fields: [
                {
                    name: "firstStartDate",
                    title: "<spring:message code="start.date"/> " + "<spring:message code="from"/> : ",
                    ID: "firstStartDate",
                    colSpan: 3,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    wrapTitle : false,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('firstStartDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkStartDate();
                        CPReport_check_date();
                    }
                },
                {
                    name: "secondStartDate",
                    title: "<spring:message code="till"/>",
                    ID: "secondStartDate",
                    colSpan: 3,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondStartDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkStartDate();
                        CPReport_check_date();
                    }
                },
                {
                    name: "firstFinishDate",
                    title: "<spring:message code="end.date"/> " + "<spring:message code="from"/> : ",
                    ID: "firstFinishDate",
                    colSpan: 3,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    wrapTitle: false,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('firstFinishDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkFinishDate();
                        CPReport_check_date();
                    }

                },
                {
                    name: "secondFinishDate",
                    title: "<spring:message code="till"/>",
                    ID: "secondFinishDate",
                    colSpan: 3,
                    width: "*",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondFinishDate', this, 'ymd', '/');
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
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Institute,
                    displayField: "titleFa",
                    valueField: "titleFa",
                    textAlign: "center",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "inSet"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "category",
                    ID: "category",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="course_category"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Category,
                    displayField: "titleFa",
                    valueField: "titleFa",
                    textAlign: "center",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "inSet"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "subcategory",
                    ID: "subcategory",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="course_subcategory"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Sub_Category,
                    displayField: "titleFa",
                    valueField: "titleFa",
                    textAlign: "center",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "equals"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "term",
                    ID: "term",
                    emptyDisplayValue: "همه",
                    multiple: true,
                    title: "<spring:message code="term"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Term,
                    displayField: ["code"],
                    valueField: ["code"],
                    sortDirection: "descending",
                    textAlign: "center",
                    pickListFields: [
                        {
                            name: "code",
                            title: "<spring:message code='term.code'/>",
                            filterOperator: "iContains"
                        },
                    ],
                    filterFields: [""]
                },
                {
                    name: "searchBtn",
                    ID: "searchBtnJspCPReport",
                    type: "ButtonItem",
                    colSpan: 4,
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
                    name: "planingClasses",
                    title: "<spring:message code="classes.planing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "processingClasses",
                    title: "<spring:message code="classes.processing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "endedClasses",
                    title: "<spring:message code="classes.finished"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "finishedClasses",
                    title: "<spring:message code="classes.finished"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "presentStudents",
                    title: "<spring:message code="students.all.present"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "overtimedStudents",
                    title: "<spring:message code="students.all.overtime"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "absentStudents",
                    title: "<spring:message code="students.all.absent"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "unjustifiedStudents",
                    title: "<spring:message code="students.all.unjustified"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
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



            var criteria = DynamicForm_CPReport.getValuesAsAdvancedCriteria();
            criteria.criteria.remove(criteria.criteria.find({fieldName: "reportType"}));

            console.log(criteria);

            ListGrid_CPReport.implicitCriteria = criteria;
            ListGrid_CPReport.invalidateCache();
            ListGrid_CPReport.fetchData();
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