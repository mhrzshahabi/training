<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //--------------------------------------------------- Rest DataSource ----------------------------------------------
    RestDataSource_Not_Started_Test_Monitoring = isc.TrDS.create({
        fields: [
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
            },
            {
                name: "hasExamResult",
                title: "سابقه شرکت در آزمون آنلاین",
                valueMap: {"true" : "بله", "false" : "خیر"}
            }
        ]
    });
    RestDataSource_Performing_Test_Monitoring = isc.TrDS.create({
        fields: [
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
            },
            {
                name: "hasExamResult",
                title: "سابقه شرکت در آزمون آنلاین",
                valueMap: {"true" : "بله", "false" : "خیر"}
            }
        ]
    });
    RestDataSource_Finished_Test_Monitoring = isc.TrDS.create({
        fields: [
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
            },
            {
                name: "hasExamResult",
                title: "سابقه شرکت در آزمون آنلاین",
                valueMap: {"true" : "بله", "false" : "خیر"}
            }
        ]
    });
    RestDataSource_Messages_Monitoring = isc.TrDS.create({
        fields: [
            {name: "code", title: "<spring:message code='course.code'/>", filterOperator: "equals"},
            {name: "title", title: "<spring:message code='group.code'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='course.title'/>", filterOperator: "iContains"},
        ]
    });

    //----------------------------------------------------- Main Layout ------------------------------------------------
    DynamicForm_Not_Started_Test_Monitoring = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        fields: [
            {
                name: "testStatus",
                title: "<spring:message code="final.test.status"/>",
                type: "staticText"
            },
            {
                name: "timeToStart",
                title: "مدت زمان مانده به شروع آزمون:",
                type: "staticText"
            },
            {
                name: "sendPreparation",
                title: "ارسال آزمون آمادگی",
                type: "Button",
                baseStyle: 'MSG-btn-orange',
                startRow: false,
                endRow: false,
                click: function (form, item) {
                    sendPreparationTest();
                }
            }
        ]
    });
    DynamicForm_Performing_Test_Monitoring = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        fields: [
            {
                name: "testStatus",
                title: "<spring:message code="final.test.status"/>",
                type: "staticText"
            },
            {
                name: "timeToEnd",
                title: "مدت زمان مانده تا انمام آزمون:",
                type: "staticText"
            },
            {
                name: "sendMessage",
                title: "ارسال پیام شرکت در آزمون",
                type: "Button",
                baseStyle: 'MSG-btn-orange',
                icon: '../static/img/msg/mail.svg',
                startRow: false,
                endRow: false,
                click: function (form, item) {
                    sendMessageForPerformingTest();
                }
            }
        ]
    });
    DynamicForm_Finished_Test_Monitoring = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        fields: [
            {
                name: "testStatus",
                title: "<spring:message code="final.test.status"/>",
                type: "staticText"
            }
        ]
    });

    ListGrid_Not_Started_Test_Monitoring = isc.TrLG.create({
        dataSource: RestDataSource_Not_Started_Test_Monitoring,
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        width: "100%",
        fields: [
            {
                name: "firstName"
            },
            {
                name: "lastName"
            },
            {
                name: "nationalCode"
            },
            {
                name: "hasExamResult"
            }
        ],
        gridComponents: [DynamicForm_Not_Started_Test_Monitoring, "filterEditor", "header", "body"]
        // dataChanged: function () {},
        // cellClick: function (record, rowNum, colNum) {}
    });
    ListGrid_Performing_Test_Monitoring = isc.TrLG.create({
        dataSource: RestDataSource_Performing_Test_Monitoring,
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        width: "100%",
        fields: [
            {
                name: "firstName"
            },
            {
                name: "lastName"
            },
            {
                name: "nationalCode"
            },
            {
                name: "hasExamResult"
            }
        ],
        gridComponents: [DynamicForm_Performing_Test_Monitoring, "filterEditor", "header", "body"]
        // getCellCSSText: function (record) {
        //     if (record.status === "وارد آزمون نشده")
        //         return "background-color : #e67e7e";
        //     else
        //         return "background-color : #d8e4bc";
        // }
    });
    ListGrid_Finished_Test_Monitoring = isc.TrLG.create({
        dataSource: RestDataSource_Finished_Test_Monitoring,
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        width: "100%",
        fields: [
            {
                name: "firstName"
            },
            {
                name: "lastName"
            },
            {
                name: "nationalCode"
            },
            {
                name: "hasExamResult"
            }
        ],
        gridComponents: [DynamicForm_Finished_Test_Monitoring, "filterEditor", "header", "body"]
        // getCellCSSText: function (record) {
        //     if (record.status === "آزمون نداده اند")
        //         return "background-color : #e67e7e";
        // }
    });

    VLayout_Body_Monitoring = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
        ]
    });

    //----------------------------------------------------- Functions --------------------------------------------------

    function loadPageMonitoring() {

        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.tclass.id == null) {

            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                    VLayout_Body_Monitoring.setMembers([]);
                }
            });
        } else if (record.onlineFinalExamStatus !== true) {

            isc.Dialog.create({
                message: "آزمون هنوز به سیستم آزمون آنلاین ارسال نشده است",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                    VLayout_Body_Monitoring.setMembers([]);
                }
            });
        } else {

            let testStatus;
            let currentTime = new Date().toLocaleString('IR',{ hour: 'numeric', minute: 'numeric', hour12: false}).slice(0, 5);

            if (record.date > todayDate) {
                testStatus = "notStart";

            } else if (record.date === todayDate) {

                if (record.endDate === todayDate) {
                    // time
                    if (record.time > currentTime) {
                        testStatus = "notStart";
                    } else if (record.time === currentTime) {
                        testStatus = "performing";
                    } else if (record.time < currentTime) {
                        // end tme
                        if (record.endTime > currentTime) {
                            testStatus = "performing";
                        } else if (record.endTime <= currentTime) {
                            testStatus = "finished";
                        }
                    }

                } else if (record.endDate > todayDate) {
                    // time
                    if (record.time > currentTime)
                        testStatus = "notStart";
                    else if (record.time <= currentTime)
                        testStatus = "performing";
                }

            } else if (record.date < todayDate) {

                if (record.endDate < todayDate) {
                    testStatus = "finished";
                } else if (record.endDate === todayDate) {
                    // end time
                    if (record.endTime <= currentTime) {
                        testStatus = "finished"
                    } else {
                        testStatus = "performing";
                    }

                } else if (record.endDate > todayDate) {
                    testStatus = "performing";
                }
            }

            let startHour = Number(record.time.slice(0, 2));
            let startMinute = Number(record.time.slice(3, 5));

            let endHour = Number(record.endTime.slice(0, 2));
            let endMinute = Number(record.endTime.slice(3, 5));

            let currentHour = Number(currentTime.slice(0, 2));
            let currentMinute = Number(currentTime.slice(3, 5));

            debugger;
            if (testStatus === "notStart") {

                let dateNow = JalaliDate.jalaliToGregori(todayDate);
                dateNow.setHours(currentHour, currentMinute);
                let dateFuture = JalaliDate.jalaliToGregori(record.date);
                dateFuture.setHours(startHour, startMinute);
                let timeToStart = dateTimeDiff(dateFuture, dateNow);

                VLayout_Body_Monitoring.setMembers([]);
                DynamicForm_Not_Started_Test_Monitoring.setValue("testStatus", "شروع نشده");
                DynamicForm_Not_Started_Test_Monitoring.setValue("timeToStart", timeToStart);
                RestDataSource_Not_Started_Test_Monitoring.fetchDataURL = examMonitoringUrl + "/list/" + record.tclass.code;
                ListGrid_Not_Started_Test_Monitoring.fetchData();
                VLayout_Body_Monitoring.addMembers(ListGrid_Not_Started_Test_Monitoring);

            } else if (testStatus === "performing") {

                let dateNow = JalaliDate.jalaliToGregori(todayDate);
                dateNow.setHours(currentHour, currentMinute);
                let dateFuture = JalaliDate.jalaliToGregori(record.endDate);
                dateFuture.setHours(endHour, endMinute);
                let timeToEnd = dateTimeDiff(dateFuture, dateNow);

                VLayout_Body_Monitoring.setMembers([]);
                DynamicForm_Performing_Test_Monitoring.setValue("testStatus", "درحال برگزاری");
                DynamicForm_Performing_Test_Monitoring.setValue("timeToEnd", timeToEnd);
                RestDataSource_Performing_Test_Monitoring.fetchDataURL = examMonitoringUrl + "/list/" + record.tclass.code;
                ListGrid_Performing_Test_Monitoring.fetchData();
                VLayout_Body_Monitoring.addMembers(ListGrid_Performing_Test_Monitoring);

            } else if (testStatus === "finished") {

                VLayout_Body_Monitoring.setMembers([]);
                DynamicForm_Finished_Test_Monitoring.setValue("testStatus", "پایان یافته")
                RestDataSource_Finished_Test_Monitoring.fetchDataURL = examMonitoringUrl + "/list/" + record.tclass.code;
                ListGrid_Finished_Test_Monitoring.invalidateCache();
                ListGrid_Finished_Test_Monitoring.fetchData();
                VLayout_Body_Monitoring.addMembers(ListGrid_Finished_Test_Monitoring);
            }
        }
    }

    function dateTimeDiff(dateFuture, dateNow) {

        let diffInMilliSeconds = Math.abs(dateFuture - dateNow) / 1000;

        const days = Math.floor(diffInMilliSeconds / 86400);
        diffInMilliSeconds -= days * 86400;

        const hours = Math.floor(diffInMilliSeconds / 3600) % 24;
        diffInMilliSeconds -= hours * 3600;

        const minutes = Math.floor(diffInMilliSeconds / 60) % 60;
        diffInMilliSeconds -= minutes * 60;

        let difference = days + " روز " + hours + " ساعت و " + minutes + " دقیقه";
        return difference;
    }

    function sendPreparationTest() {

        let records = ListGrid_Not_Started_Test_Monitoring.getSelectedRecords();

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(examMonitoringUrl + "/send-preparation-test", "POST", JSON.stringify(records), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                // Window_Agreement.close();
                // ListGrid_Agreement.invalidateCache();
            } else {
                wait.close();
                // createDialog("info", "خطایی رخ داده است");
                // Window_Agreement.close();
            }
        }));
    }

    function sendMessageForPerformingTest() {

        MSG_Window_MSG_Main.show();
        // RestDataSource_Messages_Monitoring.fetchDataURL =  parameterValueUrl + "/messages/class/student";
        // MSG_main_layout.members[0].getField("messageType").optionDataSource = RestDataSource_Messages_student;
        // MSG_main_layout.members[0].getField("messageType").fetchData();
    }

// </script>