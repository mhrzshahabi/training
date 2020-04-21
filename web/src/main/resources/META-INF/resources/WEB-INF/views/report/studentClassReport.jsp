<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    
    var selectedPerson_TrainingFile = null;
    var printUrl_TrainingFile = "<spring:url value="/web/print/class-student/"/>";

    var RestDataSource_Student_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "studentFirstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCompanyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "studentPostTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "studentCcpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "studentCcpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "studentCcpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "studentCcpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: studentUrl + "spec-list/"
    });
    var RestDataSource_Course_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "classStudentId", primaryKey: true, hidden: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "courseCode", filterOperator: "equals", autoFitWidth: true,
                title:"<spring:message code='corse_code'/>",
            },
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentScore", title:"<spring:message code="score"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "studentComplexTitle",
                title: "<spring:message code="complex"/>"
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>"
            },
            {
                name: "studentCompanyName",
                title: "<spring:message code="company"/>"
            },
            {name: "classStudentScoresState", title:"<spring:message code="score.state"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: studentClassReportUrl
    });
    var ScoresStateDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        autoCacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=scoreState"
    });

    var CompanyDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=company"
    });
    var AreaDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=area"
    });
    var ComplexDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=complex"
    });
    var AssistantDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=assistant"
    });
    var AffairsDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=affairs"
    });
    var CourseDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true},
            {name: "courseCode", title: "<spring:message code="corse_code"/>"},
            {name: "courseTitleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: studentClassReportUrl + "/all-courses",
    });
    var UnitDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpUnit"
    });

    var ListGrid_StudentSearch_JspTrainingFile = isc.TrLG.create({
        dataSource: RestDataSource_Student_JspTrainingFile,
        allowAdvancedCriteria: true,
        canSelect: false,
        selectionType: "single",
        allowFilterExpressions: true,
        fields: [
            {name: "studentFirstName"},
            {name: "studentLastName"},
            {name: "studentNationalCode"},
            {name: "studentPersonnelNo"},
            {name: "studentPersonnelNo2"},
            {name: "studentPostTitle"},
            {name: "studentCcpArea"},
            {name: "studentCcpAssistant"},
            {name: "studentCcpAffairs"},
            {name: "studentCcpSection"},
            {name: "studentCcpUnit"}
        ],
        autoFetchData: false,
        rowDoubleClick: function () {
            DynamicForm_TrainingFile.editRecord(this.getSelectedRecord());
            selectedPerson_TrainingFile = this.getSelectedRecord();
            RestDataSource_Course_JspTrainingFile.fetchDataURL = tclassStudentUrl + "/classes-of-student/" + this.getSelectedRecord().nationalCode;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
            ListGrid_TrainingFile_TrainingFileJSP.fetchData();
            Window_StudentSearch_JspTrainingFile.close();

        }
    });
    var Window_StudentSearch_JspTrainingFile = isc.Window.create({
        autoSize:false,
        title:"<spring:message code="students.list"/>",
        width: "100%",
        placement:"fillPanel",
        height: 600,
        items:[
           ListGrid_StudentSearch_JspTrainingFile
        ]
    });
    var DynamicForm_TrainingFile = isc.DynamicForm.create({
        numCols: 10,
        padding: 10,
        margin:0,
        // cellPadding: 10,
        titleAlign:"left",
        wrapItemTitles: true,
        colWidths:[50,150,50,150,50,150,50,150, 50, 150],
        // sectionVisibilityMode: "mutex",
        fields: [
            // {
            //     defaultValue:"جستجو فرد", type:"section", sectionExpanded:true,canTabToHeader:true,
            //     itemIds: ["studentPersonnelNo2","studentPersonnelNo","studentNationalCode","searchBtn","studentFirstName","studentLastName","clearBtn"],
            //     width:"80%"
            // },
            {
                name: "studentPersonnelNo2",
                title:"پرسنلی 6رقمی",
                <%--title:"<spring:message code="personnel.no.6.digits"/>",--%>
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentPersonnelNo",
                title:"<spring:message code="personnel.no"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentNationalCode",
                title:"<spring:message code="national.code"/> ",
                textAlign: "center",
                width: "*",
            },
            {
                name: "studentFirstName",
                title:"<spring:message code="firstName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentLastName",
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                width: "*"
            },
            // {
            //     type: "SpacerItem"
            // },
            // {
            //     type: "SpacerItem"
            // },
            // {
            //     defaultValue:"جستجو گروه", type:"section",canTabToHeader:true,
            //     itemIds: ["classStudentScoresState","studentComplexTitle","studentCcpAffairs","studentCompanyName","courseTitle","termTitleFa"], width:"80%"
            // },
            {
                name: "classStudentScoresState",
                title: "<spring:message code="score.state"/>",
                type: "SelectItem",
                optionDataSource: ScoresStateDS_SCRV,
                multiple: true,
                valueField: "value",
                displayField: "value",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
            },
            {
                name: "studentComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_SCRV,
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCompanyName",
                title: "<spring:message code="company"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_SCRV,
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_SCRV,
                // filterFields: ["value", "value"],
                // pickListWidth: 300,
                type: "MultiComboBoxItem",
                textMatchStyle: "substring",
                comboBoxWidth: 155,
                layoutStyle: "verticalReverse",
                comboBoxProperties: {
                    pickListWidth: 300,
                },
                // pickListProperties: {
                //     showFilterEditor: false,
                //     showClippedValuesOnHover: true,
                // },
                valueField: "value",
                displayField: "value",
            },
            {
                name: "courseCode",
                title: "<spring:message code="course"/>",
                optionDataSource: CourseDS_SCRV,
                valueField: "courseCode",
                displayField: "courseCode",
                // comboBoxFields: [
                //     {name: "code", autoFitWidth: true},
                //     {name: "titleFa"},
                // ],
                // filterFields: ["titleFa", "code"],
                type: "MultiComboBoxItem",
                textMatchStyle: "substring",
                comboBoxWidth: 155,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    pickListWidth: 400,
                },
            },
            {
                name: "termTitleFa",
                title: "<spring:message code="term"/>"
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspTrainingFile",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width:"*",
                startRow:false,
                endRow:false,
                click (form) {
                    var advancedCriteriaStudentJspTrainingFile = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: []
                    };
                    var items = form.getItems();
                    for (let i = 0; i < items.length; i++) {
                        if(items[i].getValue() != undefined){
                            advancedCriteriaStudentJspTrainingFile.criteria.add({fieldName: items[i].name, operator: "iContains", value: items[i].getValue()})
                        }
                    }
                    ListGrid_StudentSearch_JspTrainingFile.fetchData(advancedCriteriaStudentJspTrainingFile);
                    Window_StudentSearch_JspTrainingFile.show();
                }
            },
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width:"*",
                startRow:false,
                endRow:false,
                click (form, item) {
                    form.clearValues();
                    ListGrid_TrainingFile_TrainingFileJSP.setData([]);
                }
            },
        ],
        itemChanged (item, newValue){
            ListGrid_TrainingFile_TrainingFileJSP.filterData(DynamicForm_TrainingFile.getValuesAsCriteria())
        },
        itemKeyPress: function(item, keyName) {
            if(keyName == "Enter"){
                searchBtnJspTrainingFile.click(DynamicForm_TrainingFile);
            }
        }
    });

    DynamicForm_TrainingFile.getField("courseCode").comboBox.pickListFields = [
        {name: "courseCode", autoFitWidth: true},
        {name: "courseTitleFa"},
    ];
    DynamicForm_TrainingFile.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_TrainingFile.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];
    DynamicForm_TrainingFile.getField("courseCode").comboBox.textMatchStyle="substring";
    DynamicForm_TrainingFile.getField("courseCode").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.filterFields = ["value", "value"];
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.textMatchStyle="substring";
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.setHint("امور مورد نظر را انتخاب کنید");
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 300,
        showClippedValuesOnHover: true,
    };

    var Menu_Courses_TrainingFileJSP = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="global.form.print.pdf"/>",
                click: function () {
                    print_Training_File();
                }
            }, {
                title: "<spring:message code="global.form.print.excel"/>",
                click: function () {
                    print_Training_File("excel");
                }
            }, {
                title: "<spring:message code="global.form.print.html"/>",
                click: function () {
                    print_Training_File("html");
                }
        }]
    });

    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        contextMenu: Menu_Courses_TrainingFileJSP,
        dataSource: RestDataSource_Course_JspTrainingFile,
        filterOnKeypress: true,

        gridComponents: [DynamicForm_TrainingFile, "header", "filterEditor", "body"],
        fields:[
            {name: "studentPersonnelNo2"},
            {name: "studentNationalCode"},
            {name: "studentFirstName"},
            {name: "studentLastName"},
            {name: "studentCcpUnit"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "classStudentScore"},
            {
                name: "classStudentScoresState",
                autoFetchDisplayMap: true,
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "value",
                valueField: "value",
                multiple: true,

                optionDataSource: ScoresStateDS_SCRV,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "value", width: "30%"}
                ],
            },
        ]
    });

    var ToolStripButton_Training_File = isc.ToolStripButtonPrint.create({
        <%--title: "<spring:message code='print'/>",--%>
        click: function () {
            print_Training_File();
        }
    });

    var ToolStrip_Actions_Training_File = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_Training_File]
    });

    var VLayout_Body_Training_File = isc.VLayout.create({
        width: "100%",
        height: "100%",
        // overflow: "scroll",
        members: [
            // ToolStrip_Actions_Training_File,
            ListGrid_TrainingFile_TrainingFileJSP
        ]
    });

    //*************this function calls from studentPortal page**************
    function call_trainingFile(selected_person) {
        selectedPerson_TrainingFile = selected_person;
        DynamicForm_TrainingFile.hide();
        RestDataSource_Course_JspTrainingFile.fetchDataURL = studentPortalUrl + "/class-student/classes-of-student/" + selectedPerson_TrainingFile.nationalCode;
        printUrl_TrainingFile = "<spring:url value="/web/print/student-portal/"/>";
        ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        ListGrid_TrainingFile_TrainingFileJSP.fetchData();
    }

    function print_Training_File(type = "pdf") {
        if (selectedPerson_TrainingFile == null){
            createDialog("info", "<spring:message code='personnel.not.selected'/>");
            return;
        }
        let params = {};
        params.firstName = selectedPerson_TrainingFile.firstName;
        params.lastName = selectedPerson_TrainingFile.lastName;
        params.nationalCode = selectedPerson_TrainingFile.nationalCode;
        params.personnelNo = selectedPerson_TrainingFile.personnelNo;
        params.personnelNo2 = selectedPerson_TrainingFile.personnelNo2;
        params.companyName = selectedPerson_TrainingFile.companyName;
        
        let CriteriaForm_TrainingFile = isc.DynamicForm.create({
            method: "POST",
            action: printUrl_TrainingFile + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "myToken", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "formData", type: "hidden"},
                ]
        });
        CriteriaForm_TrainingFile.setValue("CriteriaStr", JSON.stringify(ListGrid_TrainingFile_TrainingFileJSP.getCriteria()));
        CriteriaForm_TrainingFile.setValue("formData", JSON.stringify(selectedPerson_TrainingFile.nationalCode));
        CriteriaForm_TrainingFile.setValue("myToken", "<%=accessToken%>");
        CriteriaForm_TrainingFile.setValue("params", JSON.stringify(params));
        CriteriaForm_TrainingFile.show();
        CriteriaForm_TrainingFile.submitForm();
    }

 //</script>