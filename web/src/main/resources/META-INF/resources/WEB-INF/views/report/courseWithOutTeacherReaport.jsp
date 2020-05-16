<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>


    var endDateCheckReportCWOT = true;
    var modalDialog;
    var RestDataSource_CourseWithOutTeacher = isc.TrDS.create({

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

    var ToolStrip_Actions = isc.ToolStrip.create({
        ID: "ToolStrip_Actions1",
       // width: "100%",
        members: [
            isc.Label.create({
                ID: "totalsLabel_scores"
            })]
    })
    var List_Grid_Reaport_CourseWithOutTeacher = isc.TrLG.create({
      dataSource: RestDataSource_CourseWithOutTeacher,
        showRowNumbers: true,
       //autoFetchData: true,

        fields: [
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},
            {name: "title", title:"<spring:message code="class"/>", align: "center", filterOperator: "iContains",autoFitWidth:true},

        ],
        recordDoubleClick: function () {

        },
        gridComponents: ["filterEditor", "header", "body"],
        dataArrived: function ()
        {
            modalDialog.close();
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,
    });

    var DynamicForm_Report_CourseWithOutTeacher = isc.DynamicForm.create({
       numCols: 9,
        colWidths: ["5%","15%","5%","15%","10%","10%"],
        items: [
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
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("startDate"));
                    if (dateCheck == false)
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                    if (dateCheck == true)
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                        endDateCheckReportCWOT = true;
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").setValue("");
                        endDateCheckReportCWOT = false;
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
                    dateCheck = checkDate(DynamicForm_Report_CourseWithOutTeacher.getValue("endDate"));
                    var endDate = DynamicForm_Report_CourseWithOutTeacher.getValue("endDate");
                    var startDate = DynamicForm_Report_CourseWithOutTeacher.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                        DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReportCWOT = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                           endDateCheckReportCWOT = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReportCWOT = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("endDate", true);
                            DynamicForm_Report_CourseWithOutTeacher.clearFieldErrors("startDate", true);
                            endDateCheckReportCWOT = true;
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


                    if (endDateCheckReportCWOT == false)
                        return;

                    if (!DynamicForm_Report_CourseWithOutTeacher.validate()) {
                        return;
                    }
                    modalDialog=createDialog('wait', 'لطفا منتظر بمانید', 'در حال واکشی اطلاعات');
                    var strSData=DynamicForm_Report_CourseWithOutTeacher.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report_CourseWithOutTeacher.getItem("endDate").getValue().replace(/(\/)/g, "");
                    RestDataSource_CourseWithOutTeacher.fetchDataURL=courseUrl + "courseWithOutTeacher"+"/"+strSData + "/" + strEData;
                    List_Grid_Reaport_CourseWithOutTeacher.invalidateCache();
                    List_Grid_Reaport_CourseWithOutTeacher.fetchData();
                }
            },
         ]
    })

    var ToolStrip_ToolStrip_Personnel_Info_Training_Action = isc.ToolStrip.create({
        width: "30%",
        padding:16,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    ExportToFile.DownloadExcelFormClient(List_Grid_Reaport_CourseWithOutTeacher, null, '', "دوره های بدون استاد");
                }
            })
        ]
    });

    var Hlayout__Personnel_Info_Training_body = isc.HLayout.create({
        height:"10%",
        top:20,
        members: [ToolStrip_ToolStrip_Personnel_Info_Training_Action]
    });


    var Hlayout_Reaport_body = isc.HLayout.create({
        height:"10%",
        members: [DynamicForm_Report_CourseWithOutTeacher, Hlayout__Personnel_Info_Training_body]
    })

    var Hlayout_Reaport_body1=isc.HLayout.create({
        members:[List_Grid_Reaport_CourseWithOutTeacher],
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
