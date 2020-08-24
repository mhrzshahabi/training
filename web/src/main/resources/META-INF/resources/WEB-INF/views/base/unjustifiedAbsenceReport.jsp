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
  
    var RestDataSource_unjustifiedAbsenceReport = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "sessionDate"},
            {name: "lastName"},
            {name: "firstName"},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "endHour"},
            {name: "startHour"},
            {name: "code"},

        ], dataFormat: "json",

        // autoFetchData: true,
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        ID: "ToolStrip_Actions1",
        // width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores"
            })]
    })

    var ToolStripButton_ExportToExcel = isc.ToolStripButtonExcel.create({
        margin:5,
        click: function () {
            let title="گزارش غيبت ناموجه از تاریخ "+DynamicForm_Report.getItem("startDate").getValue()+ " الی "+DynamicForm_Report.getItem("endDate").getValue();

            ExportToFile.showDialog(null, List_Grid_Reaport, 'unjustifiedAbsence', 0, null, '', title, List_Grid_Reaport.data.criteria, null);
        }
    })

    ToolStripButton_ExportToExcel.setDisabled(true);

    var List_Grid_Reaport = isc.TrLG.create({
        dataSource: RestDataSource_unjustifiedAbsenceReport,
        showRowNumbers: true,
        gridComponents: [ToolStripButton_ExportToExcel,"filterEditor", "header", "body"],
        fields: [
            // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "titleClass", title: "عنوان کلاس", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "firstName", title: "نام", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "lastName",title: "نام خانوادگی",align: "center",filterOperator: "iContains"},
            {name: "startDate",title: "تاریخ شروع",align: "center",filterOperator: "iContains"},
            {name: "endDate",title: "تاریخ پایان",align: "center",filterOperator: "iContains"},
            {name: "startHour",title: "ساعت شروع",align: "center",filterOperator: "iContains"},
            {name: "endHour",title: "ساعت پایان",align: "center",filterOperator: "iContains"},
            {name: "sessionDate",title: "جلسه",align: "center",filterOperator: "iContains"},
        ],

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

                    ToolStripButton_ExportToExcel.setDisabled(false);
                    var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                    let url = unjustifiedAbsenceReport + "list?startDate=" + strSData + "&endDate=" + strEData;

                    RestDataSource_unjustifiedAbsenceReport.fetchDataURL=url;
                    List_Grid_Reaport.fetchData();
                    List_Grid_Reaport.invalidateCache();
                    List_Grid_Reaport.fetchData();
                }
            },
            // {
            //     type: "button",
            //     startRow:false,
            //     align:"center",
            //     title: "چاپ گزارش",
            //     height:"25",
            //     click:function () {
            //         if (endDateCheckReport == false)
            //             return;
            //         if (!DynamicForm_Report.validate()) {
            //             return;
            //         }
            //         var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
            //         var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
            //         Print(strSData,strEData);
            //     }
            //
            //
            // },
        ]
    })

    var Hlayout_Reaport_body = isc.HLayout.create({
        height:"5%",
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
            action: "<spring:url value="/unjustifiedAbsenceReport/unjustifiedAbsence"/>" +"/"+startDate + "/" + endDate,
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

