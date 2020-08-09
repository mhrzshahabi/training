<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

// <script>

    teacherPortalWait = createDialog("wait");

    isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "getOneByNationalCode", "GET", null, userData_Result_JspTeacherReport));

    var teacher_JspTeacherReport = null;

    var teacherPortalWait;

    //--------------------------------------------------------------------------------------------------------------------//
    //*Main Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var currentClasses_JspTeacherReport = isc.ToolStripButton.create({
        title: "کلاس های در حال برگزاری",
        click: function () {
            //----------------- Mr Hydari --------------------------//
        }
    });

    var trainingClasses_JspTeacherReport = isc.ToolStripButton.create({
        title: "کلاس های تدریس شده",
        click: function () {
            //----------------- Mr Hydari --------------------------//
        }
    });

    var evaluationForms_JspTeacherReport = isc.ToolStripButton.create({
        title: "فرم های ارزیابی",
        click: function () {
            createTab_JspTeacherReport(this.title, "<spring:url value="/questionEvaluation/show-form"/>", "call_questionEvaluation_forTeacher(teacher_JspTeacherReport)");
        }
    });

    var messagingSection_JspTeacherReport = isc.ToolStripButton.create({
        title: "تبادل اطلاعات با مسئول آموزش",
        click: function () {
            //----------------- Mr Jafari --------------------------//
        }
    });

    MainToolStrip_JspTeacherReport = isc.ToolStrip.create({
        align: "center",
        membersMargin: 20,
        layoutMargin: 5,
        showShadow: true,
        shadowDepth: 3,
        shadowColor: "#153560",
        disabled: true,
        members: [
            currentClasses_JspTeacherReport,
            trainingClasses_JspTeacherReport,
            evaluationForms_JspTeacherReport,
            messagingSection_JspTeacherReport
        ]
    });

    MainDesktopMenuHL_JspTeacherReport = isc.HLayout.create({
        width: "100%",
        minWidth: 1024,
        height: "4%",
        styleName: "main-menu",
        align: "center",
        members: [
            MainToolStrip_JspTeacherReport
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*Main TabSet*/
    //--------------------------------------------------------------------------------------------------------------------//

    closeAllButton_JspTeacherReport = isc.IButtonClose.create({
        width: 100,
        title: "<spring:message code="close.all"/>",
        click: function () {
            if (MainTS_JspTeacherReport.tabs.length == 0) return;
            var dialog = createDialog("ask", "<spring:message code="close.all.tabs?"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        MainTS_JspTeacherReport.removeTabs(MainTS_JspTeacherReport.tabs);
                    }
                }
            });
        }
    });

    MainTS_JspTeacherReport = isc.TabSet.create({
        ID:"mainTS_JspTeacherReport",
        minWidth: 1024,
        tabs: [],
        tabBarControls: [closeAllButton_JspTeacherReport],
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*UI*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelNoLabel_JspTeacherReport = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    NationalCodeLabel_JspTeacherReport = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    UserNameLabel_JspTeacherReport = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    HeaderLayout_JspTeacherReport = isc.HLayout.create({
        width: "100%",
        height: 50,
        styleName: "header-top",
        members: [
            UserNameLabel_JspTeacherReport,
            NationalCodeLabel_JspTeacherReport,
            PersonnelNoLabel_JspTeacherReport
        ],
    });

    isc.TrVLayout.create({
        autoDraw: true,
        width: "100%",
        height: "100%",
        members: [
            HeaderLayout_JspTeacherReport,
            MainDesktopMenuHL_JspTeacherReport,
            MainTS_JspTeacherReport,
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*Function*/
    //--------------------------------------------------------------------------------------------------------------------//

    function userData_Result_JspTeacherReport(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            teacher_JspTeacherReport = (JSON.parse(resp.data));
            UserNameLabel_JspTeacherReport.contents = "<spring:message code="user"/>: " + teacher_JspTeacherReport.firstName + " " + teacher_JspTeacherReport.lastName;
            NationalCodeLabel_JspTeacherReport.contents = "<spring:message code='national.code'/>: " + teacher_JspTeacherReport.nationalCode;
            PersonnelNoLabel_JspTeacherReport.contents = "<spring:message code='personal.ID'/>: " + (teacher_JspTeacherReport.personnelCode !== undefined ? teacher_JspTeacherReport.personnelCode : "استاد خارجی است");
            UserNameLabel_JspTeacherReport.redraw();
            NationalCodeLabel_JspTeacherReport.redraw();
            PersonnelNoLabel_JspTeacherReport.redraw();
            MainToolStrip_JspTeacherReport.enable();
        } else {
            teacher_JspTeacherReport = null;
            createDialog("info", resp.httpResponseText);
        }
        teacherPortalWait.close();
    }

    function createTab_JspTeacherReport(title, url, callFunction, autoRefresh) {
        if (teacher_JspTeacherReport == null) {
            createDialog("info", "<spring:message code='person.not.found'/>");
            return;
        }
        tab = MainTS_JspTeacherReport.getTabObject(title);
        if (tab !== undefined) {
            if ((autoRefresh !== undefined) && (autoRefresh === true)) {
                MainTS_JspTeacherReport.setTabPane(tab, isc.ViewLoader.create({viewURL: url}));
            }
            MainTS_JspTeacherReport.selectTab(tab);
        } else {
            MainTS_JspTeacherReport.addTab({
                title: title,
                ID: title,
                pane: isc.ViewLoader.create({
                    viewURL: url,
                    handleError() {createDialog("info", "خطا در ایجاد تب")},
                    viewLoaded() {eval(callFunction)}
                }),
                canClose: true,
            });
            createTab_JspTeacherReport(title, url);
        }
    }

    // </script>