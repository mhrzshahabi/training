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
            fetchDataURL: instituteUrl +"iscTupleList",
            allowAdvancedCriteria: true,
        });

        var RestDataSource_Category = isc.TrDS.create({
            fields: [{name: "id"},
                {name: "titleFa"}],
            fetchDataURL: categoryUrl + "iscTupleList"
        });

        var RestDataSource_Sub_Category = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", type: "text"}
            ],
            fetchDataURL: subCategoryUrl + "iscTupleList",
        });

        var RestDataSource_Course = isc.TrDS.create({
            fields: [
                {name: "id"},
                {name: "titleFa"}
            ],
            fetchDataURL: courseUrl + "iscTupleList"
        });

        var RestDataSource_Term = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa"},
            ],
            fetchDataURL: termUrl + "spec-list",
            autoFetchData: true
        });


        var RestDataSource_ClPReport = isc.TrDS.create({
            fields:
                [
                    {name: "institute"},
                    {name: "category"},
                    {name: "planingClasses"},
                    {name: "processingClasses"},
                    {name: "finishedClasses"},
                    {name: "endedClasses"},
                    // {name: "presentStudents"},
                    // {name: "overdueStudents"},
                    // {name: "absentStudents"},
                    // {name: "unjustifiedStudents"},
                    // {name: "unknownStudents"},
                ],
        });


        var RestDataSource_atPReport = isc.TrDS.create({
            fields:
                [
                    {name: "institute"},
                    {name: "category"},
                    // {name: "planingClasses"},
                    // {name: "processingClasses"},
                    // {name: "finishedClasses"},
                    // {name: "endedClasses"},
                    {name: "presentStudents"},
                    {name: "overdueStudents"},
                    {name: "absentStudents"},
                    {name: "unjustifiedStudents"},
                    {name: "unknownStudents"},
                ],
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
            styleName: "teacher-form",
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
                         checkUndefinedDate("firstStartDate");
                        CPReport_check_date("firstStartDate","secondStartDate");
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
                        checkUndefinedDate("secondStartDate");
                        CPReport_check_date("secondStartDate","firstFinishDate");
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
                        checkNullableDate("firstFinishDate");
                        CPReport_check_date("firstFinishDate","secondFinishDate");
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
                        checkNullableDate("secondFinishDate");
                        CPReport_check_date("firstStartDate","secondFinishDate");
                    }

                },
                {
                    name: "institute",
                    ID: "institute",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    required: true,
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
                    filterFields: [""],
                    icons:[
                        {
                            name: "clear",
                            src: "[SKIN]actions/remove.png",
                            width: 15,
                            height: 15,
                            inline: true,
                            prompt: "پاک کردن",
                            click : function (form, item, icon) {
                                item.clearValue();
                                item.focusInItem();
                                form.setValue(null);
                            }
                        }
                    ]
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
                        {name: "titleFa", filterOperator: "iContains"},
                    ],
                    filterFields: [""],
                    icons:[
                        {
                            name: "clear",
                            src: "[SKIN]actions/remove.png",
                            width: 15,
                            height: 15,
                            inline: true,
                            prompt: "پاک کردن",
                            click : function (form, item, icon) {
                                item.clearValue();
                                item.focusInItem();
                                form.setValue(null);
                            }
                        }
                    ]
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
                        {name: "titleFa", filterOperator: "iContains"},
                    ],
                    filterFields: [""],
                    icons:[
                        {
                            name: "clear",
                            src: "[SKIN]actions/remove.png",
                            width: 15,
                            height: 15,
                            inline: true,
                            prompt: "پاک کردن",
                            click : function (form, item, icon) {
                                item.clearValue();
                                item.focusInItem();
                                form.setValue(null);
                            }
                        }
                    ]
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
                        {name: "titleFa", filterOperator: "iContains"},
                    ],
                    filterFields: [""],
                    icons:[
                        {
                            name: "clear",
                            src: "[SKIN]actions/remove.png",
                            width: 15,
                            height: 15,
                            inline: true,
                            prompt: "پاک کردن",
                            click : function (form, item, icon) {
                                item.clearValue();
                                item.focusInItem();
                                form.setValue(null);
                            }
                        }
                    ]
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
                    sortField: ["id"],
                    sortDirection: "descending",
                    textAlign: "center",
                    pickListFields: [
                        {
                            name: "titleFa",
                            title: "<spring:message code="term.code"/>",
                            filterOperator: "iContains"
                        },
                    ],
                    filterFields: [""],
                    icons:[
                        {
                            name: "clear",
                            src: "[SKIN]actions/remove.png",
                            width: 15,
                            height: 15,
                            inline: true,
                            prompt: "پاک کردن",
                            click : function (form, item, icon) {
                                item.clearValue();
                                item.focusInItem();
                                form.setValue(null);
                            }
                        }
                    ]
                },
                {
                    ID: "reportType",
                    name: "reportType",
                    colSpan: 4,
                    // rowSpan: 1,
                    title: "نوع گزارش :",
                    wrapTitle: false,
                    type: "radioGroup",
                    vertical: false,
                    endRow: true,
                    fillHorizontalSpace: true,
                    defaultValue: "1",
                    valueMap: {
                        "1": "کلاسی",
                        "2": "حضور و غیابی",
                    },
                    change: function (form, item, value, oldValue) {


                        if (value === "1"){
                            Vlayout_Body_CPReport.addMember(ListGrid_ClPReport);
                            Vlayout_Body_CPReport.removeMember(ListGrid_atPReport);
                        }
                        else if(value === "2"){
                            Vlayout_Body_CPReport.removeMember(ListGrid_ClPReport);
                            Vlayout_Body_CPReport.addMember(ListGrid_atPReport);
                        }
                        else
                            return false;

                    }
                },
                {
                    name: "searchBtn",
                    ID: "searchBtnJspCPReport",
                    type: "ButtonItem",
                    colSpan: 2,
                    width:"*",
                    startRow:false,
                    endRow:false,
                    title: "<spring:message code="reporting"/>",
                    click: function () {
                        searchResult();
                    }
                },
                {
                    type: "button",
                    width:"*",
                    startRow:false,
                    endRow:false,
                    colSpan: 2,
                    title: "<spring:message code="global.form.print.excel"/>",
                    click: function () {
                        if (ListGrid_ClPReport.data.size()>0 || ListGrid_atPReport.data.size()>0) {
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

                            if (DynamicForm_CPReport.getValue("reportType") === "1") {
                                ExportToFile.downloadExcelRestUrl(null, ListGrid_ClPReport, classPerformanceReport + "list" + "/" + JSON.stringify(reportParameters), 0, null, '', "لیست گزارش عملکرد واحدهای آموزشی - کلاسی", ListGrid_ClPReport.getCriteria(), null);
                            }
                            else {
                                ExportToFile.downloadExcelRestUrl(null, ListGrid_atPReport, attendancePerformanceReportUrl + "list" + "/" + JSON.stringify(reportParameters), 0, null, '', "لیست گزارش عملکرد واحدهای آموزشی - حضور و غیابی", ListGrid_atPReport.getCriteria(), null);
                            }
                        }
                    }
                },
            ]
        });
        // ----------------------------------- Create - DynamicForm & Window --------------------------->>
        // <<----------------------------------------------- List Grid --------------------------------------------

        var ListGrid_ClPReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_ClPReport,
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
                // isc.ToolStripButtonExcel.create({
                //     margin:5,
                //     click: function() {
                //         ExportToFile.showDialog(null, ListGrid_ClPReport, 'categoriesPerformanceReport', 0, null, '',  "عملکرد واحدهای آموزشی", DynamicForm_CPReport.getValuesAsAdvancedCriteria(), null);
                //     }
                // })
                , "header", "filterEditor", "body", "summaryRow"
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
                    // summaryFunction: "totalCategory(records)",
                },
                {
                    name: "planingClasses",
                    title: "<spring:message code="classes.planing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPlaningClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "processingClasses",
                    title: "<spring:message code="classes.processing"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalProcessingClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "finishedClasses",
                    title: "<spring:message code="classes.finished"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalFinishedClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "endedClasses",
                    title: "<spring:message code="classes.ended"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalEndedClasses(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
            ]
        });

    }


        var ListGrid_atPReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_atPReport,
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
                // isc.ToolStripButtonExcel.create({
                //     margin:5,
                //     click: function() {
                //
                //         let criteria = DynamicForm_CPReport.getValuesAsAdvancedCriteria();
                //
                //         if(criteria != null && Object.keys(criteria).length != 0) {
                //
                //         }else{
                //             return ;
                //         }
                //
                //         ExportToFile.showDialog(null, ListGrid_CPReport, 'categoriesPerformanceReport', 0, null, '',  "عملکرد واحدهای آموزشی", criteria, null);
                //     }
                // })
                , "header", "filterEditor", "body", "summaryRow"
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
                    // summaryFunction: "totalCategory(records)",
                },
                {
                name: "presentStudents",
                title: "<spring:message code="students.all.present"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: "totalPresentStudents(records)",
                filterEditorProperties: {
                keyPressFilter: "[0-9|:]"
                }
                },
                {
                name: "overdueStudents",
                title: "<spring:message code="students.all.overtime"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: "totalOverdueStudents(records)",
                filterEditorProperties: {
                keyPressFilter: "[0-9|:]"
                }
                },
                {
                name: "absentStudents",
                title: "<spring:message code="students.all.absent"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: "totalAbsentStudents(records)",
                filterEditorProperties: {
                keyPressFilter: "[0-9|:]"
                }
                },
                {
                name: "unjustifiedStudents",
                title: "<spring:message code="students.all.unjustified"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: "totalUnjustifiedStudents(records)",
                filterEditorProperties: {
                keyPressFilter: "[0-9|:]"
                }
                },
                {
                name: "unknownStudents",
                title: "<spring:message code="students.all.unknown"/>",
                align: "center",
                filterOperator: "iContains",
                summaryFunction: "totalUnknownStudents(records)",
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
            members: [ListGrid_ClPReport]
        })

    // <<----------------------------------------------- Layout --------------------------------------------

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function  checkUndefinedDate(id) {

            DynamicForm_CPReport.clearFieldErrors(id, true);

            if (DynamicForm_CPReport.getValue(id) === undefined || !checkDate(DynamicForm_CPReport.getValue(id))) {
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code="msg.correct.date"/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors(id, true);
            }
        }

        function   checkNullableDate(id) {

            DynamicForm_CPReport.clearFieldErrors(id, true);

            if (DynamicForm_CPReport.getValue(id) === undefined){
                DynamicForm_CPReport.getField(id)._value = " ";
            }
            else if (!checkDate(DynamicForm_CPReport.getValue(id))) {
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code="msg.correct.date"/>", true);
            } else {
                DynamicForm_CPReport.clearFieldErrors(id, true);
            }
        }

        function CPReport_check_date(id1,id2) {

            if (DynamicForm_CPReport.getValue(id1) !== undefined && DynamicForm_CPReport.getValue(id2) !== undefined) {
                if (DynamicForm_CPReport.getValue(id1) > DynamicForm_CPReport.getValue(id2)) {
                    DynamicForm_CPReport.addFieldErrors(id1, "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_CPReport.addFieldErrors(id2, "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_CPReport.clearFieldErrors(id1, true);
                    DynamicForm_CPReport.clearFieldErrors(id2, true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            checkNullableDate("firstFinishDate");
            checkNullableDate("secondFinishDate");
            checkUndefinedDate("firstStartDate");
            checkUndefinedDate("secondStartDate");
            CPReport_check_date("firstStartDate","secondStartDate");
            CPReport_check_date("firstFinishDate","secondFinishDate");

            if (DynamicForm_CPReport.hasErrors())
                return;
            /*if(firstStartDate._value === undefined || firstStartDate._value === null)
                firstStartDate._value = " ";
            if(secondStartDate._value === undefined || secondStartDate._value === null)
                secondStartDate._value = " ";
            if(firstFinishDate._value === undefined || firstFinishDate._value === null)
                firstFinishDate._value = " ";
            if(secondFinishDate._value === undefined || secondFinishDate._value === null)
                secondFinishDate._value = " ";*/

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

            if (DynamicForm_CPReport.getValue("reportType") === "1"){
                RestDataSource_ClPReport.fetchDataURL = classPerformanceReport + "list" + "/" + JSON.stringify(reportParameters);
                //classPerformanceReport
                ListGrid_ClPReport.invalidateCache();
                ListGrid_ClPReport.fetchData();
            }
            else if(DynamicForm_CPReport.getValue("reportType") === "2"){
                RestDataSource_atPReport.fetchDataURL = attendancePerformanceReportUrl + "list" + "/" + JSON.stringify(reportParameters);
                //attendancePerformanceReport
                ListGrid_atPReport.invalidateCache();
                ListGrid_atPReport.fetchData();
            }


        }

        //*****calculate total summary*****
        function totalSummary() {
            return "جمع کل :";
        }

        function totalPlaningClasses(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].planingClasses;
            }
            return total.toString();
        }

        function totalProcessingClasses(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].processingClasses;
            }
            return total.toString();
        }

        function totalFinishedClasses(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].finishedClasses;
            }
            return total.toString();
        }

        function totalEndedClasses(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].endedClasses;
            }
            return total.toString();
        }

        function totalPresentStudents(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].presentStudents;
            }
            return total.toString() + " نفر بر ساعت";
        }

        function totalOverdueStudents(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].overdueStudents;
            }
            return total.toString() + " نفر بر ساعت";
        }

        function totalAbsentStudents(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].absentStudents;
            }
            return total.toString() + " نفر بر ساعت";
        }

        function totalUnjustifiedStudents(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].unjustifiedStudents;
            }
            return total.toString() + " نفر بر ساعت";
        }

        function totalUnknownStudents(records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].unknownStudents;
            }
            return total.toString() + " نفر بر ساعت";
        }

        //***********************************

    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>