<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>


// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
        var evalWait_BE;

        var classRecord_BE;

        var selected_questionnaire_BE = null;

    //----------------------------------------- DataSources ------------------------------------------------------------
        var AudienceTypeDS_BE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            cacheAllData: true,
            fetchDataURL: parameterUrl + "/iscList/EvaluatorType",
            implicitCriteria: {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[{ fieldName: "code", operator: "inSet", value: ["21","32","42","4"]}]
            }
        });

        var RestDataSource_student_BE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.firstName;
                    }
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.lastName;
                    }
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
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.nationalCode;
                    }
                },
                {
                    name: "student.contactInfo.smSMobileNumber",
                    title: "<spring:message code="cellPhone"/>",
                    filterOperator: "iContains",
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
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.companyName;
                    }
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.personnelNo;
                    }
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.personnelNo2;
                    }
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.student.postTitle;
                    }
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains",
                    sortNormalizer: function (record) {
                        return record.student.ccpArea;
                    }
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
                },
                {
                    name: "numberOfSendedBehavioralForms"
                },
                {
                    name: "numberOfRegisteredBehavioralForms"
                },
            ],
        });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
         var DynamicForm_ReturnDate_BE = isc.DynamicForm.create({
        width: "150px",
        height: "10px",
        padding: 0,
        fields: [
            {
                name: "evaluationReturnDate",
                title: "<spring:message code='return.date'/>",
                ID: "ReturnDate_BE",
                width: "150px",
                hint: "----/--/--",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('ReturnDate_BE', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                click: function (form) {

                },
                changed: function (form, item, value) {
                    evaluation_check_date_BE();
                }
            }
        ]
    });

    //----------------------------------------- ListGrids --------------------------------------------------------------
        var ListGrid_student_BE = isc.TrLG.create({
            width: "100%",
            height: "100%",
            <sec:authorize access="hasAuthority('Evaluation_Behavior_R')">
            dataSource: RestDataSource_student_BE,
            </sec:authorize>
            selectionType: "single",
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            sortField: 5,
            sortDirection: "descending",
            fields: [
                {name: "student.firstName"},
                {name: "student.lastName"},
	            {name: "student.gender"},
                {name: "student.nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "student.postTitle",
                },
                {
                    name: "student.contactInfo.smSMobileNumber",
                },
	            {
                    name: "applicantCompanyName",
                    textAlign: "center"
                },
                {
                    name: "numberOfSendedBehavioralForms",
                    title: "تعداد فرم های صادر شده"
                },
                {
                    name: "numberOfRegisteredBehavioralForms",
                    title: "تعداد فرم های ثبت شده"
                },
                {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
                {
                    name: "saveResults",
                    title: " ",
                    align: "center",
                    canSort: false,
                    canFilter: false,
                    autoFithWidth: true
                }
            ],
            filterEditorSubmit: function () {
                ListGrid_student_BE.invalidateCache();
            },
            getCellCSSText: function (record, rowNum, colNum) {
                // if (!ListGrid_student_BE.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 1)
                //     return "background-color : #d8e4bc";
                //
                // if (!ListGrid_student_BE.getFieldByName("evaluationStatusBehavior").hidden && (record.evaluationStatusBehavior === 3 || record.evaluationStatusBehavior === 2))
                //     return "background-color : #b7dee8";
                if (this.getFieldName(colNum) == "student.contactInfo.smSMobileNumber")
                    return  ";color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
            },
            createRecordComponent: function (record, colNum) {
                let fieldName = this.getFieldName(colNum);
                if (fieldName == "saveResults") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "فرم های صادر شده",
                        width: "120",
                        baseStyle: "registerFile",
                        click: function () {
                            register_Behavioral_Form_BE(record);
                        }
                    });
                    return button;
                } else if (fieldName == "sendForm") {
                    <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        baseStyle: "sendFile",
                        title: "صدور فرم",
                        width: "120",
                        click: function () {
                            Training_Behavioral_Form_Inssurance_BE(record);
                        }
                    });
                    return button;
                    </sec:authorize>
                } else {
                    return null;
                }
            },
            <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
            cellClick: function (record, rowNum, colNum) {
                editMobileForm.callBack = (contactInfo ,m) => {record.student.contactInfo = contactInfo;record.student.contactInfo.smSMobileNumber = m;};
                if (this.getFieldName(colNum) == "student.contactInfo.smSMobileNumber") {
                    if (record.student.contactInfo) {
                        record.student.contactInfo.parentId = record.student.id;
                        editMobileForm.editRecord(record.student.contactInfo);
                        switch (record.student.contactInfo.mobileForSMS) {
                            case 2:
                                editMobileForm.getItem('mobile2_c').setValue(true);
                                break;
                            case 3:
                                editMobileForm.getItem('hrMobile_c').setValue(true);
                                break;
                            case 4:
                                editMobileForm.getItem('mdmsMobile_c').setValue(true);
                                break;
                            default:
                                editMobileForm.getItem('mobile_c').setValue(true);
                                editMobileForm.getValues().mobileForSMS = 1;
                        }
                        editMobileForm.clearErrors();
                        Window_EditMobile.show();
                    } else {
                        isc.RPCManager.sendRequest(TrDSRequest(rootUrl.concat("/contactInfo/createNewFor/").concat(record.student.id), "POST", "Student", (r) => {
                            editMobileForm.clearValues();
                            editMobileForm.clearErrors();
                            editMobileForm.editRecord(JSON.parse(r.data));
                            editMobileForm.getItem('mobile_c').setValue(true);
                            editMobileForm.getValues().mobileForSMS = 1;
                            Window_EditMobile.show();
                        }));
                    }
                }
            },
            </sec:authorize>
        });

    //----------------------------------------- ToolStrips -------------------------------------------------------------
        var ToolStripButton_FormIssuanceForAll_BE = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance.Behavioral"/>",
            baseStyle: "sendFile",
            click: function () {
            }
        });

        var ToolStripButton_RefreshIssuance_BE = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_student_BE.invalidateCache();
            }
        });
        
        var ToolStripButton_Excel_BE = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_student_BE, tclassStudentUrl, 0,
                null, '', "لیست فراگیران", ListGrid_student_BE.data.getCriteria(), null);
        }
    });
        
        var ToolStripButton_Print_BE = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            printStudentList(ListGrid_student_BE);
        }
    });

        var ToolStrip_BE = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 10,
            members: [
                // isc.VLayout.create({
                //     members: [
                //         ToolStripButton_FormIssuanceForAll_BE,
                //         isc.LayoutSpacer.create({height: "22"})
                //     ]
                // }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
                        ToolStripButton_Excel_BE,
                        ToolStripButton_Print_BE,
                        </sec:authorize>
                        <sec:authorize access="hasAuthority('Evaluation_Behavior_R')">
                        ToolStripButton_RefreshIssuance_BE
                        </sec:authorize>
                    ]
                })
            ]
        });

    //----------------------------------------- LayOut -----------------------------------------------------------------
        var HLayout_Actions_BE = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_BE]
        });

        var Hlayout_Grid_BE = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_student_BE]
        });

        var HLayout_returnData_BE = isc.HLayout.create({
            width: "100%",
            members: [
                DynamicForm_ReturnDate_BE
            ]
        });

        var VLayout_Body_BE = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_returnData_BE, HLayout_Actions_BE, Hlayout_Grid_BE]
        });

    //----------------------------------------- New Funsctions ---------------------------------------------------------
        function Training_Behavioral_Form_Inssurance_BE(record){

            let EvaluationDS_PersonList_BE = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "lastName",
                        title: "<spring:message code="lastName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "personnelNo",
                        title: "<spring:message code="personnel.no"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "personnelNo2",
                        title: "<spring:message code="personnel.no.6.digits"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "postTitle",
                        title: "<spring:message code="post"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            });

            let EvaluationListGrid_PeronalLIst_BE = isc.TrLG.create({
                dataSource: EvaluationDS_PersonList_BE,
                selectionType: "single",
                autoFetchData: false,
                fields: [
                    {name: "id", hidden: true},
                    {name: "firstName"},
                    {name: "lastName"},
                    {name: "nationalCode"},
                    {name: "personnelNo"},
                    {name: "personnelNo2"},
                    {name: "postTitle"},
                ],
                selectionAppearance: "checkbox"
            });

            let evaluation_Audience_Type = isc.DynamicForm.create({
                fields: [
                    {
                        name: "audiencePost",
                        type: "SelectItem",
                        optionDataSource: AudienceTypeDS_BE,
                        title: "نوع مخاطب : ",
                        defaultValue: 190,
                        pickListProperties: {
                            showFilterEditor: false
                        },
                        pickListFields: [
                            {name: "title"}
                        ],
                        valueField: "id",
                        displayField: "title",
                        changed: function (form, item, value) {
                            if(value == 190){
                                EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/getParentEmployee/" + record.student.nationalCode;
                                EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                EvaluationListGrid_PeronalLIst_BE.fetchData(null,(resp)=>{
                                    if(resp.data.size() == 0){
                                        EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                                        EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                        EvaluationListGrid_PeronalLIst_BE.fetchData();
                                        EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                    }
                                });
                            }
                            else if(value == 189){
                                EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/getSiblingsEmployee/" + record.student.nationalCode;
                                EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                EvaluationListGrid_PeronalLIst_BE.fetchData(null,(resp)=>{
                                    if(resp.data.size() == 0){
                                        EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                                        EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                        EvaluationListGrid_PeronalLIst_BE.fetchData();
                                        EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                    }
                                });
                            }
                            else if(value == 454){
                                EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/getTraining/" +  "<%= SecurityUtil.getNationalCode()%>";
                                EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                EvaluationListGrid_PeronalLIst_BE.fetchData(null,(resp)=>{
                                    if(resp.data.size() == 0){
                                        EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                                        EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                        EvaluationListGrid_PeronalLIst_BE.fetchData();
                                        EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                    }
                                });
                            }
                            else if(value == 188){
                                EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/getStudent/" + record.student.nationalCode;
                                EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                EvaluationListGrid_PeronalLIst_BE.fetchData(null,(resp)=>{
                                    if(resp.data.size() == 0){
                                        EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                                        EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                        EvaluationListGrid_PeronalLIst_BE.fetchData();
                                        EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                                    }
                                });
                            }
                            else{
                                EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                                EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                                EvaluationListGrid_PeronalLIst_BE.fetchData();
                                EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                            }

                        }
                    },
                ],
            });
            let Buttons_List_HLayout = isc.HLayout.create({
                width: "100%",
                height: "30px",
                autoDraw: false,
                padding: "5px",
                align: "center",
                membersMargin: 5,
                members: [
                    isc.IButton.create({
                        title: "انتخاب",
                        click: function () {
                            if((evaluation_Audience_Type.getValue("audiencePost") !== null && evaluation_Audience_Type.getValue("audiencePost") !== undefined) && evaluation_Audience_Type.getValue("audiencePost") == 188){
                                    Select_Questionnarie_BE(null,null, record.id, 188, record.id, 188, 230, 156);
                            }
                            else if (EvaluationListGrid_PeronalLIst_BE.getSelectedRecord() !== null && (evaluation_Audience_Type.getValue("audiencePost") !== null && evaluation_Audience_Type.getValue("audiencePost") !== undefined)) {
                                if(evaluation_Audience_Type.getValue("audiencePost") == 190)
                                    Select_Questionnarie_BE(null,null, EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().id, 190, record.id, 188, 230, 156);
                                else if(evaluation_Audience_Type.getValue("audiencePost") == 189)
                                    Select_Questionnarie_BE(null,null, EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().id, 189, record.id, 188, 230, 156);
                                else if(evaluation_Audience_Type.getValue("audiencePost") == 454)
                                    Select_Questionnarie_BE(null,null, EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().id, 454, record.id, 188, 230, 156);
                            } else if(evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined){
                                createDialog('info', "<spring:message code="select.audience.post.ask"/>", "<spring:message code="global.message"/>");
                            } else {
                                isc.Dialog.create({
                                    message: "<spring:message code="select.audience.ask"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "<spring:message code="global.message"/>",
                                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });
                            }
                        }
                    }),
                    // isc.IButton.create({
                    //     title: "ارسال از طریق پیامک",
                    //     click: function () {
                    //     }
                    // }),
                    isc.IButton.create({
                        title: "<spring:message code="logout"/>",
                        click: function () {
                            evaluation_Audience_BE = null;
                            evaluation_Audience_Type.setValues(null);
                            EvaluationWin_PersonList.close();
                        }
                    })
                ]
            });
            let evaluation_personnel_List_VLayout = isc.VLayout.create({
                width: "100%",
                height: "100%",
                autoDraw: false,
                members: [
                    evaluation_Audience_Type,
                    EvaluationListGrid_PeronalLIst_BE,
                    Buttons_List_HLayout
                ]
            });
            evaluation_Audience_Type.setValues(null);
            let EvaluationWin_PersonList = isc.Window.create({
                title: "<spring:message code="select.audience"/>",
                width: 600,
                height: 400,
                minWidth: 600,
                minHeight: 400,
                autoSize: false,
                visibility: "hidden",
                items: [
                    evaluation_personnel_List_VLayout
                ],
                close : function () {
                    evaluation_Audience_Type.setValues(null);
                    this.Super("close",arguments);
                }
            });
            EvaluationDS_PersonList_BE.fetchDataURL =  "";
            EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
            EvaluationWin_PersonList.show();
            EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/getParentEmployee/" + record.student.nationalCode;
            EvaluationListGrid_PeronalLIst_BE.invalidateCache();
            EvaluationListGrid_PeronalLIst_BE.fetchData(null,(resp)=>{
                if(resp.data.size() == 0){
                    EvaluationDS_PersonList_BE.fetchDataURL =  viewActivePersonnelUrl + "/iscList";
                    EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                    EvaluationListGrid_PeronalLIst_BE.fetchData();
                    EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                }
            });
        }

        function Select_Questionnarie_BE(id,questionnarieId, evaluatorId,
                                         evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                         evaluationLevel) {
            let IButtonSave_SelectQuestionnarie_BE = isc.IButtonSave.create({
                title: "صدور/ارسال به کارتابل",
                width: 150,
                click: function () {
                    if (ListGrid_SelectQuestionnarie_BE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_BE.getSelectedRecord() == undefined) {
                        createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                    } else {
                        Window_SelectQuestionnarie_BE.close();
                        ListGrid_SelectQuestionnarie_BE.getSelectedRecord().id;
                        create_evaluation_form_BE(id, evaluatorId,
                            evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                            evaluationLevel,ListGrid_SelectQuestionnarie_BE.getSelectedRecord().id);
                    }
                }
            });
            let RestDataSource_Questionnarie_BE = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "questionnaireTypeId", hidden: true},
                    {
                        name: "questionnaireType.title",
                        title: "<spring:message code="type"/>",
                        required: true,
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
                ],
                fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord_BE.id
            });
            let ListGrid_SelectQuestionnarie_BE = isc.TrLG.create({
                width: "100%",
                dataSource: RestDataSource_Questionnarie_BE,
                selectionType: "single",
                selectionAppearance: "checkbox",
                fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                    name: "id",
                    hidden: true
                }]
            });
            let Window_SelectQuestionnarie_BE = isc.Window.create({
                width: 1024,
                placement: "fillScreen",
                keepInParentRect: true,
                title: "انتخاب پرسشنامه",
                items: [
                    isc.HLayout.create({
                        width: "100%",
                        height: "90%",
                        members: [ListGrid_SelectQuestionnarie_BE]
                    }),
                    isc.TrHLayoutButtons.create({
                        width: "100%",
                        height: "5%",
                        members: [
                            IButtonSave_SelectQuestionnarie_BE,
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_SelectQuestionnarie_BE.close();
                                }
                            })
                        ]
                    })
                ],
                minWidth: 1024
            });
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "enabled", operator: "isNull"},
                    {fieldName: "questionnaireTypeId", operator: "equals", value: 230}
                ]
            };
            ListGrid_SelectQuestionnarie_BE.fetchData(criteria);
            ListGrid_SelectQuestionnarie_BE.invalidateCache();
            Window_SelectQuestionnarie_BE.show();
        }

        function register_Behavioral_Form_BE(StdRecord){
            let RestDataSource_BehavioralRegisteration_JSPEvaluation = isc.TrDS.create({
                fields: [
                    {name: "evaluatorTypeId"},
                    {name: "evaluatorName"},
                    {name: "status"},
                    {name: "id", primaryKey: true},
                    {name: "evaluatorId"},
                    {name: "returnDate"},
                    {name: "evaluatorTypeTitle"},
                    {name: "status"}
                ],
                fetchDataURL : evaluationUrl + "/getBehavioralForms/" + StdRecord.id + "/" + classRecord_BE.id
            });
            let Listgrid_BehavioralRegisteration_JSPEvaluation = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: RestDataSource_BehavioralRegisteration_JSPEvaluation,
                sortField: 0,
                sortDirection: "Descending",
                showRecordComponents: true,
                showRecordComponentsByCell: true,
                showFilterEditor: false,
                fields: [
                    {
                        name: "evaluatorTypeId",
                        title: "نوع مخاطب",
                        width: "40%",
                        type: "SelectItem",
                        optionDataSource: AudienceTypeDS_BE,
                        filterEditorProperties:{
                            pickListProperties: {
                                showFilterEditor: false
                            }
                        },
                        canFilter: false,
                        valueField: "id",
                        displayField: "title"
                    },
                    {
                        name: "evaluatorName",
                        title: "نام مخاطب",
                        canFilter: false,
                        width: "40%"
                    },
                    {
                        name: "status",
                        title: "وضعیت فرم",
                        width: "10%",
                        valueMap: {
                            true: "ثبت شده",
                            false: "صادر شده"
                        }
                    },
                    {name: "evaluatorId",hidden: true},
                    {name: "status", hidden: true},
                    {name: "id", hidden: true},
                    {name: "returnDate", hidden: true},
                    {name: "evaluatorTypeTitle",hidden: true},
                    {name: "editForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                    {name: "removeForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                    {name: "printForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                ],
                getCellCSSText: function (record, rowNum, colNum) {
                    if (!record.status)
                        return "background-color : #d8e4bc";

                    if (record.status)
                        return "background-color : #b7dee8";
                },
                filterEditorSubmit: function () {
                    Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();
                },
                createRecordComponent: function (record, colNum) {
                    let fieldName = this.getFieldName(colNum);
                    if (fieldName == "editForm") {
                        let recordCanvas = isc.HLayout.create({
                            height: "100%",
                            width: "100%",
                            layoutMargin: 5,
                            membersMargin: 10,
                            align: "center"
                        });
                        let editIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/edit.png",
                            prompt: "ویرایش فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                register_behavioral_evaluation_result(StdRecord,record);
                            }
                        });
                        recordCanvas.addMember(editIcon);
                        return recordCanvas;
                    }
                    else if (fieldName == "removeForm") {
                        <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
                        let recordCanvas = isc.HLayout.create({
                            height: "100%",
                            width: "100%",
                            layoutMargin: 5,
                            membersMargin: 10,
                            align: "center"
                        });
                        let addIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/remove.png",
                            prompt: "حذف فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                let Dialog_Remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                                    "<spring:message code="verify.delete"/>");
                                Dialog_Remove.addProperties({
                                    buttonClick: function (button, index) {
                                        this.close();
                                        if (index === 0) {
                                            let data = {};
                                            data.classId = classRecord_BE.id;
                                            data.evaluatorId = record.evaluatorId;
                                            data.evaluatorTypeId = record.evaluatorTypeId;
                                            data.evaluatedId = StdRecord.id;
                                            data.evaluatedTypeId = 188;
                                            data.questionnaireTypeId = 230;
                                            data.evaluationLevelId = 156;
                                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation" , "POST", JSON.stringify(data), function (resp) {
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();
                                                    ListGrid_student_BE.invalidateCache();
                                                    isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateBehavioralEvaluation" + "/" +
                                                        classRecord_BE.id,"GET", null, null));
                                                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                    setTimeout(() => {
                                                        msg.close();
                                                    }, 3000);
                                                } else {
                                                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                }
                                            }))
                                        }
                                    }
                                });
                            }
                        });
                        recordCanvas.addMember(addIcon);
                        return recordCanvas;
                        </sec:authorize>
                    }
                    else if (fieldName == "printForm") {
                        <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
                        let recordCanvas = isc.HLayout.create({
                            height: "100%",
                            width: "100%",
                            layoutMargin: 5,
                            membersMargin: 10,
                            align: "center"
                        });
                        let addIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/print.png",
                            prompt: "چاپ فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                print_Behavioral_Form_BE(StdRecord,record);
                            }
                        });
                        recordCanvas.addMember(addIcon);
                        return recordCanvas;
                        </sec:authorize>
                    }
                    else
                        return null;
                },
                cellHeight: 43,
                filterOperator: "iContains",
                filterOnKeypress: false,
                allowAdvancedCriteria: true,
                allowFilterExpressions: true,
                selectionType: "single",
                autoFetchData: true,
                filterUsingText: "<spring:message code='filterUsingText'/>",
                groupByText: "<spring:message code='groupByText'/>",
                freezeFieldText: "<spring:message code='freezeFieldText'/>"
            });
            let Window_BehavioralRegisteration_JSPEvaluation = isc.Window.create({
                placement: "fillScreen",
                title: "لیست فرم های ارزیابی تغییر رفتار فراگیر " + StdRecord.student.firstName + " " + StdRecord.student.lastName,
                canDragReposition: true,
                align: "center",
                autoDraw: true,
                border: "1px solid gray",
                items: [isc.TrVLayout.create({
                    members: [
                        Listgrid_BehavioralRegisteration_JSPEvaluation
                    ]
                })]
            });
            Window_BehavioralRegisteration_JSPEvaluation.show();
            function register_behavioral_evaluation_result(StdRecord,FormRecord) {
                    let evaluationResult_DS = isc.TrDS.create({
                        fields:
                            [
                                {name: "id", primaryKey: true, hidden: true},
                                {name: "title", title: "<spring:message code="title"/>"},
                                {name: "code", title: "<spring:message code="code"/>"}
                            ],
                        autoFetchData: false,
                        autoCacheAllData: true,
                        fetchDataURL: parameterUrl + "/iscList/EvaluationResult"
                    });

                    let evaluationId;

                    let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};

                    let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                        numCols: 6,
                        width: "100%",
                        borderRadius: "10px 10px 0px 0px",
                        border: "2px solid black",
                        titleAlign: "left",
                        margin: 10,
                        padding: 10,
                        fields: [
                            {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                            {name: "titleClass", title: "<spring:message code='class.title'/>:", canEdit: false},
                            {name: "startDate", title: "<spring:message code='start.date'/>:", canEdit: false},
                            {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                            {name: "institute", title: "<spring:message code='institute'/>:", canEdit: false},
                            {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                            {name: "evaluationLevel", title: "<spring:message code="evaluation.level"/>:", canEdit: false},
                            {name: "evaluationType", title: "<spring:message code="evaluation.type"/>:", canEdit: false, endRow: true},
                            {name: "evaluator", title: "<spring:message code="evaluator"/>:", canEdit: false,},
                            {name: "evaluated", title: "<spring:message code="evaluation.evaluated"/>:", canEdit: false}
                        ]
                    });

                    let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                        validateOnExit: true,
                        colWidths: ["45%", "50%"],
                        cellBorder: 1,
                        width: "100%",
                        padding: 10,
                        styleName: "teacher-form",
                        fields: []
                    });

                    let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                        width: "100%",
                        fields: [
                            {
                                name: "description",
                                title: "<spring:message code='suggestions'/>",
                                type: 'textArea',
                                height: 100,
                                length: "600",
                                enforceLength : true
                            }
                        ]
                    });

                    let IButton_Questions_Save = isc.IButtonSave.create({
                        click: function () {
                            let evaluationAnswerList = [];
                            let data = {};
                            let evaluationFull = true;
                            let evaluationEmpty = true;

                            let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                            for (let i = 0; i < questions.length; i++) {
                                if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                                    evaluationFull = false;
                                }
                                else{
                                    evaluationEmpty = false;
                                }
                                let evaluationAnswer = {};
                                evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                                evaluationAnswer.id = questions[i].name.substring(1);
                                evaluationAnswerList.push(evaluationAnswer);
                            }
                            data.evaluationAnswerList = evaluationAnswerList;
                            data.evaluationFull = evaluationFull;
                            data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                            data.classId = classRecord_BE.id;
                            if(FormRecord.evaluatorTypeId == 188)
                                data.evaluatorId = StdRecord.id;
                            else
                                data.evaluatorId = FormRecord.evaluatorId;
                            data.evaluatorTypeId = FormRecord.evaluatorTypeId;
                            data.evaluatedId = StdRecord.id;
                            data.evaluatedTypeId = 188;
                            data.questionnaireTypeId = 230;
                            data.evaluationLevelId = 156;
                            data.status = true;
                            if(evaluationEmpty == false){
                                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        Window_Questions_JspEvaluation.close();
                                        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateBehavioralEvaluation" + "/" +
                                            classRecord_BE.id,"GET", null, null));
                                        ListGrid_student_BE.invalidateCache();
                                        Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();
                                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                        setTimeout(() => {
                                            msg.close();
                                        }, 3000);
                                    } else {
                                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                    }
                                }))
                            }
                            else{
                                createDialog("info", "حداقل به یکی از سوالات فرم ارزیابی باید جواب داده شود", "<spring:message code="error"/>");
                            }

                        }
                    });

                    let Window_Questions_JspEvaluation = isc.Window.create({
                        width: 1024,
                        height: 768,
                        keepInParentRect: true,
                        title: "<spring:message code="record.evaluation.results"/>",
                        items: [
                            DynamicForm_Questions_Title_JspEvaluation,
                            DynamicForm_Questions_Body_JspEvaluation,
                            DynamicForm_Description_JspEvaluation,
                            isc.TrHLayoutButtons.create({
                                members: [
                                    <sec:authorize access="hasAuthority('Evaluation_Behavior_Actions')">
                                    IButton_Questions_Save,
                                    </sec:authorize>
                                    isc.IButtonCancel.create({
                                        click: function () {
                                            Window_Questions_JspEvaluation.close();
                                        }
                                    })]
                            })
                        ],
                        minWidth: 1024
                    });

                    let itemList = [];

                    DynamicForm_Questions_Title_JspEvaluation.clearValues();
                    DynamicForm_Description_JspEvaluation.clearValues();
                    DynamicForm_Questions_Body_JspEvaluation.clearValue();

                    DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classRecord_BE.tclassCode);
                    DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(classRecord_BE.courseTitleFa);
                    DynamicForm_Questions_Title_JspEvaluation.getItem("institute").setValue(classRecord_BE.instituteTitleFa);

                    DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classRecord_BE.tclassStartDate);
                    DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("ارزیابی دیگری از فراگیر");
                    DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("رفتاری");
                    DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", StdRecord.student.firstName + " " + StdRecord.student.lastName);
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", FormRecord.evaluatorName);
                    isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_BE.teacherId,"GET", null, function (resp1) {
                        DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp1.httpResponseText);
                        load_evaluation_form_BS();
                    }));

                    Window_Questions_JspEvaluation.show();

                    evalWait_BE = createDialog("wait");

                    function load_evaluation_form_BS(criteria, criteriaEdit) {

                        let data = {};
                        data.classId = classRecord_BE.id;
                        data.evaluatorId = FormRecord.evaluatorId;
                        data.evaluatorTypeId = FormRecord.evaluatorTypeId;
                        data.evaluatedId = StdRecord.id;
                        data.evaluatedTypeId = 188;
                        data.questionnaireTypeId = 230;
                        data.evaluationLevelId = 156;

                        let itemList = [];
                        let description;
                        let record = {};

                        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
                            let result = JSON.parse(resp.httpResponseText).response.data;
                            description = result[0].description;
                            evaluationId = result[0].evaluationId;
                            for(let i=0;i<result.size();i++){
                                let item = {};
                                if(result[i].questionSourceId === 199){
                                    switch (result[i].domainId) {
                                        case 54:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "امکانات: " + result[i].question;
                                            break;
                                        case 138:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "کلاس: " + result[i].question;
                                            break;
                                        case 53:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "مدرس: " + result[i].question;
                                            break;
                                        case 1:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "مدرس: " + result[i].question;
                                            break;
                                        case 183:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "محتواي کلاس: " + result[i].question;
                                            break;
                                        case 659:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = "فراگیر: " + result[i].question;
                                            break;
                                        default:
                                            item.name = "Q" + result[i].id;
                                            item.domainId = result[i].domainId;
                                            item.title = result[i].question;
                                    }

                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    item.icons = [
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "پاک کردن",
                                            click : function (form, item, icon) {
                                                item.clearValue();
                                                item.focusInItem();
                                            }
                                        }
                                    ];
                                    record["Q" + result[i].id] = result[i].answerId;
                                }
                                else if(result[i].questionSourceId === 200){
                                    item.name = "M" + result[i].id;
                                    item.title = "هدف اصلی: " + result[i].question;
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    item.icons = [
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "پاک کردن",
                                            click : function (form, item, icon) {
                                                item.clearValue();
                                                item.focusInItem();
                                            }
                                        }
                                    ];
                                    record["M" + result[i].id] = result[i].answerId;
                                }
                                else if(result[i].questionSourceId === 201){
                                    item.name = "G" + result[i].id;
                                    item.title = "هدف: " + result[i].question;
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    item.icons = [
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "پاک کردن",
                                            click : function (form, item, icon) {
                                                item.clearValue();
                                                item.focusInItem();
                                            }
                                        }
                                    ];
                                    record["G" + result[i].id] = result[i].answerId;
                                }
                                itemList.add(item);
                            }
                            itemList.sortByProperty("domainId", true);
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                            DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                            evalWait_BE.close();
                        }));
                    }
                }
         }

        function print_Behavioral_Form_BE(StdRecord,EvaluatorRecord){
            let myObj = {
                classId: classRecord_BE.id,
                evaluationLevelId: 156,
                questionnarieTypeId: 230,
                evaluatorId: EvaluatorRecord.evaluatorId,
                evaluatorTypeId: EvaluatorRecord.evaluatorTypeId,
                audienceName: EvaluatorRecord.evaluatorName,
                audienceType: EvaluatorRecord.evaluatorTypeTitle,
                evaluatedId: StdRecord.id,
                evaluatedTypeId: 188
            };
            trPrintWithCriteria("<spring:url value="/evaluation/printEvaluationForm"/>", null, JSON.stringify(myObj));
        }

    //----------------------------------------- Global Functions  ------------------------------------------------------
        function evaluation_check_date_BE() {
            DynamicForm_ReturnDate_BE.clearFieldErrors("evaluationReturnDate", true);

            if (DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate") !== undefined && !checkDate(DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate"))) {
                DynamicForm_ReturnDate_BE.addFieldErrors("evaluationReturnDate", "<spring:message code='msg.correct.date'/>", true);
            } else if (DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate") < classRecord_BE.startDate) {
                DynamicForm_ReturnDate_BE.addFieldErrors("evaluationReturnDate", "<spring:message code='return.date.before.class.start.date'/>", true);
            } else {
                DynamicForm_ReturnDate_BE.clearFieldErrors("evaluationReturnDate", true);
            }
        }

        function create_evaluation_form_BE(id, evaluatorId,
                                        evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                        evaluationLevel,questionnaireId){

            let data = {};
            data.classId = classRecord_BE.id;
            data.status = false;
            if(ReturnDate_BE._value != undefined )
                data.returnDate =  ReturnDate_BE._value;
            data.sendDate = todayDate;
            data.evaluatorId = evaluatorId;
            data.evaluatorTypeId = evaluatorTypeId;
            data.evaluatedId = evaluatedId;
            data.evaluatedTypeId = evaluatedTypeId;
            data.questionnaireId = questionnaireId;
            data.questionnaireTypeId = questionnarieTypeId;
            data.evaluationLevelId = evaluationLevel;
            data.evaluationFull = false;
            data.description = null;

            let obj = {};
            obj.classId = classRecord_BE.id;
            obj.evaluatorId = evaluatorId;
            obj.evaluatorTypeId = evaluatorTypeId;
            obj.evaluatedId = evaluatedId;
            obj.evaluatedTypeId = evaluatedTypeId;
            obj.questionnaireTypeId = questionnarieTypeId;
            obj.evaluationLevelId = evaluationLevel;

            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(obj), function (resp) {
                if(resp.httpResponseCode == 406){
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                                ListGrid_student_BE.invalidateCache();
                        }
                        else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }));
                }
                else
                    createDialog("info", "فرم ارزیابی رفتاری قبلا برای این فرد صادر شده است");
            }));
        }

        function questionSourceConvert(s) {
        switch (s.charAt(0)) {
            case "G":
                return 201;
            case "M":
                return 200;
            case "Q":
                return 199;
        }
    }

    // </script>


