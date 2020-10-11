<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let selectedGroup_CNAR = null;
    let valuePersonnelGroup;
    let data_values;

    //--------------------------------------------------------------------------------------------------------------------//
    //*course form*/
    //--------------------------------------------------------------------------------------------------------------------//

    CourseDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "description"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    Menu_Course_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(CourseLG_CNAR);
            }
        }]
    });

    CourseLG_CNAR = isc.TrLG.create({
        dataSource: CourseDS_CNAR,
        contextMenu: Menu_Course_CNAR,
        selectionType: "single",
        autoFetchData: true,
        fields: [
            {name: "code", title: "<spring:message code="corse_code"/>", autoFitWidth: true, filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='description'/>", autoFitWidth: true, filterOperator: "iContains"},
        ],
        rowDoubleClick: function () {
            Window_Course_CNAR.close();
            Select_Course_Or_Personnel_Group_CNAR(valuePersonnelGroup);
        }
    });

    IButton_Course_Ok_CNAR = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: function () {
            if (CourseLG_CNAR.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_Course_CNAR.close();
            Select_Course_Or_Personnel_Group_CNAR(valuePersonnelGroup);
        }
    });

    HLayout_Course_Ok_CNAR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Course_Ok_CNAR]
    });

    ToolStripButton_Course_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(CourseLG_CNAR);
        }
    });

    ToolStrip_Course_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Course_Refresh_CNAR
        ]
    });

    Window_Course_CNAR = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Course_Actions_CNAR,
                CourseLG_CNAR,
                HLayout_Course_Ok_CNAR
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*REST DataSources*/
    //--------------------------------------------------------------------------------------------------------------------//
    CompanyDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    AreaDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpArea"
    });

    ComplexDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    UnitDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });

    EduLevelDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="education.level"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        autoCacheAllData: true,
        fetchDataURL: educationLevelUrl + "iscList"
    });

    JobDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "peopleType",  title: "نوع فراگیر",valueMap: {"personnel_registered": "متفرقه", "Personal": "شرکتی", "ContractorPersonal": "پیمانکار"}},
            {name: "enabled", title: "فعال/غیرفعال", valueMap: {"undefined": "فعال", "74": "غیرفعال"}}
        ],
        autoCacheAllData: true,
        fetchDataURL: jobUrl + "/iscList"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    //*courses form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_CNAR = isc.TrDS.create({
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

    CourseNAReportDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "totalPersonnelCount", title: "<spring:message code='personnel.total'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "passedPersonnelCount", title: "<spring:message code='personnel.passed'/>", filterOperator: "equals", autoFitWidth: true},
        ],
        fetchDataURL: null
    });

    Menu_Courses_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG_CNAR();
            }
        }]
    });

    MenuButton_GroupType_CNAR = isc.MenuButton.create({
        title: "<spring:message code='personnel.pased.on'/>",
        height: 27,
        width: 160,
        menu: isc.Menu.create({
            autoDraw: false,
            showShadow: true,
            shadowDepth: 10,
            data: [
                {title: "<spring:message code='company'/>", click: function () {changeSourcePersonnelGroup(0);}},
                {title: "<spring:message code='area'/>", click: function () {changeSourcePersonnelGroup(1);}},
                {title: "<spring:message code='complex'/>", click: function () {changeSourcePersonnelGroup(2);}},
                {title: "<spring:message code='assistance'/>", click: function () {changeSourcePersonnelGroup(3);}},
                {title: "<spring:message code='affairs'/>", click: function () {changeSourcePersonnelGroup(4);}},
                {title: "<spring:message code='unit'/>", click: function () {changeSourcePersonnelGroup(5);}},
                {title: "<spring:message code='education.level'/>", click: function () {changeSourcePersonnelGroup(6);}},
                {title: "<spring:message code='job'/>", click: function () {changeSourcePersonnelGroup(7);}},
            ]
        }),
    });

    HeaderDF_CNAR = isc.IButton.create({
        name: "courseId",
        align : "center",
        title: "<spring:message code='course.select'/>",
        type: "ButtonItem",
        height: 27,
        click() {
            CourseLG_CNAR.fetchData();
            Window_Course_CNAR.show();
        }
    });

    PersonnelGroup_CNAR = isc.DynamicForm.create({
        width: "350",
        numCols: 2,
        paddingLeft:20,
        colWidths: ["10%", "90%"],
        fields: [
            {
                name: "personnelGroup",
                title: "گروه",
                valueField: "value",
                displayField: "value",
                disabled:true,
                changed: function (form, item, value) {
                    valuePersonnelGroup=value;
                    setCriteria(selectedGroup_CNAR,valuePersonnelGroup);
                    Select_Course_Or_Personnel_Group_CNAR(valuePersonnelGroup);
                }
            },
        ]
    });

    Buttoms_HLayout_CNAR = isc.TrHLayout.create({
        height: "50px",
        members: [MenuButton_GroupType_CNAR,PersonnelGroup_CNAR,HeaderDF_CNAR]
    });

    DynamicForm_Title_CNAR = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "title",
                type: "staticText",
                title: "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='course'/> " + getFormulaMessage("...", 2, "red", "b") + " <spring:message code='personnel.for'/> " + getFormulaMessage("...", 2, "red", "b"),
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });

    CourseNAReportLG_CNAR = isc.TrLG.create({
        gridComponents: [Buttoms_HLayout_CNAR, DynamicForm_Title_CNAR, "header", "filterEditor", "body"],
        padding: 10,
        dataSource: CourseNAReportDS_CNAR,
        contextMenu: Menu_Courses_CNAR,
        selectionType: "single",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        showFilterEditor: false,
        fields: [
            {
                name: "needsAssessmentPriorityId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_CNAR,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "totalPersonnelCount"},
            {name: "passedPersonnelCount"},
        ],
    });

    ToolStripButton_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG_CNAR();
        }
    });
    let ToolStripButton_Export2EXcel_CNAR = isc.ToolStripButtonExcel.create({
        click: function () {
            if (CourseLG_CNAR.getSelectedRecord() !== null && valuePersonnelGroup ) {
                let restUrl = needsAssessmentReportsUrl + "/courseNA?courseId=" + CourseLG_CNAR.getSelectedRecord().id + "&passedReport=true";
                let groupTitle = "";
                let personnelforGroup =  valuePersonnelGroup;
                if (selectedGroup_CNAR == 7)
                    personnelforGroup = PersonnelGroup_CNAR.getField("personnelGroup").getDisplayValue();

                if (personnelforGroup)
                    groupTitle = MenuButton_GroupType_CNAR.menu.data[selectedGroup_CNAR].title + ": " + personnelforGroup;

                let courseInfo = "<spring:message code='course.code'/>: " + CourseLG_CNAR.getSelectedRecord().code + '   ' + "<spring:message code='course.title'/>: "+ CourseLG_CNAR.getSelectedRecord().titleFa;

                let titr = courseInfo + "   " + groupTitle;

                ExportToFile.downloadExcelRestUrl(null, CourseNAReportLG_CNAR,restUrl, 0, null, titr, "طراحی و برنامه ریزی - گزارش نیازسنجی دوره", null, null);
            }
            else
            {
                isc.Dialog.create({
                        message:  " برای ايجاد فايل اکسل فیلترها به درستی انتخاب نشده اند" ,
                        icon: "[SKIN]ask.png",
                        title: "توجه",
                        buttons: [isc.IButtonSave.create({title: "تائید"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });

                }
        }
    });
    ToolStrip_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_CNAR,
                        ToolStripButton_Export2EXcel_CNAR
                    ]
                })
            ]
    });

    Main_HLayout_CNAR = isc.TrHLayout.create({
        members: [CourseNAReportLG_CNAR]
    });

    Main_VLayout_CNAR = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [ToolStrip_Actions_CNAR, Main_HLayout_CNAR]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function refreshLG_CNAR() {
        if (CourseLG_CNAR.getSelectedRecord() !== null && data_values){
            CourseNAReportLG_CNAR.invalidateCache();
            CourseNAReportLG_CNAR.fetchData(data_values);
        }
    }

    function Select_Course_Or_Personnel_Group_CNAR (value) {
        let courseTitle = getFormulaMessage(CourseLG_CNAR.getSelectedRecord() !== null ? CourseLG_CNAR.getSelectedRecord().titleFa : "...", 2, "red", "b");
        let groupTitle = getFormulaMessage("...", 2, "red", "b");

        if (selectedGroup_CNAR==7)
            value=PersonnelGroup_CNAR.getField("personnelGroup").getDisplayValue();

        if (value)
            groupTitle = getFormulaMessage(MenuButton_GroupType_CNAR.menu.data[selectedGroup_CNAR].title + " " + value, 2, "red", "b");

        DynamicForm_Title_CNAR.getItem("title").title = "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='course'/> " + courseTitle + " <spring:message code='personnel.for'/> " + groupTitle;
        DynamicForm_Title_CNAR.getItem("title").redraw();

        if (CourseLG_CNAR.getSelectedRecord() !== null){
            CourseNAReportDS_CNAR.fetchDataURL = needsAssessmentReportsUrl + "/courseNA?courseId=" + CourseLG_CNAR.getSelectedRecord().id + "&passedReport=true";
            refreshLG_CNAR();
        }
    }

    function changeSourcePersonnelGroup(groupType){
        selectedGroup_CNAR=groupType;

        PersonnelGroup_CNAR.getField("personnelGroup").setDisabled(false);
        PersonnelGroup_CNAR.getField("personnelGroup").setValue("");
        let title=MenuButton_GroupType_CNAR.menu.data[groupType].title;

        switch(groupType) {
            case 0:
                PersonnelGroup_CNAR.dataSource = CompanyDS_CNAR;
                break;

            case 1:
                PersonnelGroup_CNAR.dataSource = AreaDS_CNAR;
                break;

            case 2:
                PersonnelGroup_CNAR.dataSource = ComplexDS_CNAR;
                break;

            case 3:
                PersonnelGroup_CNAR.dataSource = AssistantDS_CNAR;
                break;

            case 4:
                PersonnelGroup_CNAR.dataSource = AffairsDS_CNAR;
                break;

            case 5:
                PersonnelGroup_CNAR.dataSource = UnitDS_CNAR;
                break;

            case 6:
                PersonnelGroup_CNAR.dataSource = EduLevelDS_CNAR;
                break;

            case 7:
                PersonnelGroup_CNAR.dataSource = JobDS_CNAR;
                break;
        }

        if (groupType==6){
            PersonnelGroup_CNAR.getField("personnelGroup").pickListWidth=350;
            PersonnelGroup_CNAR.getField("personnelGroup").pickListFields=null;
            PersonnelGroup_CNAR.getField("personnelGroup").displayField="titleFa";
            PersonnelGroup_CNAR.getField("personnelGroup").valueField="titleFa";
        }else if (groupType==7){
            PersonnelGroup_CNAR.getField("personnelGroup").pickListWidth=550;
            PersonnelGroup_CNAR.getField("personnelGroup").pickListFields=[{name:"titleFa"},{name:"code"},{name:"peopleType",canFilter: false},{name:"enabled"}];
            PersonnelGroup_CNAR.getField("personnelGroup").filterFields=[{name:"titleFa"},{name:"code"},{name:"enabled"}];
            PersonnelGroup_CNAR.getField("personnelGroup").displayField=["titleFa"];
            PersonnelGroup_CNAR.getField("personnelGroup").valueField="id";
        }
        else{
            PersonnelGroup_CNAR.getField("personnelGroup").pickListWidth=350
            PersonnelGroup_CNAR.getField("personnelGroup").pickListFields=null;
            PersonnelGroup_CNAR.getField("personnelGroup").displayField="value";
            PersonnelGroup_CNAR.getField("personnelGroup").valueField="value";
        }

        PersonnelGroup_CNAR.getField("personnelGroup").title=title;
        PersonnelGroup_CNAR.getField("personnelGroup").redraw();
    }

    function setCriteria(groupType,value){
        data_values=PersonnelGroup_CNAR.getValuesAsAdvancedCriteria();
        let nameField;

        switch(groupType) {
            case 0:
                nameField="companyName";
                break;

            case 1:
                nameField="ccpArea";
                break;

            case 2:
                nameField="complexTitle";
                break;

            case 3:
                nameField="ccpAssistant";
                break;

            case 4:
                nameField="ccpAffairs";
                break;

            case 5:
                nameField="ccpUnit";
                break;

            case 6:
                nameField="educationLevelTitle";
                break;

            case 7:
                nameField="jobId";
                break;
        }

        data_values.criteria[0].operator = "equals";
        data_values.criteria[0].value = value;
        data_values.criteria[0].fieldName = nameField;
    }

    //</script>