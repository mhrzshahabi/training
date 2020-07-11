<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource  ----------------------------
    var PersonnelDS_PCNR_DF = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
        },
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

    var RestDataSource_Year = isc.TrDS.create({
        fields: [
            {name: "year"}
        ],
        fetchDataURL: termUrl + "years",
        autoFetchData: true
    });

    var RestDataSource_CSReport = isc.TrDS.create({
        fields:
            [
                {name: "EmpNo"},
                {name: "PersonnelNo"},
                {name: "NationalCode"},
                {name: "FirstName"},
                {name: "LastName"},
                {name: "ClassCode"},
                {name: "CourseCode"},
                {name: "CourseTitle"},
                {name: "ComplexTitle"},
                {name: "CompanyName"},
                {name: "Area"},
                {name: "Assistant"},
                {name: "Affairs"},
                {name: "Unit"},
                {name: "PostTitle"},
                {name: "PostCode"},
                {name: "StartDate"},
                {name: "EndDate"},
                {name: "TermId"},
                {name: "Year"},
                {name: "RegestryState"},
                {name: "EvaluationState"},
                {name: "EvaluationPriority"},
                {name: "ClassStatus"},
            ],
        fetchDataURL : continuousStatusReportViewUrl + "/iscList",
        autoFetchData : true
    });


    // ---------------------------------------- Create - RestDataSource -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    var FilterCSR_PCNR = isc.DynamicForm.create({
        // border: "1px solid black",
        // numCols: 10,
        // padding: 10,
        // margin:0,
        numCols: 9,
        titleAlign:"left",
        wrapItemTitles: true,
        fields: [
            {
                name: "personnelPersonnelNo",
                title:"انتخاب پرسنل",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: PersonnelDS_PCNR_DF,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "personnelNo",
                displayField: "personnelNo",
                endRow: false,
                colSpan: 1,
                comboBoxWidth: 200,
                layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    // pickListWidth: 550,
                    pickListFields: [
                        {name: "personnelNo2"},
                        {name: "firstName"},
                        {name: "lastName"},
                        {name: "nationalCode"},
                        {name: "personnelNo"}
                    ],
                    filterFields: ["personnelNo2", "firstName", "lastName", "nationalCode", "personnelNo"],
                    pickListProperties: {sortField: "personnelNo"},
                    textMatchStyle: "substring",
                },
            },
            {
                name: "classStudentNo",
                colSpan: 2,
                type: "SelectItem",
                pickListProperties: {
                    showFilterEditor: false
                },
                multiple: false,
                hidden: false,
                textAlign: "center",
                title: "وضعیت فراگیران کلاس:",
                wrapTitle: false,
                defaultValue: "0",
                valueMap: {
                    "0": "فاقد فراگیر",
                    "1": "دارای فراگیر",
                },
            },
        ],
    });
    
    
        //*****report main dynamic form*****
        var DynamicForm_CSReport = isc.DynamicForm.create({
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
                        checkNullableDate("firstStartDate");
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
                        checkNullableDate("secondStartDate");
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
                    name: "class",
                    ID: "class",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="class"/>",
                    colSpan: 3,
                    width: "*",
                    autoFetchData: false,
                    useClientFiltering: true,
                    // optionDataSource: ,
                    // displayField: "titleFa",
                    // valueField: "id",
                    textAlign: "center",
                    pickListFields: [
                        // {name: "titleFa", filterOperator: "iContains"},
                    ],
                    filterFields: [""]
                },
                {
                    name: "year",
                    ID: "year",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="year"/>",
                    colSpan: 3,
                    width: "*",
                    textAlign: "center",
                    editorType: "ComboBoxItem",
                    displayField: "year",
                    valueField: "year",
                    optionDataSource: RestDataSource_Year,
                    filterFields: ["year"],
                    sortField: ["year"],
                    sortDirection: "descending",
                    defaultToFirstOption: true,
                    useClientFiltering: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    },
                    pickListFields: [
                        {
                            name: "year",
                            title: "<spring:message code='year'/>",
                            filterOperator: "iContains",
                            filterEditorProperties: {
                                keyPressFilter: "[0-9]"
                            }
                        }
                    ],
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
                    name: "searchBtn",
                    ID: "searchBtnJspCSReport",
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

        var ListGrid_CSReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_CSReport,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            showGridSummary: true,
            autoFetchData : true,
            initialSort: [
                {property: "", direction: "ascending"}
            ],
            gridComponents: [
                FilterCSR_PCNR,
                DynamicForm_CSReport,
                // isc.ToolStripButtonExcel.create({
                //     margin:5,
                //     click: function() {
                //         ExportToFile.showDialog(null, ListGrid_ClPReport, 'categoriesPerformanceReport', 0, null, '',  "عملکرد واحدهای آموزشی", DynamicForm_CSReport.getValuesAsAdvancedCriteria(), null);
                //     }
                // })
                , "header", "filterEditor", "body", "summaryRow"
            ],
            fields: [
                {
                    name: "EmpNo",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "PersonnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "NationalCode",
                    title: "<spring:message code="national.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "FirstName",
                    title: "<spring:message code="firstName"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "LastName",
                    title: "<spring:message code="lastName"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "ClassCode",
                    title: "<spring:message code="class.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "CourseCode",
                    title: "<spring:message code="course.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "CourseTitle",
                    title: "<spring:message code="course.title"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "ComplexTitle",
                    title: "<spring:message code="complex"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "CompanyName",
                    title: "<spring:message code="company"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "Area",
                    title: "<spring:message code="area"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "Assistant",
                    title: "<spring:message code="assistance"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "Affairs",
                    title: "<spring:message code="affairs"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "Unit",
                    title: "<spring:message code="unit"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "PostTitle",
                    title: "<spring:message code="post"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "PostCode",
                    title: "<spring:message code="post.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "StartDate",
                    title: "<spring:message code="start.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "EndDate",
                    title: "<spring:message code="end.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "TermId",
                    title: "<spring:message code="term"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "Year",
                    title: "<spring:message code="year"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "RegestryState",
                    title: "<spring:message code="register.status"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "EvaluationState",
                    title: "<spring:message code="evaluation.status"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "EvaluationPriority",
                    title: "<spring:message code="evaluation.level"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "ClassStatus",
                    title: "<spring:message code="class.status"/>",
                    align: "center",
                    filterOperator: "iContains",
                },
            ]
        });

        // <<----------------------------------------------- List Grid --------------------------------------------
        // <<----------------------------------------------- Layout --------------------------------------------
        var Vlayout_Body_CPReport = isc.VLayout.create({
            width: "100%",
            height: "100%",
            overflow: "visible",
            members: [ListGrid_CSReport]
        })

    // <<----------------------------------------------- Layout --------------------------------------------

    // <<----------------------------------------------- Functions --------------------------------------------
        //*****check date is valid*****
        function  checkUndefinedDate(id) {

            DynamicForm_CSReport.clearFieldErrors(id, true);

            if (DynamicForm_CSReport.getValue(id) === undefined || !checkDate(DynamicForm_CSReport.getValue(id))) {
                DynamicForm_CSReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CSReport.clearFieldErrors(id, true);
            }
        }

        function   checkNullableDate(id) {

            DynamicForm_CSReport.clearFieldErrors(id, true);

            if (DynamicForm_CSReport.getValue(id) === undefined){
                DynamicForm_CSReport.getField(id)._value = " ";
            }
            else if (!checkDate(DynamicForm_CSReport.getValue(id))) {
                DynamicForm_CSReport.addFieldErrors(id, "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_CSReport.clearFieldErrors(id, true);
            }
        }

        function CPReport_check_date(id1,id2) {

            if (DynamicForm_CSReport.getValue(id1) !== undefined && DynamicForm_CSReport.getValue(id2) !== undefined) {
                if (DynamicForm_CSReport.getValue(id1) > DynamicForm_CSReport.getValue(id2)) {
                    DynamicForm_CSReport.addFieldErrors(id1, "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_CSReport.addFieldErrors(id2, "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_CSReport.clearFieldErrors(id1, true);
                    DynamicForm_CSReport.clearFieldErrors(id2, true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            checkNullableDate("firstFinishDate");
            checkNullableDate("secondFinishDate");
            checkNullableDate("firstStartDate");
            checkNullableDate("secondStartDate");
            CPReport_check_date("firstStartDate","secondStartDate");
            CPReport_check_date("firstFinishDate","secondFinishDate");


            if (DynamicForm_CSReport.hasErrors())
                return;

            var reportParameters = {
                firstStartDate: firstStartDate._value.replace(/\//g, "^"),
                secondStartDate: secondStartDate._value.replace(/\//g, "^"),
                firstFinishDate: firstFinishDate._value.replace(/\//g, "^"),
                secondFinishDate: secondFinishDate._value.replace(/\//g, "^"),
                class: DynamicForm_CSReport.getValue("class") !== undefined ? DynamicForm_CSReport.getValue("class") : "همه",
                year: DynamicForm_CSReport.getValue("year") !== undefined ? DynamicForm_CSReport.getValue("year") : "همه",
                course: DynamicForm_CSReport.getValue("course") !== undefined ? DynamicForm_CSReport.getValue("course") : "همه",
                term: DynamicForm_CSReport.getValue("term") !== undefined ? DynamicForm_CSReport.getValue("term") : "همه",
                // course: DynamicForm_CSReport.getValue("course") !== undefined ? DynamicForm_CSReport.getValue("course") : "همه"
            };

            RestDataSource_CSReport.fetchDataURL = continuousStatusReportViewUrl + "/iscList" + "/" + JSON.stringify(reportParameters);
            ListGrid_CSReport.invalidateCache();
            ListGrid_CSReport.fetchData();

        }

        //*****calculate total summary*****


        //***********************************
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>