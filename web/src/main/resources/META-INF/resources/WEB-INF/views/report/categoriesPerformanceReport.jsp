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
            fetchDataURL: instituteUrl +"spec-list",
            allowAdvancedCriteria: true,
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

        var RestDataSource_Course = isc.TrDS.create({
            fields: [
                {name: "id"},
                {name: "titleFa"}
            ],
            fetchDataURL: categoryUrl + "spec-list"
        });

        var RestDataSource_Term = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa"},
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
                    {name: "overdueStudents"},
                    {name: "absentStudents"},
                    {name: "unjustifiedStudents"},
                    {name: "unknownStudents"},
                ],
            // fetchDataURL:  + "/iscList",
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
            colWidths:[75, 75, 75, 75, 25, 75, 75, 75, 100, 75, 75, 75, 25, 75, 75, 75],
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
                    required: false,
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
                        // checkStartDate("firstStartDate");
                        // CPReport_check_date("firstStartDate");
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
                    required: false,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondStartDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        // checkStartDate("secondStartDate");
                        // CPReport_check_date("secondStartDate");
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
                    required: false,
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
                        // checkFinishDate("firstFinishDate");
                        // CPReport_check_date("firstFinishDate");
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
                    required: false,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondFinishDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        // checkFinishDate("secondFinishDate");
                        // CPReport_check_date("secondFinishDate");
                    }

                },
                {
                    name: "institute",
                    ID: "institute",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="institute"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Institute,
                    displayField: "titleFa",
                    valueField: "id",
                    textAlign: "center",
                    textMatchStyle: "substring",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "iContains"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "category",
                    ID: "category",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="course_category"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Category,
                    displayField: "titleFa",
                    valueField: "id",
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
                    multiple: false,
                    title: "<spring:message code="course_subcategory"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Sub_Category,
                    displayField: "titleFa",
                    valueField: "id",
                    textAlign: "center",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "equals"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "course",
                    ID: "course",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="course"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Course,
                    displayField: "titleFa",
                    valueField: "id",
                    textAlign: "center",
                    pickListFields: [
                        {name: "titleFa", filterOperator: "inSet"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "term",
                    ID: "term",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="term"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Term,
                    displayField: ["titleFa"],
                    valueField: ["id"],
                    sortField: ["titleFa"],
                    sortDirection: "descending",
                    textAlign: "center",
                    pickListFields: [
                        {
                            name: "titleFa",
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
                    name: "overdueStudents",
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
                {
                    name: "unknownStudents",
                    title: "<spring:message code="students.all.unknown"/>",
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
        function checkStartDate(id) {

            DynamicForm_CPReport.clearFieldErrors(id, true);

            if (DynamicForm_CPReport.getValue(id) === undefined || !checkDate(DynamicForm_CPReport.getValue(id))) {
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors(id, true);
            }
        }

        function checkFinishDate(id) {

            DynamicForm_CPReport.clearFieldErrors(id, true);

            if (DynamicForm_CPReport.getValue(id) === undefined || !checkDate(DynamicForm_CPReport.getValue(id))) {
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors(id, true);
            }
        }

        function CPReport_check_date(id) {

            if (DynamicForm_CPReport.getValue(id) !== undefined && DynamicForm_CPReport.getValue(id) !== undefined) {
                if (DynamicForm_CPReport.getValue(id) > DynamicForm_CPReport.getValue(id)) {
                    DynamicForm_CPReport.addFieldErrors(id, "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_CPReport.addFieldErrors(id, "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_CPReport.clearFieldErrors(id, true);
                    DynamicForm_CPReport.clearFieldErrors(id, true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            /*checkFinishDate("firstFinishDate");
            checkFinishDate("secondFinishDate");
            checkStartDate("firstStartDate");
            checkStartDate("secondStartDate");
            CPReport_check_date("firstFinishDate");
            CPReport_check_date("secondFinishDate");
            CPReport_check_date("firstStartDate");
            CPReport_check_date("secondStartDate");*/

            if (DynamicForm_CPReport.hasErrors())
                return;
            if(firstStartDate._value === undefined || firstStartDate._value === null)
                firstStartDate._value = " ";
            if(secondStartDate._value === undefined || secondStartDate._value === null)
                secondStartDate._value = " ";
            if(firstFinishDate._value === undefined || firstFinishDate._value === null)
                firstFinishDate._value = " ";
            if(secondFinishDate._value === undefined || secondFinishDate._value === null)
                secondFinishDate._value = " ";

            var reportParameters = {
                firstStartDate: firstStartDate._value.replace(/\//g, "^"),
                secondStartDate: secondStartDate._value.replace(/\//g, "^"),
                firstFinishDate: firstFinishDate._value.replace(/\//g, "^"),
                secondFinishDate: secondFinishDate._value.replace(/\//g, "^"),
                institute: DynamicForm_CPReport.getValue("institute") !== undefined ? DynamicForm_CPReport.getValue("institute") : "همه",
                category: DynamicForm_CPReport.getValue("category") !== undefined ? DynamicForm_CPReport.getValue("category") : "همه",
                subcategory: DynamicForm_CPReport.getValue("subcategory") !== undefined ? DynamicForm_CPReport.getValue("subcategory") : "همه",
                term: DynamicForm_CPReport.getValue("term") !== undefined ? DynamicForm_CPReport.getValue("term") : "همه",
                course: DynamicForm_CPReport.getValue("course") !== undefined ? DynamicForm_CPReport.getValue("course") : "همه"
            };

            RestDataSource_CPReport.fetchDataURL = attendancePerformanceReportUrl + "list" + "/" + JSON.stringify(reportParameters);
            //classPerformanceReport
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