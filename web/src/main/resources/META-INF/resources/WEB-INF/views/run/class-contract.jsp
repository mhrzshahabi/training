<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>


    // ------------------------------------------- createWindow -------------------------------------------

    CompanyDS_ClassContract = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyId", title: "<spring:message code="company.id"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "economicalId", title: "<spring:message code="company.economical.id"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "registerId", title: "<spring:message code="company.register.id"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        fetchDataURL: companyUrl + "spec-list"
    });

    ContractDF_ClassContract = isc.DynamicForm.create({
        width: "100%",
        align: "center",
        isGroup: true,
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        // valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 6,
        titleAlign: "left",
        <%--requiredMessage: "<spring:message code='msg.field.is.required'/>",--%>
        margin: 2,
        newPadding: 5,
        fields:[
            {
                name: "contractNumber",
                title: "شماره قرارداد",
                colSpan: 2,
                width: "*",
                disabled: true
            },
            {
                name: "date",
                ID: "contractDate_ClassContract",
                title: "<spring:message code='date'/>",
                width: "*",
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                colSpan: 2,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('contractDate_ClassContract', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            // {
            //     name: "firstPartyCompany.id",
            //     title: "شرکت طرف اول قرارداد",
            //     type: "selectItem",
            //     textAlign: "center",
            //     optionDataSource: RestDataSource_Category_JspEmploymentHistory,
            //     valueField: "id",
            //     displayField: "titleFa",
            //     filterFields: ["titleFa"],
            //     multiple: true,
            //     required: true,
            //     pickListProperties: {
            //         showFilterEditor: true,
            //         filterOperator: "iContains",
            //     },
            //     changed: function () {
            //         isCategoriesChanged = true;
            //         var subCategoryField = DynamicForm_JspEmploymentHistory.getField("subCategories");
            //         if (this.getSelectedRecords() == null) {
            //             subCategoryField.clearValue();
            //             subCategoryField.disable();
            //             return;
            //         }
            //         subCategoryField.enable();
            //         if (subCategoryField.getValue() === undefined)
            //             return;
            //         var subCategories = subCategoryField.getSelectedRecords();
            //         var categoryIds = this.getValue();
            //         var SubCats = [];
            //         for (var i = 0; i < subCategories.length; i++) {
            //             if (categoryIds.contains(subCategories[i].categoryId))
            //                 SubCats.add(subCategories[i].id);
            //         }
            //         subCategoryField.setValue(SubCats);
            //         subCategoryField.focus(this.form, subCategoryField);
            //     }
            // },







            // {
            //     name: "evaluationCategory",
            //     title: " حداقل نمره ی ارزیابی استاد در گروه",
            //     textAlign: "center",
            //     width: "*",
            //     editorType: "ComboBoxItem",
            //     defaultValue: null,
            //     changeOnKeypress: true,
            //     prompt: "در صورت انتخاب گروه زیرگروه هم باید انتخاب شود",
            //     displayField: "titleFa",
            //     valueField: "id",
            //     optionDataSource: RestDataSource_Category_Evaluation_JspTeacherReport,
            //     autoFetchData: false,
            //     addUnknownValues: false,
            //     cachePickListResults: false,
            //     useClientFiltering: true,
            //     filterFields: ["titleFa"],
            //     sortField: ["id"],
            //     textMatchStyle: "startsWith",
            //     generateExactMatchCriteria: true,
            //     pickListProperties: {
            //         showFilterEditor: true
            //     },
            //     pickListFields: [
            //         {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            //     changed: function (form,item,value) {
            //         isEvaluationCategoriesChanged = true;
            //
            //         if (value == null || value == undefined) {
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").disable();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").clearValue();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").clearValue();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").disable();
            //         } else{
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").enable();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").enable();
            //         }
            //     }
            // },
            // {
            //     name: "evaluationSubCategory",
            //     title: "و زیرگروه",
            //     textAlign: "center",
            //     width: "*",
            //     titleAlign: "center",
            //     editorType: "ComboBoxItem",
            //     changeOnKeypress: true,
            //     defaultValue: null,
            //     displayField: "titleFa",
            //     valueField: "id",
            //     disabled: true,
            //     optionDataSource: RestDataSource_SubCategory_Evaluation_JspTeacherReport,
            //     autoFetchData: false,
            //     addUnknownValues: false,
            //     cachePickListResults: false,
            //     useClientFiltering: true,
            //     filterFields: ["titleFa"],
            //     sortField: ["id"],
            //     textMatchStyle: "startsWith",
            //     generateExactMatchCriteria: true,
            //     pickListProperties: {
            //         showFilterEditor: true
            //     },
            //     pickListFields: [
            //         {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            //     focus: function () {
            //         if (isEvaluationCategoriesChanged) {
            //             isEvaluationCategoriesChanged = false;
            //             var id = DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getValue();
            //             if (id == null || id == undefined) {
            //                 RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = null;
            //             } else {
            //                 RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = {
            //                     _constructor: "AdvancedCriteria",
            //                     operator: "and",
            //                     criteria: [{fieldName: "categoryId", operator: "inSet", value: id}]
            //                 };
            //             }
            //             this.fetchData();
            //         }
            //     }
            // },
        ]
    });

    Create_Window_ClassContract = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='create'/>",
        items: [isc.TrVLayout.create({
            members: [ContractDF_ClassContract]
        })]
    });

    // ------------------------------------------- Menu -------------------------------------------
    Menu_ClassContract = isc.Menu.create({
        data: [{title: "<spring:message code="refresh"/>", click: function () {refreshLG(ContractLG_ClassContract);}},]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    TS_ClassContract = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({click: function () {CreateBtn_ClassContract()}}),
            isc.ToolStripButtonEdit.create({click: function () {}}),
            isc.ToolStripButtonRemove.create({click: function () {}}),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({click: function () {refreshLG(ContractLG_ClassContract);}})
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ContractDS_ClassContract = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "contractNumber", title: "شماره", filterOperator: "iContains", autoFitWidth: true},
            {name: "date", title: "تاریخ", filterOperator: "iContains", autoFitWidth: true},
            {name: "isSigned", title: "امضا شده", filterOperator: "iContains", autoFitWidth: true},
            {name: "accountable", title: "امضا کننده", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyInstitute.titleFa", title: "نام", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyInstitute.instituteId", title: "شماره ملی", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyPerson.firstNameFa", title: "نام", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyPerson.lastNameFa", title: "نام خانوادگی", filterOperator: "iContains", autoFitWidth: true},
            {name: "secondPartyPerson.nationalCode", title: "شماره ملی", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: classContractUrl + "/iscList"
    });

    ContractLG_ClassContract = isc.TrLG.create({
        dataSource: ContractDS_ClassContract,
        gridComponents: [TS_ClassContract, "filterEditor", "header", "body",],
        contextMenu: Menu_ClassContract,
        headerHeight: 45,
        autoFetchData: true,
        fields: [
            {name: "contractNumber"},
            {name: "date"},
            {name: "isSigned"},
            {name: "secondPartyInstitute.titleFa"},
            {name: "secondPartyInstitute.instituteId"},
            {name: "secondPartyPerson.firstNameFa"},
            {name: "secondPartyPerson.lastNameFa"},
            {name: "secondPartyPerson.nationalCode"},
        ],
        headerSpans: [
            {
                fields: ["secondPartyInstitute.titleFa", "secondPartyInstitute.instituteId"],
                title: "موسسه آموزشی طرف قرارداد"
            },
            {
                fields: ["secondPartyPerson.firstNameFa", "secondPartyPerson.lastNameFa", "secondPartyPerson.nationalCode"],
                title: "مدرس طرف قرارداد"
            },
            {
                fields: ["contractNumber", "date", "isSigned"],
                title: "مشخصات قرارداد"
            }
        ]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ContractLG_ClassContract],
    });

    // ------------------------------------------- Functions -------------------------------------------

    function CreateBtn_ClassContract() {
        Create_Window_ClassContract.show();
        // methodEducation = "POST";
        // saveActionUrlEducation = Url;
        // EducationDynamicForm.clearValues();
        // EducationWindows.setTitle(title);
        // EducationWindows.show();
    }

    function createContract() {

    }

    // </script>