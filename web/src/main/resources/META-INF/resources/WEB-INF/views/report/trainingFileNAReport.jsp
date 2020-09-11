<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='personnelNo']").attr("disabled","disabled");
        },0)}
    );

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_eTechnicalType = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTechnicalType/spec-list",
    });
    let RestDataSource_PersonnelDurationNa = isc.TrDS.create({
        fields: [
            {name: "personnelId", primaryKey: true, hidden:true},
            {name: "duration", title:"جمع کل"},
            {name: "passed", title:"جمع گذرانده"},
            {name: "essential", title:"جمع عملکردی ضروری"},
            {name: "essentialPassed", title:"گذرانده عملکردی ضروری"},
            {name: "improving", title:"جمع عملکردی بهبود"},
            {name: "improvingPassed", title:"گذرانده عملکردی بهبود"},
            {name: "developmental", title:"جمع عملکردی توسعه ای"},
            {name: "developmentalPassed", title:"گذرانده عملکردی توسعه ای"},
        ],
        fetchDataURL: personnelDurationNAReportUrl,
    });

    let RestDataSource_ScoreState = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        cacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/StudentScoreState"
    });

    let RestDataSource_PriorityId = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    let RestDataSource_Personnel_JspTrainingFileNAReport = isc.TrDS.create({
        fields: [
            {name: "personnelNo", title:"شماره پرسنلی", autoFitWidth: true},
            {name: "firstName", title:"نام", autoFitWidth: true},
            {name: "lastName", title:"نام خانوادگی", autoFitWidth: true},
            // {name: "personnelFullName", title:"نام و نام خانوادگی", autoFitWidth: true},
            {name: "nationalCode", title:"کد ملی", autoFitWidth: true},
            {name: "postTitle", title:"عنوان پست", autoFitWidth: true},
            {name: "postCode", title:"کد پست", autoFitWidth: true},
            {name: "companyName", title:"شرکت", autoFitWidth: true},
            {name: "personnelNo2", title:"پرسنلی 6 رقمی", autoFitWidth: true},
            {name: "ccpArea", title:"<spring:message code='area'/>", autoFitWidth: true},
            {name: "ccpAssistant", title:"معاونت", autoFitWidth: true},
            {name: "ccpAffairs", title:"امور", autoFitWidth: true},
            {name: "ccpUnit", title:"<spring:message code='unit'/>", autoFitWidth: true},
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList"
    });
    let RestDataSource_TrainingFile_JspTrainingFileNAReport = isc.TrDS.create({
        fields: [
            {name: "courseId", autoFitWidth: true},
            {name: "courseCode", title:"کد دوره", autoFitWidth: true},
            {name: "courseTitleFa", title:"نام دوره", autoFitWidth: true},
            {name: "theoryDuration", title:"مدت دوره", autoFitWidth: true},
            {name: "technicalType", title:"نوع تخصصی", autoFitWidth: true, optionDataSource: RestDataSource_eTechnicalType, displayField: "titleFa", valueField:"id"},

            {name: "skillId", autoFitWidth: true},
            {name: "skillCode", title:"کد مهارت", autoFitWidth: true},
            {name: "skillTitleFa", title:"نام مهارت", autoFitWidth: true},
            {name: "priorityId", title:"اولویت", autoFitWidth: true, optionDataSource: RestDataSource_PriorityId, displayField: "title", valueField:"id"},
            {name: "isInNA", title:"نیازسنجی", autoFitWidth: true, type:"boolean"},

            {name: "classId", autoFitWidth: true},
            {name: "classCode", title:"کد کلاس", autoFitWidth: true},
            {name: "classStartDate", title:"شروع کلاس", autoFitWidth: true},
            {name: "classEndDate", title:"پایان کلاس", autoFitWidth: true},
            {name: "location", title:"محل برگزاری", autoFitWidth: true},
            {name: "score", title:"نمره", autoFitWidth: true},
            {name: "scoreStateId", title:"وضعیت نمره", autoFitWidth: true, optionDataSource: RestDataSource_ScoreState, displayField: "title", valueField:"id"},
        ],
        fetchDataURL: trainingFileNAReportUrl
    });

    let PersonnelDS_PTSR_DF = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList",
    });

    let RestDataSource_Course_JspTrainingFileNAReport = isc.TrDS.create({
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    let RestDataSource_Class_JspTrainingFileNAReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    let CourseDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="corse_code"/>"},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    let CompanyDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });
    let AreaDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpArea"
    });
    let AssistantDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });
    let AffairsDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });
    let SectionDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true},
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
    });
    let UnitDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Personnel_JspTrainingFileNAReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_Personnel_JspTrainingFileNAReport,
        cellHeight: 43,
        sortField: 1,
        showFilterEditor: false,
        selectionType: "single",
        showResizeBar: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowClick(record){
            let cr = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "personnelId", operator: "equals", value: record.id}]
            };
            ListGrid_TrainingFile_JspTrainingFileNAReport.setImplicitCriteria(cr);
            ListGrid_TrainingFile_JspTrainingFileNAReport.fetchData(cr);
            detailView.fetchData(cr);
        }
    });
    let ListGrid_TrainingFile_JspTrainingFileNAReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_TrainingFile_JspTrainingFileNAReport,
        cellHeight: 43,
        titleAlign: "center",
        sortField: 1,
        autoFetchData: false,
        // showRowNumbers: false,
        showFilterEditor: false,
        showResizeBar: true,
        selectionType: "single",
        fields:[
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "theoryDuration"},
            {name: "technicalType"},

            {name: "skillCode"},
            {name: "skillTitleFa"},
            {name: "priorityId"},
            {name: "isInNA"},

            {name: "classCode"},
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "location"},
            {name: "score"},
            {name: "scoreStateId"},
        ],
        headerSpans: [
            {
                fields: ["skillCode", "skillTitleFa","priorityId","isInNA"],
                title: "نیازسنجی"
            },
            {
                fields: ["classCode", "classStartDate","classEndDate","location","score","scoreStateId"],
                title: "پرونده آموزشی"
            },
            {
                fields: ["courseCode","courseTitleFa","theoryDuration","technicalType"],
                title: "مشخصات دوره"
            }
        ],
        headerHeight: 60,
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    let IButton_JspTrainingFileNAReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            let cr = ListGrid_Personnel_JspTrainingFileNAReport.getCriteria().criteria
            console.log(cr)
            let strCr=JSON.stringify(cr);
            strCr=strCr.substring(1,strCr.length-1);

