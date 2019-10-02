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
    var equalCourse = [];
    var preCourseIdList = [];
    var equalPreCourse = [];
    var equalCourseIdList = [];
    // var test1;
    // var courseCacheData = [];
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
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", type: "text"}
        ], dataFormat: "json",
        fetchDataURL: categoryUrl + "spec-list",
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
            {name: "needText"},
            {name: "description"}
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
    var RestDataSourceSubCategory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ]
    });
    var RestDataSource_CourseGoal = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"}],
        // fetchDataURL: courseUrl + courseId.id + "/goal"
    });
    var RestDataSource_CourseSkill = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ], dataFormat: "json",

        fetchDataURL: courseUrl + "skill/" + courseId.id
    });
    var RestDataSource_CourseJob = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
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
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"}
        ],

        // fetchDataURL: courseUrl + "getcompetence/" + courseId.id
    });
    var RestDataSourceEducationCourseJsp = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],

        fetchDataURL: educationUrl + "level/" + "spec-list",
    });
    var Menu_ListGrid_course = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code="refresh"/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Course_refresh();
                ListGrid_CourseJob.setData([]);
                ListGrid_CourseSkill.setData([]);
                ListGrid_CourseSyllabus.setData([]);
                // ListGrid_CourseGoal.setData([]);
                // ListGrid_CourseCompetence.setData([]);
            }
        }, {
            title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Course_add();
            }
        }, {
            title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Course_Edit();
            }
        }, {
            title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Course_remove()
            }
        }
            <%--, {--%>
            <%--title: "تعریف هدف و سرفصل", icon: "<spring:url value="goal.png"/>", click: function () {--%>
            <%--openTabGoal();--%>
            <%--}--%>
            <%--}--%>
            , {
                isSeparator: true
            }, {
                title: "<spring:message code="print.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                    print_CourseListGrid("pdf");
                }
            }, {
                title: "<spring:message code="print.excel"/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    print_CourseListGrid("excel");
                }
            }, {
                title: "<spring:message code="print.html"/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    print_CourseListGrid("html");
                }
            },
            <%--{--%>
            <%--title: "چاپ با جزییات", icon: "<spring:url value="print.png"/>", click: function() {--%>
            <%--window.open("course/testCourse/"+ListGrid_Course.getSelectedRecord().id+"/pdf");}--%>
            <%--}--%>
        ]
    });
    var ListGrid_Course = isc.MyListGrid.create({
        ID: "gridCourse",
        dataSource: "courseDS",
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_course,
        allowAdvancedCriteria: true,
        hoverWidth: "30%",
        hoverHeight: "30%",
        hoverMoveWithMouse: true,
        canHover: false,
        showHover: false,
        showHoverComponents: false,
        <%--getCellHoverComponent: function (record, rowNum, colNum) {--%>
        <%--equalPreCourse.length = 0;--%>
        <%--isc.RPCManager.sendRequest({--%>
        <%--actionURL: courseUrl + "equalCourse/" + record.id,--%>
        <%--httpMethod: "GET",--%>
        <%--httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
        <%--useSimpleHttp: true,--%>
        <%--contentType: "application/json; charset=utf-8",--%>
        <%--showPrompt: false,--%>
        <%--serverOutputAsString: false,--%>
        <%--callback: function (resp) {--%>
        <%--for (var i = 0; i < JSON.parse(resp.data).length; i++) {--%>
        <%--equalPreCourseDS.addData(JSON.parse(resp.data)[i]);--%>
        <%--}--%>
        <%--}--%>
        <%--});--%>
        <%--this.rowHoverComponent = isc.ListGrid.create({--%>
        <%--dataSource: equalPreCourseDS,--%>
        <%--autoFetchData: true,--%>
        <%--});--%>
        <%--return this.rowHoverComponent;--%>
        <%--},--%>

        doubleClick: function () {
            DynamicForm_course.clearValues();
            ListGrid_Course_Edit()
        },
        selectionChanged: function (record, state) {
            courseId = record;
            RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
            ListGrid_CourseSyllabus.fetchData();
            ListGrid_CourseSyllabus.invalidateCache();
            // RestDataSource_CourseGoal.fetchDataURL = courseUrl + courseId.id + "/goal";
            // ListGrid_Goal.fetchData();
            // ListGrid_Goal.invalidateCache();
            // ListGrid_Syllabus_Goal_refresh();
            RestDataSource_CourseSkill.fetchDataURL = courseUrl + "skill/" + courseId.id;
            ListGrid_CourseSkill.fetchData();
            ListGrid_CourseSkill.invalidateCache();
            RestDataSource_CourseJob.fetchDataURL = courseUrl + "job/" + courseId.id;
            ListGrid_CourseJob.fetchData();
            ListGrid_CourseJob.invalidateCache();
            RestDataSource_CourseCompetence.fetchDataURL = courseUrl + "skill-group/" + courseId.id;
            ListGrid_CourseCompetence.fetchData();
            ListGrid_CourseCompetence.invalidateCache();
            RestData_Post_JspCourse.fetchDataURL = courseUrl + "post/" + courseId.id;
            ListGrid_Post_JspCourse.fetchData();
            ListGrid_Post_JspCourse.invalidateCache();
            for (var i = 0; i < trainingTabSet.tabs.length; i++) {
                if ("اهداف" == (trainingTabSet.getTab(i).title).substr(0, 5)) {
                    trainingTabSet.getTab(i).setTitle("اهداف دوره " + record.titleFa);
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
                autoFitWidth: true,
                filterOperator: "contains",
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                align: "center",
                filterOperator: "contains",
                hidden: true
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
        code="course_minTeacherDegree"/>", align: "center", filterOperator: "contains", hidden: true
            },
            {
                name: "minTeacherExpYears", title: "<spring:message
        code="course_minTeacherExpYears"/>", align: "center", filterOperator: "contains", hidden: true
            },
            {
                name: "minTeacherEvalScore", title: "<spring:message
        code="course_minTeacherEvalScore"/>", align: "center", filterOperator: "contains", hidden: true
            },
            {
                name: "knowledge",
                title: "دانشی",
                align: "center",
                filterOperator: "greaterThan",
                format: "%",
                width: "50"
                // formatCellValue: function (value, record) {
                //     // if (!isc.isA.Number(record.gdp) || !isc.isA.Number(record.population)) return "N/A";
                //     var gdpPerCapita = Math.round(record.theoryDuration/10);
                //     return isc.NumberUtil.format(gdpPerCapita, "%");
                // }
            },
            {name: "skill", title: "مهارتی", align: "center", filterOperator: "greaterThan", format: "%", width: "50"},
            {
                name: "attitude",
                title: "نگرشی",
                align: "center",
                filterOperator: "greaterThan",
                format: "%",
                width: "50"
            },
            {name: "needText", title: "شرح", hidden: true},
            {name: "description", title: "توضیحات", hidden: true}
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
        showResizeBar: false,

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
        showResizeBar: false,

    });
    var ListGrid_CourseCompetence = isc.MyListGrid.create({
        dataSource: RestDataSource_CourseCompetence,
        fields: [
            {name: "id", title: "شماره", canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center"}
        ],
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
        showResizeBar: false,

    });
    var ListGrid_CourseSyllabus = isc.MyListGrid.create({

        dataSource: RestDataSource_Syllabus,
        groupByField: "goal.titleFa", groupStartOpen: "none",
        showGridSummary: true,
        showGroupSummary: true,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "goal.titleFa", title: "نام هدف", align: "center"},
            {name: "titleFa", title: "<spring:message code="course_syllabus_name"/>", align: "center"},
            {name: "edomainType.titleFa", title: "<spring:message code="course_domain"/>", align: "center"},
            {name: "titleEn", title: "<spring:message code="course_en_name"/>", align: "center", hidden: true},
            {
                name: "practicalDuration",
                title: "<spring:message code="course_Running_time"/>",
                align: "center",
                summaryFunction: "sum",
                format: "# ساعت "
            },
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        showResizeBar: false,

    });
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
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
            ListGrid_Course_Edit()
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",

        click: function () {
            ListGrid_Course_add();
        }
    });
    <%--var ToolStripButton_OpenTabGoal = isc.ToolStripButton.create({--%>
    <%--icon: "[SKIN]/actions/goal.png",--%>
    <%--title: "<spring:message code="create_Goal_Syllabus"/>",--%>
    <%--click: function () {--%>
    <%--openTabGoal();--%>
    <%--}--%>
    <%--});--%>
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
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });

    isc.ClassFactory.defineClass("ListGridItem", "CanvasItem");
    isc.ListGridItem.addProperties({
        height: "*", width: "*",
        colSpan: this.colSpan, endRow: this.endRow, startRow: this.startRow,

        // this is going to be an editable data item
        shouldSaveValue: true,

        // Implement 'createCanvas' to build a ListGrid from which the user may
        // select items.
        createCanvas: function () {
            return isc.ListGrid.create({
                ID: this.ID,
                autoDraw: false,
                // fill the space the form allocates to the item
                width: this.width, height: this.height,
                leaveScrollbarGaps: false,
                // dataSource and fields to use, provided to a listGridItem as
                // listGridItem.gridDataSource and optional gridFields
                dataSource: this.gridDataSource,
                fields: this.gridFields,
                autoFetchData: true,

//hamed
                canAcceptDroppedRecords: this.canAcceptDroppedRecords,
                canDragRecordsOut: this.canDragRecordsOut,
                dragDataAction: this.dragDataAction,
                selectionType: this.selectionType,
                allowAdvancedCriteria: this.allowAdvancedCriteria,
                sortField: "1",
                canRemoveRecords: this.canRemoveRecords,
                filterOnKeypress: this.filterOnKeypress,
                showFilterEditor: this.showFilterEditor,
// align : "center",
                alternateRecordStyles: true,
                sortFieldAscendingText: "مرتب سازي صعودي",
                sortFieldDescendingText: "مرتب سازي نزولي",
                selectionChanged: function (record, state) {
                    if (this.ID == "courseAllGrid") {
                        orBtn.enable();
                        // addPreCourseBtn.show();
                        orBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به معادل های دوره");
                        // addPreCourseBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به پیش نیازهای دوره");
                        if (equalCourseGrid.getSelectedRecord() != null) {
                            andBtn.enable();
                            andBtn.setTitle("افزودن " + "'" + record.titleFa + "'" + " و " + equalCourseGrid.getSelectedRecord().nameEC + " به معادل های دوره")
                        } else {
                            andBtn.disable();
                        }
                    }
                    if (this.ID == "courseAllGrid2") {
                        // orBtn.show();
                        addPreCourseBtn.enable();
                        // orBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به معادل های دوره");
                        addPreCourseBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به پیش نیازهای دوره");
                        // if (equalCourseGrid.getSelectedRecord() != null) {
                        //     andBtn.show();
                        //     andBtn.setTitle("افزودن " + "'" + record.titleFa + "'" + " و " + equalCourseGrid.getSelectedRecord().nameEC + " به معادل های دوره")
                        // } else {
                        //     andBtn.hide();
                        // }
                    }
                    if (this.ID == "equalCourseGrid") {
                        if ((courseAllGrid.getSelectedRecord() != null) && (equalCourseGrid.getSelectedRecord() != null)) {
                            andBtn.enable();
                            andBtn.setTitle("افزودن " + "'" + courseAllGrid.getSelectedRecord().titleFa + "'" + " و " + record.nameEC + " به معادل های دوره")
                        } else {
                            andBtn.disable();
                        }
                    }
                },

                recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
                    if (sourceWidget.ID === "courseAllGrid2") {
                        preCourseGrid.transferSelectedData(courseAllGrid2);
                    }
                    if (sourceWidget.ID === "courseAllGrid") {
                        if (targetRecord) {
                            targetRecord.nameEC = "'" + courseAllGrid.getSelectedRecord().titleFa + "'" + " و " + targetRecord.nameEC;
                            targetRecord.idEC = courseAllGrid.getSelectedRecord().id.toString() + "_" + targetRecord.idEC;
                            equalCourseGrid.updateData(targetRecord);
                            //     {
                            //     nameEC: "'" + courseAllGrid.getSelectedRecord().titleFa + "'" + " و " + targetRecord.nameEC,
                            //     idEC: courseAllGrid.getSelectedRecord().id.toString() + "_" + targetRecord.idEC
                            // });
                            // equalCourseGrid.removeData(targetRecord);
                        } else {
                            equalCourseGrid.addData({
                                nameEC: "'" + courseAllGrid.getSelectedRecord().titleFa + "'",
                                idEC: courseAllGrid.getSelectedRecord().id.toString()
                            });
                        }
                    }
                },

// dropComplete: function() {
// equalCourseGrid.getSelectedRecord().titleFa = equalCourseGrid.getSelectedRecord().titleFa+" و "+courseAllGrid.getSelectedRecord().titleFa;
// equalCourseGrid.refreshFields();
// }
                removeRecordClick: function (rowNum) {
                    if (this.ID == "equalCourseGrid") {
                        andBtn.disable();
                    }
                    var record = this.getRecord(rowNum);
                    this.removeData(record, function (dsResponse, data, dsRequest) {
                        //     // Update `employeesGrid` now that an employee has been removed from
                        //     // the selected team.  This will add the employee back to `employeesGrid`,
                        //     // the list of employees who are not in the team.
                        //     // mockAddEmployeesFromTeamMemberRecords(record);
                    });
                },

                hoverWidth: "30%",
                hoverHeight: "30%",
                hoverMoveWithMouse: true,
                canHover: this.canHover,
                showHover: this.showHover,
                showHoverComponents: this.showHoverComponents,
                getCellHoverComponent: function (record, rowNum, colNum) {
                    equalPreCourse.length = 0;
                    isc.RPCManager.sendRequest({
                        actionURL: courseUrl + "equalCourse/" + record.id,
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        serverOutputAsString: false,
                        callback: function (resp) {
                            for (var i = 0; i < JSON.parse(resp.data).length; i++) {
                                equalPreCourseDS.addData(JSON.parse(resp.data)[i]);
                            }
                        }
                    });
                    this.rowHoverComponent = isc.ListGrid.create({
                        dataSource: "equalPreCourseDS",
                        autoFetchData: true,
                        fields: [{name: "nameEC", title: "معادل های دوره " + record.titleFa}]
                    });
                    return this.rowHoverComponent;
                },


                // dataArrived : function () {
                //     this.canvasItem.showValue(null, this.canvasItem.getValue());
                // },
                // selectionUpdated : function (record) {
                //     var item = this.canvasItem;
                //     if (record == null) item.storeValue(null);
                //     else item.storeValue(record[item.name]);
                // }
            });
        },
        autoDraw: false,

        // implement showValue to update the ListGrid selection
        // showValue : function (displayValue, dataValue) {
        //     if (this.canvas == null) return;
        //     var record = this.canvas.data.find(this.name, dataValue);
        //     if (record) this.canvas.selection.selectSingle(record);
        //     else this.canvas.selection.deselectAll();
        // }
    });

    var vm_JspCourse = isc.ValuesManager.create({});
    var DynamicForm_course_MainTab = isc.DynamicForm.create({
        // sectionVisibilityMode: "mutex",
        colWidths: ["10%", "40%", "9%", "10%"],
        titleAlign: "left",
        showInlineErrors: true,
        numCols: 4,
        fields: [
            {
                name: "mainObjective",
                title: "<spring:message code="course_mainObjective"/>",
                colSpan: 1,
                rowSpan: 2,
                readonly: true,
                type: "textArea",
                width: "*",
                length: "*",
                required: true,
                endRow: false
            },
            {
                name: "code",
                title: "کد دوره:",
                type: "staticText",
                align: "center",
                startRow: false,
                colSpan: 1,
                // height: "30",
            },
            {
                name: "theoryDuration",
                colSpan: 1,
                endRow: true,
                title: "<spring:message code="course_theoryDuration"/>",
                prompt: "لطفا طول دوره را به صورت یک عدد وارد کنید",
                // height: "30",
                required: true,
                // titleOrientation: "top",
                textAlign: "center",
                keyPressFilter: "[0-9]",
                requiredMessage: "لطفا طول دوره را به صورت یک عدد با حداکثر طول سه رقم وارد کنید",
                validators: [{
                    type: "integerRange", min: 0, max: 999,
                    errorMessage: "حداکثر یک عدد سه رقمی وارد کنید",
                }],
                // width: "100",
                change: function (form, item, value, oldValue) {
                    if ((value != ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration) && (course_method == "PUT")) {
                        item.setErrors("جمع مدت زمان اجرای سرفصل ها برابر با: " + ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration + " است.");
                    } else {
                        item.clearErrors();
                    }
                }
            },
            {
                name: "needText",
                // titleOrientation: "top",
                // title: "شرح\u200cمشکل /نیاز /درخواست",
                title: "درخواست",
                colSpan: 4,
                rowSpan: 1,
                readonly: true,
                type: "textArea",
                showHintInField:true,
                hint:"شرح مشکل/نیاز/درخواست",
                // height: "100",
                width: "*",
                length: "*",
                required: false,
                endRow: true,
                wrapTitle: true
            },
            {name: "id", hidden: true},
            {
                colSpan: 4,
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                // length: "250",
                required: true,
                // titleOrientation: "top",
                // type: 'text',
                width: "*",
                // height: "30",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                // change: function (form, item, value) {
                //     if(value != null){
                //         form.getItem("epSection").enable();
                //         form.getField("preCourseGrid").title = "پیش نیازهای دوره " + value;
                //         form.getField("equalCourseGrid").title = "معادلهای دوره " + value;
                //     }
                //     else{
                //         form.getItem("epSection").disable();
                //     }
                //
                // }
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                colSpan: 4,
                // length: "250",
                // type: 'text',
                // titleOrientation: "top",
                keyPressFilter: "[a-z|A-Z|0-9|' ']",
                // height: "30",
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },


            // {
            //     defaultValue: "معادل دوره", type: "section", sectionExpanded: false,
            //     itemIds: ["courseAllEqualGrid","imgEqualMove","equalCourseGrid"]
            // },
            // {name:"courseAllEqualGrid",
            //     ID: "courseAllEqualGrid",
            //     title:"دوره ها",
            //     align: "center",
            //     colSpan: 3,
            //     rowSpan:3,
            //     width: "*",
            //     titleOrientation: "top",
            //     editorType:"ListGridItem",
            //     // height: "300",
            //     allowAdvancedCriteria: true,
            //     // gridDataSource:"courseDS",
            //     gridFields:[ {name:"titleFa",title:"نام دوره"}],
            //     hidden: false,
            //     canRemoveRecords:false,
            //     canDragRecordsOut: true,
            //     dragDataAction: "none"
            // },
            // {name:"imgEqualMove",
            //     colSpan: 1,
            //     align: "center",
            //     rowSpan:3,
            //     title:"",
            //     width:"*",
            //     type:"button",
            //     icon:"pieces/512/back2.png",
            //     click:function() {
            //         if(courseAllEqualGrid.getSelectedRecord()== null){
            //             isc.say("دوره ای انتخاب نشده است");
            //         }
            //         else {
            //             equalCourseGrid.transferSelectedData(courseAllEqualGrid);
            //         }
            //     }
            // },
            // {name:"equalCourseGrid",
            //     ID : "equalCourseGrid",
            //     title:"معادل های دوره",
            //     colSpan:2,
            //     align: "center",
            //     rowSpan:3,
            //     titleOrientation: "top",
            //     editorType:"ListGridItem",
            //     // height: "300",
            //     width: "*",
            //     gridDataSource:"equalCourseDS",
            //     gridFields:[ {name:"titleFa",title:"نام دوره"}],
            //     canRemoveRecords:true,
            //     canDragRecordsOut: false,
            //     canAcceptDroppedRecords: true,
            //     dragDataAction: "none"
            // }
        ],
        valuesManager: "vm_JspCourse"
    });
    var DynamicForm_course_GroupTab = isc.DynamicForm.create({
        colWidths: ["6%", "11%", "6%", "11%"],
        numCols: 4,
// cellBorder:1,
// titleAlign:"right",

// isGroup:true,
        // groupTitle:"اطلاعات پایه",
        // groupLabelBackgroundColor:"lightGray",
        // groupBorderCSS:"1px solid Gray",
        // border:"1px solid blue",
        fields: [
            {
                name: "category.id",
                colSpan: 1,
                title: "<spring:message code="course_category"/>",
                textAlign: "center",
                // autoFetchData: true,
                required: true,
                // titleOrientation: "top",
                // height: "30",
                width: "*",
                // editorType: "TrComboBoxItem",
                // changeOnKeypress: true,
                // filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("subCategory.id").enable();
                    DynamicForm_course_GroupTab.getItem("subCategory.id").setValue([]);
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                    DynamicForm_course_GroupTab.getItem("subCategory.id").fetchData();
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
                    // console.log(item.getSelectedRecord().code)
                },
            },
            {
                name: "subCategory.id",
                colSpan: 1,
                title: "<spring:message code="course_subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                required: true,
                autoFetchData: false,
                // titleOrientation: "top",
                // height: "30",
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function(form, item, value) {
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
                }
            },
            {
                name: "erunType.id",
                colSpan: 1,
                // titleOrientation: "top",
                title: "<spring:message code="course_eruntype"/>",
                required: true,
                // editorType: "MyComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSource_e_run_type,
                // autoFetchData: false,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["id"],
                // height: "30",
                width: "*",
                changed: function (form, item, value) {
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
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
                title: "<spring:message code="cousre_elevelType"/>",
                // editorType: "MyComboBoxItem",
                textAlign: "center",
                required: true,
                // height: "30",
                width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_e_level_type,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                // titleOrientation: "top",
                generateExactMatchCriteria: true,
                changed: function (form, item, value) {
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
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
                // editorType: "MyComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSourceETheoType,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["id"],
                // height: "30",
                width: "*",
                // titleOrientation: "top",
                changed: function (form, item, value) {
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
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
                // editorType: "MyComboBoxItem",
                textAlign: "center",
                required: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_eTechnicalType,
                sortField: ["id"],
                // titleOrientation: "top",
                width: "*",
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
                type: "TextAreaItem",
                colSpan: 4,
                rowSpan: 4,
                height: "*",
                title: "توضیحات",
                width: "*",
                length: 5000,
            }
        ],
        valuesManager: "vm_JspCourse"
    });
    // var DynamicForm

    var IButton_course_Save = isc.IButton.create({
        ID: "courseSaveBtn",
        title: "<spring:message code="save"/>",
        icon: "[SKIN]/actions/save.png",
        click: function () {
            vm_JspCourse.validate();
            if (vm_JspCourse.hasErrors()) {
                return;
            }
//------------------------------------
            if (course_method == "POST") {
                var y = (DynamicForm_course_GroupTab.getItem('subCategory.id').getSelectedRecord().code);
                x = y + runV + eLevelTypeV + etheoTypeV;
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
                        DynamicForm_course_MainTab.getItem('code').setValue(x);
                        var data2 = vm_JspCourse.getValues();
                        ChangeEtechnicalType = false;
                        preCourseIdList = [];
                        equalCourseIdList = [];
                        for (var i = 0; i < testData.length; i++) {
                            preCourseIdList.add(testData[i].id);
                        }
                        for (var j = 0; j < equalCourse.length; j++) {
                            equalCourseIdList.add(equalCourse[j].idEC);
                        }
                        data2.equalCourseListId = equalCourseIdList;
                        data2.preCourseListId = preCourseIdList;
                        isc.RPCManager.sendRequest({
                            actionURL: course_url,
                            httpMethod: course_method,
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(data2),
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    ListGrid_Course_refresh();
                                    var responseID = JSON.parse(resp.data).id;
                                    var gridState = "[{id:" + responseID + "}]";
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                    Window_course.close();
                                    setTimeout(function () {
                                        ListGrid_Course.setSelectedState(gridState);
                                    }, 3000);

                                } else {
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");

                                }

                            }
                        });
                    }
                });
            }//end if
            // else if ((course_method == "PUT" && DynamicForm_course.valuesHaveChanged()) || (course_method == "PUT" || ChangeEtechnicalType == true)) {
            else if (course_method == "PUT") {
                var data1 = vm_JspCourse.getValues();
                ChangeEtechnicalType = false;
                preCourseIdList = [];
                equalCourseIdList = [];
                for (var i = 0; i < testData.length; i++) {
                    preCourseIdList.add(testData[i].id);
                }
                for (var j = 0; j < equalCourse.length; j++) {
                    equalCourseIdList.add(equalCourse[j].idEC);
                }
                data1.equalCourseListId = equalCourseIdList;
                data1.preCourseListId = preCourseIdList;
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
                            ListGrid_Course_refresh();
                            var responseID = JSON.parse(resp.data).id;
                            var gridState = "[{id:" + responseID + "}]";
                            simpleDialog("<spring:message code="edit"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                            Window_course.close();
                            setTimeout(function () {
                                ListGrid_Course.setSelectedState(gridState);
                            }, 3000);
                        } else {
                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");

                        }
                    }
                });
            } else {
                simpleDialog("<spring:message code="edit"/>", "<spring:message code="course_noEdit"/>", 3000, "say");
                // Window_course.close();
            }//end else
