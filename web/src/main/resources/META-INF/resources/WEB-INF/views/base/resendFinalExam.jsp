<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>


    //-----------------------------Tool Strip------------------------------------

    let resendFinalExam_ToolStrip = isc.ToolStrip.create({
        members: []


    });

    function closeCalendarWindowInResend() {
        if (document.getElementById(datePickerDivID) !== null) {
            var pickerDiv = document.getElementById(datePickerDivID);
            pickerDiv.style.visibility = "hidden";
            pickerDiv.style.display = "none";
            adjustiFrame();
        }
    }

    function resendFinalExam_func() {

        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (!resendFinalExam_DynamicForm.validate()) {
            return;
        }
        let selectedStudents = ListGrid_resendExamStudents.getSelectedRecords();
        if (selectedStudents.length === 0) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>")
        } else {
            let users = [];
            for (let i = 0; i < selectedStudents.length; i++) {
                var EvalTargetUser = {
                    surname: selectedStudents[i].student.firstName,
                    lastName: selectedStudents[i].student.lastName,
                    cellNumber: selectedStudents[i].student.mobile,
                    nationalCode: selectedStudents[i].student.nationalCode,
                    gender: selectedStudents[i].student.gender
                };
                users.add(EvalTargetUser);
            }

            let inValidStudents = [];
            for (let i = 0; i < users.length; i++) {

                let studentData = users[i];
                if (!NCodeAndMobileValidationOnResend(studentData.nationalCode, studentData.cellNumber, studentData.gender)) {

                    inValidStudents.add({
                        firstName: studentData.surname,
                        lastName: studentData.lastName
                    });
                }
            }

            if (inValidStudents.length) {

                let DynamicForm_InValid_Students_Resend = isc.DynamicForm.create({
                    width: 600,
                    height: 100,
                    padding: 6,
                    titleAlign: "right",
                    fields: [
                        {
                            name: "text",
                            width: "100%",
                            colSpan: 2,
                            value: "<spring:message code='msg.check.student.mobile.ncode'/>"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                            showTitle: false,
                            editorType: 'staticText'
                        },
                        {
                            type: "RowSpacerItem"
                        },
                        {
                            name: "invalidNames",
                            width: "100%",
                            colSpan: 2,
                            title: "<spring:message code="title"/>",
                            showTitle: false,
                            editorType: 'textArea',
                            canEdit: false
                        }
                    ]
                });

                let names = "";
                for (var j = 0; j < inValidStudents.length; j++) {

                    names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                }
                DynamicForm_InValid_Students_Resend.setValue("invalidNames", names);

                let Window_InValid_Students_Resend = isc.Window.create({
                    width: 600,
                    height: 150,
                    numCols: 2,
                    title: "<spring:message code='invalid.students.window'/>",
                    items: [
                        DynamicForm_InValid_Students_Resend,
                        isc.MyHLayoutButtons.create({
                            members: [
                                isc.IButtonSave.create({
                                    title: "<spring:message code="continue"/>",
                                    click: function () {

                                        studentsToElsResendExam(record, users);
                                        Window_InValid_Students_Resend.close();
                                    }}),
                                isc.IButtonCancel.create({
                                    title: "<spring:message code="cancel"/>",
                                    click: function () {
                                        Window_InValid_Students_Resend.close();
                                    }
                                })],
                        })]
                });
                Window_InValid_Students_Resend.show();
            } else {
                studentsToElsResendExam(record, users);
            }
        }

    }

    let resendFinalExamButton = isc.TrSaveBtn.create({
        title: "ارسال",
        click: function () {
            resendFinalExam_func();
        }
    });

    var resendFinalExam_DynamicForm = isc.DynamicForm.create({
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
                        closeCalendarWindowInResend();
                        displayDatePicker('date_resendFinalTest', this, 'ymd', '/');
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
                    resendFinalExam_DynamicForm.setValue("time", arrangeDate(resendFinalExam_DynamicForm.getValue("time")));
                    let val = resendFinalExam_DynamicForm.getValue("time");
                    if (val === null || val === '' || typeof (val) === 'undefined' || !val.match(/^(([0-1][0-9]|2[0-3]):([0-5][0-9]))$/)) {
                        resendFinalExam_DynamicForm.addFieldErrors("time", "<spring:message code="session.hour.invalid"/>", true);
                    } else {
                        resendFinalExam_DynamicForm.clearFieldErrors("time", true);
                    }
                }
            },
            {
                name: "duration",
                title: "<spring:message code='test.question.duration'/>",
                required: true,
                textAlign: "center",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='test.question.duration.hint'/>",
                showHintInField: true,
                length: 3
            },
            {
                name: "sendBtn",
                ID: "resendBtnJspFinalExam",
                title: "<spring:message code="resend.final.test"/>",
                type: "ButtonItem",
                startRow: false,
                endRow: false,
                click(form, item) {
                    form.clearErrors();
                    resendFinalExam_func();
                }
            }
        ]

    });

    //-----------------------------------------------------------------


    let StudentsDS_student_resend = isc.TrDS.create({
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
            {name: "student.mobile", title: "<spring:message code="mobile"/>", filterOperator: "iContains"},
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


    let ListGrid_resendExamStudents = isc.TrLG.create({
        ID: "ListGrid_resendExamStudents",
        <sec:authorize access="hasAnyAuthority('TclassStudentsTab_R','TclassStudentsTab_classStatus')">
        dataSource: StudentsDS_student_resend,
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
                name: "applicantCompanyName",
                textAlign: "center",
                autoFitWidth: true
            },
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
                name: "student.mobile",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.mobile;
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
                name: "student.ccpArea",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.ccpArea;
                }
            },
            {
                name: "student.ccpAssistant",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.ccpAssistant;
                }
            },
            {
                name: "student.ccpAffairs",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.ccpAffairs;
                }
            },
            {
                name: "student.ccpSection",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.ccpSection;
                }
            },
            {
                name: "student.ccpUnit",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.ccpUnit;
                }
            },
        ],
        gridComponents: [resendFinalExam_DynamicForm, "filterEditor", "header", "body"],
        dataArrived: function () {
            ListGrid_resendExamStudents.data.localData.filter(p => p.warning == 'Ok').forEach(p => p.hasWarning = 'checkBlue');
        },
        // contextMenu: StudentMenu_student,
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
            }//end switch-case

            if (this.getFieldName(colNum) == "student.personnelNo") {
                result += ";color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
            }

            return result;
        },//end getCellCSSText
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

    let VLayout_Body_resendExamVLayout = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_resendExamStudents
        ]
    });

    function NCodeAndMobileValidationOnResend(nationalCode, mobileNum, gender) {

        let isValid = true;
        if (nationalCode===undefined || nationalCode===null || mobileNum===undefined || mobileNum===null) {
            isValid = false;
        } else {
            if (nationalCode.length !== 10 || !(/^-?\d+$/.test(nationalCode)))
                isValid = false;

            if((mobileNum.length !== 10 && mobileNum.length !== 11) || !(/^-?\d+$/.test(mobileNum)))
                isValid = false;

            if(mobileNum.length === 10 && !mobileNum.startsWith("9"))
                isValid = false;

            if(mobileNum.length === 11 && !mobileNum.startsWith("09"))
                isValid = false;
        }
        return isValid;
    }

    function studentsToElsResendExam(record, users) {

        let examData = {
            sourceExamId: record.id,
            duration: resendFinalExam_DynamicForm.getValue("duration"),
            time: resendFinalExam_DynamicForm.getValue("time"),
            startDate: resendFinalExam_DynamicForm.getValue("startDate"),
            users: users
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/checkForResendExamToEls", "POST", JSON.stringify(examData), function (resp) {
            let respText = JSON.parse(resp.httpResponseText);
            if (respText.status === 200) {
                sendResendExam(examData)

            } else {
                 let Dialog_ask = createDialog("ask", respText.message,
                                                "<spring:message code="verify.resend"/>");
                Dialog_ask.addProperties({
                                                buttonClick: function (button, index) {
                                                    this.close();
                                                    if (index === 0) {
                                                      sendResendExam(examData)
                                                    }
                                                }
                                            });

            }
            wait.close();
        }));
    }
    function sendResendExam(examData) {
             wait.show();
        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/resendExamToEls", "POST", JSON.stringify(examData), function (resp) {

            resendFinalExam_DynamicForm.clearValues();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                refresh_finalTest();

                var OK = isc.Dialog.create({
                    message: "<spring:message code="msg.operation.successful"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    dialog.close();
                    OK.close();
                }, 2000);
            } else {

                if (resp.httpResponseCode === 406)
                    createDialog("info", "<spring:message code="msg.check.teacher.mobile.ncode"/>" + " " + "<spring:message code="msg.check.teacher.mobile.ncode.message"/>", "<spring:message code="error"/>");
                else if (resp.httpResponseCode === 404)
                    createDialog("info", "<spring:message code="msg.check.users.mobile.ncode"/>", "<spring:message code="error"/>");
                else if (resp.httpResponseCode === 500)
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                else
                    createDialog("info", JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");

            }
            wait.close();
        }));

    }

    // ---------------------------------Functions-----------------------------------------------

    function loadPage_student_resend() {
        let record = FinalTestLG_finalTest.getSelectedRecord();
        if (record == null || record.tclass.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                    ListGrid_resendExamStudents.setData([]);

                }
            });

        } else {
            StudentsDS_student_resend.fetchDataURL = tclassStudentUrl + "/students-iscList/" + record.tclass.id;


            ListGrid_resendExamStudents.invalidateCache();
            ListGrid_resendExamStudents.fetchData();
            isc.Label.create({ID: "StudentsCount_student"});

        }
    }
// </script>