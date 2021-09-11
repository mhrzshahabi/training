<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

// <script>

    personnelPortalWait = createDialog("wait");

    isc.RPCManager.sendRequest(TrDSRequest(studentPortalUrl + "/personnel/getOneByNationalCode", "GET", null, userData_Result_SP));
    isc.RPCManager.sendRequest(TrDSRequest(studentPortalUrl + "/student/getOneByNationalCode", "GET", null, studentData_Result_SP));

    var person_SP = null;
    var student_SP = null;
    var personnelPortalWait;

    //--------------------------------------------------------------------------------------------------------------------//
    //*Main Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    basicInfoTSMB_SP = isc.ToolStripMenuButton.create({
        title: "<spring:message code="basic.information"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                {
                    title: "<spring:message code="training.file"/>",
                    click: function () {
                        createTab_SP(this.title, "<spring:url value="/web/trainingFile"/>");
                    }
                },
                {isSeparator: true},
            ]
        }),
    });

    NAreportTSMB_SP = isc.ToolStripMenuButton.create({
        title: "<spring:message code="needsAssessmentReport"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                {
                    title: "<spring:message code="your.needs.assessment"/>",
                    click: function () {
                        if (person_SP == null)
                            return;
                        if (MainTS_SP.getTab("<spring:message code="needsAssessmentReport"/>") == null)
                            createTab_SP("<spring:message code="needsAssessmentReport"/>", "<spring:url value="/web/needsAssessment-reports"/>", "call_needsAssessmentReports('0',false,person_SP,false)");
                        else {
                            call_needsAssessmentReports('0',false,person_SP,false);
                            MainTS_SP.selectTab("<spring:message code="needsAssessmentReport"/>");
                        }
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code='your.needs.assessment.on.post'/>",
                    click: function () {
                        if (person_SP == null)
                            return;
                        if (MainTS_SP.getTab("<spring:message code="needsAssessmentReport"/>") == null)
                            createTab_SP("<spring:message code="needsAssessmentReport"/>", "<spring:url value="/web/needsAssessment-reports"/>", "call_needsAssessmentReports('2',false,person_SP,false)");
                        else {
                            call_needsAssessmentReports('2',false,person_SP,false);
                            MainTS_SP.selectTab("<spring:message code="needsAssessmentReport"/>");
                        }
                    }
                },
                {isSeparator: true},
            ]
        }),
    });

    runTSMB_SP = isc.ToolStripMenuButton.create({
        title: "<spring:message code='class'/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                {
                    title: "<spring:message code="weekly.training.schedule"/>",
                    click:function(){
                        createTab_SP(this.title, "<spring:url value="weeklyTrainingSchedule/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="report.calender.current.term"/>",
                    click: function () {
                        createTab_SP(this.title, "<spring:url value="web/calenderCurrentTerm"/>", "call_calenderCurrentTerm(person_SP)");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="unfinished.classes"/>",
                    click: function () {
                        createTab_SP(this.title, "<spring:url value="unfinishedClasses-report/show-form"/>");
                    }
                },
                {isSeparator: true},
            ]
        }),
    });

    evaluationTSMB_SP = isc.ToolStripMenuButton.create({
        title: "<spring:message code="evaluation"/>",
        menu: isc.Menu.create({
            placement: "none",
            data: [
                {
                    title: "ثبت نتایج",
                    click: function () {
                        createTab_SP(this.title, "<spring:url value="/questionEvaluation/show-form"/>", "call_questionEvaluation_forPersonnel(person_SP)");
                    }
                },
                {isSeparator: true},
            ]
        }),
    });

    MainToolStrip_SP = isc.ToolStrip.create({
        align: "center",
        membersMargin: 20,
        layoutMargin: 5,
        showShadow: true,
        shadowDepth: 3,
        shadowColor: "#153560",
        disabled: true,
        members: [
            basicInfoTSMB_SP,
            NAreportTSMB_SP,
            runTSMB_SP,
            evaluationTSMB_SP
        ]
    });

    MainDesktopMenuHL_SP = isc.HLayout.create({
        width: "100%",
        minWidth: 1024,
        height: "4%",
        styleName: "main-menu",
        align: "center",
        members: [
            MainToolStrip_SP
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*Main TabSet*/
    //--------------------------------------------------------------------------------------------------------------------//

    closeAllButton_SP = isc.IButtonClose.create({
        width: 100,
        title: "<spring:message code="close.all"/>",
        click: function () {
            if (MainTS_SP.tabs.length == 0) return;
            var dialog = createDialog("ask", "<spring:message code="close.all.tabs?"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        MainTS_SP.removeTabs(MainTS_SP.tabs);
                    }
                }
            });
        }
    });

    MainTS_SP = isc.TabSet.create({
        ID:"mainTS_SP",
        minWidth: 1024,
        tabs: [],
        tabBarControls: [closeAllButton_SP],
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*UI*/
    //--------------------------------------------------------------------------------------------------------------------//

    AffairsLabel_SP = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    PostLabel_SP = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    PersonnelNoLabel_SP = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    NationalCodeLabel_SP = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    UserNameLabel_SP = isc.Label.create({
        padding: 15,
        dynamicContents: true,
        styleName: "header-label-username"
    });

    HeaderLayout_SP = isc.HLayout.create({
        width: "100%",
        height: 50,
        styleName: "header-top",
        members: [
            UserNameLabel_SP,
            NationalCodeLabel_SP,
            PersonnelNoLabel_SP,
            PostLabel_SP,
            AffairsLabel_SP
        ],
    });

    isc.TrVLayout.create({
        autoDraw: true,
        width: "100%",
        height: "100%",
        members: [
            HeaderLayout_SP,
            MainDesktopMenuHL_SP,
            MainTS_SP,
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*Function*/
    //--------------------------------------------------------------------------------------------------------------------//

    function userData_Result_SP(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            person_SP = (JSON.parse(resp.data));
            UserNameLabel_SP.contents = "<spring:message code="user"/>: " + person_SP.firstName + " " + person_SP.lastName;
            NationalCodeLabel_SP.contents = "<spring:message code='national.code'/>: " + person_SP.nationalCode;
            PersonnelNoLabel_SP.contents = "<spring:message code='personal.ID'/>: " + (person_SP.personnelNo !== undefined ? person_SP.personnelNo : "");
            PostLabel_SP.contents = "<spring:message code='post'/>: " + (person_SP.postTitle !== undefined ? person_SP.postTitle : "");
            AffairsLabel_SP.contents = "<spring:message code='affairs'/>: " + (person_SP.ccpAffairs !== undefined ? person_SP.ccpAffairs : "");
            UserNameLabel_SP.redraw();
            NationalCodeLabel_SP.redraw();
            PersonnelNoLabel_SP.redraw();
            PostLabel_SP.redraw();
            AffairsLabel_SP.redraw();
            MainToolStrip_SP.enable();
        } else {
            person_SP = null;
            createDialog("info", resp.httpResponseText);
        }
        personnelPortalWait.close();
    }

    function studentData_Result_SP(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            student_SP = (JSON.parse(resp.data));
        } else {
            student_SP = null;
        }
    }

    function createTab_SP(title, url, callFunction, autoRefresh) {
        if (person_SP == null) {
            createDialog("info", "<spring:message code='person.not.found'/>");
            return;
        }
        tab = MainTS_SP.getTabObject(title);
        if (tab !== undefined) {
            if ((autoRefresh !== undefined) && (autoRefresh === true)) {
                MainTS_SP.setTabPane(tab, isc.ViewLoader.create({viewURL: url}));
            }
            MainTS_SP.selectTab(tab);
        } else {
            MainTS_SP.addTab({
                title: title,
                ID: title,
                pane: isc.ViewLoader.create({
                    viewURL: url,
                    handleError() {createDialog("info", "خطا در ایجاد تب")},
                    viewLoaded() {eval(callFunction)}
                }),
                canClose: true,
            });
            createTab_SP(title, url);
        }
    }

    // </script>