//-----------------------------------------------

        }
    });
    var courseSaveOrExitHlayout = isc.HLayout.create({

        width: "100%",
        align: "center",
        // alignLayout: "center",
        membersMargin: 15,
        autoDraw: false,
        // defaultLayoutAlign: "center",
        members: [IButton_course_Save, isc.IButton.create({
            ID: "EditExitIButton",
            title: "<spring:message code="cancel"/>",
            prompt: "",
            icon: "<spring:url value="remove.png"/>",
            // orientation: "vertical",
            click: function () {
                Window_course.close();
            }
        })]
    });

    isc.DataSource.create({
        ID: "preCourseDS",
        clientOnly: true,
        testData: testData,
        fields: [
            {name: "id", type: "integer", primaryKey: true},
            {name: "titleFa", type: "text", title: "نام دوره"}
        ]
    });
    isc.DataSource.create({
        ID: "equalCourseDS",
        clientOnly: true,
        testData: equalCourse,
        fields: [
            {name: "id", type: "sequence", primaryKey: true},
            {name: "nameEC", type: "text", title: "نام دوره"},
            {name: "idEC", type: "text", hidden: true}
        ]
    });
    isc.DataSource.create({
        ID: "equalPreCourseDS",
        clientOnly: true,
        testData: equalPreCourse,
        fields: [
            {name: "id", type: "sequence", primaryKey: true, hidden: true},
            {name: "nameEC", type: "text", title: "دوره های معادل", align: "center"},
            {name: "idEC", type: "text", hidden: true}
        ]
    });
{

// isc.ListGrid.create({
// ID: "employeesGrid",
// width:300, height:224,
// canDragRecordsOut: true,
// dragDataAction: "none",
// // dragType: "nonTeamMemberEmployee",
// autoFetchData: true,
// sortField: "id",
// dataSource: "courseDS",
// fields:[
// {name: "id", title:"ID", primaryKey:true, width:50},
// {name: "titleFa", title: "Employee Name"}
// ]
// });
// isc.ListGrid.create({
// ID: "teamMembersGrid",
// width:350, height:264,
// canAcceptDroppedRecords: true,
// // dropTypes: ["nonTeamMemberEmployee"],
// canRemoveRecords: true,
// autoFetchData: true,
// sortField: "id",
// dataSource: "preCourseDS",
// fields:[
// {name: "id", title:"EID", width:"20%"},
// {name: "titleFa", title: "Employee Name", width:"40%"}
// ],
// // recordDrop : function (dropRecords, targetRecord, index, sourceWidget) {
// // // mockRemoveEmployees(dropRecords);
// // return this.Super("recordDrop", arguments);
// // },
// removeRecordClick : function (rowNum) {
// var record = this.getRecord(rowNum);
// this.removeData(record, function (dsResponse, data, dsRequest) {
// // Update `employeesGrid` now that an employee has been removed from
// // the selected team. This will add the employee back to `employeesGrid`,
// // the list of employees who are not in the team.
// // mockAddEmployeesFromTeamMemberRecords(record);
// });
// }
// });

// isc.LayoutSpacer.create({
// ID: "spacer",
// height: 30
// });

// isc.Img.create({
// ID: "arrowImg",
// layoutAlign:"center",
// width: 32,
// height: 32,
// src: "icons/32/arrow_right.png",
// click : function () {
// var selectedEmployeeRecords = employeesGrid.getSelectedRecords();
// teamMembersGrid.transferSelectedData(employeesGrid);
// mockRemoveEmployees(selectedEmployeeRecords);
// }
// });

// isc.VStack.create({
// ID: "vStack",
// members: [spacer, employeesGrid]
// });

// isc.VStack.create({
// ID: "vStack2",
// members: [teamMembersGrid]
// });

// isc.HStack.create({
// ID: "hStack",
// height: 160,
// members: [vStack, arrowImg, vStack2]
// });

// var Window_course = isc.TrWindow.create({
// width: "90%",
// autoSize: true,
// canDragReposition: false,
// autoCenter: true,
// align: "center",
// isModal: true,
// showModalMask: true,
// autoDraw: false,
// dismissOnEscape: false,
//
// border: "1px solid gray",
// closeClick: function () {
// this.Super("closeClick", arguments);
// // for(var i = 0; i <testData.length ; i++) {
// // preCourseDS.removeData(testData[i]);
// // }
// },
// items: [isc.VLayout.create({
// width: "100%",
// height: "100%",
// members: [DynamicForm_course, courseSaveOrExitHlayout]
// })]
// });
<%--var TabSet_BasicInfo_JspCourse = isc.TabSet.create({--%>
<%--tabBarPosition: "top",--%>
<%--width: "43%",--%>
<%--tabs: [--%>
<%--{--%>
<%--title: "<spring:message code='basic.information'/>", canClose: false,--%>
<%--pane: DynamicForm_course_MainTab--%>
<%--}--%>
<%--]--%>
<%--});--%>
<%--var TabSet_Teacher_JspCourse = isc.TabSet.create({--%>
<%--tabBarPosition: "top",--%>
<%--tabs: [--%>
<%--{--%>
<%--title: "شرایط مدرس دوره", canClose: false,--%>
<%--pane: isc.DynamicForm.create({--%>
<%--ID:"teacherForm",--%>
<%--groupTitle:"اطلاعات پایه",--%>
<%--styleName:"paddingRight",--%>
<%--groupLabelBackgroundColor:"lightGray",--%>
<%--groupBorderCSS:"1px solid LightGray",--%>
<%--width: "90%",--%>
<%--fields: [{--%>
<%--name: "minTeacherDegree",--%>
<%--// colSpan: 2,--%>
<%--title: "<spring:message code="course_minTeacherDegree"/>",--%>
<%--autoFetchData: true,--%>
<%--required: true,--%>
<%--// height: "30",--%>
<%--// width: "*",--%>
<%--textAlign:"center",--%>
<%--displayField: "titleFa",--%>
<%--valueField: "titleFa",--%>
<%--optionDataSource: RestDataSourceEducationCourseJsp,--%>
<%--filterFields: ["titleFa"],--%>
<%--sortField: ["id"],--%>
<%--changed: function (form, item, value) {--%>
<%--RestDataSourceEducation.fetchDataURL = courseUrl + "getlistEducationLicense";--%>
<%--},--%>
<%--},--%>
<%--{--%>
<%--name: "minTeacherExpYears",--%>
<%--// colSpan: 1,--%>
<%--title: "<spring:message code="course_minTeacherExpYears"/>",--%>
<%--prompt: "لطفا حداقل سال سابقه تدریس وارد کنید",--%>
<%--// shouldSaveValue: true,--%>
<%--textAlign: "center",--%>
<%--required: true,--%>
<%--validators: [{--%>
<%--type: "integerRange", min: 1, max: 15,--%>
<%--errorMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",--%>
<%--}],--%>
<%--// height: "30",--%>
<%--// width: "*",--%>
<%--keyPressFilter: "[0-9]",--%>
<%--requiredMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",--%>
<%--},--%>
<%--{--%>
<%--name: "minTeacherEvalScore",--%>
<%--// colSpan: 1,--%>
<%--title: "<spring:message code="course_minTeacherEvalScore"/>",--%>
<%--prompt: "لطفا حداقل نمره ارزیابی را وارد کنید",--%>
<%--shouldSaveValue: true,--%>
<%--textAlign: "center",--%>
<%--writeStackedIcons: true,--%>
<%--// height: "30",--%>
<%--required: true,--%>
<%--// width: "*",--%>
<%--keyPressFilter: "[0-9]",--%>
<%--requiredMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",--%>
<%--validators: [{--%>
<%--type: "integerRange", min: 65, max: 100,--%>
<%--errorMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",--%>
<%--}]--%>
<%--}],--%>
<%--valuesManager:"vm_JspCourse"--%>
<%--})--%>
<%--}--%>
<%--]--%>
<%--});--%>

// var TabSet_GroupInfo_JspCourse = isc.TabSet.create({
// tabBarPosition: "top",
// // width: "40%",
// tabs: [
// {
// title: "اطلاعات تکمیلی",
// canClose: false,
// pane: DynamicForm_course_GroupTab
// }
// ]
// });
}
    var TabSet_Goal_JspCourse = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        titleEditorTopOffset: 2,
        // height: "250",
        tabs: [
            {
                title: "هدف و سرفصل", canClose: false,
                pane: isc.ViewLoader.create(
                    {viewURL: "goal/show-form"}
                )
            },
            {
                title: "پیشنیازها", canClose: false,
                pane: isc.DynamicForm.create({
                    numCols: 6,
                    height: "100%",
                    overflow: "hidden",
                    styleName: "paddingRight",

                    // border:"1px solid red",
                    fields: [
                        {
                            name: "courseAllGrid21",
                            endRow: false,
                            ID: "courseAllGrid2",
                            title: "دوره ها",
                            align: "center",
                            colSpan: 5,
                            // rowSpan: 3,
                            width: "*",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
// height: "400",
                            allowAdvancedCriteria: true,
                            filterOnKeypress: true,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}],
                            canRemoveRecords: false,
                            canDragRecordsOut: true,
                            selectionType: "single",
                            dragDataAction: "none",
                            canHover: false
// selectionChanged : function(record, state) {
//     orBtn.setTitle(record.titleFa);
// }
                        },
                        {
                            name: "preCourseGrid1",
                            ID: "preCourseGrid",
                            title: "پیش نیازهای دوره",
                            colSpan: 1,
                            align: "center",
                            // rowSpan: 3,
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            // height: "400",
                            width: "*",
                            gridDataSource: "preCourseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}],
                            canRemoveRecords: true,
                            canDragRecordsOut: false,
                            // showFilterEditor:true,
                            // filterOnKeypress:true,
                            canAcceptDroppedRecords: true,
                            dragDataAction: "none",
                            canHover: true,
                            showHover: true,
                            showHoverComponents: true,
                            endRow: true
                        },
                        {type: "SpacerItem", colSpan: 3, endRow: false},
                        {
                            name: "imgMove",
                            ID: "addPreCourseBtn",
                            colSpan: 3,
                            title: "",
                            width: "*",
                            type: "button",
                            startRow: false,
                            icon: "[SKIN]/actions/back.png",
                            click: function () {
                                if (courseAllGrid2.getSelectedRecord() == null) {
                                    isc.say("دوره ای انتخاب نشده است");
                                } else {
                                    preCourseGrid.transferSelectedData(courseAllGrid2);
                                }
                            }
                        },
                    ]
                })
            },
            {
                title: "معادل ها", canClose: false,
                pane: isc.DynamicForm.create({
                    numCols: 6,
                    height: "100%",
                    overflow: "hidden",
                    styleName: "paddingRight",
                    fields: [
                        {
                            name: "courseAllGrid22",
                            endRow: false,
                            ID: "courseAllGrid",
                            title: "دوره ها",
                            align: "center",
                            colSpan: 5,
                            // rowSpan: 3,
                            width: "*",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
// height: "400",
                            allowAdvancedCriteria: true,
                            filterOnKeypress: true,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}],
                            canRemoveRecords: false,
                            canDragRecordsOut: true,
                            selectionType: "single",
                            dragDataAction: "none",
                            canHover: false
// selectionChanged : function(record, state) {
//     orBtn.setTitle(record.titleFa);
// }
                        },
                        {
                            name: "equalCourseGrid1",
                            ID: "equalCourseGrid",
                            title: "معادل های دوره",
                            colSpan: 1,
                            align: "center",
                            // rowSpan: 3,
// startRow:true,
                            titleOrientation: "top",
                            editorType: "ListGridItem",
// height: "400",
                            width: "*",
                            gridDataSource: "equalCourseDS",
                            gridFields: [{name: "nameEC", title: "نام دوره"}],
                            canRemoveRecords: true,
                            canDragRecordsOut: false,
                            selectionType: "single",
                            canAcceptDroppedRecords: true,
                            // canReorderRecords: true,

// showFilterEditor:true,
// filterOnKeypress:true,
// canAcceptDroppedRecords: true,
                            dragDataAction: "none",
                            canHover: false,
// selectionChanged : function(record, state) {
//     orBtn.setTitle(record.titleFa);
// }
                        },
                        {
                            name: "andBtn",
                            ID: "andBtn",
                            colSpan: 4,
                            align: "center",
                            // rowSpan:1,
                            startRow: true,
                            endRow: false,
                            title: "",
                            width: "*",
                            type: "button",
                            icon: "[SKIN]/actions/configure.png",
                            click: function () {
                                if (courseAllGrid.getSelectedRecord() == null) {
                                    isc.say("دوره ای انتخاب نشده است");
                                } else {
                                    equalCourseGrid.getSelectedRecord().nameEC = "'" + courseAllGrid.getSelectedRecord().titleFa + "'" + " و " + equalCourseGrid.getSelectedRecord().nameEC;
                                    equalCourseGrid.getSelectedRecord().idEC = courseAllGrid.getSelectedRecord().id.toString() + "_" + equalCourseGrid.getSelectedRecord().idEC;
                                    equalCourseGrid.updateData(equalCourseGrid.getSelectedRecord());
                                    // equalCourseGrid.addData({
                                    //     nameEC: "'" + courseAllGrid.getSelectedRecord().titleFa + "'" + " و " + equalCourseGrid.getSelectedRecord().nameEC,
                                    //     idEC: courseAllGrid.getSelectedRecord().id.toString() + "_" + equalCourseGrid.getSelectedRecord().idEC
                                    // });
                                    // equalCourseGrid.removeData(equalCourseGrid.getSelectedRecord());
                                }
                            }
                        },
                        {
                            name: "orBtn",
                            ID: "orBtn",
                            colSpan: 2,
                            align: "center",
                            // rowSpan:1,
                            title: "",
                            startRow: false,
                            endRow: false,
                            width: "*",
                            type: "button",
                            icon: "[SKIN]/actions/back.png",
                            click: function () {
                                if (courseAllGrid.getSelectedRecord() == null) {
                                    isc.say("دوره ای انتخاب نشده است");
                                } else {
                                    equalCourseGrid.addData({
                                        // id: courseAllGrid.getSelectedRecord().id,
                                        nameEC: "'" + courseAllGrid.getSelectedRecord().titleFa + "'",
                                        idEC: courseAllGrid.getSelectedRecord().id.toString()
                                    });
                                }
                            }
                        },
                    ]
                })
            }
        ],
        tabSelected: function (tabSet) {
            if (tabSet.valueOf() == 2) {
                andBtn.disable();
            }
        }
    });
    var VLayout_Tab_JspCourse = isc.VStack.create({
        membersMargin: 5,
        width: "22%",
        members: [
            isc.DynamicForm.create({
                ID: "lblCourse",
                numCols:1,
                width:"96%",
// cellBorder:1,
                fields: [{name: "domainCourse", type: "staticText", showTitle:false, width:"*", align:"center"}],
                // padding: 10,
                isGroup: true,
                groupTitle: "حیطه",
                // styleName:"paddingRight",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid LightBlue",
                // align: "center",
                // vAlign: "center",
                // wrap: false,
                // border: "1px solid lightGray",
                height: "30%"
            }),
            isc.DynamicForm.create({
                colWidths: ["8%", "18%","1%"],
                ID: "teacherForm",
                numCols:3,
                // padding:10,
                isGroup: true,
                groupTitle: "شرایط مدرس دوره",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid lightBlue",
                width: "96%",
                height:"74%",
                // margin:20,
                fields: [{
                    name: "minTeacherDegree",
                    colSpan: 1,
                    title: "<spring:message code="course_minTeacherDegree"/>",
                    autoFetchData: true,
                    required: true,
                    // height: "30",
                    width: "*",
                    textAlign: "center",
                    displayField: "titleFa",
                    valueField: "titleFa",
                    optionDataSource: RestDataSourceEducationCourseJsp,
                    filterFields: ["titleFa"],
                    sortField: ["id"],
                    changed: function (form, item, value) {
                        RestDataSourceEducation.fetchDataURL = courseUrl + "getlistEducationLicense";
                    },
                },
                    {
                        name: "minTeacherExpYears",
                        // colSpan: 1,
                        title: "<spring:message code="course_minTeacherExpYears"/>",
                        prompt: "لطفا حداقل سال سابقه تدریس وارد کنید",
                        // shouldSaveValue: true,
                        textAlign: "center",
                        required: true,
                        validators: [{
                            type: "integerRange", min: 1, max: 15,
                            errorMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",
                        }],
                        // height: "30",
                        width: "*",
                        keyPressFilter: "[0-9]",
                        requiredMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",
                    },
                    {
                        name: "minTeacherEvalScore",
                        // colSpan: 1,
                        title: "<spring:message code="course_minTeacherEvalScore"/>",
                        prompt: "لطفا حداقل نمره ارزیابی را وارد کنید",
                        shouldSaveValue: true,
                        textAlign: "center",
                        writeStackedIcons: true,
                        // height: "30",
                        required: true,
                        width: "*",
                        keyPressFilter: "[0-9]",
                        requiredMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",
                        validators: [{
                            type: "integerRange", min: 65, max: 100,
                            errorMessage: "لطفا یک عدد بین 65 تا 100 وارد کنید",
                        }]
                    }],
                valuesManager: "vm_JspCourse"
            })],
    });
    // var VLayout_Tab2_JspCourse = isc.VLayout.create({
    //     membersMargin: 5,
    //     width: "30%",
    //     members: [TabSet_GroupInfo_JspCourse],
    // });
    var HLayOut_Tab_JspCourse = isc.HLayout.create({
        layoutMargin: 5,
        height: "40%",
        width: "100%",
        membersMargin: 5,
        // members: [DynamicForm_course_MainTab, VLayout_Tab2_JspCourse, VLayout_Tab_JspCourse]
        // members: [DynamicForm_course_MainTab, DynamicForm_course_GroupTab, VLayout_Tab_JspCourse]
        members: [isc.HStack.create({
            isGroup: true, width: "13%",
            height:"100%",
            groupTitle: "اطلاعات پایه",
            styleName: "paddingRight",
            groupLabelBackgroundColor: "lightBlue",
            groupBorderCSS: "1px solid lightBlue",
            members: [DynamicForm_course_MainTab, DynamicForm_course_GroupTab]
        }), VLayout_Tab_JspCourse]
    });

    var Window_course = isc.Window.create({
        placement: "fillScreen",
        items: [isc.VLayout.create({
            // membersMargin: 5,
            width: "100%",
            height: "100%",
            members: [HLayOut_Tab_JspCourse, TabSet_Goal_JspCourse, courseSaveOrExitHlayout]
        })]
    });
    // var VLayout_Grid_Syllabus = isc.VLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [ListGrid_CourseSyllabus]
    // });
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
    // var HLayout_Tab_Course_Goal = isc.HLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [
    //         VLayout_Grid_Syllabus
    //     ]
    // });
    // var HLayout_Tab_Course_Skill = isc.HLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [
    //         ListGrid_CourseSkill
    //     ]
    // });
    // var HLayout_Tab_Course_Job = isc.HLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [
    //         ListGrid_CourseJob
    //     ]
    // });
    // var HLayout_Tab_Course_Competence = isc.HLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [ListGrid_CourseCompetence]
    // });
    var Detail_Tab_Course = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                // id: "TabPane_Goal_Syllabus",
                title: "<spring:message code="course_syllabus_goal"/>",
                pane: ListGrid_CourseSyllabus
            },
            {
                // id: "TabPane_Job",
                title: "<spring:message code="course_job"/>",
                pane: ListGrid_CourseJob
            },
            {
                // id: "TabPane_Post",
                title: "<spring:message code="course_post"/>",
                pane: isc.MyListGrid.create({
                    ID:"ListGrid_Post_JspCourse",
                    showResizeBar: false,
                    dataSource: isc.MyRestDataSource.create({fields:[{name:"id",primaryKey:true,hidden:true},
                        {name:"titleFa",title:"نام فارسی",align:"center"},
                        {name:"titleEn",title:"نام لاتین",align:"center"}
                        ],
                        ID:"RestData_Post_JspCourse",
                    // fetchDataURL:courseUrl + "post/" + ListGrid_Course.getSelectedRecord().id,
                    }),
                })
            },
            {
                // id: "TabPane_Skill",
                title: "<spring:message code="course_skill"/>",
                pane: ListGrid_CourseSkill

            },

            {
                // id: "TabPane_Competence",
                title: "گروه مهارت",
                pane: ListGrid_CourseCompetence
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
        for (j = 0; j < trainingTabSet.tabs.length; j++) {
            if (trainingTabSet.getTab(j).title.substr(0, 5) == "اهداف") {
                trainingTabSet.removeTab(j);
            }
        }
    };

    function ListGrid_Course_add() {
        TabSet_Goal_JspCourse.disableTab(0);
        TabSet_Goal_JspCourse.selectTab(1);
        DynamicForm_course_GroupTab.getItem("category.id").enable();
        DynamicForm_course_GroupTab.getItem("erunType.id").enable();
        DynamicForm_course_GroupTab.getItem("elevelType.id").enable();
        DynamicForm_course_GroupTab.getItem("etheoType.id").enable();
        course_method = "POST";
        course_url = courseUrl;
        vm_JspCourse.clearValues();
        vm_JspCourse.clearErrors();
        DynamicForm_course_GroupTab.getItem("subCategory.id").disable();
        Window_course.setTitle("<spring:message code="create"/>");
        equalCourse.length = 0;
        testData.length = 0;
        lblCourse.hide();
        preCourseGrid.invalidateCache();
        equalCourseGrid.invalidateCache();
        courseAllGrid.invalidateCache();
        // DynamicForm_course.getItem("epSection").disable();
        // DynamicForm_course.getItem("theoryDuration").clearErrors();
        Window_course.show();

        // DynamicForm_course.getFields().get(5).prompt = "لطفا طول دوره را به صورت یک عدد وارد کنید";

    };

    function ListGrid_Course_remove() {
        var record = ListGrid_Course.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
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
        testData.length = 0;
        equalCourse.length = 0;
        preCourseGrid.invalidateCache();
        equalCourseGrid.invalidateCache();

        var sRecord = ListGrid_Course.getSelectedRecord();

        if (sRecord == null || sRecord.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            TabSet_Goal_JspCourse.enableTab(0);
            TabSet_Goal_JspCourse.selectTab(0);
            vm_JspCourse.clearValues();
            vm_JspCourse.clearErrors();
            // DynamicForm_course_GroupTab.clearValues();
            isc.RPCManager.sendRequest({
                actionURL: courseUrl + "preCourse/" + ListGrid_Course.getSelectedRecord().id,
                httpMethod: "GET",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                serverOutputAsString: false,
                callback: function (resp) {
                    for (var i = 0; i < JSON.parse(resp.data).length; i++) {

                        preCourseDS.addData(JSON.parse(resp.data)[i]);
                    }
                }
            });
            isc.RPCManager.sendRequest({
                actionURL: courseUrl + "equalCourse/" + ListGrid_Course.getSelectedRecord().id,
                httpMethod: "GET",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                serverOutputAsString: false,
                callback: function (resp) {
                    for (var i = 0; i < JSON.parse(resp.data).length; i++) {
                        equalCourseDS.addData(JSON.parse(resp.data)[i]);
                    }
                }
            });
            // RestDataSource_category.fetchDataURL = categoryUrl + "spec-list";
            DynamicForm_course_GroupTab.getItem("category.id").fetchData();

            DynamicForm_course_GroupTab.getItem("category.id").disable();
            DynamicForm_course_GroupTab.getItem("subCategory.id").setDisabled(true);
            DynamicForm_course_GroupTab.getItem("erunType.id").setDisabled(true);
            DynamicForm_course_GroupTab.getItem("elevelType.id").setDisabled(true);
            DynamicForm_course_GroupTab.getItem("etheoType.id").setDisabled(true);
            course_method = "PUT";
            course_url = courseUrl + sRecord.id;
            // DynamicForm_course.getItem("epSection").enable();
            RestDataSourceSubCategory.fetchDataURL = categoryUrl + sRecord.category.id + "/sub-categories";
            DynamicForm_course_GroupTab.getItem("subCategory.id").fetchData();
            // sRecord.domainPercent = "دانشی: " + sRecord.knowledge + "%" + "، مهارتی: " + sRecord.skill + "%" + "، نگرشی: " + sRecord.attitude + "%";
            vm_JspCourse.editRecord(sRecord);

            Window_course.setTitle("<spring:message code="edit"/>");
            Window_course.show();
            lblCourse.getField("domainCourse").setValue("دانشی: " + getFormulaMessage(sRecord.knowledge + "%",2,"brown") + "، مهارتی: " + getFormulaMessage(sRecord.skill + "%",2,"green") + "، نگرشی: " + getFormulaMessage(sRecord.attitude + "%",2,"blue"));
            lblCourse.show();
            setTimeout(function () {

                RestDataSource_CourseGoal.fetchDataURL = courseUrl + ListGrid_Course.getSelectedRecord().id + "/goal";
                ListGrid_Goal.fetchData();
                ListGrid_Goal.invalidateCache();
                RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + ListGrid_Course.getSelectedRecord().id
                ListGrid_Syllabus_Goal.invalidateCache();
                ListGrid_Syllabus_Goal.fetchData();
            }, 200)
            // if (ListGrid_Course.getSelectedRecord().theoryDuration != ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration) {
            // DynamicForm_course.getItem("theoryDuration").setErrors("جمع مدت زمان اجرای سرفصل ها برابر با: " + ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration + " است.");
            // }

            // DynamicForm_course.getFields().get(5).prompt = "  جمع مدت زمان اجرای سرفصل ها " + (ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration).toString() + " ساعت می باشد."
        }
    };
{
<%--function openTabGoal() {--%>
<%--if (ListGrid_Course.getSelectedRecord() == null) {--%>
<%--isc.Dialog.create({--%>
<%--message: "<spring:message code="msg.no.records.selected"/>",--%>
<%--icon: "[SKIN]ask.png",--%>
<%--title: "<spring:message code="course_Warning"/>",--%>
<%--buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],--%>
<%--buttonClick: function (button, index) {--%>
<%--this.close();--%>
<%--}--%>
<%--});--%>
<%--} else {--%>
<%--for (j = 0; j < trainingTabSet.tabs.length; j++) {--%>
<%--if (trainingTabSet.getTab(j).title.substr(0, 5) == "اهداف") {--%>
<%--trainingTabSet.removeTab(j);--%>
<%--}--%>
<%--}--%>
<%--createTab("<spring:message code="course_goal_of_syllabus"/>" + " " + courseId.titleFa, "goal/show-form", false);--%>
<%--RestDataSource_CourseGoal.fetchDataURL = courseUrl + ListGrid_Course.getSelectedRecord().id + "/goal";--%>
<%--}--%>
<%--};--%>
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

    function courseCode() {
        var subCat = DynamicForm_course_GroupTab.getField("subCategory.id").getSelectedRecord();
        var cat = DynamicForm_course_GroupTab.getField("category.id").getSelectedRecord();
        var eRun = DynamicForm_course_GroupTab.getField("erunType.id").getSelectedRecord();
        var eLevel = DynamicForm_course_GroupTab.getField("elevelType.id").getSelectedRecord();
        var eTheo = DynamicForm_course_GroupTab.getField("etheoType.id").getSelectedRecord();
        subCat = subCat==undefined ? (cat==undefined ? "" : cat.code) : subCat.code;
        eRun = eRun==undefined ? "" : eRun.code;
        eLevel = eLevel==undefined ? "" : eLevel.code;
        eTheo = eTheo==undefined ? "" : eTheo.code;
        return subCat + eRun + eLevel + eTheo;
    }

    //</script>