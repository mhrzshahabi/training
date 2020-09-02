<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>


    var endDateCheckReportASRBS = true;
    var modalDialog;
    var RestDataSource_Complex_MSReport = isc.TrDS.create({
        fields: [
            {name: "complexTitle", title: "<spring:message code="telephone"/>"}
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    var RestDataSource_Category = isc.TrDS.create({
        fields: [{name: "id"},
            {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscTupleList"
    });

    var RestDataSource_annualStatisticalReportBySection = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [
            {name: "institute_id",hidden:true},
            {name: "institute_title_fa"},
            {name: "category_id"},
            {name: "finished_class_count"},
            {name: "canceled_class_count"},
            {name: "sum_of_duration"},
            {name: "student_count"},
            {name: "sum_of_student_hour"},
        ], dataFormat: "json",
        autoFetchData:false,
    });


    var RestDataSource_Assistant_MSReport = isc.TrDS.create({
        fields: [
            {name: "ccpAssistant", title: "<spring:message code="telephone"/>"}
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    var RestDataSource_Affairs_MSReport = isc.TrDS.create({
        fields: [
            {name: "ccpAffairs", title: "<spring:message code="telephone"/>"}
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });
    var RestDataSource_Unit_MSReport = isc.TrDS.create({
        fields: [
            {name: "ccpUnit", title: "<spring:message code="telephone"/>"}
        ],
        fetchDataURL: departmentUrl +  "/all-field-values?fieldName=ccpUnit"
    });
    var RestDataSource_Year_Filter_annualStatistical = isc.TrDS.create({
        fields: [
            {name: "year"}
        ],
        fetchDataURL: termUrl + "years",
        autoFetchData: true
    });

    var RestDataSource_Term_Filter_annualStatistical = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
    });



    var RestDataSource_Institute = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="institute"/>"}
        ],
        fetchDataURL: instituteUrl +"iscTupleList",
        allowAdvancedCriteria: true,
    });

    var RestDataSource_Term_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspControlReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });


    RestDataSource_CourseDS = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    var ButtonExcel =isc.ToolStripButtonExcel.create({
        margin:5,
        click: function () {
            ExportToFile.downloadExcelFromClient(List_Grid_Reaport_annualStatisticalReportBySection, null, '', "'گزارش آماري سالانه");
        }
    })
    var ToolStrip_Actions = isc.ToolStrip.create({
        // width: "100%",
        members: [
            ButtonExcel,
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({
                ID: "totalsCount_Rows"
            }),]
    })
    var List_Grid_Reaport_annualStatisticalReportBySection = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_annualStatisticalReportBySection,
        showRowNumbers: true,
        fields: [
            {name: "institute_id",hidden:true},
            {name: "institute_title_fa", title:"<spring:message code="institute"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "category_id",  title:"<spring:message code="category"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "finished_class_count",  title:"تعداد کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "canceled_class_count",  title:"تعداد کلاس لغو شده", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "sum_of_duration",  title:"ساعت آموزشی ارائه شده", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "student_count",  title:"تعداد فراگیر", align: "center", filterOperator: "iContains",autoFitWidth:true},

            {name: "sum_of_student_hour",  title:"جمع نفر ساعت آموزشي", align: "center", filterOperator: "iContains",autoFitWidth:true},

        ],
        recordDoubleClick: function () {

        },
        gridComponents: [ToolStrip_Actions,"filterEditor", "header", "body"],

        dataArrived: function ()
        {

            totalsCount_Rows.setContents("&nbsp;");
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                totalsCount_Rows.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                totalsCount_Rows.setContents("&nbsp;");
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,
    });

    var DynamicForm_Report_annualStatisticalReportBySection = isc.DynamicForm.create({
        width: "550px",
        height: "100%",
        overflow:"auto",
        padding: 5,
        cellPadding: 5,
        // titleWidth: 0,
        // titleAlign: "center",
        numCols: 4,
        // colWidths: ["3"],
        items: [
            {

                name: "startDate",
                //height: 35,
                //   titleColSpan: 1,
                // colSpan: 2,
                // titleAlign:"center",
                title: "تاریخ شروع : از",
                ID: "startDate_jspReport",
                type: 'text',
                textAlign:"center",
                titleAlign:"center",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate"));
                    if (result){
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate").setValue(result);
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate", true);
                    }
                },
                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate"));
                    if (dateCheck == false)
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    endDateCheckReportASRBS = false;
                    if (dateCheck == true)
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate", true);
                    endDateCheckReportASRBS = true;
                    var endDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate");
                    var startDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate").setValue("");
                        endDateCheckReportASRBS = false;
                    }
                }
            },

            {
                name: "endDate",
                // height: 35,
                //  width:"1%",
                //  titleColSpan: 1,
                title: "تا",
                titleAlign:"center",
                ID: "endDate_jspReport",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                // colSpan: 2,
                // focus: function () {
                //     displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspReport', this, 'ymd', '/');

                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate"));
                    if (result){
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate").setValue(result);
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate", true);
                    }
                },
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate"));
                    var endDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate");
                    var startDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate", true);
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportASRBS = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate", true);
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportASRBS = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate", true);
                            DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReportASRBS = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate", true);
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate", true);
                            endDateCheckReportASRBS = true;
                        }
                    }
                }

            },
            {

                name: "startDate2",
                //height: 35,
                // width:"5%",
                //   titleColSpan: 1,
                //   colSpan: 2,
                titleAlign:"center",
                title: "تاریخ پایان : از",
                ID: "startDate2_jspReport",
                type: 'text',
                textAlign: "center",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                // focus: function () {
                //     displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_jspReport', this, 'ymd', '/');
                    }
                }],

                editorExit:function(){
                    let result=reformat(DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate2"));
                    if (result){
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate2").setValue(result);
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate2", true);
                    }
                },

                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate2"));
                    if (dateCheck == false)
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    endDateCheckReportASRBS = false;
                    if (dateCheck == true)
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate2", true);
                    endDateCheckReportASRBS = true;
                    var endDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate2");
                    var startDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate2");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate2", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate2").setValue("");
                        endDateCheckReportASRBS = false;
                    }
                }
            },

            {
                name: "endDate2",
                // height: 35,
                //  width:"5%",
                // titleColSpan: 1,
                title: "تا",
                titleAlign:"center",
                ID: "endDate2_jspReport",
                // required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                // colSpan: 2,
                // focus: function () {
                //     displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_jspReport', this, 'ymd', '/');

                    }
                }],
                editorExit:function(){
                    let result=reformat(DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate2"));
                    if (result){
                        DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate2").setValue(result);
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate2", true);
                    }
                },
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate2"));
                    var endDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("endDate2");
                    var startDate = DynamicForm_Report_annualStatisticalReportBySection.getValue("startDate2");
                    if (dateCheck == false) {
                        DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate2", true);
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportASRBS = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate2", true);
                        DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportASRBS = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate2", true);
                            DynamicForm_Report_annualStatisticalReportBySection.addFieldErrors("endDate2", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReportASRBS = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("endDate2", true);
                            DynamicForm_Report_annualStatisticalReportBySection.clearFieldErrors("startDate2", true);
                            endDateCheckReportASRBS = true;
                        }
                    }
                }
            },


            {
                name: "classYear",
                title: "سال",
                type: "SelectItem",
                optionDataSource: RestDataSource_Year_JspControlReport,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                textAlign:"center",
                titleAlign:"center",
                multiple: true,
                filterLocally: true,
                initialSort: [
                    {property: "year", direction: "descending", primarySort: true}
                ],
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
                            DynamicForm_Report_annualStatisticalReportBySection.getField("termId").disable();
                            DynamicForm_Report_annualStatisticalReportBySection.getField("termId").setValue(null);
                            DynamicForm_Report_annualStatisticalReportBySection.getField("classYear").setValue(null);
                        }
                    }
                ],

                changed: function (form, item, value) {
                    if (value != null && value != undefined  && value.size() == 1) {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").clearValue()
                        RestDataSource_Term_JspControlReport.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").optionDataSource = RestDataSource_Term_JspControlReport;
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").fetchData();
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").enable();
                    } else {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").clearValue();
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termId").setDisabled(true)

                    }
                }
            },
            {
                name: "termId",
                title: "ترم",
                type: "SelectItem",
                width:160,
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                textAlign:"center",
                titleAlign:"center",
                multiple: true,
                filterLocally: true,
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
                            DynamicForm_Report_annualStatisticalReportBySection.getField("termId").setValue(null);
                        }
                    }
                ],
            },

            {
                name: "institute",
                ID: "institute",
                //  emptyDisplayValue: "همه",
                //  required: true,
                endRow:false,
                startRow:true,
                title: "<spring:message code="institute"/>",
                width:430,
                colSpan:4,
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Institute,
                displayField: "titleFa",
                valueField: "id",
                textAlign:"center",
                titleAlign:"center",
                multiple: true,
                textMatchStyle: "substring",
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
                ],
                filterFields: [""]
            },
            {
                name: "category",
                ID: "category",
                //emptyDisplayValue: "همه",
                multiple: false,
                title: "<spring:message code="course_category"/>",
                width:430,
                colSpan:4,
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Category,
                displayField: "titleFa",
                valueField: "id",
                textAlign:"center",
                multiple: true,
                titleAlign:"center",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                ],
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
                ],
                filterFields: [""]
            },

            {
                name: "complex_MSReport",
                ID: "complex_MSReport",
                // emptyDisplayValue: "همه",
                multiple: false,
                title: "<spring:message code="complex"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Complex_MSReport,
                textAlign:"center",
                titleAlign:"center",
                valueField: "value",
                displayField: "value",
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
                            DynamicForm_Report_annualStatisticalReportBySection.getField("category").enable()
                        }
                    }
                ],

                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.includes('شهربابک')) {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("category").clearValue()
                        DynamicForm_Report_annualStatisticalReportBySection.getField("category").setValue(null)
                        DynamicForm_Report_annualStatisticalReportBySection.getField("category").setDisabled(true)
                    } else
                    {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("category").enable()
                    }

                }
            },
            {
                name: "Assistant",
                ID: "Assistant",
                // emptyDisplayValue: "همه",
                multiple: false,
                width: 160,
                title: "<spring:message code="assistance"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Assistant_MSReport,
                textAlign:"center",
                titleAlign:"center",
                valueField: "value",
                displayField: "value",
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
                ],
            },
            {
                name: "Affairs",
                ID: "Affairs",
                // emptyDisplayValue: "همه",
                multiple: false,
                title: "<spring:message code="affairs"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Affairs_MSReport,
                textAlign:"center",
                titleAlign:"center",
                valueField: "value",
                displayField: "value",
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
                ],
            },
            {
                name: "Unit",
                ID: "Unit",
                width: 160,
                //emptyDisplayValue: "همه",
                multiple: false,
                title: "<spring:message code="unit"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Unit_MSReport,
                textAlign:"center",
                titleAlign:"center",
                valueField: "value",
                displayField: "value",
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
                ],
            },

            {type: "SpacerItem"},
            {type: "SpacerItem",colSpan:3},
            {type: "SpacerItem"},
            {
                type: "button",
                title: "تهیه گزارش",
                width:418,
                colSpan:3,
                // align:"left",
                titleAlign:"center",
                endRow:false,
                startRow: false,
                click:function () {
                    totalsCount_Rows.setContents("&nbsp;");
                    if (endDateCheckReportASRBS == false)
                        return;

                    if (!DynamicForm_Report_annualStatisticalReportBySection.validate()) {
                        return;
                    }

                    RestDataSource_annualStatisticalReportBySection.fetchDataURL=annualStatisticsReportUrl+"/list" + "?data=" + JSON.stringify(DynamicForm_Report_annualStatisticalReportBySection.getValues())
                    refreshLG(List_Grid_Reaport_annualStatisticalReportBySection);

                }
            }
        ]
    });

    function fill_control_result(resp) {
        if (resp.httpResponseCode === 200) {
            modalDialog.close();
            List_Grid_Reaport_annualStatisticalReportBySection.setData(JSON.parse(resp.data).response.data);
        }
    }

    var ToolStrip_ToolStrip_Personnel_Info_Training_Action = isc.ToolStrip.create({
        width: "30%",
        padding:16,
        members: [
            ToolStrip_Actions
        ]
    });

    var Hlayout__Personnel_Info_Training_body_CWOTR = isc.HLayout.create({
        height:"10%",
        top:20,
        members: [ToolStrip_ToolStrip_Personnel_Info_Training_Action]
    });


    var Hlayout_Reaport_body =  isc.VLayout.create({
        width: "500px",
        height: "100%",
        members: [DynamicForm_Report_annualStatisticalReportBySection]
        //, Hlayout__Personnel_Info_Training_body_CWOTR]
    })

    var Hlayout_Reaport_body1= isc.VLayout.create({
        width: "50%",
        height: "100%",
        border: "1px solid gray",
        members:[List_Grid_Reaport_annualStatisticalReportBySection],
    })

    var Vlayout_Report_body = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [Hlayout_Reaport_body,Hlayout_Reaport_body1]
    })

    function Print(startDate,endDate) {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/unjustified/unjustifiedabsence"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function  PrintPreTest(startDate,endDate)
    {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/preTestScoreReport/printPreTestScore"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function load_term_by_year(value)
    {
        let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value + '"}';
        RestDataSource_Term_Filter_annualStatistical.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
        DynamicForm_Report_annualStatisticalReportBySection.getItem("termFilters").fetchData();
    }