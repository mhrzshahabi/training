<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource  ----------------------------
        var RestDataSource_CTReport = isc.TrDS.create({
            fields:
                [

                ],
        });


    // ---------------------------------------- Create - RestDataSource -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
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
                /*{
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
                        {name: "titleFa", filterOperator: "iContains"},
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
                        {name: "titleFa", filterOperator: "iContains"},
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
                        {name: "titleFa", filterOperator: "iContains"},
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
                    colSpan: 4,
                    width:"*",
                    startRow:false,
                    endRow:false,
                    title: "<spring:message code="reporting"/>",
                    click: function () {
                        searchResult();
                    }
                }*/
            ]
        });
        // ----------------------------------- Create - DynamicForm & Window --------------------------->>
        // <<----------------------------------------------- List Grid --------------------------------------------

        var ListGrid_CTReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_CTReport,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            showGridSummary: true,
            initialSort: [
                {property: "", direction: "ascending"}
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

            ]
        });

        // <<----------------------------------------------- List Grid --------------------------------------------
        // <<----------------------------------------------- Layout --------------------------------------------
        var Vlayout_Body_CPReport = isc.VLayout.create({
            width: "100%",
            height: "100%",
            overflow: "visible",
            members: [ListGrid_CTReport]
        })

    // <<----------------------------------------------- Layout --------------------------------------------

    // <<----------------------------------------------- Functions --------------------------------------------
        //*****check date is valid*****
        function  checkUndefinedDate(id) {

            DynamicForm_CPReport.clearFieldErrors(id, true);

            if (DynamicForm_CPReport.getValue(id) === undefined || !checkDate(DynamicForm_CPReport.getValue(id))) {
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
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
                DynamicForm_CPReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
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

        }

        //*****calculate total summary*****


        //***********************************
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>