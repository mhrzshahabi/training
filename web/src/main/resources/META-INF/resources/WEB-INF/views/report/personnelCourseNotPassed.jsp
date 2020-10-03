<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>

    $(document).ready(()=>{
        setTimeout(()=>{
        $("input[name='personnelNo']").attr("disabled","disabled");
        $("input[name='courseCode']").attr("disabled","disabled");
        $("input[name='postGrade']").attr("disabled","disabled");
    },0)}
    );

    let criteriaDisplayValuesPostGrade;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspCoursesNotPassedPersonnel = isc.TrDS.create({
        fields: [
            {name: "personnelId", hidden: true},
            {name: "personnelPersonnelNo2", title: "<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNationalCode", title: "<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelFirstName", title: "<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelLastName", title: "<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpUnit", title: "<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpSection", title: "<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpAssistant", title: "<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpArea", title: "<spring:message code='area'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCompanyName", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelPostGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseId", hidden: true},
            {name: "courseCode", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title: "<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNotPassedReportUrl
    });

    PersonnelDS_PTSR_DF = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
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
            criteria:[{fieldName: "deleted", operator: "equals", value: 0}]
        },
    });

    RestDataSource_Class_JspCoursesNotPassedPersonnel = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    RestDataSource_Category_JspCoursesNotPassedReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_Course_JspCoursesNotPassedReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="corse_code"/>"},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    CompanyDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    ComplexDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    SectionDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true},
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
    });

    UnitDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>",filterOnKeypress: true, filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
                valueMap:{
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspCoursesNotPassedPersonnel = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspCoursesNotPassedPersonnel,
        cellHeight: 43,
        initialSort: [
            {property: "personnelId", direction: "ascending",primarySort: true}
        ],
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
	    border: "1px solid #4a4444",
	    margin: 5
    });

    IButton_JspCoursesNotPassedPersonnel_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_JspCoursesNotPassedPersonnel, personnelCourseNotPassedReportUrl, 0, null, '',  "گزارش عدم آموزش", ListGrid_JspCoursesNotPassedPersonnel.data.getCriteria(), null);
        }
    });

    var HLayOut_CriteriaForm_JspCoursesNotPassedPersonnel_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspCoursesNotPassedPersonnel
        ]
    });

    var HLayOut_Confirm_JspCoursesNotPassedPersonnel_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCoursesNotPassedPersonnel_FullExcel
        ]
    });

    var Window_JspCoursesNotPassedPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش عدم آموزش",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspCoursesNotPassedPersonnel_Details,HLayOut_Confirm_JspCoursesNotPassedPersonnel_UnitExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "personnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspCoursesNotPassed.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "postGrade",
                title: "رده پستی",
                hint: "رده پستی را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPostGrade_JspCoursesNotPassed.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "companyName",
                title: "<spring:message code="company"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "complexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "assistant",
                title: "<spring:message code="assistance"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "unit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "section",
                title: "<spring:message code="section.cost"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
                icons:[
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
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را وارد نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectCourses_JspCoursesNotPassedReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspCoursesNotPassedReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
            },
        ],
    });

    var initialLayoutStyle = "vertical";

    var DynamicForm_SelectPeople_JspCoursesNotPassed = isc.DynamicForm.create({
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

    DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").comboBox.setHint("پرسنل مورد نظر را انتخاب کنید");
    DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").comboBox.pickListFields =
        [
            {name: "firstName", title: "نام", autoFitWidth:true, filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo", title: "کد پرسنلي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo2", title: "کد پرسنلي 6 رقمي",autoFitWidth:true, filterOperator: "iContains"},
        ];
    DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").comboBox.filterFields = ["firstName","lastName","nationalCode","personnelNo","personnelNo2"];

    IButton_ConfirmPeopleSelections_JspCoursesNotPassed = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPeople_JspCoursesNotPassed.getItem("people.code").getValue();
            if (DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").getValue() != undefined && DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPeople_JspCoursesNotPassed.getField("people.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.getField("personnelNo").setValue(criteriaDisplayValues);
            Window_SelectPeople_JspCoursesNotPassed.close();
        }
    });

    var Window_SelectPeople_JspCoursesNotPassed = isc.Window.create({
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
                    DynamicForm_SelectPeople_JspCoursesNotPassed,
                    IButton_ConfirmPeopleSelections_JspCoursesNotPassed,
                ]
            })
        ]
    });

    var DynamicForm_SelectPostGrade_JspCoursesNotPassed = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "PostGrade.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "titleFa",
                comboBoxWidth: 500,
                valueField: "id",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
            },
        ]
    });

    DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").comboBox.setHint("رده پستی مورد نظر را انتخاب کنید");
    DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").comboBox.pickListFields =
        [
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "peopleType",  title: "نوع فراگیر",valueMap: {"personnel_registered": "متفرقه", "Personal": "شرکتی", "ContractorPersonal": "پیمانکار"}},
            {name: "enabled", title: "فعال/غیرفعال", valueMap: {"undefined": "فعال", "74": "غیرفعال"}}
        ];
    DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").comboBox.filterFields = ["titleFa","peopleType","enabled"];

    IButton_ConfirmPostGradeSelections_JspCoursesNotPassed = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPostGrade_JspCoursesNotPassed.getItem("PostGrade.code").getValue();
            if (DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").getValue() != undefined && DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPostGrade_JspCoursesNotPassed.getField("PostGrade.code").getValue().join(",");
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

            criteriaDisplayValuesPostGrade=criteriaDisplayValues;
            DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.getField("postGrade").setValue(DynamicForm_SelectPostGrade_JspCoursesNotPassed.getItem("PostGrade.code").getDisplayValue().join(","));
            Window_SelectPostGrade_JspCoursesNotPassed.close();
        }
    });

    var Window_SelectPostGrade_JspCoursesNotPassed = isc.Window.create({
        placement: "center",
        title: "انتخاب رده پستی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPostGrade_JspCoursesNotPassed,
                    IButton_ConfirmPostGradeSelections_JspCoursesNotPassed,
                ]
            })
        ]
    });

    var DynamicForm_SelectCourses_JspCoursesNotPassedReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "courseCode",
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
                optionDataSource: RestDataSource_Course_JspCoursesNotPassedReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspCoursesNotPassedReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspCoursesNotPassedReport.getItem("courseCode").getValue();
            if (DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").getValue() != undefined
                && DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspCoursesNotPassedReport.getField("courseCode").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
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

            DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspCoursesNotPassedReport.close();
        }
    });

    var Window_SelectCourses_JspCoursesNotPassedReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspCoursesNotPassedReport,
                    IButton_ConfirmCourseSelections_JspCoursesNotPassedReport
                ]
            })
        ]
    });

    IButton_JspCoursesNotPassedPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if(DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.getValuesAsAdvancedCriteria()==null) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }
            DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.validate();
            if (DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel.getValuesAsAdvancedCriteria();
                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName == "personnelNo") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }

                        data_values.criteria[i].fieldName = "personnelPersonnelNo";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "courseCode") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "postGrade") {
                        var codesString = criteriaDisplayValuesPostGrade;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }

                        data_values.criteria[i].fieldName = "pgId";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "companyName") {
                        data_values.criteria[i].fieldName = "personnelCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "assistant") {
                        data_values.criteria[i].fieldName = "personnelCcpAssistant";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "unit") {
                        data_values.criteria[i].fieldName = "personnelCcpUnit";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "affairs") {
                        data_values.criteria[i].fieldName = "personnelCcpAffairs";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "section") {
                        data_values.criteria[i].fieldName = "personnelCcpSection";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "personnelComplexTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "courseCategory") {
                        data_values.criteria[i].fieldName = "categoryId";
                        data_values.criteria[i].operator = "inSet";
                    }
                }

                ListGrid_JspCoursesNotPassedPersonnel.invalidateCache();
                ListGrid_JspCoursesNotPassedPersonnel.fetchData(data_values);
                Window_JspCoursesNotPassedPersonnel.show();
            }
        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspCoursesNotPassedPersonnel = isc.TrHLayoutButtons.create({
        showEdges: false,
	    margin:20,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_JspCoursesNotPassedPersonnel
        ]
    });

    var HLayOut_Confirm_JspCoursesNotPassedPersonnel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCoursesNotPassedPersonnel
        ]
    });

    isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspCoursesNotPassedPersonnel,
            HLayOut_Confirm_JspCoursesNotPassedPersonnel
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspCoursesNotPassedPersonnel.hide();