<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
    //----------------------------------------- Variables --------------------------------------------------------------

    //----------------------------------------- DataSources ------------------------------------------------------------
    var RestDataSource_student_PreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "student.id", hidden: true},
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
            },
            {
                name: "applicantCompanyName",
                title: "<spring:message code="company.applicant"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "presenceTypeId",
                title: "<spring:message code="class.presence.type"/>",
                filterOperator: "equals",
                autoFitWidth: true
            },
            {
                name: "student.companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "student.ccpArea",
                title: "<spring:message code="reward.cost.center.area"/>",
                filterOperator: "iContains"
            },
            {
                name: "evaluationStatusReaction",
                title: "<spring:message code="evaluation.reaction.status"/>",
                filterOperator: "iContains"
            },
            {
                name: "evaluationStatusLearning",
                title: "<spring:message code="evaluation.learning.status"/>",
                filterOperator: "iContains"
            },
            {
                name: "evaluationStatusBehavior",
                title: "<spring:message code="evaluation.behavioral.status"/>",
                filterOperator: "iContains"
            },
            {
                name: "evaluationStatusResults",
                title: "<spring:message code="evaluation.results.status"/>",
                filterOperator: "iContains"
            }
        ],
    });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
    var DynamicForm_ReturnDate_PreTest = isc.DynamicForm.create({
        width: "150px",
        height: "10px",
        padding: 0,
        fields: [
            {
                name: "evaluationReturnDate",
                title: "<spring:message code='return.date'/>",
                ID: "ReturnDate_PreTest",
                width: "150px",
                hint: "----/--/--",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('ReturnDate_PreTest', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                click: function (form) {

                },
                changed: function (form, item, value) {
                    evaluation_check_date_PreTest();
                }
            }
        ]
    });
    //----------------------------------------- ListGrids --------------------------------------------------------------
    var ListGrid_student_PreTest = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_student_PreTest,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        sortField: 5,
        sortDirection: "descending",
        fields: [
            {name: "student.firstName"},
            {name: "student.lastName"},
            {
                name: "student.nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "student.personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "student.personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "applicantCompanyName",
                textAlign: "center"
            },
            {
                name: "evaluationStatusReaction",
                valueMap: {
                    "0": "صادر نشده",
                    "1": "صادر شده",
                    "2": "تکمیل شده و کامل",
                    "3": "تکمیل شده و ناقص"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOnKeypress: true,
                filterOperator: "equals"
            },
            {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
            {
                name: "saveResults",
                title: " ",
                align: "center",
                canSort: false,
                canFilter: false,
                autoFithWidth: true
            },
            {name: "removeForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
            {name: "printForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true}
        ],
    });

    //----------------------------------------- ToolStrips -------------------------------------------------------------

    var ToolStripButton_RefreshIssuance_PreTest = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_student_PreTest.invalidateCache();
        }
    });

    var ToolStripButton_InsertQuestionFromQuestionBank_PreTest = isc.ToolStripButtonAdd.create({
        title: "اضافه کردن از بانک سوال",
        click: function () {
            ListGrid_student_PreTest.invalidateCache();
        }
    });

    var ToolStripButton_InsertQuestionFromLatestQuestions_PreTest = isc.ToolStripButtonAdd.create({
        title:  "اضافه کردن از آخرین سوالات انتخاب شده",
        click: function () {
            ListGrid_student_PreTest.invalidateCache();
        }
    });

    var ToolStrip_Actions_PreTest = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_InsertQuestionFromQuestionBank_PreTest,
            ToolStripButton_InsertQuestionFromLatestQuestions_PreTest,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_RefreshIssuance_PreTest
                ]
            })
        ]
    });

    //----------------------------------------- LayOut -----------------------------------------------------------------
    var HLayout_Actions_PreTest = isc.HLayout.create({
        width: "100%",
        height:35,
        members: [
            ToolStrip_Actions_PreTest
        ]
    });

    var Hlayout_Grid_PreTest = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_student_PreTest]
    });

    var VLayout_Body_PreTest = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_PreTest, Hlayout_Grid_PreTest]
    });

    //----------------------------------- New Funsctions ---------------------------------------------------------------


//</script>