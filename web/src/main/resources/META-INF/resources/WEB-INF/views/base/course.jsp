<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
//<script>

    var testData = [];
    var test1;
    var courseCacheData = [];

    var courseId = "";
    var runV = "";
    var eLevelTypeV = "";
    var etechnicalTypeV = "";
    var etheoTypeV = "";
    var course_method = "";
    var count = "";
    var x;
    var ChangeEtechnicalType = false;
    var chang = false;
    var course_url = courseUrl;
    var RestDataSource_category = isc.MyRestDataSource.create({
        ID: "categoryDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ], dataFormat: "json",
        fetchDataURL: categoryUrl + "spec-list",
        autoFetchData: true,
    });
    var RestDataSource_course = isc.MyRestDataSource.create({
        ID: "courseDS",
        fields: [{name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            {name: "knowledge"},
            {name: "skill"},
            {name: "attitude"},
            // {name: "version"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });
    var RestDataSource_eTechnicalType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTechnicalType/spec-list",
        autoFetchData: true,
    });
    var RestDataSource_e_level_type = isc.MyRestDataSource.create({
        autoCacheAllData: false,
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLevelType",
        autoFetchData: true,
    });
    var RestDataSource_e_run_type = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eRunType/spec-list",
// cacheAllData:true,
        autoFetchData: true,
    });
    var RestDataSourceETheoType = isc.MyRestDataSource.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTheoType",
