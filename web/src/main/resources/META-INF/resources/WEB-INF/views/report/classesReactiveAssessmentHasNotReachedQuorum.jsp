<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var complex = [];
    var assistance = [];
    var affairs = [];
    var section = [];
    var unit = [];

    let reportCriteria_AssessmentHasNotReachedQuorum;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//

    RestDataSource_Class_JspAssessmentHasNotReachedQuorum = isc.TrDS.create({
        fields: [
            {name: "mojtameTitle"},
            {name: "classCode"},
            {name: "courseCode"},
            {name: "courseTitle"},
            {name: "teacherName"},
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "classDuration"},
             {name: "supervisorName"},
             {name: "reactionPercent"},
             {name: "reactiveLimit"},
         ],
        fetchDataURL: classesReactiveAssessmentHasNotReachedQuorumReportUrl + "/iscList?_endRow=10000"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//

    ToolStripButton_Excel_AssessmentHasNotReachedQuorum = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });

    ToolStripButton_Refresh_AssessmentHasNotReachedQuorum = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_AssessmentHasNotReachedQuorum.invalidateCache();
        }
    });

    ToolStrip_Actions_AssessmentHasNotReachedQuorum = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_AssessmentHasNotReachedQuorum,
                        ToolStripButton_Excel_AssessmentHasNotReachedQuorum
                    ]
                })
            ]
    });

    var organSegmentFilter_AssessmentHasNotReachedQuorum = init_OrganSegmentFilterDF(true, true, true, false, false, null, "complexTitle","assistant","affairs", "section", "unit");

    for (let i = 2; i < organSegmentFilter_AssessmentHasNotReachedQuorum.getFields().length; i++) {
        organSegmentFilter_AssessmentHasNotReachedQuorum.getFields()[i].hide();
    }

    var DynamicForm_AssessmentHasNotReachedQuorum = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "center",
        width: "100%",
        align: "center",
        colWidths: ["10%", "10%", "10%", "10%", "10%", "10%", "10%", "10%"],
        fields: [
            {
                colSpan: 1,
                hidden: true
            },
            {
                name: "startDate",
                titleColSpan: 1,
                colSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspAssessmentHasNotReachedQuorum",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspAssessmentHasNotReachedQuorum', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    // var endDate = form.getValue("endDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                colSpan: 2,
                hidden: true
            },
            {
                name: "endDate",
                titleColSpan: 1,
                colSpan: 1,
                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspAssessmentHasNotReachedQuorum",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspAssessmentHasNotReachedQuorum', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                hidden: true
            }
        ]
    });

    IButton_AssessmentHasNotReachedQuorum = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            let form = DynamicForm_AssessmentHasNotReachedQuorum;
            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            if(form.getValuesAsAdvancedCriteria() == null || form.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                createDialog("info","بازه زمان مشخص نشده است");
                return;
            }

            complex = [];
            assistance = [];
            affairs = [];
            section = [];
            unit = [];

            if (organSegmentFilter_AssessmentHasNotReachedQuorum.getCriteria() !== undefined) {

                reportCriteria_AssessmentHasNotReachedQuorum = organSegmentFilter_AssessmentHasNotReachedQuorum.getCriteria();

                DynamicForm_AssessmentHasNotReachedQuorum.validate();
                if (DynamicForm_AssessmentHasNotReachedQuorum.hasErrors())
                    return;

                for (let i = 0; i < reportCriteria_AssessmentHasNotReachedQuorum.criteria.size(); i++) {

                    if (reportCriteria_AssessmentHasNotReachedQuorum.criteria[i].fieldName === "complexTitle") {
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria[i].fieldName = "mojtameTitle";
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria[i].operator = "inSet";
                        complex.add(reportCriteria_AssessmentHasNotReachedQuorum.criteria[i].value);
                    }

                }

                data_values = DynamicForm_AssessmentHasNotReachedQuorum.getValuesAsAdvancedCriteria();

                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName === "startDate") {
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria.add(
                            {
                                fieldName: "classStartDate",
                                operator: "greaterOrEqual",
                                 value: form.getValue("startDate")
                            }
                        );
                    }
                    else if (data_values.criteria[i].fieldName === "endDate") {
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria.add(
                            {
                                fieldName: "classEndDate",
                                operator: "lessOrEqual",
                                value: form.getValue("endDate")
                            }
                        );
                    }
                }

                ListGrid_AssessmentHasNotReachedQuorum.invalidateCache();
                ListGrid_AssessmentHasNotReachedQuorum.fetchData(reportCriteria_AssessmentHasNotReachedQuorum);

            } else {

                reportCriteria_AssessmentHasNotReachedQuorum = {
                    "operator": "and",
                    "_constructor": "AdvancedCriteria",
                    "criteria": []
                };

                data_values = DynamicForm_AssessmentHasNotReachedQuorum.getValuesAsAdvancedCriteria();

                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName === "startDate") {
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria.add(
                            {
                                fieldName: "classStartDate",
                                operator: "greaterOrEqual",
                                value:  form.getValue("startDate")
                            }
                        );
                    } else if (data_values.criteria[i].fieldName === "endDate") {
                        reportCriteria_AssessmentHasNotReachedQuorum.criteria.add(
                            {
                                fieldName: "classStartDate",
                                operator: "lessOrEqual",
                                value: form.getValue("startDate")
                            }
                        );
                    }
                }

                ListGrid_AssessmentHasNotReachedQuorum.invalidateCache();
                ListGrid_AssessmentHasNotReachedQuorum.fetchData(reportCriteria_AssessmentHasNotReachedQuorum);
            }

        }
    });

    IButton_Clear_AssessmentHasNotReachedQuorum = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            DynamicForm_AssessmentHasNotReachedQuorum.clearValues();
            DynamicForm_AssessmentHasNotReachedQuorum.clearErrors();
            organSegmentFilter_AssessmentHasNotReachedQuorum.clearValues();
            ListGrid_AssessmentHasNotReachedQuorum.setData([]);
        }
    });

    var HLayOut_Confirm_AssessmentHasNotReachedQuorum = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_AssessmentHasNotReachedQuorum,
            IButton_Clear_AssessmentHasNotReachedQuorum
        ]
    });

    var ListGrid_AssessmentHasNotReachedQuorum = isc.TrLG.create({
        ID: "AssessmentHasNotReachedQuorumGrid",
        autoFitWidth: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Class_JspAssessmentHasNotReachedQuorum,
        fields: [
            {name: "mojtameTitle", title: "مجتمع" },
            {name: "classCode", title: "کد کلاس" },
            {name: "courseCode", title: "کد دوره" },
            {name: "courseTitle", title: "عنوان دوره" },
            {name: "teacherName", title: "نام استاد"},
            {name: "classStartDate", title: "تاریخ شروع" },
            {name: "classEndDate", title: "تاریخ پایان" },
            {name: "classDuration", title: "مدت" },
            {name: "supervisorName", title: "مسئول اجرا" },
            {name: "reactionPercent", title: "نمره ارزیابی واکنشی" },
            {name: "reactiveLimit", title: "حد نصاب ارزیابی واکنشی" },
        ]
    });

    var VLayout_Body_AssessmentHasNotReachedQuorum = isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_AssessmentHasNotReachedQuorum,
            organSegmentFilter_AssessmentHasNotReachedQuorum,
            DynamicForm_AssessmentHasNotReachedQuorum,
            HLayOut_Confirm_AssessmentHasNotReachedQuorum,
            ListGrid_AssessmentHasNotReachedQuorum
        ]
    });

    function makeExcelOutput() {

        if (ListGrid_AssessmentHasNotReachedQuorum.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_AssessmentHasNotReachedQuorum, classesReactiveAssessmentHasNotReachedQuorumReportUrl + "/iscList?_endRow=10000", 0, null, '',"گزارش کلاسهایی که ارزیابی واکنشی آنها به حدنصاب نرسیده"  , reportCriteria_AssessmentHasNotReachedQuorum, null);
    }

    //</script>
