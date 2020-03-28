<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var selectedGroup_CNAR = null;

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
        rowDoubleClick: Select_Course_Or_Personnel_Group_CNAR
    });

    IButton_Course_Ok_CNAR = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: Select_Course_Or_Personnel_Group_CNAR
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
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},

            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains"},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            <%--{name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},--%>
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
            {name: "educationLevelTitle", title: "<spring:message code="education.level"/>", filterOperator: "equals"},
            {name: "jobNo", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    EduLevelDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="education.level"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: educationLevelUrl + "iscList"
    });

    Menu_Personnel_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_CNAR);
            }
        }]
    });

    PersonnelsLG_CNAR = isc.TrLG.create({
        dataSource: PersonnelDS_CNAR,
        contextMenu: Menu_Personnel_CNAR,
        selectionType: "single",
        allowAdvancedCriteria: true,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "postCode"},

            {name: "companyName", hidden: true},
            {name: "ccpArea"},
            {name: "complexTitle"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            // {name: "ccpSection"},
            {name: "ccpUnit"},
            {
                name: "educationLevelTitle",
                filterOnKeypress: true,

                // filterEditorType: "ComboBoxItem",
                // autoFetchData: true,
                // filterEditorProperties: {
                //     optionDataSource: EduLevelDS_CNAR,
                //     autoFetchData: true,
                //     displayField: "titleFa",
                //     valueField: "titleFa",
                //     useAdvancedCriteria: true,
                //     allowAdvancedCriteria: true,
                //     pickListFields: [
                //         {name: "titleFa"},
                //         {name: "titleEn"}
                //     ],
                //     pickListProperties: {
                //         showFilterEditor: false,
                //         alternateRecordStyles: true,
                //         autoFitWidthApproach: "both",
                //         useAdvancedCriteria: true,
                //         allowAdvancedCriteria: true
                //     },
                // },



                // optionDataSource: EduLevelDS_CNAR,
                // displayField: "titleFa",
                // valueField: "titleFa",
                // autoFetchData: true,
                // useClientFiltering: false,
                // pickListFields: [
                //     {name: "titleFa"},
                // ],
                // pickListProperties: {
                //     showFilterEditor: true,
                //     alternateRecordStyles: true,
                //     autoFitWidthApproach: "both",
                // },

                filterEditorType: "ComboBoxItem",
                useAdvancedCriteria: true,
                filterEditorProperties:{
                    optionDataSource: EduLevelDS_CNAR,
                    displayField: "titleFa",
                    valueField: "titleFa",
                    autoFetchData: true,
                    useClientFiltering: true,
                    filterFields: ["titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    useAdvancedCriteria: true,
                    pickListProperties: {showFilterEditor: false, useAdvancedCriteria: true,},
                    pickListFields: [
                        {name: "titleFa", title: "<spring:message code="education.level"/>", filterOperator: "iContains", autoFitWidth: true},
                    ],
                },
            },
            {name: "jobNo"},
            {name: "jobTitle"},
        ],
        // rowDoubleClick: Select_Person_CNAR
    });

    // FilterBuilder_CNAR = isc.FilterBuilder.create({
    //     ID:"advancedFilter",
    //     dataSource:PersonnelDS_CNAR,
    //     // topOperatorAppearance: "radio"
    //     criteria: { _constructor: "AdvancedCriteria", operator: "and",
    //         criteria: [{fieldName: "educationLevelTitle", operator: "equals", value: "land"}]
    //         // operator: "and", criteria: [
    //         //     {fieldName: "continent", operator: "equals", value: "Europe"},
    //         //     {operator: "or", criteria: [
    //         //             {fieldName: "countryName", operator: "iEndsWith", value: "land"},
    //         //             {fieldName: "population", operator: "lessThan", value: 3000000}
    //         //         ]}
    //         // ]
    //     }
    // });

    IButton_Personnel_Ok_CNAR = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: Select_Course_Or_Personnel_Group_CNAR
    });

    HLayout_Personnel_Ok_CNAR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Personnel_Ok_CNAR]
    });

    ToolStripButton_Personnel_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_CNAR);
        }
    });

    ToolStrip_Personnel_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_CNAR
        ]
    });

    Window_Personnel_CNAR = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_CNAR,
                // FilterBuilder_CNAR,
                PersonnelsLG_CNAR,
                HLayout_Personnel_Ok_CNAR
            ]
        })]
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
            {name: "totalPersonnelCount", title: "تعداد کل پرسنل", filterOperator: "iContains", autoFitWidth: true},
            {name: "passedPersonnelCount", title: "تعداد پرسنل گذرانده", filterOperator: "equals", autoFitWidth: true},
        ],
        fetchDataURL: null
    });

    Menu_Courses_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG_CNAR();
            }
        <%--}, {--%>
        <%--    isSeparator: true--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.pdf"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("pdf");--%>
        <%--    }--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.excel"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("excel");--%>
        <%--    }--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.html"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("html");--%>
        <%--    }--%>
        }]
    });

    MenuButton_GroupType_CNAR = isc.MenuButton.create({
        title: "انتخاب گروه پرسنل بر اساس",
        height: 27,
        width: 160,
        menu: isc.Menu.create({
            autoDraw: false,
            showShadow: true,
            shadowDepth: 10,
            data: [
                {title: "شرکت", click: function () {Show_Personnel_Window_CNAR(8)}},
                {title: "حوزه", click: function () {Show_Personnel_Window_CNAR(9)}},
                {title: "مجتمع", click: function () {Show_Personnel_Window_CNAR(10)}},
                {title: "معاونت", click: function () {Show_Personnel_Window_CNAR(11)}},
                {title: "امور", click: function () {Show_Personnel_Window_CNAR(12)}},
                {title: "واحد", click: function () {Show_Personnel_Window_CNAR(13)}},
                {title: "تحصیلی", click: function () {Show_Personnel_Window_CNAR(14)}},
                {title: "شغل", click: function () {Show_Personnel_Window_CNAR(15)}},
            ]
        }),
    });

    HeaderDF_CNAR = isc.DynamicForm.create({
        // titleAlign: "left",
        fields: [
            {
                name: "courseId",
                title: "انتخاب دوره",
                type: "ButtonItem",
                height: 27,
                click() {
                    CourseLG_CNAR.fetchData();
                    Window_Course_CNAR.show();
                }
            },
        ]
    });

    Buttoms_HLayout_CNAR = isc.TrHLayout.create({
        height: "50px",
        members: [MenuButton_GroupType_CNAR, HeaderDF_CNAR]
    });

    DynamicForm_Title_CNAR = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "title",
                type: "staticText",
                title: "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='course'/> " + getFormulaMessage("...", 2, "red", "b") + " برای پرسنل " + getFormulaMessage("...", 2, "red", "b"),
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
    <%--ToolStripButton_Print_CNAR = isc.ToolStripButtonPrint.create({--%>
    <%--    title: "<spring:message code='print'/>",--%>
    <%--    click: function () {--%>
    <%--        print_CNAR("pdf");--%>
    <%--    }--%>
    <%--});--%>

    ToolStrip_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                // ToolStripButton_Print_CNAR,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_CNAR
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
        if (CourseLG_CNAR.getSelectedRecord() !== null && PersonnelsLG_CNAR.getCriteria() !== undefined && PersonnelsLG_CNAR.getCriteria().operator !== undefined){
            CourseNAReportLG_CNAR.invalidateCache();
            CourseNAReportLG_CNAR.fetchData(PersonnelsLG_CNAR.getCriteria());
        }
    }

    function Show_Personnel_Window_CNAR (groupType) {
        selectedGroup_CNAR = groupType - 8;
        PersonnelsLG_CNAR.getAllFields().subList(8,17).forEach(field => PersonnelsLG_CNAR.hideField(field));
        PersonnelsLG_CNAR.getAllFields().forEach(field => field.canFilter = false);
        PersonnelsLG_CNAR.showField(PersonnelsLG_CNAR.getAllFields()[groupType]);
        PersonnelsLG_CNAR.getAllFields()[groupType].canFilter = true;
        PersonnelsLG_CNAR.sort(PersonnelsLG_CNAR.getAllFields()[groupType].name, "ascending");
        if (groupType === 15) {
            PersonnelsLG_CNAR.showField(PersonnelsLG_CNAR.getAllFields()[groupType + 1]);
            PersonnelsLG_CNAR.getAllFields()[groupType +1 ].canFilter = true;
        }
        PersonnelsLG_CNAR.clearCriteria();
        PersonnelsLG_CNAR.fetchData();
        Window_Personnel_CNAR.show();
    }

    function Select_Course_Or_Personnel_Group_CNAR () {
        Window_Personnel_CNAR.close();
        Window_Course_CNAR.close();

        let courseTitle = getFormulaMessage(CourseLG_CNAR.getSelectedRecord() !== null ? CourseLG_CNAR.getSelectedRecord().titleFa : "...", 2, "red", "b");
        let groupTitle = getFormulaMessage("...", 2, "red", "b");
        if (PersonnelsLG_CNAR.getCriteria() !== undefined && PersonnelsLG_CNAR.getCriteria().operator !== undefined)
            groupTitle = getFormulaMessage(MenuButton_GroupType_CNAR.menu.data[selectedGroup_CNAR].title + " " + PersonnelsLG_CNAR.getCriteria().criteria[0].value, 2, "red", "b");
        DynamicForm_Title_CNAR.getItem("title").title = "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='course'/> " + courseTitle + " برای پرسنل " + groupTitle;
        DynamicForm_Title_CNAR.getItem("title").redraw();

        if (CourseLG_CNAR.getSelectedRecord() !== null){
            CourseNAReportDS_CNAR.fetchDataURL = needsAssessmentReportsUrl + "/courseNA?courseId=" + CourseLG_CNAR.getSelectedRecord().id + "&passedReport=true";
            refreshLG_CNAR();
        }
    }

    //</script>