// cacheAllData:true,
        autoFetchData: true,
    });
    var RestDataSourceSubCategory = isc.MyRestDataSource.create({

        fields: [{name: "id"}, {name: "titleFa"}, {name: "code"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",

    });
    var RestDataSource_CourseGoal = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"}],
        fetchDataURL: goalUrl + "spec-list"
    });
    var RestDataSource_CourseSkill = isc.MyRestDataSource.create({
        fields: [
            {name: "id"}, {name: "titleFa"}, {name: "titleEn"}
        ], dataFormat: "json",

        fetchDataURL: courseUrl + "skill/" + courseId.id
    });
    var RestDataSource_CourseJob = isc.MyRestDataSource.create({
        fields: [
            {name: "id"}, {name: "titleFa"}, {name: "titleEn"}
        ],

        fetchDataURL: courseUrl + "job/" + courseId.id
    });
    var RestDataSource_Syllabus = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "goal.titleFa"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "edomainType.titleFa"},
            {name: "practicalDuration"}
        ],

        fetchDataURL: syllabusUrl + "spec-list"
    });
    var RestDataSource_CourseCompetence = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"}
        ],

        fetchDataURL: courseUrl + "getcompetence/" + courseId.id
    });
    var RestDataSourceEducation = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"}
        ],

        fetchDataURL: courseUrl + "getlistEducationLicense",
    });
    var Menu_ListGrid_course = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code="refresh"/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Course_refresh();
                ListGrid_CourseJob.setData([]);
                ListGrid_CourseSkill.setData([]);
                ListGrid_CourseSyllabus.setData([]);
                ListGrid_CourseGoal.setData([]);
                ListGrid_CourseCompetence.setData([]);
            }
        }, {
            title: "<spring:message code="create"/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Course_add();
            }
        }, {
            title: "<spring:message code="edit"/>", icon: "pieces/16/icon_edit.png", click: function () {

                DynamicForm_course.clearValues();
                ListGrid_Course_Edit();
            }
        }, {
            title: "<spring:message code="remove"/>", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Course_remove()
            }
        },
            // {
            // title: "تعریف هدف و سرفصل", icon: "pieces/16/goal.png", click: function () {
            // openTabGoal();
            // }
            //        },
            {isSeparator: true}, {
                title: "<spring:message code="print.pdf"/>", icon: "icon/pdf.png", click: function () {
                    print_CourseListGrid("pdf");
                }
            }, {
                title: "<spring:message code="print.excel"/>", icon: "icon/excel.png", click: function () {
                    print_CourseListGrid("excel");
                }
            }, {
                title: "<spring:message code="print.html"/>", icon: "icon/html.jpg", click: function () {
                    print_CourseListGrid("html");
                }
            }]
    });
    var ListGrid_Course = isc.MyListGrid.create({
        ID: "gridCourse",
        dataSource: "courseDS",
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_course,
        allowAdvancedCriteria: true,
        doubleClick: function () {
            DynamicForm_course.clearValues();
            ListGrid_Course_Edit()
        },
        selectionChanged: function (record, state) {
            courseId = record;
            // RestDataSource_CourseGoal.fetchDataURL = courseUrl + courseId.id + "/goal";
            // ListGrid_CourseGoal.fetchData();
            // ListGrid_CourseGoal.invalidateCache();
            RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
            ListGrid_CourseSyllabus.fetchData();
            ListGrid_CourseSyllabus.invalidateCache();
            RestDataSource_CourseSkill.fetchDataURL = courseUrl + "skill/" + courseId.id;
            ListGrid_CourseSkill.fetchData();
            ListGrid_CourseSkill.invalidateCache();
            // RestDataSource_CourseJob.fetchDataURL = courseUrl + "job/" + courseId.id;
            // ListGrid_CourseJob.fetchData();
            // ListGrid_CourseJob.invalidateCache();
            // RestDataSource_CourseCompetence.fetchDataURL = courseUrl + "getcompetence/" + courseId.id;
            // ListGrid_CourseCompetence.fetchData();
            // ListGrid_CourseCompetence.invalidateCache();
            for (i = 0; i < mainTabSet.tabs.length; i++) {
                if ("اهداف" == (mainTabSet.getTab(i).title).substr(0, 5)) {
                    mainTabSet.getTab(i).setTitle("اهداف دوره " + record.titleFa);
                }
            }
            // sumCourseTime = ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration;
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code="corse_code"/>", align: "center", filterOperator: "contains"},
            {
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "category.titleFa", title: "<spring:message
        code="course_category"/>", align: "center", filterOperator: "contains"
            },
            {
                name: "subCategory.titleFa", title: "<spring:message
        code="course_subcategory"/>", align: "center", filterOperator: "contains"
            },
            {
                name: "erunType.titleFa",
                title: "<spring:message code="course_eruntype"/>",
                align: "center",
                filterOperator: "contains",
                allowFilterOperators: false,
                canFilter: false

            },
            {
                name: "elevelType.titleFa", title: "<spring:message
        code="cousre_elevelType"/>", align: "center", filterOperator: "contains",
                canFilter: false
            },
            {
                name: "etheoType.titleFa", title: "<spring:message
        code="course_etheoType"/>", align: "center", filterOperator: "contains",
                canFilter: false
            },
            {
                name: "theoryDuration", title: "<spring:message
                code="course_theoryDuration"/>", align: "center", filterOperator: "contains",

            },
            {
                name: "etechnicalType.titleFa", title: "<spring:message
                 code="course_etechnicalType"/>", align: "center", filterOperator: "contains",
                canFilter: false
            },
            {
                name: "minTeacherDegree", title: "<spring:message
        code="course_minTeacherDegree"/>", align: "center", filterOperator: "contains"
            },
            {
                name: "minTeacherExpYears", title: "<spring:message
        code="course_minTeacherExpYears"/>", align: "center", filterOperator: "contains"
            },
            {
                name: "minTeacherEvalScore", title: "<spring:message
        code="course_minTeacherEvalScore"/>", align: "center", filterOperator: "contains"
            },
            {name: "knowledge", title: "دانشی", align:"center",filterOperator: "greaterThan", format: "%"
                // formatCellValue: function (value, record) {
                //     // if (!isc.isA.Number(record.gdp) || !isc.isA.Number(record.population)) return "N/A";
                //     var gdpPerCapita = Math.round(record.theoryDuration/10);
                //     return isc.NumberUtil.format(gdpPerCapita, "%");
                // }
            },
            {name: "skill", title: "مهارتی", align:"center",filterOperator: "greaterThan", format: "%"},
            {name: "attitude", title: "نگرشی", align:"center",filterOperator: "greaterThan", format: "%"},
            // {name: "version", title: "version", canEdit: false, hidden: true},
            // {name: "goalSet", hidden: true}
        ],
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
    });
    var ListGrid_CourseSkill = isc.MyListGrid.create({
        dataSource: RestDataSource_CourseSkill,
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
    });
    var ListGrid_CourseJob = isc.MyListGrid.create({

        dataSource: RestDataSource_CourseJob,
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
    });
    var ListGrid_CourseCompetence = isc.MyListGrid.create({
        dataSource: RestDataSource_CourseCompetence,
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center"}
        ],
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
    });
    var ListGrid_CourseSyllabus = isc.MyListGrid.create({

        dataSource: RestDataSource_Syllabus,
        groupByField:"goal.titleFa", groupStartOpen:"none",
        showGridSummary:true,
        showGroupSummary:true,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "goal.titleFa", title: "نام هدف", align: "center"},
            {name: "titleFa", title: "<spring:message code="course_syllabus_name"/>", align: "center"},
            {name: "edomainType.titleFa", title: "<spring:message code="course_domain"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center", hidden:true},
            {name: "practicalDuration", title: "<spring:message code="course_Running_time"/>", align: "center", summaryFunction:"sum",type:"integer", format: "# ساعت "},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
    });
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code="refresh"/> ",

        click: function () {
            ListGrid_Course_refresh();
            ListGrid_CourseJob.setData([]);
            ListGrid_CourseSkill.setData([]);
            ListGrid_CourseSyllabus.setData([]);
            ListGrid_CourseGoal.setData([]);
            ListGrid_CourseCompetence.setData([]);
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/> ",
        click: function () {
            DynamicForm_course.getItem("category.id").setDisabled(true);
            DynamicForm_course.getItem("subCategory.id").setDisabled(true);
            DynamicForm_course.getItem("erunType.id").setDisabled(true);
            DynamicForm_course.getItem("elevelType.id").setDisabled(true);
            DynamicForm_course.getItem("etheoType.id").setDisabled(true);
            DynamicForm_course.clearValues();
            ListGrid_Course_Edit()
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",

        click: function () {
            // DynamicForm_course.getItem("category.id").setDisabled(false);
            // DynamicForm_course.getItem("subCategory.id").setDisabled(false);
            // DynamicForm_course.getItem("erunType.id").setDisabled(false);
            // DynamicForm_course.getItem("elevelType.id").setDisabled(false);
            // DynamicForm_course.getItem("etheoType.id").setDisabled(false);
            // DynamicForm_course.clearValues();

            ListGrid_Course_add();
        }
    });
    var ToolStripButton_OpenTabGoal = isc.ToolStripButton.create({
        icon: "pieces/16/goal.png",
        title: "<spring:message code="create_Goal_Syllabus"/>",
        click: function () {
            openTabGoal();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/> ",
        click: function () {
            ListGrid_Course_remove()
        }
    });
    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            print_CourseListGrid("pdf");
        }
    });
    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print, ToolStripButton_OpenTabGoal]
    });





    isc.ClassFactory.defineClass("ListGridItem", "CanvasItem");
    isc.ListGridItem.addProperties({
        height:"*", width:"*",
        colSpan:"*", endRow:true, startRow:true,

        // this is going to be an editable data item
        shouldSaveValue:true,

        // Implement 'createCanvas' to build a ListGrid from which the user may
        // select items.
        createCanvas : function () {
            return isc.ListGrid.create({
                autoDraw:false,
                // fill the space the form allocates to the item
                width:this.width, height:this.height,
                leaveScrollbarGaps:false,
                // dataSource and fields to use, provided to a listGridItem as
                // listGridItem.gridDataSource and optional gridFields
                dataSource:this.gridDataSource,
                fields:this.gridFields,
                autoFetchData:true,


                canAcceptDroppedRecords: this.canAcceptDroppedRecords,
                canDragRecordsOut: this.canDragRecordsOut,
                dragDataAction: this.dragDataAction,
                // sortField: "id",
                canRemoveRecords: this.canRemoveRecords,
                filterOnKeypress: true,
                showFilterEditor: true,
                align : "center",
                alternateRecordStyles: true,
                sortFieldAscendingText: "مرتب سازي صعودي",
                sortFieldDescendingText: "مرتب سازي نزولي",
                removeRecordClick : function (rowNum) {
                    var record = this.getRecord(rowNum);
                    this.removeData(record, function (dsResponse, data, dsRequest) {
                        // Update `employeesGrid` now that an employee has been removed from
                        // the selected team.  This will add the employee back to `employeesGrid`,
                        // the list of employees who are not in the team.
                        // mockAddEmployeesFromTeamMemberRecords(record);
                    });
                },



                dataArrived : function () {
                    this.canvasItem.showValue(null, this.canvasItem.getValue());
                },
                selectionUpdated : function (record) {
                    var item = this.canvasItem;
                    if (record == null) item.storeValue(null);
                    else item.storeValue(record[item.name]);
                }
            });
        },

        // implement showValue to update the ListGrid selection
        showValue : function (displayValue, dataValue) {
            if (this.canvas == null) return;
            var record = this.canvas.data.find(this.name, dataValue);
            if (record) this.canvas.selection.selectSingle(record);
            else this.canvas.selection.deselectAll();
        }
    });




    var DynamicForm_course = isc.MyDynamicForm.create({
        ID: "DF_course",
        colWidths: [60, "*"],
        // height: "90%",
        // align: "center",
        titleAlign: "left",
        showInlineErrors: true,
        numCols: 6,
        // isGroup: true,
        fields: [
            {
                defaultValue: "اطلاعات دوره", type: "section", sectionExpanded: true,
                itemIds: ["titleFa", "titleEn", "theoryDuration","category.id","subCategory.id","erunType.id","elevelType.id","etheoType.id","etechnicalType.id","description","mainObjective"]
            },
            {name: "id", hidden: true},
            {
                colSpan: 1,
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                length: "250",
                required: true,
                type: 'text',
                width: "300",
                // height: "30",
                validators: [MyValidators.NotEmpty, MyValidators.NotStartWithSpecialChar, MyValidators.NotStartWithNumber]
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                colSpan: 1,
                length: "250",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9|' ']",
                // height: "30",
                width: "300",
                validators: [MyValidators.NotEmpty, MyValidators.NotStartWithSpecialChar, MyValidators.NotStartWithNumber]
            },
            {
                name: "code",
                title: "<spring:message code="corse_code"/>",
                type: 'text',
                length: "100",
                // width: "*",
                // height: "30",
                hidden: true,

            },
            {
                name: "theoryDuration",
                colSpan: 1,
                title: "<spring:message code="course_theoryDuration"/>",
                prompt: "لطفا طول دوره را به صورت یک عدد وارد کنید",
                // height: "30",
                required: true,
                type: "integer",
                textAlign: "center",
                keyPressFilter: "[0-9]",
                requiredMessage: "لطفا طول دوره را به صورت یک عدد با حداکثر طول سه رقم وارد کنید",
                validators: [{
                    type: "integerRange", min: 1, max: 999,
                    errorMessage: "حداکثر یک عدد سه رقمی وارد کنید",
                }],
                width: "100",
            },
            {
                name: "category.id",
                colSpan: 1,
                title: "<spring:message code="course_category"/>",
                textAlign: "center",
                autoFetchData: true,
                required: true,
                // height: "30",
                width: "200",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {

                    DynamicForm_course.getItem("subCategory.id").setDisabled(false);
                    DynamicForm_course.getItem("subCategory.id").setValue();
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                    DynamicForm_course.getItem("subCategory.id").fetchData();

                },
            },
            {
                name: "subCategory.id",
                colSpan: 1,

                title: "<spring:message code="course_subcategory"/>",
                editorType: "MyComboBoxItem",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                required: true,
                // height: "30",
                width: "200",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {

                },
            },
            {
                name: "erunType.id",
                colSpan: 1,

                title: "<spring:message code="course_eruntype"/>",
                //   value: "erunTypeId",
                required: true,
                editorType: "MyComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSource_e_run_type,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["id"],
                // height: "30",
                width: "200",
                changed: function (form, item, value) {

                    switch (value) {
                        case 1:
                            runV = "C";
                            break;
                        case 2:
                            runV = "D";
                            break;
                        case 3:
                            runV = "S";
                            break;
                        case 4:
                            runV = "H";
                            break;
                        case 5:
                            runV = "J";
                            break;
                    }

                }
            },
            {
                name: "elevelType.id",
                colSpan: 1,

                value: "eLevelTypeId",
                title: "<spring:message code="cousre_elevelType"/>",
                editorType: "MyComboBoxItem",
                textAlign: "center",
                required: true,
                // height: "30",
                width: "200",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_e_level_type,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                changed: function (form, item, value) {
                    switch (value) {
                        case 1:
                            eLevelTypeV = "1";
                            break;
                        case 2:
                            eLevelTypeV = "2";
                            break;
                        case 3:
                            eLevelTypeV = "3";
                            break;
                    }

                },
            },
            {
                name: "etheoType.id",
                colSpan: 1,

                title: "<spring:message code="course_etheoType"/>",
                required: true,
                editorType: "MyComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSourceETheoType,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["id"],
                // height: "30",
                width: "200",
                changed: function (form, item, value) {
                    switch (value) {
                        case 1:
                            etheoTypeV = "T";
                            break;
                        case 2:
                            etheoTypeV = "P";
                            break;
                        case 3:
                            etheoTypeV = "M";
                            break;
                    }

                },

            },
            {
                name: "etechnicalType.id",
                colSpan: 1,

                title: "<spring:message code="course_etechnicalType"/>",
                editorType: "MyComboBoxItem",
                textAlign: "center",
                required: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_eTechnicalType,
                sortField: ["id"],
                width: "200",
                // height: "30",
                changed: function (form, item, value) {
                    ChangeEtechnicalType = true;
                    switch (value) {
                        case 1:
                            eLevelTypeV = "1";
                            break;
                        case 2:
                            eLevelTypeV = "2";
                            break;
                        case 3:
                            eLevelTypeV = "3";
                            break;
                    }

                },
            },
            {
                name: "description",
                type: "textArea",
                colSpan: 3,
                height: "50",
                titleOrientation: "top",
                title: "<spring:message code="course_description"/>",
                width: "600",
                length: 5000,

            },
            {
                name: "mainObjective",
                titleOrientation: "top",
                title: "<spring:message code="course_mainObjective"/>",
                colSpan: 3,
                readonly: true,
                type: "textArea",
                height: "50",
                width: "650",
                length: "500",
                required: true,

            },
            {
                defaultValue: "اطلاعات مدرس دوره", type: "section", sectionExpanded: true,
                itemIds: ["minTeacherDegree","minTeacherExpYears","minTeacherEvalScore"]
            },
            {
                name: "minTeacherDegree",
                colSpan: 1,

                title: "<spring:message code="course_minTeacherDegree"/>",
                editorType: "MyComboBoxItem",
                autoFetchData: true,
                required: true,
                // height: "30",
                width: "200",
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSourceEducation,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {
                    RestDataSourceEducation.fetchDataURL = courseUrl + "getlistEducationLicense";
                },
            },
            {
                name: "minTeacherExpYears",
                colSpan: 1,

                title: "<spring:message code="course_minTeacherExpYears"/>",
                prompt: "لطفا حداقل سال سابقه تدریس وارد کنید",
                // shouldSaveValue: true,
                textAlign: "center",
                type: "integer",
                required: true,
                validators: [{
                    type: "integerRange", min: 1, max: 15,
                    errorMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",
                }],
                // height: "30",
                width: "200",
                keyPressFilter: "[0-9]",
                requiredMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",
            },
            {
                name: "minTeacherEvalScore",
                colSpan: 1,

                title: "<spring:message code="course_minTeacherEvalScore"/>",
                prompt: "لطفا حداقل نمره ارزیابی را وارد کنید",
                shouldSaveValue: true,
                textAlign: "center",
                type: "integer",
                writeStackedIcons: true,
                // height: "30",
                required: true,
                width: "200",
                keyPressFilter: "[0-9]",
                requiredMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",
                validators: [{
                    type: "integerRange", min: 65, max: 100,
                    errorMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",
                }]
            },
            {
                defaultValue: "پیشنیاز دوره", type: "section", sectionExpanded: false,
                itemIds: ["courseAllGrid","imgMove","preCourseGrid"]
            },
            {name:"courseAllGrid",
                ID: "courseAllGrid",
                title:"دوره ها",
                align: "center",
                colSpan: 2,
                rowSpan:3,
                width: "400",
                titleOrientation: "top",
                editorType:"ListGridItem",
                height: "300",
                allowAdvancedCriteria: true,
                gridDataSource:"courseDS",
                gridFields:[ {name:"titleFa",title:"نام دوره"}],
                hidden: false,
                canRemoveRecords:false,
                canDragRecordsOut: true,
                dragDataAction: "none"
            },
            {name:"imgMove",
                colSpan: 1,
                align: "center",
                rowSpan:3,
                title:"",
                type:"button",
                icon:"pieces/512/back2.png",
                click:function() {
                    isc.say("courseAllGrid".getSelectedRecord().titleFa);
                }
            },
            {name:"preCourseGrid",
                ID : "preCourseGrid",
                title:"پیش نیازهای دوره",
                colSpan:2,
                align: "center",
                rowSpan:3,
                titleOrientation: "top",
                editorType:"ListGridItem",
                height: "300",
                width: "400",
                gridDataSource:"preCourseDS",
                gridFields:[ {name:"titleFa",title:"نام دوره"}],
                canRemoveRecords:true,
                canDragRecordsOut: false,
                canAcceptDroppedRecords: true,
                dragDataAction: "none"
            }
        ],
    });


    var IButton_course_Save = isc.IButton.create({
        title: "<spring:message code="save"/>",
        icon: "pieces/16/save.png",
        click: function () {
            DynamicForm_course.validate();
            if (DynamicForm_course.hasErrors()) {
                return;
            }
            var y = (DynamicForm_course.getItem('subCategory.id').getSelectedRecord().code);
            x = y + runV + eLevelTypeV + etheoTypeV;
//------------------------------------
            if (course_method == "POST") {
                isc.RPCManager.sendRequest({
                    actionURL: courseUrl + "getmaxcourse/" + x,
                    httpMethod: "GET",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    serverOutputAsString: false,
                    callback: function (resp) {
                        var newCourseCounter = courseCounterCode(resp.data);
                        x = x + newCourseCounter;
                        DynamicForm_course.getItem('code').setValue(x);
                        var data1 = DynamicForm_course.getValues();

                        var idList=[];
                        for (var i = 0; i <testData.length ; i++) {
                            idList.add(testData[i].id);
                        }
                        data1.preCourse = idList;
                        console.log(data1);
                        isc.RPCManager.sendRequest({
                            actionURL: course_url,
                            httpMethod: course_method,
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(data1),
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                    Window_course.close();
                                    ListGrid_Course_refresh();
                                } else {
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");

                                }

                            }
                        });
                    }
                });
            }//end if
            else if ((course_method == "PUT" && DynamicForm_course.valuesHaveChanged()) || (course_method == "PUT" && ChangeEtechnicalType == true)) {
                var data1 = DynamicForm_course.getValues();
                ChangeEtechnicalType = false;
                isc.RPCManager.sendRequest({
                    actionURL: course_url,
                    httpMethod: course_method,
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    data: JSON.stringify(data1),
                    serverOutputAsString: false,
                    callback: function (resp) {

                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                            simpleDialog("<spring:message code="edit"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");

                            Window_course.close();
                            ListGrid_Course_refresh();
                        } else {

                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");

                        }

                    }
                });
            } else {
                simpleDialog("<spring:message code="edit"/>", "<spring:message code="course_noEdit"/>", 3000, "say");
                Window_course.close();
            }//end else
