<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Monitoring = isc.TrDS.create({
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
                autoFitWidth: true
            },
            {
                name: "applicantCompanyName",
                title: "<spring:message code="company.applicant"/>",
                filterOperator: "iContains",
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
                filterOperator: "iContains"
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
                name: "student.ccpAssistant",
                title: "<spring:message code="reward.cost.center.assistant"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.ccpAffairs",
                title: "<spring:message code="reward.cost.center.affairs"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.ccpSection",
                title: "<spring:message code="reward.cost.center.section"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.ccpUnit",
                title: "<spring:message code="reward.cost.center.unit"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.fatherName",
                title: "<spring:message code="father.name"/>",
                filterOperator: "iContains"
            },
            {name: "student.contactInfo.mobile", title: "<spring:message code="mobile"/>", filterOperator: "iContains"},
            {
                name: "student.birthCertificateNo",
                title: "<spring:message code="birth.certificate.no"/>",
                filterOperator: "iContains"
            },
            {
                name: "student.gender",
                title: "<spring:message code="gender"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.gender;
                }
            },
            {
                name: "hasWarning",
                title: " ",
                width: 40,
                type: "image",
                imageURLPrefix: "",
                imageURLSuffix: ".png",
                canEdit: false
            },
            {name: "warning", autoFitWidth: true}

        ],

        fetchDataURL: tclassStudentUrl + "/students-iscList/"
    });

    //----------------------------------------------------Main  -----------------------------------------------------------------------

    DynamicForm_Monitoring = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 100, 100, 200, 100],
        fields: [
            {
                name: "startDate",
                ID: "date_resendFinalTest",
                title: "<spring:message code='test.question.date'/>",
                required: true,
                textAlign: "center",
                width: "*",
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "time",
                title: "<spring:message code="test.question.time"/>",
                required: true,
                requiredMessage: "<spring:message code="msg.field.is.required"/>",
                hint: "--:--",
                defaultValue: "08:00",
                keyPressFilter: "[0-9:]",
                showHintInField: true,
                textAlign: "center",
                validateOnChange: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 5,
                    max: 5,
                    stopOnError: true,
                    errorMessage: "زمان مجاز بصورت 08:30 است"
                },
                    {
                        type: "regexp",
                        expression: "^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$",
                        validateOnChange: true,
                        errorMessage: "ساعت 23-0 و دقیقه 59-0"
                    }
                ],
                length: 5,
                editorExit: function () {
                    DynamicForm_Monitoring.setValue("time", arrangeDate(DynamicForm_Monitoring.getValue("time")));
                    let val = DynamicForm_Monitoring.getValue("time");
                    if (val === null || val === '' || typeof (val) === 'undefined' || !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)) {
                        DynamicForm_Monitoring.addFieldErrors("time", "<spring:message code="session.hour.invalid"/>", true);
                    } else {
                        DynamicForm_Monitoring.clearFieldErrors("time", true);
                    }
                }
            },
            {
                name: "duration",
                title: "<spring:message code='test.question.duration'/>",
                textAlign: "center",
                type: "IntegerItem",
                hidden:true,
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='test.question.duration.hint'/>",
                showHintInField: true,
                length: 3
            },
            <sec:authorize access="hasAuthority('FinalTest_Send')">
            {
                name: "sendBtn",
                ID: "resendBtnJspFinalExam",
                title: "<spring:message code="resend.final.test"/>",
                type: "ButtonItem",
                startRow: false,
                endRow: false,
                click(form, item) {
                    form.clearErrors();
                    // resendFinalExam_func();
                }
            }
            </sec:authorize>
        ]

    });

    ListGrid_Monitoring = isc.TrLG.create({
        ID: "ListGrid_Monitoring",
        <sec:authorize access="hasAuthority('FinalTest_R')">
        dataSource: RestDataSource_Monitoring,
        </sec:authorize>
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        fields: [
            {
                name: "student.firstName",

                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.firstName;
                }
            },
            {
                name: "student.lastName",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.lastName;
                }
            },
            {
                name: "student.nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.nationalCode;
                }
            },
            {name: "student.fatherName", hidden: true},
            {
                name: "student.personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.personnelNo;
                }
            },
            {
                name: "student.personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.personnelNo2;
                }
            },
            {
                name: "student.postTitle",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.postTitle;
                }
            },
            {
                name: "student.contactInfo.mobile",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.contactInfo.mobile;
                }
            },
            {
                name: "student.birthCertificateNo",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.birthCertificateNo;
                }
            },
            {
                name: "student.gender",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.gender;
                }
            },
            {
                name: "extendTime",
                title: " زمان آزمون مجدد" +
                    "",
                filterOperator: "iContains",
                autoFitWidth: true
            },
        ],
        gridComponents: [DynamicForm_Monitoring, "filterEditor", "header", "body"],
        dataArrived: function () {
            ListGrid_Monitoring.data.localData.filter(p => p.warning == 'Ok').forEach(p => p.hasWarning = 'checkBlue');
        },
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                StudentsCount_student.setContents("&nbsp;");
            }
        },
        getCellCSSText: function (record, rowNum, colNum) {
            let result = "background-color : ";
            let blackColor = "; color:black";
            switch (parseInt(record.presenceTypeId)) {
                case 104:
                    result += "#FFF9C4" + blackColor;
                    break;
            }
            if (this.getFieldName(colNum) == "student.personnelNo") {
                result += ";color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
            }
            return result;
        },
        cellClick: function (record, rowNum, colNum) {
            if (colNum === 6) {
                selectedRecord_addStudent_class = {
                    firstName: record.student.firstName,
                    lastName: record.student.lastName,
                    postTitle: record.student.postTitle,
                    ccpArea: record.student.ccpArea,
                    ccpAffairs: record.student.ccpAffairs,
                    personnelNo: record.student.personnelNo,
                    nationalCode: record.student.nationalCode,
                    postCode: record.student.postCode
                };

                let window_class_Information = isc.Window.create({
                    title: "<spring:message code="personnel.information"/>",
                    width: "70%",
                    minWidth: 500,
                    autoSize: false,
                    height: "50%",
                    closeClick: deleteCachedValue,
                    items: [isc.VLayout.create({
                        width: "100%",
                        height: "100%",
                        //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
                    })]
                });

                if (!loadjs.isDefined('personnel-information-details')) {
                    loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                }

                loadjs.ready('personnel-information-details', function () {
                    let oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                    window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);

                });
                window_class_Information.show();
            }
        }
    });

    VLayout_Body_Monitoring = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_Monitoring
        ]
    });

    // ---------------------------------Functions--------------------------------

    function loadPage_monitoring() {

        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.tclass.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                    // ListGrid_Monitoring.setData([]);
                }
            });
        } else {
            DynamicForm_Monitoring.setValue("duration", record.duration)
            RestDataSource_Monitoring.fetchDataURL = tclassStudentUrl + "/students-iscList/resend/" + record.tclass.id + "/" + record.id;
            ListGrid_Monitoring.invalidateCache();
            ListGrid_Monitoring.fetchData();
            isc.Label.create({ID: "StudentsCount_student"});
        }
    }

// </script>