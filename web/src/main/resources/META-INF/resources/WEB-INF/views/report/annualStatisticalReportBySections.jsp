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

    var RestDataSource_annualStatisticalReportBySection = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "title"},
        ], dataFormat: "json",

       // autoFetchData: true,
    });

    var RestDataSource_Institute = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="institute"/>"}
        ],
        fetchDataURL: instituteUrl +"iscTupleList",
        allowAdvancedCriteria: true,
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
            ExportToFile.downloadExcelFromClient(List_Grid_Reaport_annualStatisticalReportBySection, null, '', "دوره های بدون استاد");
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
       //autoFetchData: true,

        fields: [
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "title", title:"<spring:message code="course"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "max_start_date", title:"تاریخ شروع آخرین کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},

        ],
        recordDoubleClick: function () {

        },
            gridComponents: [ToolStrip_Actions,"filterEditor", "header", "body"],



        dataArrived: function ()
        {
            modalDialog.close();

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
                name: "tclassYears",
                title: "سال کاری",
                width:430,
                colSpan:4,
                textAlign:"center",
                titleAlign:"center",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_Filter_annualStatistical,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item =DynamicForm_Report_annualStatisticalReportBySection.getField("tclassYears"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].year;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                        DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setDisabled(true)


                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item =DynamicForm_Report_annualStatisticalReportBySection.getField("tclassYears");
                                        item.setValue([]);
                                        item.pickList.hide();
                                      //  DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setValue([]);
                                       // DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                     if (value != null && value != undefined && value.size() == 1) {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setValue([])
                        let criteria= '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value[0] + '"}';
                        RestDataSource_Term_Filter_annualStatistical.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
                       DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").optionDataSource = RestDataSource_Term_Filter_annualStatistical;
                       DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").fetchData();
                       DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").enable();
                    } else {
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setDisabled(true)
                        DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setValue([])
                    }
                },
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
                name: "termFilters",
                title: "<spring:message code='term'/>",
                width:430,
                colSpan:4,
                textAlign:"center",
                titleAlign:"center",
                endRow:false,
                startRow:true,
                textAlign: "center",
                type: "SelectItem",
                multiple: true,
                filterLocally: true,
                displayField: "code",
                valueField: "id",
                filterFields: ["code"],
                sortField: ["code"],
                sortDirection: "descending",
                defaultToFirstOption: true,
                useClientFiltering: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]",
                },
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    }
                ],
                pickListProperties: {
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item =    DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();

                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").setValue([])
                                       }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    // load_classes_by_term(value);
                },
                dataArrived:function (startRow, endRow, data) {
                    //if(data.allRows[0].id !== undefined)
                  //  {
                        // DynamicForm_Term_Filter.getItem("termFilters").clearValue();
                        // DynamicForm_Term_Filter.getItem("termFilters").setValue(data.allRows[0].code);
                        // load_classes_by_term(data.allRows[0].id);
                   // }
                },
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
                           // item.focusInItem();
                            item.setValue([])
                        }
                    }
                ],
            },

            {
                name: "institute",
                ID: "institute",
              //  emptyDisplayValue: "همه",
                multiple: true,
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
                textMatchStyle: "substring",
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
                        }
                    }
                ],
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


                    if (endDateCheckReportASRBS == false)
                        return;

                    if (!DynamicForm_Report_annualStatisticalReportBySection.validate()) {
                        return;
                    }
                    modalDialog=createDialog('wait');
                    let strSData =(!DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate").getValue() ? '13000101' : DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate").getValue().replace(/(\/)/g, ""));
                    let strEData =(!DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate").getValue() ? '19000101' : DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate").getValue().replace(/(\/)/g, ""));
                    let strSData2 =(!DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate2").getValue() ? '13000101': DynamicForm_Report_annualStatisticalReportBySection.getItem("startDate2").getValue().replace(/(\/)/g, ""));
                    let strEData2 =(!DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate2").getValue() ? '19000101' : DynamicForm_Report_annualStatisticalReportBySection.getItem("endDate2").getValue().replace(/(\/)/g, ""));
                    let Years = (!DynamicForm_Report_annualStatisticalReportBySection.getField("tclassYears").getValue()  ?  "" : DynamicForm_Report_annualStatisticalReportBySection.getField("tclassYears").getValue()) ;
                    let termId =(!DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").getValue()  ?  "" : DynamicForm_Report_annualStatisticalReportBySection.getField("termFilters").getValue());
                  //  let courseId =(!DynamicForm_Report_annualStatisticalReportBySection.getField("courseId").getValue()  ?  "" : DynamicForm_Report_annualStatisticalReportBySection.getField("courseId").getValue());
                   // let teacherId =(!DynamicForm_Report_annualStatisticalReportBySection.getField("teacherId").getValue()  ?  "" : DynamicForm_Report_annualStatisticalReportBySection.getField("teacherId").getValue());
                   // RestDataSource_annualStatisticalReportBySection.fetchDataURL=courseUrl + "courseWithOutTeacher"+"/"+strSData + "/" + strEData +"?strSData2=" +strSData2  +"&strEData2=" +strEData2 +"&Years=" +Years +"&termId=" +termId + "&courseId=" +courseId+ "&teacherId="+teacherId;
                  //  List_Grid_Reaport_annualStatisticalReportBySection.invalidateCache();
                  //  List_Grid_Reaport_annualStatisticalReportBySection.fetchData();
                }
            },

         ]
    })

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