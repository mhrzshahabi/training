<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var teacherMethod = "POST";
    var teacherWait;
    var responseID;
    var attachName;
    var attachNameTemp;
    var nationalCodeCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;
    var selectedRecordPersonalID = null;
    var isCategoriesChanged;
    var selected_record = null;
    var selected_teacher = null;
    var tab_selected = null;
    var selectedRecordID = null;
    var isFileAttached = false;
    var editTeacherMode = false;
    let oLoadAttachments_Teacher = null;
    var vm = isc.ValuesManager.create({});

    //----------------------------------------------------Rest Data Sources---------------------------------------------
    var RestDataSource_Teacher_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories", filterOperator: "inSet"},
            {name: "subCategories", filterOperator: "inSet"},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"},
            {name: "personality.accountInfo.id"},
            {name: "personality.educationLevelId"}
        ],
        fetchDataURL: teacherUrl + "spec-list-grid"
    });

    var RestDataSource_Category_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Education_Level_JspTeacher = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "iscList"
    });

    var RestDataSource_Education_Level_ByID_JspTeacher = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "spec-list-by-id"
    });

    var RestDataSource_Education_Major_JspTeacher = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        autoCacheAllData: true,
        fetchDataURL: educationMajorUrl + "iscList",
    });

    var RestDataSource_Education_Major_ByID_JspTeacher = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationMajorUrl + "spec-list-by-id"
    });

    var RestDataSource_Education_Orientation_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleEn"}, {name: "titleFa"}]
    });

    var RestDataSource_Home_City_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Home_State_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_Work_City_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_Work_State_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_BasicInfo_JspTeacher = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });
    //----------------------------------------------------Menu-------------------------------------------------------
    let ToolStripExcel_JspTeacher = isc.ToolStripButtonExcel.create({
        click: function () {
           ExportToFile.downloadExcelRestUrl(null, ListGrid_Teacher_JspTeacher, teacherUrl + "spec-list-grid", 0, null, '', "اجرا - استاد", ListGrid_Teacher_JspTeacher.getCriteria(), null);
    }
    });

    //----------------------------------------------------ListGrid------------------------------------------------------
    var ListGrid_Teacher_JspTeacher = isc.TrLG.create({
        width: "100%",
        height: "100%",

        <sec:authorize access="hasAuthority('Teacher_R')">
        dataSource: RestDataSource_Teacher_JspTeacher,
        </sec:authorize>

        <sec:authorize access="hasAuthority('Teacher_U')">
        rowDoubleClick: function () {
            ListGrid_teacher_edit(null,"teacher");
        },
        </sec:authorize>
        initialSort: [
            {property: "teacherCode", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "teacherCode",
                title: "<spring:message code='national.code'/>",
                align: "center",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.firstNameFa;
                }
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.lastNameFa;
                }
            },
            {
                name: "personnelCode",
                title: "<spring:message code='personnel.code.six.digit'/>",
                align: "center",
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                editorType: "SelectItem",
                optionDataSource: RestDataSource_Category_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                canSort: false,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_Category_JspTeacher,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["titleFa","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='subcategory'/>",
                editorType: "ComboBoxItem",
                optionDataSource: RestDataSource_SubCategory_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                canSort: false,
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_SubCategory_JspTeacher,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["titleFa","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                }
            },
            {
                name: "personality.educationLevel.titleFa",
                title: "<spring:message code='education.level'/>",
                align: "center",
                filterOperator: "equals",
                sortNormalizer: function (record) {
                    return record.personality.educationLevel.titleFa;
                }
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                filterOperator: "equals",
                sortNormalizer: function (record) {
                    return record.personality.educationMajor.titleFa;
                }
            },
            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='mobile.connection'/>",
                align: "center",
                type: "phoneNumber",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                sortNormalizer: function (record) {
                    return record.personality.contactInfo.mobile;
                }
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                align: "center",
                type: "boolean"
            }
        ],
        filterEditorSubmit: function () {
            ListGrid_Teacher_JspTeacher.invalidateCache();
        },
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: false,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    //-----------------------------------------------Save and Close Buttons---------------------------------------------
    IButton_Teacher_Save_And_Close_JspTeacher = isc.IButtonSave.create({
        top: 260,
        title: "<spring:message code="save.and.close"/>",
        click: function () {
            Teacher_Save_Close_Button_Click_JspTeacher();
        }
    });

    IButton_Teacher_Save_JspTeacher = isc.IButtonSave.create({
        top: 260,
        click: function () {
            Teacher_Save_Button_Click_JspTeacher();
        }
    });

    IButton_Teacher_Exit_JspTeacher = isc.IButtonCancel.create({
        width: 100,
        orientation: "vertical",
        click: function () {
            showAttachViewLoader.hide();
            Window_Teacher_JspTeacher.close();
            ListGrid_teacher_refresh();
        }
    });
    //-----------------------------------------------LayOuts and Tabsets and Window-------------------------------------
    var HLayOut_TeacherSaveOrExit_JspTeacher = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Teacher_Save_And_Close_JspTeacher,
            IButton_Teacher_Save_JspTeacher,
            IButton_Teacher_Exit_JspTeacher
        ]
    });

    var TabSet_BasicInfo_JspTeacher = isc.TabSet.create({
        showResizeBar: true,
        titleEditorTopOffset: 2,
        width: "100%",
        minWidth:1350,
        height: "65%",
        tabs: [
            {
                ID: "teacherBasicInfo",
                title: "<spring:message code='basic.information'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teacherBasicInfo-tab"})
            }
        ]
    });

    var TabSet_Bottom_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "25%",
        minWidth:1350,
        width:"100%",
        tabs: [
            {
                ID: "academicBK",
                title: "<spring:message code="academicBK"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/academicBK-tab"})
            },
            {
                ID: "employmentHistory",
                title: "<spring:message code='employmentHistory'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/employmentHistory-tab"})
            },
            {
                ID: "teachingHistory",
                title: "سوابق تدریس خارجی",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teachingHistory-tab"})
            },
            {
                ID: "internalTeachingHistory",
                title: "سوابق تدریس در این مرکز",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/internalTeachingHistory-tab"})
            },
            {
                ID: "teacherCertification",
                title: "<spring:message code='teacherCertification'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/teacherCertification-tab"})
            },
            {
                ID: "publication",
                title: "<spring:message code="publication"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/publication-tab"})
            },
            {
                ID: "foreignLangKnowledge",
                title: "<spring:message code="foreign.languages.knowledge"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/foreignLangKnowledge-tab"})
            },
            {
                ID: "accountInfo",
                title: "<spring:message code='account.information'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/accountInfo-tab"})
            },
            {
                ID: "addressInfo",
                title: "<spring:message code='address'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/addressInfo-tab"})
            },
            {
                ID: "jobInfo",
                title: "<spring:message code='work.place'/>", canClose: false,
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/jobInfo-tab"})
            },
            {
                ID: "TeacherAttachmentsTab",
                name:"TeacherAttachmentsTab",
                title: "<spring:message code="attachments"/>",

            },
            {
                ID: "otherActivities",
                title: "<spring:message code="otherActivities"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "teacher/otherActivities-tab"})
            },
        ],
        tabSelected: function (tabSet, tabNum, tabPane, ID, tab, name) {
            var teacherId;
            if (selectedRecordID != null) {
                teacherId = selectedRecordID;
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "TeacherAttachmentsTab" || TabSet_Bottom_JspTeacher.getSelectedTab().name  == "TeacherAttachmentsTab")
                    oLoadAttachments_Teacher.loadPage_attachment_Job("Teacher", teacherId, "<spring:message code="document"/>", {
                        1: "رزومه",
                        2: "مدرک تحصیلی",
                        3: "گواهینامه"
                    });
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "academicBK")
                    loadPage_AcademicBK(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == 'teachingHistory')
                    loadPage_TeachingHistory(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "internalTeachingHistory")
                    loadPage_InternalTeachingHistory(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "teacherCertification")
                    loadPage_TeacherCertification(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "foreignLangKnowledge")
                    loadPage_ForeignLangKnowledge(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == "publication")
                    loadPage_Publication(teacherId);
                if (TabSet_Bottom_JspTeacher.getSelectedTab().ID == 'employmentHistory')
                    loadPage_EmploymentHistory(teacherId);
            }
        }
    });

    var Window_Teacher_JspTeacher = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        close : function(){closeCalendarWindow(); Window_Teacher_JspTeacher.hide();ListGrid_Teacher_JspTeacher.invalidateCache(); selected_teacher = null;
            editTeacherMode = false;},
        items: [isc.TrVLayout.create({
            members: [
                TabSet_BasicInfo_JspTeacher,
                HLayOut_TeacherSaveOrExit_JspTeacher,
                TabSet_Bottom_JspTeacher
            ]
        })]
    });
    //----------------------------------------- Evaluation -------------------------------------------------------------
    IButton_Evaluation_Show_JspTeacher = isc.IButton.create({
        title: "<spring:message code='cal.eval.grade'/>",
        width: 130,
        click: function () {
            DynamicForm_Evaluation_JspTeacher.validate();
            if (DynamicForm_Evaluation_JspTeacher.hasErrors())
                return;
            var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
            var catId = DynamicForm_Evaluation_JspTeacher.getValue("category");
            var subCatId = DynamicForm_Evaluation_JspTeacher.getValue("subCategory");
            isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "evaluateTeacher/" + record.id + "/" + catId + "/" + subCatId, "GET", null,
                "callback: teacher_evaluate_action_result(rpcResponse)"));
        }
    });

    IButton_Evaluation_Print_JspTeacher = isc.IButton.create({
        title: "<spring:message code='print.eval.form'/>",
        width: 130,
        click: function () {
            DynamicForm_Evaluation_JspTeacher.validate();
            if (DynamicForm_Evaluation_JspTeacher.hasErrors())
                return;
            var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
            var catId = DynamicForm_Evaluation_JspTeacher.getValue("category");
            var subCatId = DynamicForm_Evaluation_JspTeacher.getValue("subCategory");
            trPrintWithCriteria("<spring:url value="/teacher/printEvaluation/"/>" + record.id + "/" + catId + "/" + subCatId, null);
        }
    });

    IButton_Evaluation_Exit_JspTeacher = isc.IButtonCancel.create({
        orientation: "vertical",
        width: 130,
        click: function () {
            Window_Evaluation_JspTeacher.close();
        }
    });

    var HLayOut_EvaluationPrintOrExit_JspTeacher = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        membersMargin: 15,
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Evaluation_Show_JspTeacher,
            <sec:authorize access="hasAuthority('Teacher_P')">
            IButton_Evaluation_Print_JspTeacher,
            </sec:authorize>
            IButton_Evaluation_Exit_JspTeacher
        ]
    });

    var DynamicForm_Evaluation_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "80%",
        align: "right",
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        fields: [
            {name: "id", hidden: true},
            {
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                disabled: true
            },
            {
                name: "evaluationNumber",
                title: "<spring:message code='eval.grade'/>",
                disabled: true
            },
            {
                name: "category",
                title: "<spring:message code='category'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                defaultValue: null,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],

                changed: function () {
                    isCategoriesChanged = true;
                    var subCategoryField = DynamicForm_Evaluation_JspTeacher.getField("subCategory");
                    subCategoryField.clearValue();
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }

            },
            {
                name: "subCategory",
                title: "<spring:message code='subcategory'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultValue: null,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_SubCategory_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
                focus: function () {
                    if (isCategoriesChanged) {
                        isCategoriesChanged = false;
                        var ids = DynamicForm_Evaluation_JspTeacher.getField("category").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            }
        ]
    });

    var Window_Evaluation_JspTeacher = isc.Window.create({
        placement: "center",
        title: "<spring:message code='teacher.evaluation'/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        width: 550,
        height: 150,
        border: "1px solid gray",
        items: [isc.TrVLayout.create({
            members: [
                DynamicForm_Evaluation_JspTeacher,
                HLayOut_EvaluationPrintOrExit_JspTeacher,
            ]
        })]
    });

    function teacher_evaluate_action_result(resp) {
        DynamicForm_Evaluation_JspTeacher.setValue("evaluationNumber", resp.data);
    }

    //----------------------------------------------ToolStrips and Layout-Grid------------------------------------------
    var ToolStripButton_Refresh_JspTeacher = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_teacher_refresh();
        }
    });

    var ToolStripButton_Edit_JspTeacher = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_teacher_edit(null,"teacher");

        }
    });

    var ToolStripButton_Add_JspTeacher = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_teacher_add();
        }
    });

    var ToolStripButton_Remove_JspTeacher = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_teacher_remove();
        }
    });

    var ToolStripButton_Print_JspTeacher = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print'/>",
        click: function () {
            trPrintWithCriteria("<spring:url value="/teacher/printWithCriteria/"/>" + "pdf",
                ListGrid_Teacher_JspTeacher.getCriteria());
        }
    });

    var ToolStripButton_Evaluation_JspTeacher = isc.ToolStripButton.create({
        title: "<spring:message code='teacher.evaluation'/>",
        click: function () {
            var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            DynamicForm_Evaluation_JspTeacher.clearValues();
            DynamicForm_Evaluation_JspTeacher.setValue("teacherCode", record.teacherCode),
                Window_Evaluation_JspTeacher.show();
        }
    });

    var ToolStripButton_Print_InfoForm_JspTeacher = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print.teacher.detail'/>",
        click: function () {
            var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            trPrintWithCriteria("<spring:url value="/teacher/printWithDetail/"/>" + record.id, null);
        }
    });

    var ToolStripButton_Print_Empty_InfoForm_JspTeacher = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print.teacher.empty.form'/>",
        click: function () {
            window.open("pdf/teacher-info.pdf");
        }
    });

    var ToolStrip_Actions_JspTeacher = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Teacher_C')">
            ToolStripButton_Add_JspTeacher,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Teacher_U')">
            ToolStripButton_Edit_JspTeacher,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Teacher_D')">
            ToolStripButton_Remove_JspTeacher,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Teacher_P')">
            ToolStripButton_Print_JspTeacher,
            ToolStripExcel_JspTeacher,
            ToolStripButton_Print_InfoForm_JspTeacher,
            ToolStripButton_Print_Empty_InfoForm_JspTeacher,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Teacher_E')">
            ToolStripButton_Evaluation_JspTeacher,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Teacher_R')">
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspTeacher
                ]
            })
            </sec:authorize>
        ]
    });

    var HLayout_Grid_Teacher_JspTeacher = isc.TrHLayout.create({
        members: [ListGrid_Teacher_JspTeacher]
    });

    var HLayout_Actions_Teacher = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspTeacher]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Teacher,
            HLayout_Grid_Teacher_JspTeacher
        ]
    });
    //-------------------------------------------------Functions--------------------------------------------------------
    function ListGrid_teacher_refresh() {
        ListGrid_Teacher_JspTeacher.invalidateCache();
        ListGrid_Teacher_JspTeacher.filterByEditor();
        editTeacherMode = false;
    }

    function Teacher_Save_Button_Click_JspTeacher() {
        nationalCodeCheck = checkNationalCode(DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue());
        if (nationalCodeCheck === false || cellPhoneCheck === false || mailCheck === false || persianDateCheck === false) {
            if(nationalCodeCheck == false)
                DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
            return;
        }
        vm.validate();
        if (vm.hasErrors()) {
            return;
        }
        var nCode = DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue();
        DynamicForm_BasicInfo_JspTeacher.getField("teacherCode").setValue(nCode);

        if (selected_record != null) {
            DynamicForm_BasicInfo_JspTeacher.getField("personality.id").setValue(selected_record.personality.id);
            if (selected_record.personality.contactInfo != null && selected_record.personality.contactInfo.homeAddress != undefined)
                DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.id").setValue(selected_record.personality.contactInfo.homeAddress.id);
            if (selected_record.personality.contactInfo != null && selected_record.personality.contactInfo.workAddress != undefined)
                DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.id").setValue(selected_record.personality.contactInfo.workAddress.id);
            if (selected_record.personality.accountInfo != undefined)
                DynamicForm_AccountInfo_JspTeacher.getField("personality.accountInfo.id").setValue(selected_record.personality.accountInfo.id);
        }

        var data = vm.getValues();
        var teacherSaveUrl = teacherUrl;
        teacherWait = createDialog("wait");
        if (teacherMethod.localeCompare("PUT") === 0) {
            teacherSaveUrl += selectedRecordID;
            isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data),
                "callback: teacher_save_edit_result(rpcResponse)"));
        }

        if (teacherMethod.localeCompare("POST") === 0)
            isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data),
                "callback: teacher_save_add_result(rpcResponse)"));
    }

    function Teacher_Save_Close_Button_Click_JspTeacher() {
        nationalCodeCheck = checkNationalCode(DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue());
        if (nationalCodeCheck === false || cellPhoneCheck === false || mailCheck === false || persianDateCheck === false) {
            if(nationalCodeCheck == false)
                DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
            return;
        }
        vm.validate();
        if (vm.hasErrors()) {
            return;
        }
        var nCode = DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue();
        DynamicForm_BasicInfo_JspTeacher.getField("teacherCode").setValue(nCode);

        if (selected_record != null) {
            DynamicForm_BasicInfo_JspTeacher.getField("personality.id").setValue(selected_record.personality.id);
            if (selected_record.personality.contactInfo.homeAddress != undefined)
                DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.id").setValue(selected_record.personality.contactInfo.homeAddress.id);
            if (selected_record.personality.contactInfo.workAddress != undefined)
                DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.id").setValue(selected_record.personality.contactInfo.workAddress.id);
            if (selected_record.personality.accountInfo != undefined)
                DynamicForm_AccountInfo_JspTeacher.getField("personality.accountInfo.id").setValue(selected_record.personality.accountInfo.id);
        }

        var data = vm.getValues();
        var teacherSaveUrl = teacherUrl;

        if (teacherMethod.localeCompare("PUT") === 0) {
            teacherSaveUrl += selectedRecordID;
        }
        teacherWait = createDialog("wait");
        isc.RPCManager.sendRequest(TrDSRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data),
            "callback: teacher_saveClose_result(rpcResponse)"));

    }
    function hiddenVisibilityButtons() {
            HLayOut_TeacherSaveOrExit_JspTeacher.setVisibility(false);
            ToolStrip_Actions_JspAcademicBK.setVisibility(false);
            ToolStrip_Actions_JspTeachingHistory.setVisibility(false);
            ToolStrip_Actions_JspTeacherCertification.setVisibility(false);
            ToolStrip_Actions_JspPublication.setVisibility(false);
            ToolStrip_Actions_JspForeignLangKnowledge.setVisibility(false);
            ToolStrip_Actions_JspEmploymentHistory.setVisibility(false);
            DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;
    }
    function ListGrid_teacher_edit(teacherRecordId = null,tab) {
        editTeacherMode = true;
        tab_selected=tab
        // console.log(teacherRecordId)
        selected_teacher = teacherRecordId;
        // console.log(selected_teacher)
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        selected_record = record;
        if ((record == null || record.id == null) && (selected_teacher == null || selected_teacher == undefined)) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "info/" + (selected_teacher ? selected_teacher : record.id), "GET", null,
            "callback: teacher_get_one_result(rpcResponse)"));
    }

    function  Edit_teacher() {
        showAttachViewLoader.setView();
        showAttachViewLoader.show();
        showAttach(selected_record.personalityId);
        vm.clearValues();
        vm.clearErrors(true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
        DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

        teacherMethod = "PUT";

        var clonedRecord = Object.assign({}, selected_record);
        clonedRecord.categories = null;
        clonedRecord.subCategories = null;

        vm.editRecord(clonedRecord);

        var categoryIds = selected_record.categories;
        var subCategoryIds =selected_record.subCategories;
        if (categoryIds == null || categoryIds.length === 0)
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").disable();
        else {
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").enable();
            var catIds = [];
            for (let i = 0; i < categoryIds.length; i++)
                catIds.add(categoryIds[i].id);
            DynamicForm_BasicInfo_JspTeacher.getField("categories").setValue(catIds);
            hasTeacherCategoriesChanged = true;
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").focus(null, null);
        }
        if (subCategoryIds != null && subCategoryIds.length > 0) {
            var subCatIds = [];
            for (let i = 0; i < subCategoryIds.length; i++)
                subCatIds.add(subCategoryIds[i].id);
            DynamicForm_BasicInfo_JspTeacher.getField("subCategories").setValue(subCatIds);
        }

        if(DynamicForm_BasicInfo_JspTeacher.getField("majorCategoryId").getValue() != null && DynamicForm_BasicInfo_JspTeacher.getField("majorCategoryId").getValue() != undefined){
            var catId = DynamicForm_BasicInfo_JspTeacher.getField("majorCategoryId").getValue();
            DynamicForm_BasicInfo_JspTeacher.getField("majorSubCategoryId").enable();
            RestDataSource_SubCategory_Evaluation_JspTeacher.implicitCriteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "categoryId", operator: "inSet", value: catId}]
            };
            DynamicForm_BasicInfo_JspTeacher.getField("majorSubCategoryId").fetchData();
        }

        var eduMajorValue = selected_record.personality.educationMajorId;
        var eduOrientationValue = selected_record.personality.educationOrientationId;
        var eduLevelValue = selected_record.personality.educationLevelId;

        if (eduMajorValue != undefined && eduLevelValue != undefined) {
            RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationOrientationUrl +
                "spec-list-by-levelId-and-majorId/" + eduLevelValue + ":" + eduMajorValue;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
        } else if (eduMajorValue !== undefined && eduLevelValue == undefined) {
            RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationMajorUrlUrl +
                "spec-list-by-majorId/" + eduMajorValue;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
            DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
        }
        if (eduOrientationValue === undefined && eduMajorValue === undefined) {
            DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        }

        var stateValue_home = undefined;
        var cityValue_home = undefined;
        var stateValue_work = undefined;
        var cityValue_work = undefined;

        var HAOCEnable = false;
        if (selected_record.personality.contactInfo !== undefined) {
            if (selected_record.personality.contactInfo.homeAddress !== undefined) {
                if (selected_record.personality.contactInfo.homeAddress.stateId !== undefined)
                    stateValue_home = selected_record.personality.contactInfo.homeAddress.stateId;
                if (selected_record.personality.contactInfo.homeAddress.cityId !== undefined)
                    cityValue_home = selected_record.personality.contactInfo.homeAddress.cityId;
                if (selected_record.personality.contactInfo.homeAddress.otherCountry !== undefined)
                    HAOCEnable = selected_record.personality.contactInfo.homeAddress.otherCountry;
            }
        }

        if (cityValue_home === undefined) {
            DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
        }
        if (stateValue_home !== undefined) {
            RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_home;
            DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
            DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
        }

        var WAOCEnable = false;
        if (selected_record.personality.contactInfo !== undefined) {
            if (selected_record.personality.contactInfo.workAddress !== undefined) {
                if (selected_record.personality.contactInfo.workAddress.stateId !== undefined)
                    stateValue_work = selected_record.personality.contactInfo.workAddress.stateId;
                if (selected_record.personality.contactInfo.workAddress.cityId !== undefined)
                    cityValue_work = selected_record.personality.contactInfo.workAddress.cityId;
                if (selected_record.personality.contactInfo.workAddress.otherCountry !== undefined)
                    WAOCEnable = selected_record.personality.contactInfo.workAddress.otherCountry;
            }
        }
        if (cityValue_work === undefined) {
            DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
        }
        if (stateValue_work !== undefined) {
            RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_work;
            DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
            DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
        }

        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.cityId", HAOCEnable);
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.stateId", HAOCEnable);

        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.cityId", WAOCEnable);
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.stateId", WAOCEnable);


        if(selected_record.personnelStatus == true){
            DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = true;
            DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").enable();
            DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;
            DynamicForm_BasicInfo_JspTeacher.getField("updatePersonnelInfo").enable();
            DynamicForm_BasicInfo_JspTeacher.getItem("personnelCode").setRequired(true);
        }
        else if(selected_record.personnelStatus == false){
            DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").enable();
            DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disabled = true;
            DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;
            DynamicForm_BasicInfo_JspTeacher.getField("updatePersonnelInfo").disabled = true;
            DynamicForm_BasicInfo_JspTeacher.getItem("personnelCode").setRequired(false);
        }
        if (!loadjs.isDefined('load_Attachments_Teacher')) {
            loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_Teacher');
        }

        loadjs.ready('load_Attachments_Teacher', function () {
            setTimeout(()=> {
                oLoadAttachments_Teacher = new loadAttachments();
                TabSet_Bottom_JspTeacher.updateTab(TeacherAttachmentsTab, oLoadAttachments_Teacher.VLayout_Body_JspAttachment);
                if(tab_selected==="class") {
                    oLoadAttachments_Teacher.ToolStrip_Actions_JspAttachment.setVisibility(false);
                }
                clearTabFilters(oLoadAttachments_Teacher);
            },0);

        });
        selectedRecordID = ListGrid_Teacher_JspTeacher.getSelectedRecord() ? ListGrid_Teacher_JspTeacher.getSelectedRecord().id : selected_teacher;
        loadPage_AcademicBK(selectedRecordID);

        DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();
        TabSet_Bottom_JspTeacher.show();
        TabSet_Bottom_JspTeacher.selectTab(0);
        if(tab_selected==="class") {
            hiddenVisibilityButtons();
        }
    }

    function ListGrid_teacher_add() {
        ListGrid_Teacher_JspTeacher.invalidateCache();
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValues();
        vm.clearErrors(true);
        showAttachViewLoader.show();
        showAttachViewLoader.setView();
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").enable();
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.stateId").enable();
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").enable();
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").enable();

        teacherMethod = "POST";
        // vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").enable();
        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disabled = true;
        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").enable();
        DynamicForm_BasicInfo_JspTeacher.getField("updatePersonnelInfo").disabled = true;
        DynamicForm_BasicInfo_JspTeacher.getItem("personnelCode").setRequired(false);
        TabSet_Bottom_JspTeacher.hide();
        clearTabFilters();
        DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();
    }

    function ListGrid_teacher_remove() {
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        teacherWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + record.id, "DELETE", null,
                            "callback: teacher_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function addAttach(personalId) {
        if (isFileAttached) {
            var formData1 = new FormData();
            var fileBrowserId = document.getElementById('file-upload');
            var file = fileBrowserId.files[0];
            formData1.append("file", file);
            selectedRecordPersonalID = personalId;
            isFileAttached = false;
            if (file !== undefined) {
                isc.RPCManager.sendRequest(TrDSRequest(getFmsConfig, "Get",  null, function (resp) {
                    let data= JSON.parse(resp.data)
                    MinIoUploadHttpRequest(formData1, data.url, data.groupId, personalInfo_showTempAttach_result);

                }));
                // TrnXmlHttpRequest(formData1, personalInfoUrl + "addAttach/" + personalId, "POST", personalInfo_addAttach_result);
            }
        }
    }

    function personalInfo_addAttach_result(req) {
        attachName = req.response;
        showAttach(selectedRecordPersonalID);
    }

    function showTempAttach() {
        if (isFileAttached) {
            var formData1 = new FormData();
            var fileBrowserId = document.getElementById('file-upload');
            var file = fileBrowserId.files[0];
            formData1.append("file", file);
            isFileAttached = false;
            if (file.size > 30000000) {
                createDialog("info", "<spring:message code="file.size.hint"/>", "<spring:message code='error'/>");
        } else {
                isc.RPCManager.sendRequest(TrDSRequest(getFmsConfig, "Get",  null, function (resp) {
                    let data= JSON.parse(resp.data)
                    MinIoUploadHttpRequest(formData1, data.url, data.groupId, personalInfo_showTempAttach_result);

                }));
            // TrnXmlHttpRequest(formData1, personalInfoUrl + "addTempAttach", "POST", personalInfo_showTempAttach_result)
        }
        }
    }

    function personalInfo_showTempAttach_result(req) {
        if (req.status === 200) {
            isFileAttached = true;
            attachNameTemp = req.response;
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getTempAttach/"/>" + attachNameTemp);
            showAttachViewLoader.show();
        } else if (req.status === 406) {
            if (req.response === "wrong size")
                createDialog("info", "<spring:message code="file.size.hint"/>", "<spring:message code='error'/>");
            else if (req.response === "wrong dimension")
                createDialog("info", "<spring:message code="photo.dimension.hint"/>", "<spring:message code='error'/>");
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function teacher_delete_result(resp) {
        teacherWait.close();
        if (resp.httpResponseCode === 200 && resp.httpResponseText == "ok") {
            var OK = createDialog("info", "<spring:message code='msg.record.remove.successful'/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            // refreshSelectedTab_teacher(null);
            ListGrid_teacher_refresh();
        } else if (resp.httpResponseText === "personalFail") {
            createDialog("info", "<spring:message code='teacher.delete.personal.fail.message'/>");
        } else{
            var msg = getFormulaMessage(resp.httpResponseText, 2, "red", null);
            createDialog("info", "این مدرس بعلت استفاده در کلاس"+ " " + msg + " " +
                "قابل حذف نمی باشد");
        }
    }

    function teacher_saveClose_result(resp) {
        teacherWait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            if (resp.data === "") {
                createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
            } else {
                responseID = JSON.parse(resp.data).id;
                var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>");
                addAttach(JSON.parse(resp.data).personality.id);
                showAttachViewLoader.hide();
            }
        } else if (resp.httpResponseText == "duplicateAndBlackList") {
            createDialog("info", "<spring:message code='teacher.duplicate.and.in.black.list'/>");
        } else if (resp.httpResponseText == "duplicateAndNotBlackList") {
            createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
        }
        Window_Teacher_JspTeacher.close();
        ListGrid_teacher_refresh();
    }

    function teacher_save_add_result(resp) {
        teacherWait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            responseID = JSON.parse(resp.data).id;
            vm.setValue("id", responseID);
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>");
            addAttach(JSON.parse(resp.data).personality.id);
            selectedRecordID = responseID;
            selected_record = JSON.parse(resp.data);
            loadPage_AcademicBK(responseID);
            TabSet_Bottom_JspTeacher.show();
            TabSet_Bottom_JspTeacher.selectTab(0);
            TabSet_Bottom_JspTeacher.disable();
            setTimeout(function () {
                TabSet_Bottom_JspTeacher.enable();
            }, 300);
            if(selected_record.personnelStatus == true){
                DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = true;
                DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").enable();
                DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;
                DynamicForm_BasicInfo_JspTeacher.getField("updatePersonnelInfo").enable();
                DynamicForm_BasicInfo_JspTeacher.getItem("personnelCode").setRequired(true);
            }
            else if(selected_record.personnelStatus == false){
                DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").enable();
                DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disabled = true;
                DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").disabled = true;
                DynamicForm_BasicInfo_JspTeacher.getField("updatePersonnelInfo").disabled = true;
                DynamicForm_BasicInfo_JspTeacher.getItem("personnelCode").setRequired(false);
            }
            DynamicForm_BasicInfo_JspTeacher.getField("personality.id").setValue(selected_record.personality.id);
            if(selected_record.personality.contactInfo.homeAddress != undefined)
                DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.id").setValue(selected_record.personality.contactInfo.homeAddress.id);
            if(selected_record.personality.contactInfo.workAddress != undefined)
                DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.id").setValue(selected_record.personality.contactInfo.workAddress.id);
            if(selected_record.personality.accountInfo != undefined)
                DynamicForm_AccountInfo_JspTeacher.getField("personality.accountInfo.id").setValue(selected_record.personality.accountInfo.id);
            teacherMethod = "PUT";
        } else if (resp.httpResponseText == "duplicateAndBlackList") {
            createDialog("info", "<spring:message code='teacher.duplicate.and.in.black.list'/>");
        } else if (resp.httpResponseText == "duplicateAndNotBlackList") {
            createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
        }
    }

    function teacher_save_edit_result(resp) {
        teacherWait.close();
        if (resp.httpResponseText == "duplicateAndBlackList") {
            createDialog("info", "<spring:message code='teacher.duplicate.and.in.black.list'/>");
        } else if (resp.httpResponseText == "duplicateAndNotBlackList") {
            createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
        }
        else if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            if (resp.data === "") {
                createDialog("info", "<spring:message code='msg.national.code.duplicate'/>");
            } else {
                responseID = JSON.parse(resp.data).id;
                var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>");
                addAttach(JSON.parse(resp.data).personality.id);
                showAttach(JSON.parse(resp.data).personality.id);
                showAttachViewLoader.hide();
            }
        }
    }

    function teacher_get_one_result(rpcResponse) {
        selected_record = JSON.parse(rpcResponse.data);
        Edit_teacher();
    }

    function checkEmail(email) {
        if (email == null || email == "")
            return true;
        else
            return !(email.indexOf("@") === -1 || email.indexOf(".") === -1 || email.lastIndexOf(".") < email.indexOf("@"));
    }

    function checkMobile(mobile) {
        if (mobile == null || mobile == "")
            return true;
        else
            return mobile[0] === "0" && mobile[1] === "9" && mobile.length === 11;
    }

    function fillPersonalInfoFields(nationalCode,internalTeacher,personnelCode) {
        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "getOneByNationalCode/" + nationalCode, "GET", null,(resp) => {
                if (resp !== null && resp !== undefined && resp.data !== "") {
                    vm.clearValues();
                    var personality = JSON.parse(resp.data);
                    showAttach(personality.id);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationalCode", personality.nationalCode);
                    DynamicForm_BasicInfo_JspTeacher.setValue("teacherCode", personality.nationalCode);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.id", personality.id);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personality.firstNameFa);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameFa", personality.lastNameFa);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameEn", personality.firstNameEn);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameEn", personality.lastNameEn);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.fatherName", personality.fatherName);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthDate", personality.birthDate);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthLocation", personality.birthLocation);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificate", personality.birthCertificate);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificateLocation", personality.birthCertificateLocation);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationality", personality.nationality);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.description", personality.description);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", personality.genderId);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", personality.marriedId);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", personality.militaryId);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationLevelId", personality.educationLevelId);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationMajorId", personality.educationMajorId);
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationOrientationId", personality.educationOrientationId);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.jobTitle", personality.jobTitle);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.jobLocation", personality.jobLocation);
                    DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");


                    if (personality.contactInfo !== null && personality.contactInfo !== undefined) {
                        DynamicForm_BasicInfo_JspTeacher.setValue("personality.contactInfo.mobile", personality.contactInfo.mobile);
                        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.email", personality.contactInfo.email);
                        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.personalWebSite", personality.contactInfo.personalWebSite);

                        if (personality.contactInfo.workAddress !== null && personality.contactInfo.workAddress !== undefined) {
                            setWorkAddressFields(personality.contactInfo.workAddress);
                        }
                        if (personality.contactInfo.homeAddress !== null && personality.contactInfo.homeAddress !== undefined) {
                            setHomeAddressFields(personality.contactInfo.homeAddress);
                        }
                    }

                    if (personality.accountInfo !== null && personality.accountInfo !== undefined) {
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.id", personality.accountInfo.id);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.accountNumber", personality.accountInfo.accountNumber);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bank", personality.accountInfo.bank);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bankBranch", personality.accountInfo.bankBranch);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bankBranchCode", personality.accountInfo.bankBranchCode);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.cartNumber", personality.accountInfo.cartNumber);
                        DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.shabaNumber", personality.accountInfo.shabaNumber);
                    }
                    if(internalTeacher == true){
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").setValue(personnelCode);
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("true");
                    }
                }

        }));
    }

    function fillPersonalInfoByPersonnelNumber(personnelCode) {
        isc.RPCManager.sendRequest(TrDSRequest(viewActivePersonnelUrl + "/byPersonnelCode/" + personnelCode, "GET", null,
            "callback: personnel_findOne_result(rpcResponse)"));
    }

    // function  fillPersonalInfoByNationalCode(nationalCode){
    //     isc.RPCManager.sendRequest(TrDSRequest(viewActivePersonnelUrl + "/byNationalCode/" + nationalCode, "GET", null,
    //         "callback: personnel_findOne_result(rpcResponse)"));
    // }

    function fillWorkAddressFields(postalCode) {
        if (postalCode !== undefined)
            isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,
                "callback: workAddress_findOne_result(rpcResponse)"));
    }

    function fillHomeAddressFields(postalCode) {
        if (postalCode !== undefined)
            isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,
                "callback: homeAddress_findOne_result(rpcResponse)"));
    }

    function showAttach(pId) {
        selectedRecordPersonalID = pId;
        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "checkAttach/" + pId, "GET", null,
            "callback: personalInfo_checkAttach_result(rpcResponse)"));
    }

    function personalInfo_checkAttach_result(resp) {
        if (resp.data === "true") {
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getAttach/"/>" + selectedRecordPersonalID);
            showAttachViewLoader.show();
        } else if (resp.data === "false") {
            showAttachViewLoader.setView();
            showAttachViewLoader.show();
        }
    }

    function set_city_state(dForm, fItem, value) {
        if (value === true) {
            dForm.clearValue(fItem.toString());
            dForm.getItem(fItem.toString()).disable();
        } else {
            dForm.getItem(fItem.toString()).enable();
        }
    }

    function workAddress_findOne_result(resp) {
        if (resp === null || resp === undefined || resp.data === "") {
            return null;
        }
        setWorkAddressFields(JSON.parse(resp.data));
    }

    function homeAddress_findOne_result(resp) {
        if (resp === null || resp === undefined || resp.data === "") {
            return null;
        }
        setHomeAddressFields(JSON.parse(resp.data));
    }

    function setWorkAddressFields(workAddress) {
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.restAddr", workAddress.restAddr);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.postalCode", workAddress.postalCode);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.id", workAddress.id);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.phone", workAddress.phone);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.fax", workAddress.fax);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.webSite", workAddress.webSite);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.otherCountry", workAddress.otherCountry);
        DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.stateId", workAddress.stateId);
        var OCEnable = (workAddress.otherCountry !== undefined) ? workAddress.otherCountry : false;
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.cityId", OCEnable);
        set_city_state(DynamicForm_JobInfo_JspTeacher,
            "personality.contactInfo.workAddress.stateId", OCEnable);
        if (workAddress.city !== undefined)
            DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.cityId", workAddress.cityId);
        else
            DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
    }

    function setHomeAddressFields(homeAddress) {
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.restAddr", homeAddress.restAddr);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.id", homeAddress.id);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.postalCode", homeAddress.postalCode);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.phone", homeAddress.phone);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.fax", homeAddress.fax);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.otherCountry", homeAddress.otherCountry);
        DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.stateId", homeAddress.stateId);
        var OCEnable = (homeAddress.otherCountry !== undefined) ? homeAddress.otherCountry : false;
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.cityId", OCEnable);
        set_city_state(DynamicForm_AddressInfo_JspTeacher,
            "personality.contactInfo.homeAddress.stateId", OCEnable);
        if (homeAddress.city !== undefined)
            DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.cityId", homeAddress.cityId);
        else
            DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
    }

    function personnel_findOne_result(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            vm.clearValues();
            var personnel = JSON.parse(resp.data);
            if (personnel.firstName != undefined && personnel.firstName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personnel.firstName);
            if (personnel.lastName != undefined && personnel.lastName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameFa", personnel.lastName);
            if (personnel.nationalCode != undefined && personnel.nationalCode != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationalCode", personnel.nationalCode);
            if (personnel.fatherName != undefined && personnel.fatherName != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.fatherName", personnel.fatherName);
            if (personnel.nationalCode != undefined && personnel.nationalCode != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("teacherCode", personnel.nationalCode);
            if (personnel.personnelNo != undefined && personnel.personnelNo != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personnelCode", personnel.personnelNo);
            if (personnel.birthDate != undefined && personnel.birthDate != null){
                let year = personnel.birthDate.substring(0,4);
                let month = personnel.birthDate.substring(5,7);
                let day = personnel.birthDate.substring(8,10);
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthDate", JalaliDate.gregorianToJalali(year,month,day));
            }
            if (personnel.birthCertificateNo != undefined && personnel.birthCertificateNo != null)
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificate", personnel.birthCertificateNo);
            if (personnel.jobTitle != undefined && personnel.jobTitle != null)
                DynamicForm_JobInfo_JspTeacher.setValue("personality.jobTitle", personnel.jobTitle);
            if (personnel.gender != undefined && personnel.gender != null) {
                if (personnel.gender == "زن")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", 2);
                if (personnel.gender == "مرد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.genderId", 1);
            }
            if (personnel.militaryStatus != undefined && personnel.militaryStatus != null) {
                if (personnel.militaryStatus == "معاف")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 2);
                if (personnel.militaryStatus == "معافیت مازاد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 2);
                if (personnel.militaryStatus == "پایان خدمت")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.militaryId", 1);
            }
            if (personnel.maritalStatusTitle != undefined && personnel.maritalStatusTitle != null) {
                if (personnel.maritalStatusTitle == "متاهل")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", 1);
                if (personnel.maritalStatusTitle == "مجرد")
                    DynamicForm_BasicInfo_JspTeacher.setValue("personality.marriedId", 2);
            }
            if (personnel.companyName != undefined && personnel.companyName != null)
                DynamicForm_JobInfo_JspTeacher.setValue("personality.jobLocation", personnel.companyName);
            var ccp_affairs = "";
            var ccp_section = "";
            var ccp_unit = "";
            if (personnel.ccpAffairs != undefined && personnel.ccpAffairs != null)
                ccp_affairs = personnel.ccpAffairs;
            if (personnel.ccpSection != undefined && personnel.ccpSection != null)
                ccp_section = personnel.ccpSection;
            if (personnel.ccpUnit != undefined && personnel.ccpUnit != null)
                ccp_unit = personnel.ccpUnit;
            var restAddress = ccp_affairs + "," + ccp_section + "," + ccp_unit;
            if (restAddress != "")
                DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.restAddr", restAddress);
        }
        DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");
        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("true");
    }

    function clearTabFilters(oLoadAttachments_Teacher) {
        ListGrid_JspAcademicBK.clearFilterValues();
        ListGrid_JspInternalTeachingHistory.clearFilterValues();
        ListGrid_JspEmploymentHistory.clearFilterValues();
        ListGrid_JspTeachingHistory.clearFilterValues();
        ListGrid_JspTeacherCertification.clearFilterValues();
        ListGrid_JspPublication.clearFilterValues();
        ListGrid_JspForeignLangKnowledge.clearFilterValues();
        // setTimeout(()=> {
        if(oLoadAttachments_Teacher)
        oLoadAttachments_Teacher.ListGrid_JspAttachment.clearFilterValues();
        // },0);
        ListGrid_JspAcademicBK.filterByEditor();
        ListGrid_JspEmploymentHistory.filterByEditor();
        ListGrid_JspTeachingHistory.filterByEditor();
        ListGrid_JspTeacherCertification.filterByEditor();
        ListGrid_JspPublication.filterByEditor();
        ListGrid_JspForeignLangKnowledge.filterByEditor();
        if(oLoadAttachments_Teacher)
        oLoadAttachments_Teacher.ListGrid_JspAttachment.filterByEditor();
        ListGrid_JspInternalTeachingHistory.filterByEditor();

    }

    // </script>