//-----------------------------------------------

        }
    });
    var courseSaveOrExitHlayout = isc.HLayout.create({

        width: "100%",
        align: "center",
        alignLayout: "center",
        membersMargin: 15,
        autoDraw: false,
        // defaultLayoutAlign: "center",
        members: [IButton_course_Save, isc.IButton.create({
            ID: "EditExitIButton",
            title: "<spring:message code="cancel"/>",
            prompt: "",
            icon: "pieces/16/icon_delete.png",
            // orientation: "vertical",
            click: function () {
                Window_course.close();
            }
        })]
    });


    isc.DataSource.create({
        ID:"preCourseDS",
        clientOnly:true,
        testData:testData,
        fields:[
            {name: "id",type: "integer", primaryKey:true},
            // {name: "code"},
            {name: "titleFa", type: "text", title:"نام دوره"}
            // {name: "titleEn"},
            // {name: "category.titleFa"},
            // {name: "subCategory.titleFa"},
            // {name: "erunType.titleFa"},
            // {name: "elevelType.titleFa"},
            // {name: "etheoType.titleFa"},
            // {name: "theoryDuration"},
            // {name: "etechnicalType.titleFa"},
            // {name: "minTeacherDegree"},
            // {name: "minTeacherExpYears"},
            // {name: "minTeacherEvalScore"},
            // {name: "knowledge"},
            // {name: "skill"},
            // {name: "attitude"},
        ]
    });



    // isc.ListGrid.create({
    //     ID: "employeesGrid",
    //     width:300, height:224,
    //     canDragRecordsOut: true,
    //     dragDataAction: "none",
    //     // dragType: "nonTeamMemberEmployee",
    //     autoFetchData: true,
    //     sortField: "id",
    //     dataSource: "courseDS",
    //     fields:[
    //         {name: "id", title:"ID", primaryKey:true, width:50},
    //         {name: "titleFa", title: "Employee Name"}
    //     ]
    // });
    // isc.ListGrid.create({
    //     ID: "teamMembersGrid",
    //     width:350, height:264,
    //     canAcceptDroppedRecords: true,
    //     // dropTypes: ["nonTeamMemberEmployee"],
    //     canRemoveRecords: true,
    //     autoFetchData: true,
    //     sortField: "id",
    //     dataSource: "preCourseDS",
    //     fields:[
    //         {name: "id", title:"EID", width:"20%"},
    //         {name: "titleFa", title: "Employee Name", width:"40%"}
    //     ],
    //     // recordDrop : function (dropRecords, targetRecord, index, sourceWidget) {
    //     //     // mockRemoveEmployees(dropRecords);
    //     //     return this.Super("recordDrop", arguments);
    //     // },
    //     removeRecordClick : function (rowNum) {
    //         var record = this.getRecord(rowNum);
    //         this.removeData(record, function (dsResponse, data, dsRequest) {
    //             // Update `employeesGrid` now that an employee has been removed from
    //             // the selected team.  This will add the employee back to `employeesGrid`,
    //             // the list of employees who are not in the team.
    //             // mockAddEmployeesFromTeamMemberRecords(record);
    //         });
    //     }
    // });

    // isc.LayoutSpacer.create({
    //     ID: "spacer",
    //     height: 30
    // });

    // isc.Img.create({
    //     ID: "arrowImg",
    //     layoutAlign:"center",
    //     width: 32,
    //     height: 32,
    //     src: "icons/32/arrow_right.png",
    //     click : function () {
    //         var selectedEmployeeRecords = employeesGrid.getSelectedRecords();
    //         teamMembersGrid.transferSelectedData(employeesGrid);
    //         mockRemoveEmployees(selectedEmployeeRecords);
    //     }
    // });

    // isc.VStack.create({
    //     ID: "vStack",
    //     members: [spacer, employeesGrid]
    // });

    // isc.VStack.create({
    //     ID: "vStack2",
    //     members: [teamMembersGrid]
    // });

    // isc.HStack.create({
    //     ID: "hStack",
    //     height: 160,
    //     members: [vStack, arrowImg, vStack2]
    // });



    var Window_course = isc.Window.create({
        width: "90%",
        autoSize: true,
        canDragReposition: false,
        autoCenter: true,
        align: "center",
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_course,courseSaveOrExitHlayout]
        })]
    });
    // var VLayout_Grid_Goal = isc.VLayout.create({
    //     width: "30%",
    //     height: "100%",
    //     members: [ListGrid_CourseGoal]
    // });
    var VLayout_Grid_Syllabus = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_CourseSyllabus]
    });
    var HLayout_Actions_Course = isc.HLayout.create({
        width: "100%",
        height: "5%",
        members: [ToolStrip_Actions]
    });
    var HLayout_Grid_Course = isc.HLayout.create({
        width: "100%",
        height: "50%",
        showResizeBar: true,
        members: [ListGrid_Course]
    });
    var HLayout_Tab_Course_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            VLayout_Grid_Syllabus
        ]
    });
    var HLayout_Tab_Course_Skill = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_CourseSkill
        ]
    });
    var HLayout_Tab_Course_Job = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_CourseJob
        ]
    });
    var HLayout_Tab_Course_Competence = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_CourseCompetence]
    });
    var Detail_Tab_Course = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Goal_Syllabus",
                title: "<spring:message code="course_syllabus_goal"/>",
                pane: HLayout_Tab_Course_Goal
            },
            {
                id: "TabPane_Skill",
                title: "<spring:message code="course_skill"/>",
                pane: HLayout_Tab_Course_Skill

            },
            {
                id: "TabPane_Job",
                title: "<spring:message code="course_job"/>",
                pane: HLayout_Tab_Course_Job
            },
            {
                id: "TabPane_Competence",
                title: "<spring:message code="course_compatency"/>",
                pane: HLayout_Tab_Course_Competence
            }
        ]
    });
    var HLayout_Tab_Course = isc.HLayout.create({
        width: "100%",
        height: "50%",

        members: [Detail_Tab_Course]
    });
    var VLayout_Body_Course = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_Course, HLayout_Grid_Course, HLayout_Tab_Course]
    });

    function ListGrid_Course_refresh() {
        ListGrid_Course.invalidateCache();
        for (j = 0; j < mainTabSet.tabs.length; j++) {
            if (mainTabSet.getTab(j).title.substr(0, 5) == "اهداف") {
                mainTabSet.removeTab(j);
            }
        }
    };

    function ListGrid_Course_add() {
        DynamicForm_course.getItem("category.id").setDisabled(false);
        DynamicForm_course.getItem("subCategory.id").setDisabled(false);
        DynamicForm_course.getItem("erunType.id").setDisabled(false);
        DynamicForm_course.getItem("elevelType.id").setDisabled(false);
        DynamicForm_course.getItem("etheoType.id").setDisabled(false);
        course_method = "POST";
        course_url = courseUrl;
        DynamicForm_course.clearValues();
        DynamicForm_course.getItem("subCategory.id").setDisabled(true);
        Window_course.setTitle("<spring:message code="create"/>");

        Window_course.show();
        DynamicForm_course.getFields().get(5).prompt = "لطفا طول دوره را به صورت یک عدد وارد کنید";
    };

    function ListGrid_Course_remove() {
        var record = ListGrid_Course.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message
        code="course_delete"/>" + " " + getFormulaMessage(record.titleFa, 3, "red", "I") + " " + "<spring:message
        code="course_delete1"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="yes"/>"}), isc.Button.create({
                    title: "<spring:message code="no"/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        isc.RPCManager.sendRequest({
                            actionURL: courseUrl + "deleteCourse/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {

                                if (resp.data == "true") {
                                    ListGrid_Course_refresh();
                                    ListGrid_CourseJob.setData([]);
                                    ListGrid_CourseSkill.setData([]);
                                    ListGrid_CourseSyllabus.setData([]);
                                    ListGrid_CourseGoal.setData([]);
                                    ListGrid_CourseCompetence.setData([]);
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code="msg.record.remove.successful"/>",

                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code="msg.command.done"/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code="course_record.remove.failed"/>",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code="error"/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }
    };

    function ListGrid_Course_Edit() {
        DynamicForm_course.getItem("category.id").setDisabled(true);
        DynamicForm_course.getItem("subCategory.id").setDisabled(true);
        DynamicForm_course.getItem("erunType.id").setDisabled(true);
        DynamicForm_course.getItem("elevelType.id").setDisabled(true);
        DynamicForm_course.getItem("etheoType.id").setDisabled(true);

        var sRecord = ListGrid_Course.getSelectedRecord();

        if (sRecord == null || sRecord.id == null) {

// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            course_method = "PUT";
            course_url = courseUrl + sRecord.id;
            DynamicForm_course.clearValues();
            RestDataSourceSubCategory.fetchDataURL = categoryUrl + sRecord.category.id + "/sub-categories";
            DynamicForm_course.getItem("subCategory.id").fetchData();
            DynamicForm_course.editRecord(sRecord);
            Window_course.setTitle("<spring:message code="edit"/>");
            Window_course.show();
            DynamicForm_course.getFields().get(5).prompt = "  جمع مدت زمان اجرای سرفصل ها "+(ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration).toString()+" ساعت می باشد."
        }
    };

    function openTabGoal() {
        if (ListGrid_Course.getSelectedRecord() == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            createTab("<spring:message code="course_goal_of_syllabus"/>" + " " + courseId.titleFa, "goal/show-form?courseId=" + courseId.id, false);
        }
    }

    function print_CourseListGrid(type) {
        var advancedCriteria_course = ListGrid_Course.getCriteria();
        var criteriaForm_course = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/course/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        })
        criteriaForm_course.setValue("CriteriaStr", JSON.stringify(advancedCriteria_course));
        criteriaForm_course.submitForm();
    };



    function mockRemoveEmployees (employeeRecords) {
        if (employeeRecords.length == 0) {
            return;
        }
        // var dsRequest = {
        //     ID: "mockRemoveResponse",
        //     operationType: "remove",
        //     data: employeeRecords
        // }
        // testData.add({id:employeesGrid.getSelectedRecord().id,titleFa:employeesGrid.getSelectedRecord().titleFa});
        teamMembersGrid.invalidateCache();
        // employeesByTeam.updateCaches(dsRequest);
    }


    function mappedByListId(listId,listGrid,DS) {
        var listGridRecord = listGrid.getData().allRows;
        for (var i = 0; i < listId.length ; i++) {
            for(var j = 0; j < listGridRecord.length ; i++) {
                if(listId[i] == listGridRecord[j].id){
                    DS.addData(listGridRecord[j]);
                    break;
                }
            }
        }
    }

    function x(data) {
        console.log(data);
        test = data;
    }
//</script>