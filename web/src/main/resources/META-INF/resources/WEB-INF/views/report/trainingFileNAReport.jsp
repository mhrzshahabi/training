<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='studentPersonnelNo']").attr("disabled","disabled");
            $("input[name='classCode']").attr("disabled","disabled");
        },0)}
    );

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_JspTrainingFileNAReport = isc.TrDS.create({
        fields: [
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "classId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", filterOperator: "inSet", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classTeachingType", title:"<spring:message code="teaching.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "sessionDate", title:"تاریخ جلسه", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "studentPersonnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentApplicantCompanyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelAreaTitle", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseId", hidden: true, title:"<spring:message code='identity'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "categoryId", title:"<spring:message code='category'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseRunType", title:"<spring:message code='course_eruntype'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTheoType", title:"<spring:message code='course_etheoType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseLevelType", title:"<spring:message code='cousre_elevelType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTechnicalType", title: "<spring:message code="technical.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "instituteId", hidden: true, title: "<spring:message code="identity"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "instituteTitleFa", title: "<spring:message code="institute"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: presenceReportUrl
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
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
        },
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
    let ListGrid_JspTrainingFileNAReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspTrainingFileNAReport,
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    let IButton_JspTrainingFileNAReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelFromClient(ListGrid_JspTrainingFileNAReport, null, '', 'گزارش حضور و غياب کلاس های آموزشي')
        }
    });

    let HLayOut_CriteriaForm_JspTrainingFileNAReport_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspTrainingFileNAReport
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
        title: "گزارش حضور و غیاب کلاسهای آموزشی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspTrainingFileNAReport_Details,HLayOut_Confirm_JspTrainingFileNAReport_AttendanceExcel
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
            {
                name: "studentPersonnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspUnitReport.show();
                    }}],
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
                name: "personnelAreaTitle",
                title: "<spring:message code="area"/>",
                optionDataSource: AreaDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "classStudentApplicantCompanyName",
                title: "<spring:message code="company"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
            },
            {
                name: "studentCcpAssistant",
                title: "<spring:message code="assistance"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
            },
            {
                name: "studentCcpSection",
                title: "<spring:message code="section.cost"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
            },
            {
                name: "studentCcpUnit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
        ]
    });

    var initialLayoutStyle = "vertical";
    let DynamicForm_SelectCourses_JspTrainingFileNAReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "course.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_Course_JspTrainingFileNAReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspTrainingFileNAReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspTrainingFileNAReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspTrainingFileNAReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    let IButton_ConfirmCourseSelections_JspTrainingFileNAReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspTrainingFileNAReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("courseCode").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ";";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ";";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspTrainingFileNAReport.close();
        }
    });

    let Window_SelectCourses_JspTrainingFileNAReport = isc.Window.create({
        placement: "center",
        title: "انتخاب دوره ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectCourses_JspTrainingFileNAReport,
                    IButton_ConfirmCourseSelections_JspTrainingFileNAReport
                ]
            })
        ]
    });

    let DynamicForm_SelectClasses_JspTrainingFileNAReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "class.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_Class_JspTrainingFileNAReport
            }
        ]
    });

    DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    let IButton_ConfirmClassesSelections_JspTrainingFileNAReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_JspTrainingFileNAReport.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspTrainingFileNAReport.getField("class.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspTrainingFileNAReport.close();
        }
    });

    let Window_SelectClasses_JspTrainingFileNAReport = isc.Window.create({
        placement: "center",
        title: "انتخاب کلاس ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectClasses_JspTrainingFileNAReport,
                    IButton_ConfirmClassesSelections_JspTrainingFileNAReport,
                ]
            })
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

            DynamicForm_CriteriaForm_JspTrainingFileNAReport.getField("studentPersonnelNo").setValue(criteriaDisplayValues);
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
            if(DynamicForm_CriteriaForm_JspTrainingFileNAReport.getValuesAsAdvancedCriteria()==null) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_JspTrainingFileNAReport.validate();
            if (DynamicForm_CriteriaForm_JspTrainingFileNAReport.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspTrainingFileNAReport.getValuesAsAdvancedCriteria();
                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName == "classCode") {
                        let codesString = data_values.criteria[i].value;
                        let codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "studentPersonnelNo") {
                        let codesString = data_values.criteria[i].value;
                        let codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "personnelAreaTitle") {
                        data_values.criteria[i].fieldName = "personnelAreaTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "classStudentApplicantCompanyName") {
                        data_values.criteria[i].fieldName = "classStudentApplicantCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpAssistant") {
                        data_values.criteria[i].fieldName = "studentCcpAssistant";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpUnit") {
                        data_values.criteria[i].fieldName = "studentCcpUnit";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpAffairs") {
                        data_values.criteria[i].fieldName = "studentCcpAffairs";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpSection") {
                        data_values.criteria[i].fieldName = "studentCcpSection";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "classStartDate") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "classEndDate") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "sessionDate") {
                        data_values.criteria[i].fieldName = "sessionDate";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentPersonnelNo") {
                        data_values.criteria[i].fieldName = "studentPersonnelNo";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentPersonnelNo2") {
                        data_values.criteria[i].fieldName = "studentPersonnelNo2";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentNationalCode") {
                        data_values.criteria[i].fieldName = "studentNationalCode";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentFirstName") {
                        data_values.criteria[i].fieldName = "studentFirstName";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentLastName") {
                        data_values.criteria[i].fieldName = "studentLastName";
                        data_values.criteria[i].operator = "iContains";
                    }
                }

                ListGrid_JspTrainingFileNAReport.invalidateCache();
                ListGrid_JspTrainingFileNAReport.fetchData(data_values);
                Window_JspTrainingFileNAReport.show();
            }
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