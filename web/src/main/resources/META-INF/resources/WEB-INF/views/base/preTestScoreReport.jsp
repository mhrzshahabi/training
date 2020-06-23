<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var endDateCheckReport = true;

    var RestDataSource_PreTestScore = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleClass"},
            {name: "preTestScore"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "employeNo"},
            {name: "personnelNo"},
            {name: "nationalCode"},
            {name: "preTestScoreParameterValue"}
        ], dataFormat: "json",

       // autoFetchData: true,
    });
    var ToolStripButton_ExportToExcel = isc.ToolStripButtonExcel.create({
        click: function () {

            let rows = List_Grid_Reaport.data.getAllLoadedRows();
            let result = ExportToFile.getAllFields(List_Grid_Reaport);
            result.fields.splice(1, 0, {name:"titleClass",title:"عنوان کلاس"});
            result.isValueMap.splice(1, 0, false);
            let fields = result.fields;
            let isValueMaps = result.isValueMap;
            let data = [];
            for (let i = 0; i < rows.length; i++) {
                data[i] = {};
                for (let j = 0; j < fields.length; j++) {
                    if (fields[j].name == 'rowNum') {
                        data[i][fields[j].name] = (i + 1).toString();
                    } else {
                        let tmpStr = ExportToFile.getData(rows[i], fields[j].name.split('.'), 0);
                        data[i][fields[j].name] = typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? tmpStr : listGrid.getDisplayValue(fields[j].name, tmpStr));
                    }
                }
            }
            ExportToFile.exportToExcelFromClient(fields, data, '', "نمره پیش تست بیشتر از حد قبول")
        }
    })
    var ToolStrip_Actions = isc.ToolStrip.create({
        ID: "ToolStrip_Actions1",
       // width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores"
            }),

            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_ExportToExcel
                ]
            })


        ]
    })
    var List_Grid_Reaport = isc.TrLG.create({
      dataSource: RestDataSource_PreTestScore,
        showRowNumbers: false,
       //autoFetchData: true,

        fields: [
            // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleClass", title: "عنوان کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "firstName", title: "نام", align: "center", filterOperator: "iContains"},
            {name: "lastName",title: "نام خانوادگی",align: "center",filterOperator: "iContains"},
            {name: "nationalCode",title: "کد ملی",align: "center",filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "startDate",title: "تاریخ شروع",align: "center",filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "endDate",title: "تاریخ پایان",align: "center",filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "personnelNo2",title: "شماره پرسنلی 6 رقمي",align: "center",filterOperator: "iContains",canFilter:false,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo",title: "شماره پرسنلی",align: "center",filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "preTestScore",title: "نمره پیش آزمون/تست",align: "center",filterOperator: "iContains"}


        ],
        recordDoubleClick: function () {

        },
        gridComponents: [ToolStrip_Actions,"filterEditor", "header", "body"],
        dataArrived: function ()
        {
            if (List_Grid_Reaport.data.localData.length >0)
            totalsLabel_scores.setContents("حد نمره پيش تست" + ":&nbsp;<b>" + List_Grid_Reaport.getRecord(0).preTestScoreParameterValue + "</b>" + "&nbsp;&nbsp;&nbsp;&nbsp;")
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,    });

    var DynamicForm_Report = isc.DynamicForm.create({
       numCols: 9,
        colWidths: ["5%","15%","5%","15%","10%","10%"],
        fields: [
            {

                name: "startDate",
               // height: 35,
             //   titleColSpan: 1,
             //   colSpan: 2,
                titleAlign:"center",
                title: "از تاریخ",
                ID: "startDate_jspReport",
                type: 'text',
                required: true,
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
                        displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                    }
                }],


                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report.getValue("startDate"));
                    if (dateCheck == false)
                        DynamicForm_Report.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReport = false;
                    if (dateCheck == true)
                        DynamicForm_Report.clearFieldErrors("startDate", true);
                        endDateCheckReport = true;
                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report.getItem("endDate").setValue("");
                        endDateCheckReport = false;
                    }
                }
            },

                {
                name: "endDate",
               // height: 35,
               // titleColSpan: 1,
                title: "تا تاریخ",
               titleAlign:"center",
                ID: "endDate_jspReport",
                required: true,
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
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report.getValue("endDate"));
                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report.clearFieldErrors("endDate", true);
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReport = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                           endDateCheckReport = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReport = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.clearFieldErrors("startDate", true);
                            endDateCheckReport = true;
                        }
                    }
                }

            },
            {
                 type: "button",
                 title: "تهیه گزارش",
                 height:"25",
                 align:"center",
                 endRow:false,
                 startRow: false,

                click:function () {
                    if (endDateCheckReport == false)
                        return;

                    if (!DynamicForm_Report.validate()) {
                        return;
                    }

                    var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                    RestDataSource_PreTestScore.fetchDataURL=preTestScoreReportURL + "spec-list"+"/"+strSData + "/" + strEData;
                    totalsLabel_scores.setContents('')
                    List_Grid_Reaport.invalidateCache();
                    List_Grid_Reaport.fetchData();
                }
            },
            {
                type: "button",
                    startRow:false,
                    align:"center",
                    title: "چاپ گزارش",
                    height:"25",
                   click:function () {
                        if (endDateCheckReport == false)
                            return;
                        if (!DynamicForm_Report.validate()) {
                            return;
                        }
                       var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                       var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                       PrintPreTest(strSData,strEData)
                    }


            },

        ]
    })

    var Hlayout_Reaport_body = isc.HLayout.create({
        height:"10%",
        members: [DynamicForm_Report]
    })

    var Hlayout_Reaport_body1=isc.HLayout.create({
        members:[List_Grid_Reaport],
    })

    var Vlayout_Report_body = isc.VLayout.create({
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