/*            isc.RPCManager.sendRequest(TrDSRequest(trainingFileNAReportUrl + "/generate-report?operator=or&_constructor=AdvancedCriteria&criteria=" + strCr, "GET", null,
                "callback: teacher_get_one_result(rpcResponse)"));*/

            let downloadForm = isc.DynamicForm.create({
                method: "GET",
                action: "<spring:url value="/training-file-na-report/generate-report"/>",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "operator", type: "hidden"},
                        {name: "_constructor", type: "hidden"},
                        {name: "criteria", type: "hidden"},
                    ]
            });

            downloadForm.setValue("operator", ListGrid_Personnel_JspTrainingFileNAReport.getCriteria().operator);
            downloadForm.setValue("_constructor", "AdvancedCriteria");
            downloadForm.setValue("criteria", strCr);
            downloadForm.show();
            downloadForm.submitForm();
        }
    });

    let detailView = isc.DetailViewer.create({
        minWidth: 150,
        width: "15%",
        height: "100%",
        autoDraw: false,
        // border: "2px solid black",
        layoutMargin: 5,
        vAlign: "center",
        autoFetchData: false,
        dataSource: RestDataSource_PersonnelDurationNa,
        emptyMessage:"رکورد مرتبطی وجود ندارد",
    });

    let HLayout_CriteriaForm = isc.TrHLayout.create({
        members:[
            ListGrid_TrainingFile_JspTrainingFileNAReport,
            detailView
        ]
    });

    let VLayOut_CriteriaForm_JspTrainingFileNAReport_Details = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_Personnel_JspTrainingFileNAReport,
            HLayout_CriteriaForm
        ]
    });

    let HLayOut_Confirm_JspTrainingFileNAReport_AttendanceExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspTrainingFileNAReport_FullExcel
        ]
    });

    let Window_JspTrainingFileNAReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش مقایسه نیازسنجی با پرونده آموزشی",
        canDragReposition: false,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    VLayOut_CriteriaForm_JspTrainingFileNAReport_Details,HLayOut_Confirm_JspTrainingFileNAReport_AttendanceExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    let DynamicForm_CriteriaForm_JspTrainingFileNAReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            { type:"header", defaultValue:"جستجو:" },
            {
                name: "personnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمائيد",
                showHintInField: true,
                // operator: "inSet",
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspUnitReport.show();
                    }},
                    // {
                    //     src: "[SKIN]/pickers/groupSearch.png",
                    //     prompt: "جستجوی گروهی",
                    //     showPrompt: true,
                    //     // hint: "جستجوی گروهی",
                    //     click: function () {
                    //         alert(2);
                    //     }}
                        ],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp0",
                title: "",
                canEdit: false
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "ccpArea",
                title: "<spring:message code="area"/>",
                optionDataSource: AreaDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "companyName",
                title: "<spring:message code="company"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
            },
            {
                name: "ccpAssistant",
                title: "<spring:message code="assistance"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
            },
            {
                name: "ccpSection",
                title: "<spring:message code="section.cost"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
            },
            {
                name: "ccpUnit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            { type:"header", defaultValue:"جستجوی دسته ای:" },
            {name: "source", title:"گزارش گیری براساس",
                valueMap:{
                "personnelNo2":"پرسنلی 6 رقمی",
                "personnelNo":"پرسنلی 10 رقمی",
                "nationalCode":"کد ملی",
                },
                defaultValue: "personnelNo2",
                pickListProperties:{
                    showFilterEditor: false
                },
            },
            {name: "hamed", showTitle:false, colSpan:3,
                // type:"TextAreaItem",
                textAlign: "center",
                keyPressFilter: "[0-9, ]",
                changed (form, item, value){
                    let res = value.split(" ");
                    item.setValue(res.toString())
                }
            }

        ]
    });

    var initialLayoutStyle = "vertical";
    let DynamicForm_SelectPeople_JspUnitReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "people.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "personnelNo",
                comboBoxWidth: 500,
                valueField: "personnelNo",
                layoutStyle: initialLayoutStyle,
                optionDataSource: PersonnelDS_PTSR_DF
            }
        ]
    });

    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.setHint("پرسنل مورد نظر را انتخاب کنید");
    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.pickListFields =
        [
            {name: "firstName", title: "نام", width: "30%", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگي", width: "30%", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملي", width: "30%", filterOperator: "iContains"},
            {name: "personnelNo", title: "کد پرسنلي", width: "30%", filterOperator: "iContains"},
            {name: "personnelNo2", title: "کد پرسنلي 6 رقمي", width: "30%", filterOperator: "iContains"},
        ];
    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.filterFields = ["firstName","lastName","nationalCode","personnelNo","personnelNo2"];

    let IButton_ConfirmPeopleSelections_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPeople_JspUnitReport.getItem("people.code").getValue();
            if (DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue() != undefined && DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("personnelNo").setValue(criteriaDisplayValues);
            Window_SelectPeople_JspUnitReport.close();
        }
    });

    let Window_SelectPeople_JspUnitReport = isc.Window.create({
        placement: "center",
        title: "انتخاب پرسنل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPeople_JspUnitReport,
                    IButton_ConfirmPeopleSelections_JspUnitReport,
                ]
            })
        ]
    });

    let IButton_JspTrainingFileNAReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            let form = DynamicForm_CriteriaForm_JspTrainingFileNAReport;
            let data_values = form.getValuesAsAdvancedCriteria();
            data_values.criteria = data_values.criteria.filter(a=>a.fieldName !== "source");
            console.log(data_values)
            if(form.getValue("hamed") === undefined) {
                if (data_values.criteria.length == 0) {
                    createDialog("info", "فیلتری انتخاب نشده است.");
                    return;
                }
                form.validate();
                if (form.hasErrors())
                    return;
                else {
                    for (let i = 0; i < data_values.criteria.size(); i++) {
                        if (data_values.criteria[i].fieldName == "personnelNo") {
                            let codesString = data_values.criteria[i].value;
                            let codesArray;
                            codesArray = codesString.split(",");
                            for (let j = 0; j < codesArray.length; j++) {
                                if (codesArray[j] == "" || codesArray[j] == " ") {
                                    codesArray.remove(codesArray[j]);
                                }
                            }
                            data_values.criteria[i].operator = "inSet";
                            data_values.criteria[i].value = codesArray;
                        } else if (data_values.criteria[i].fieldName == "ccpArea") {
                            data_values.criteria[i].fieldName = "ccpArea";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "companyName") {
                            data_values.criteria[i].fieldName = "companyName";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "ccpAssistant") {
                            data_values.criteria[i].fieldName = "ccpAssistant";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "ccpUnit") {
                            data_values.criteria[i].fieldName = "ccpUnit";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "ccpAffairs") {
                            data_values.criteria[i].fieldName = "ccpAffairs";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "ccpSection") {
                            data_values.criteria[i].fieldName = "ccpSection";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "personnelNo2") {
                            data_values.criteria[i].fieldName = "personnelNo2";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "nationalCode") {
                            data_values.criteria[i].fieldName = "nationalCode";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "firstName") {
                            data_values.criteria[i].fieldName = "firstName";
                            data_values.criteria[i].operator = "iContains";
                        } else if (data_values.criteria[i].fieldName == "lastName") {
                            data_values.criteria[i].fieldName = "lastName";
                            data_values.criteria[i].operator = "iContains";
                        }
                    }

                    ListGrid_Personnel_JspTrainingFileNAReport.invalidateCache();
                    ListGrid_Personnel_JspTrainingFileNAReport.fetchData(data_values);
                    Window_JspTrainingFileNAReport.show();
                }
            }
            else{
                data_values = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [
                        {fieldName: form.getValue("source"), operator:"inSet", value: form.getValue("hamed").split(',').toArray()}
                    ]
                };
            }
            ListGrid_Personnel_JspTrainingFileNAReport.invalidateCache();
            ListGrid_Personnel_JspTrainingFileNAReport.fetchData(data_values);
            Window_JspTrainingFileNAReport.show();
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspTrainingFileNAReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspTrainingFileNAReport]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    let HLayOut_CriteriaForm_JspTrainingFileNAReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspTrainingFileNAReport
        ]
    });

    let HLayOut_Confirm_JspTrainingFileNAReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspTrainingFileNAReport
        ]
    });

    let VLayout_Body_JspTrainingFileNAReport = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspTrainingFileNAReport,
            HLayOut_Confirm_JspTrainingFileNAReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspTrainingFileNAReport.hide();