<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//

    RestDataSource_Class_JspNeedAssessmentsPerformed = isc.TrDS.create({
        fields: [
            {name: "postType"},
            {name: "postCode"},
            {name: "postTitle"},
            {name: "updateBy"},
            {name: "updateAt"},
            {name: "version"}
        ]
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//

    ToolStripButton_Excel_NeedAssessmentsPerformed = isc.ToolStripButtonExcel.create({

        click: function () {

            makeExcelOutput();
        }
    });

    ToolStripButton_Refresh_NeedAssessmentsPerformed = isc.ToolStripButtonRefresh.create({
        click: function () {

            ListGrid_Training_Post.invalidateCache();
        }
    });

    ToolStrip_Actions_NeedAssessmentsPerformed = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_NeedAssessmentsPerformed,
                        ToolStripButton_Excel_NeedAssessmentsPerformed
                    ]
                })
            ]
    });

    var organSegmentFilter_NeedAssessmentsPerformed = init_OrganSegmentFilterDF(true, true , null, "complexTitle","assistant","affairs", "section", "unit");

    var DynamicForm_NeedsAssessmentsPerformed = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "center",
        width: "100%",
        align: "center",
        // colWidths: [70, 200, 70, 200, 100, 100],
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
                ID: "startDate_jspNeedAssessmentsPerformed",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspNeedAssessmentsPerformed', this, 'ymd', '/');
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
                ID: "endDate_jspNeedAssessmentsPerformed",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspNeedAssessmentsPerformed', this, 'ymd', '/');
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
            },
            <%--{--%>
                <%--name: "searchBtn",--%>
                <%--ID: "searchBtnJspNeedsAssessmentsPerformed",--%>
                <%--title: "<spring:message code="search"/>",--%>
                <%--type: "ButtonItem",--%>
                <%--width: "*",--%>
                <%--startRow: false,--%>
                <%--endRow: false,--%>
                <%--click(form) {--%>
                    <%--if(form.getValue("endDate") < form.getValue("startDate")) {--%>
                        <%--createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");--%>
                        <%--return;--%>
                    <%--}--%>
                    <%--if(DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria()==null || DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria().criteria.size() <= 1) {--%>
                        <%--createDialog("info","فیلتری انتخاب نشده است.");--%>
                        <%--return;--%>
                    <%--}--%>

                    <%--DynamicForm_NeedsAssessmentsPerformed.validate();--%>
                    <%--if (DynamicForm_NeedsAssessmentsPerformed.hasErrors())--%>
                        <%--return;--%>


                    <%--else {--%>
                        <%--var training_over_time_wait = createDialog("wait");--%>
                        <%--setTimeout(function () {--%>
                            <%--let url = needsAssessmentsPerformedUrl + "/list/" + gregorianDate(form.getValue("startDate")) + "/" + gregorianDate(form.getValue("endDate"));--%>
                            <%--RestDataSource_Class_JspNeedAssessmentsPerformed.fetchDataURL = url;--%>

                            <%--ListGrid_NeedAssessmentsPerformed.invalidateCache();--%>
                            <%--ListGrid_NeedAssessmentsPerformed.fetchData();--%>
                            <%--training_over_time_wait.close();--%>

                        <%--}, 100);--%>

                        <%--// data_values = DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria();--%>
                        <%--// for (let i = 0; i < data_values.criteria.size(); i++) {--%>
                        <%--//--%>
                        <%--//     if (data_values.criteria[i].fieldName == "startDate") {--%>
                        <%--//         data_values.criteria[i].fieldName = "date";--%>
                        <%--//         data_values.criteria[i].operator = "greaterThan";--%>
                        <%--//     } else if (data_values.criteria[i].fieldName == "endDate") {--%>
                        <%--//         data_values.criteria[i].fieldName = "date";--%>
                        <%--//         data_values.criteria[i].operator = "lessThan";--%>
                        <%--//     }--%>
                        <%--// }--%>
                        <%--//--%>
                        <%--//     ListGrid_NeedAssessmentsPerformed.invalidateCache();--%>
                        <%--//     ListGrid_NeedAssessmentsPerformed.fetchData(data_values);--%>
                        <%--//--%>
                        <%--//     return;--%>

                    <%--}--%>
                <%--}--%>
            <%--}--%>
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspNeedsAssessmentsPerformed.click(DynamicForm_NeedsAssessmentsPerformed);
            }
        }
    });

    IButton_NeedAssessmentsPerformed = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            let form = DynamicForm_NeedsAssessmentsPerformed;
            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            if(form.getValuesAsAdvancedCriteria() == null || form.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_NeedsAssessmentsPerformed.validate();
            if (DynamicForm_NeedsAssessmentsPerformed.hasErrors())
                return;




            // wait.show();
            // setTimeout(function () {
            //     let url = needsAssessmentsPerformedUrl + "/list/" + gregorianDate(form.getValue("startDate")) + "/" + gregorianDate(form.getValue("endDate"));
            //     RestDataSource_Class_JspNeedAssessmentsPerformed.fetchDataURL = url;
            //
            //     ListGrid_NeedAssessmentsPerformed.invalidateCache();
            //     ListGrid_NeedAssessmentsPerformed.fetchData();
            //     wait.close();
            //
            // }, 100);
        }
    });

    IButton_Clear_NeedAssessmentsPerformed = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            DynamicForm_NeedsAssessmentsPerformed.clearValues();
            DynamicForm_NeedsAssessmentsPerformed.clearErrors();
            organSegmentFilter_NeedAssessmentsPerformed.clearValues();
            ListGrid_NeedAssessmentsPerformed.setData([]);
        }
    });

    var HLayOut_Confirm_NeedAssessmentsPerformed = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_NeedAssessmentsPerformed,
            IButton_Clear_NeedAssessmentsPerformed
        ]
    });

    var ListGrid_NeedAssessmentsPerformed = isc.TrLG.create({
        ID: "NeedAssessmentsPerformedGrid",
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Class_JspNeedAssessmentsPerformed,
        fields: [
            {name: "postType", title: "نوع پست"},
            {name: "postCode", title: "کد پست"},
            {name: "postTitle", title: "عنوان پست"},
            {name: "updateBy", title: "ویرایش توسط"},
            {
                name: "updateAt",
                title: "ویرایش در تاریخ",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }
            },
            {name: "version",title: "تعداد دفعات نیازسنجی"}
        ]
    });

    var VLayout_Body_NeedAssessmentsPerformed = isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_NeedAssessmentsPerformed,
            organSegmentFilter_NeedAssessmentsPerformed,
            DynamicForm_NeedsAssessmentsPerformed,
            HLayOut_Confirm_NeedAssessmentsPerformed,
            ListGrid_NeedAssessmentsPerformed
        ]
    });

    function gregorianDate(date) {
        let dates = date.split("/");
        return JalaliDate.jalaliToGregorian(dates[0],dates[1],dates[2]).join("-");
    }

    function makeExcelOutput() {

        let fieldNames = "postType,postCode,postTitle,updateBy,updateAt,version";

        let headerNames = 'نوع پست,کد پست,عنوان پست ,ویرایش توسط,ویرایش در تاریخ,تعداد دفعات نیازسنجی';

        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/reportsToExcel/needsAssessmentsPerformed",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fields", type: "hidden"},
                    {name: "headers", type: "hidden"},
                    {name: "start", type: "hidden"},
                    {name: "end", type: "hidden"}
                ]
        });
        downloadForm.setValue("fields", fieldNames);
        downloadForm.setValue("headers", headerNames);
        downloadForm.setValue("start", gregorianDate(DynamicForm_NeedsAssessmentsPerformed.getItem("startDate").getValue()));
        downloadForm.setValue("end", gregorianDate(DynamicForm_NeedsAssessmentsPerformed.getItem("endDate").getValue()));

        downloadForm.show();
        downloadForm.submitForm();
    }

    //</script>
