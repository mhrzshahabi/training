<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    var testData = [];
    var equalCourse = [];
    var preCourseIdList = [];
    var equalPreCourse = [];
    var equalCourseIdList = [];
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
    var RestDataSource_category = isc.TrDS.create({
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
    var RestDataSource_Skill_JspCourse = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title:"عنوان"},
            {name: "courseId", hidden: true},
            {name: "code", title:"کد"},
        ],
        fetchDataURL: skillUrl + "/spec-list",
    });
    var RestDataSource_course = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
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
            // {name: "knowledge"},
            // {name: "skill"},
            // {name: "attitude"},
            {name: "needText"},
            {name: "description"},
            {name: "workflowStatus"},
            {name: "workflowStatusCode"},
            {name: "hasGoal"},
            {name: "hasSkill"},
             {
                name: "evaluation",
            },
            {
                name: "behavioralLevel",
            }
            // {name: "version"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });
    var RestDataSource_eTechnicalType = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTechnicalType/spec-list",
        autoFetchData: true,
    });
    var RestDataSource_e_level_type = isc.TrDS.create({
        autoCacheAllData: false,
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLevelType",
        autoFetchData: true,
    });
    var RestDataSource_e_run_type = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eRunType/spec-list",
// cacheAllData:true,
        autoFetchData: true,
    });
    var RestDataSourceETheoType = isc.TrDS.create({
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
    var RestDataSource_CourseGoal = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"}],
        // fetchDataURL: courseUrl + courseId.id + "/goal"
    });
    var RestDataSource_CourseSkill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ], dataFormat: "json",

        fetchDataURL: courseUrl + "skill/" + courseId.id
    });
    var RestDataSource_CourseJob = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ],

        fetchDataURL: courseUrl + "job/" + courseId.id
    });
    var RestDataSource_Syllabus = isc.TrDS.create({
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
    var RestDataSource_CourseCompetence = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"}
        ],

        // fetchDataURL: courseUrl + "getcompetence/" + courseId.id
    });
    var RestDataSourceEducationCourseJsp = isc.TrDS.create({
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
                 refreshSelectedTab_Course(tabSetCourse.getSelectedTab())
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
        },
            <%--, {--%>
            <%--title: "تعریف هدف و سرفصل", icon: "<spring:url value="goal.png"/>", click: function () {--%>
            <%--openTabGoal();--%>
            <%--}--%>
            <%--}--%>
            {
                title: "<spring:message code='send.to.workflow'/>", click: function () {
                    sendCourseToWorkflow();
                }
            },
            {
                isSeparator: true
            }, {
                title: "<spring:message code="format.pdf"/>",
                icon: "<spring:url value="pdf.png"/>",
                click: function () {
                    print_CourseListGrid("pdf");
                }
            }, {
                title: "<spring:message code="format.excel"/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    print_CourseListGrid("excel");
                }
            }, {
                title: "<spring:message code="format.html"/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    print_CourseListGrid("html");
                }
            },
            {
                title: "چاپ با جزییات", icon: "<spring:url value="print.png"/>", click: function () {
                    window.open("course/testCourse/" + ListGrid_Course.getSelectedRecord().id + "/pdf/<%=accessToken%>");
                }
            }
        ]
    });
    var ListGrid_Course = isc.TrLG.create({
        ID: "gridCourse",
        dataSource: RestDataSource_course,
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_course,
        allowAdvancedCriteria: true,
        // hoverWidth: "30%",
        // hoverHeight: "30%",
        hoverMoveWithMouse: true,
        // canHover: false,
        // showHover: false,
        // showHoverComponents: false,
        // autoFitWidthApproach:"both",
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

        rowDoubleClick: function () {
            // DynamicForm_course.clearValues();
            ListGrid_Course_Edit()
        },
        selectionUpdated: function (record) {
            courseId = record;
            RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
            ListGrid_CourseSyllabus.fetchData();
            ListGrid_CourseSyllabus.invalidateCache();
            RestDataSource_CourseSkill.fetchDataURL = courseUrl + "skill/" + courseId.id;
            ListGrid_CourseSkill.fetchData();
            ListGrid_CourseSkill.invalidateCache();
            RestDataSource_CourseJob.fetchDataURL = courseUrl + "job/" + courseId.id;
            ListGrid_CourseJob.fetchData();
            ListGrid_CourseJob.invalidateCache();
            RestDataSource_CourseCompetence.fetchDataURL = courseUrl + "skill-group/" + courseId.id;
            ListGrid_CourseCompetence.fetchData();
            ListGrid_CourseCompetence.invalidateCache();
            // RestData_Post_JspCourse.fetchDataURL = courseUrl + "post/" + courseId.id;
            // ListGrid_Post_JspCourse.fetchData();
            // ListGrid_Post_JspCourse.invalidateCache();
            // for (let i = 0; i < trainingTabSet.tabs.length; i++) {
            //     if ("اهداف" == (trainingTabSet.getTab(i).title).substr(0, 5)) {
            //         trainingTabSet.getTab(i).setTitle("اهداف دوره " + record.titleFa);
            //     }
            // }
            // sumCourseTime = ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration;

        // },
        // selectionUpdated:function(record){
            refreshSelectedTab_Course(tabSetCourse.getSelectedTab())
        },

        //working
        dataArrived: function () {
            selectWorkflowRecord();
            // var gridState = "[{id:285}]";
            // ListGrid_Course.setSelectedState(gridState);


            // if (ListGrid_Course.getSelectedRecord() != null) {
            //     alert("Yes");
            // } else {
            //     alert("No");
            // }
        },
        //working
        fields: [
            // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code", title: "<spring:message code="corse_code"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains"
            },
            {
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "category.titleFa", title: "<spring:message
        code="course_category"/>", align: "center", filterOperator: "iContains"
            },
            {
                name: "subCategory.titleFa", title: "<spring:message
        code="course_subcategory"/>", align: "center", filterOperator: "iContains"
            },
            {
                name: "erunType.titleFa",
                title: "<spring:message code="course_eruntype"/>",
                align: "center",
                filterOperator: "iContains",
                allowFilterOperators: false,
                canFilter: false

            },
            {
                name: "elevelType.titleFa", title: "<spring:message
        code="cousre_elevelType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "etheoType.titleFa", title: "<spring:message
        code="course_etheoType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "theoryDuration", title: "<spring:message
                code="course_theoryDuration"/>", align: "center", filterOperator: "iContains",

            },
            {
                name: "etechnicalType.titleFa", title: "<spring:message
                 code="course_etechnicalType"/>", align: "center", filterOperator: "iContains",
                canFilter: false
            },
            {
                name: "minTeacherDegree", title: "<spring:message
        code="course_minTeacherDegree"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            {
                name: "minTeacherExpYears", title: "<spring:message
        code="course_minTeacherExpYears"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            {
                name: "minTeacherEvalScore", title: "<spring:message
        code="course_minTeacherEvalScore"/>", align: "center", filterOperator: "iContains", hidden: true
            },
            // {
            //     name: "knowledge",
            //     title: "دانشی",
            //     align: "center",
            //     filterOperator: "greaterThan",
            //     format: "%",
            //     width: "50"
            //     // formatCellValue: function (value, record) {
            //     //     // if (!isc.isA.Number(record.gdp) || !isc.isA.Number(record.population)) return "N/A";
            //     //     var gdpPerCapita = Math.round(record.theoryDuration/10);
            //     //     return isc.NumberUtil.format(gdpPerCapita, "%");
            //     // }
            // },
            // {name: "skill", title: "مهارتی", align: "center", filterOperator: "greaterThan", format: "%", width: "50"},
            // {
            //     name: "attitude",
            //     title: "نگرشی",
            //     align: "center",
            //     filterOperator: "greaterThan",
            //     format: "%",
            //     width: "50"
            // },
            {name: "needText", title: "شرح", hidden: true},
            {name: "description", title: "توضیحات", hidden: true},
            {
                name: "workflowStatus",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains"
            },
            {name:"behavioralLevel", title:"سطح رفتاری",
                // hidden:true,
                valueMap: {
                    "1":"مشاهده",
                    "2":"مصاحبه",
                    "3":"کار پروژه ای"
                }
            },
            {
                name: "evaluation", title: "<spring:message code="evaluation.level"/>",
                valueMap: {
                    "1": "واکنش",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
            },
            {
                name: "workflowStatusCode",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
                hidden: true
            },
            {name: "hasGoal", type:"boolean", title:"بدون هدف", hidden:true, canFilter:false},
            {name: "hasSkill", type:"boolean", title:"بدون مهارت", hidden:true, canFilter:false}
            // {name: "version", title: "version", canEdit: false, hidden: true},
            // {name: "goalSet", hidden: true}
        ],
        autoFetchData: true,
        showFilterEditor: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        getCellCSSText: function (record, rowNum, colNum) {
            // if (record.attitude==0 && record.knowledge==0 && record.skill==0) {
            if(record.hasGoal&&record.hasSkill){
                return "color:red;font-size: 12px;";
            }
            if (record.hasGoal) {
                return "color:tan; font-size: 12px;";
            }
            if(record.hasSkill){
                return "color:orange;font-size: 12px;";
            }
        }
    });
    var ListGrid_CourseSkill = isc.TrLG.create({
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
    var ListGrid_CourseJob = isc.TrLG.create({
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
    var ListGrid_CourseCompetence = isc.TrLG.create({
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
    var ListGrid_CourseSyllabus = isc.TrLG.create({

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
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        //icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/> ",

        click: function () {
            ListGrid_Course_refresh();
            refreshSelectedTab_Course(tabSetCourse.getSelectedTab())


        }
    });
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/> ",
        click: function () {
            ListGrid_Course_Edit()
        }
    });
    var ToolStripButton_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",

        click: function () {
            ListGrid_Course_add();
        }
    });

    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({

        title: "<spring:message code="remove"/> ",
        click: function () {
            ListGrid_Course_remove()
        }
    });
    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
        //icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            print_CourseListGrid("pdf");
        }
    });

    var ToolStripButton_SendToWorkflow = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code='send.to.workflow'/>",
        click: function () {
            sendCourseToWorkflow();
        }
    });

    var Window_AddSkill = isc.Window.create({
        title: "<spring:message code="relate/delete.relation.skill.course"/>",
        width: "90%",
        height: "70%",
        keepInParentRect: true,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members:[
                    isc.TrLG.create({
                        ID:"ListGrid_AllSkill_JspCourse",
                        dataSource: RestDataSource_Skill_JspCourse,
                        selectionType: "single",
                        filterOnKeypress: true,
                        canDragRecordsOut: true,
                        dragDataAction: "none",
                        canAcceptDroppedRecords: true,
                        fields:[
                            {name: "titleFa", title:"عنوان"},
                            {name: "code", title:"کد"},
                        ],
                        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
                            if (ListGridOwnSkill_JspCourse.getSelectedRecord() == null){
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            }
                            else{
                                isc.RPCManager.sendRequest({
                                    actionURL: skillUrl + "/remove-course/" + ListGrid_Course.getSelectedRecord().id + "/" + ListGridOwnSkill_JspCourse.getSelectedRecord().id,
                                    httpMethod: "DELETE",
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    showPrompt: false,
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                            <%--createDialog("info", "<spring:message code='msg.operation.successful'/>", "<spring:message code="msg.command.done"/>");--%>
                                            skillBtn.click();
                                        }
                                    }
                                })
                            }
                        },
                        gridComponents : [isc.Label.create({contents:"<spring:message code="skill.plural.list"/>", align:"center", height:30,showEdges: true}) ,"filterEditor", "header", "body"],

                    }),
                    isc.ToolStrip.create({
                        width:"4%",
                        height:"100%",
                        align: "center",
                        vertical: "center",
                        membersMargin: 5,
                        members:[
                            isc.IconButton.create({
                                icon: "[SKIN]/TransferIcons/double-arrow-left.png",
                                showButtonTitle:false,
                                prompt: "افزودن",
                                click: function () {
                                    ListGridOwnSkill_JspCourse.recordDrop();
                                }
                            }),
                            isc.IconButton.create({
                                icon: "[SKIN]/TransferIcons/double-arrow-right.png",
                                showButtonTitle:false,
                                prompt: "حذف",
                                click: function () {
                                    ListGrid_AllSkill_JspCourse.recordDrop();
                                }
                            })
                        ]
                    }),
                    isc.TrLG.create({
                        ID:"ListGridOwnSkill_JspCourse",
                        dataSource:RestDataSource_Skill_JspCourse,
                        selectionType: "single",
                        filterOnKeypress: true,
                        canDragRecordsOut: true,
                        dragDataAction: "none",
                        canAcceptDroppedRecords: true,
                        fields:[
                            {name: "titleFa", title:"عنوان"},
                            {name: "code", title:"کد"},
                        ],
                        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
                            if (ListGrid_AllSkill_JspCourse.getSelectedRecord() == null){
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            }
                            else{
                                isc.RPCManager.sendRequest({
                                    actionURL: skillUrl + "/add-course/" + ListGrid_Course.getSelectedRecord().id + "/" + ListGrid_AllSkill_JspCourse.getSelectedRecord().id,
                                    httpMethod: "POST",
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    showPrompt: false,
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                            <%--createDialog("info", "<spring:message code='msg.operation.successful'/>", "<spring:message code="msg.command.done"/>");--%>
                                            skillBtn.click();
                                        }
                                    }
                                })
                            }
                        },
                        gridComponents : [isc.Label.create({ID:"labelSkill", showEdges: true, contents:"<spring:message code="list.skill.course"/>", align:"center", height:30}) ,"filterEditor", "header", "body"]
                    })
                ]
            })
        ],
        close() {
            ListGrid_Course_refresh();
            this.Super("close",arguments);
        }
    });
    var ToolStripButton_addSkill = isc.ToolStripButton.create({
        // icon: "[SKIN]/actions/column_preferences.png",
        ID:"skillBtn",
        title: "<spring:message code='add.skill'/>",
        click: function () {
            if (ListGrid_Course.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            var advancedCriteriaJspCourse = {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[{fieldName:"courseId", operator:"isNull"}]
            };
            ListGrid_AllSkill_JspCourse.setImplicitCriteria(advancedCriteriaJspCourse);
            ListGrid_AllSkill_JspCourse.fetchData(advancedCriteriaJspCourse);
            ListGrid_AllSkill_JspCourse.invalidateCache();
            ListGridOwnSkill_JspCourse.setImplicitCriteria({"courseId":ListGrid_Course.getSelectedRecord().id});
            ListGridOwnSkill_JspCourse.fetchData({"courseId":ListGrid_Course.getSelectedRecord().id});
            ListGridOwnSkill_JspCourse.invalidateCache();
            labelSkill.contents = "مهارت های دوره  " + getFormulaMessage(ListGrid_Course.getSelectedRecord().titleFa,"2","red","b");
            labelSkill.redraw();
            Window_AddSkill.show();
        }
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add,
            ToolStripButton_Edit,
            ToolStripButton_Remove,
            ToolStripButton_Print,
            ToolStripButton_addSkill,
            ToolStripButton_SendToWorkflow,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh
                ]
            })
        ]
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
                width: this.width, height: this.height,
                leaveScrollbarGaps: false,
                dataSource: this.gridDataSource,
                fields: this.gridFields,
                autoFetchData: true,
                canAcceptDroppedRecords: this.canAcceptDroppedRecords,
                canDragRecordsOut: this.canDragRecordsOut,
                dragDataAction: this.dragDataAction,
                selectionType: this.selectionType,
                allowAdvancedCriteria: this.allowAdvancedCriteria,
                sortField: "1",
                canRemoveRecords: this.canRemoveRecords,
                filterOnKeypress: this.filterOnKeypress,
                showFilterEditor: this.showFilterEditor,
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
                    if (dropRecords[0].titleFa == DynamicForm_course_MainTab.getItem("titleFa")._value) {
                        createDialog("info", "دوره " + getFormulaMessage(dropRecords[0].titleFa, 2, "red", "b") + " نمیتواند پیشنیاز یا معادل خودش باشد.",
                            "خطا");
                        return;
                    }
                    if (sourceWidget.ID === "courseAllGrid2") {
                        preCourseGrid.transferSelectedData(courseAllGrid2);
                        setPlus(vm_JspCourse.values.id, "PreCourse", testData);
                    }
                    if (sourceWidget.ID === "courseAllGrid") {
                        if (targetRecord) {
                            for (let i = 0; i < equalCourseGrid.data.allRows.size(); i++) {
                                if (equalCourseGrid.data.allRows[i].nameEC.contains(dropRecords[0].titleFa)) {
                                    createDialog("info", "دوره " + getFormulaMessage(dropRecords[0].titleFa, 2, "red", "b") + " قبلاً اضافه شده است.",
                                        "خطا");
                                    return;
                                }
                            }
                            targetRecord.nameEC = "'" + courseAllGrid.getSelectedRecord().titleFa + "(" + courseAllGrid.getSelectedRecord().code + ")" + "'" + " و " + targetRecord.nameEC;
                            targetRecord.idEC = courseAllGrid.getSelectedRecord().id.toString() + "_" + targetRecord.idEC;
                            equalCourseGrid.updateData(targetRecord);
                        } else {
                            for (let i = 0; i < equalCourseGrid.data.allRows.size(); i++) {
                                if (equalCourseGrid.data.allRows[i].nameEC.contains(dropRecords[0].titleFa)) {
                                    createDialog("info", "دوره " + getFormulaMessage(dropRecords[0].titleFa, 2, "red", "b") + " قبلاً اضافه شده است.",
                                        "خطا");
                                    return;
                                }
                            }
                            equalCourseGrid.addData({
                                nameEC: "'" + courseAllGrid.getSelectedRecord().titleFa + "(" + courseAllGrid.getSelectedRecord().code + ")" + "'",
                                idEC: courseAllGrid.getSelectedRecord().id.toString()
                            });
                        }
                        setPlus(vm_JspCourse.values.id, "EqualCourse", equalCourse)
                    }
                },
                removeRecordClick: function (rowNum) {
                    var record = this.getRecord(rowNum);
                    this.removeData(record, function (dsResponse, data, dsRequest) {
                    });
                    if (this.ID == "equalCourseGrid") {
                        andBtn.disable();
                        setPlus(vm_JspCourse.values.id, "EqualCourse", equalCourse)
                    } else {
                        setPlus(vm_JspCourse.values.id, "PreCourse", testData);
                    }
                },
                hoverWidth: this.hoverWidth,
                hoverHeight: this.hoverHeight,
                hoverMoveWithMouse: true,
                canHover: this.canHover,
                showHover: this.showHover,
                showClippedValuesOnHover: true,
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

    var vm_JspCourse = isc.ValuesManager.create({
        itemChanged: function (item, newValue) {
            IButton_course_Save.enable();
        }
    });
    var DynamicForm_course_MainTab = isc.DynamicForm.create({
        // sectionVisibilityMode: "mutex",
        colWidths: ["10%", "20%", "9%", "10%","10%"],
        titleAlign: "left",
        validateOnExit: true,
        showInlineErrors: true,
        numCols: 5,
        fields: [
            {
                name: "mainObjective",
                title: "<spring:message code="course_mainObjective"/>",
                colSpan: 2,
                rowSpan: 2,
                readonly: true,
                type: "TextAreaItem",
                width: "*",
                height:"*",
                // length: "*",
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
                prompt: "لطفا مدت دوره را به صورت یک عدد حداکثر 3 رقمی وارد کنید",
                // height: "30",
                required: true,
                mask:"###",
                useMask: true,
                // titleOrientation: "top",
                textAlign: "center",
                keyPressFilter: "[0-9.]",
                requiredMessage: "لطفا مدت دوره را به صورت یک عدد با حداکثر سه رقم وارد کنید",
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
                colSpan: 5,
                rowSpan: 1,
                readonly: true,
                type: "textArea",
                showHintInField: true,
                hint: "شرح مشکل/نیاز/درخواست",
                // height: "100",
                width: "*",
                length: "*",
                required: false,
                endRow: true,
                wrapTitle: true
            },
            {name: "id", hidden: true},
            {
                colSpan: 5,
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                // length: "250",
                required: true,
                // titleOrientation: "top",
                // type: 'text',
                width: "*",
                // height: "30",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                change: function (form, item, value) {
                    if (value != null) {
                        formEqualCourse.getItem("equalCourseGrid1").title = "معادل های " + getFormulaMessage(value, 2, "red", "b");
                        formPreCourse.getItem("preCourseGrid1").title = "پیش نیازهای " + getFormulaMessage(value, 2, "red", "b");
                        formEqualCourse.reset();
                        formPreCourse.reset();
                    } else {
                        formEqualCourse.getItem("equalCourseGrid1").title = "معادل های دوره";
                        formEqualCourse.reset();
                        formPreCourse.getItem("preCourseGrid1").title = "پیشنیازهای دوره";
                        formPreCourse.reset();
                    }

                }
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                colSpan: 5,
                // length: "250",
                // type: 'text',
                // titleOrientation: "top",
                keyPressFilter: "[a-z|A-Z|0-9|' ']",
                // height: "30",
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
             {
                name: "evaluation",
                title: "<spring:message code="evaluation.level"/>",
                colSpan:2,
                textAlign: "center",
                type: "select",
                endRow:true,
           //     defaultValue: "1",
                valueMap: {
                    "1": "واکنش",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
                 change: function (form, item, value, oldValue) {
                    if (value === "3")
                        DynamicForm_course_MainTab.getItem("behavioralLevel").setDisabled(false);
                    else
                        DynamicForm_course_MainTab.getItem("behavioralLevel").setDisabled(true);
                }
             },
              {
                name: "behavioralLevel",
                title: "<spring:message code="behavioral.Level"/>",
                  colSpan: 3,
                  type: "radioGroup",
                  vertical: false,
                  endRow:true,
                  fillHorizontalSpace: true,
                  //  defaultValue: "مشاهده",
                  valueMap: {
                      "1": "مشاهده",
                      "2": "مصاحبه",
                      "3": "کار پروژه ای"
                  }
              },
            {
                name: "scoringMethod",
                title: "روش نمره دهی",
                colSpan: 1,
                // fillHorizontalSpace: true,
                // vertical: false,
                defaultValue: "3",
                textAlign: "center",
                valueMap: {
                    "1": "ارزشی",
                    "2": "نمره از صد",
                    "3": "نمره از بیست",
                    "4": "بدون نمره",
                },
                change: function (form, item, value) {
                    if (value == "1") {
                        form.getItem("acceptancelimit").hide();
                        form.getItem("acceptancelimit_a").show();
                    }
                    else{
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit_a").hide();
                    }
                }
            },
            {
                name: "acceptancelimit",
                // colSpan:2,
                title: "حد نمره قبولی",
            },

            {
                name: "acceptancelimit_a",

                colSpan:2,
                hidden: true,
                textAlign: "center",
                title: "حد نمره قبولی",
                valueMap:{
                    "1001": "ضعیف",
                    "1002": "متوسط",
                    "1003": "خوب",
                    "1004": "خيلي خوب",
                },
            }


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
     validateOnExit: true,
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
                click: function (form, item) {
                    item.fetchData();
                }
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
                changed: function (form, item, value) {
                    DynamicForm_course_MainTab.getItem("code").setValue(courseCode());
                }
            },
            {
                name: "erunType.id",
                colSpan: 1,
                // titleOrientation: "top",
                title: "<spring:message code="course_eruntype"/>",
                required: true,
                // editorType: "ComboBoxItem",
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
                // editorType: "ComboBoxItem",
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
                // editorType: "ComboBoxItem",
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
                // editorType: "ComboBoxItem",
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

    var IButton_course_Save = isc.IButtonSave.create({
        ID: "courseSaveBtn",
        title: "<spring:message code="save"/>",
        //icon: "[SKIN]/actions/save.png",
        click: function () {
            vm_JspCourse.validate();
            if (vm_JspCourse.hasErrors()) {
                return;
            }
//------------------------------------
            if (course_method == "POST") {
                // var y = (DynamicForm_course_GroupTab.getItem('subCategory.id').getSelectedRecord().code);
                x = courseCode();
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

                         if(data2.scoringMethod == "1"){

                         data2.acceptancelimit = data2.acceptancelimit_a
                         }


                        data2["workflowStatus"] = "ثبت اولیه";
                        data2["workflowStatusCode"] = "0";

                        isc.RPCManager.sendRequest({
                            actionURL: course_url,
                            willHandleError: true,
                            httpMethod: course_method,
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(data2),
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                    TabSet_Goal_JspCourse.enable();
                                    // ToolStrip_Actions_Goal.enable();
                                    // ToolStrip_Actions_Syllabus.enable();
                                    ListGrid_Course_refresh();
                                    var responseID = JSON.parse(resp.data).id;
                                    var gridState = "[{id:" + responseID + "}]";
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                    // Window_course.close();

                                    setTimeout(function () {
                                        ListGrid_Course.setSelectedState(gridState);
                                        ListGrid_Course_Edit();

                                    }, 3000);

                                } else if (resp.httpResponseCode === 406) {
                                    var myDialog = createDialog("info", "قبلاً دوره\u200cای با این نام ذخیره شده است.",
                                        "<spring:message code="message"/>");
                                    myDialog.addProperties({
                                        buttonClick: function () {
                                            this.close();
                                            DynamicForm_course_MainTab.getItem("titleFa").selectValue();
                                        }
                                    });
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
                console.log(data1)

                   if(data1.scoringMethod == "1"){
                    data1.acceptancelimit = data1.acceptancelimit_a
                   }

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

                            sendToWorkflowAfterUpdate(JSON.parse(resp.data));

                            ListGrid_Course_refresh();
                            var responseID = JSON.parse(resp.data).id;
                            var gridState = "[{id:" + responseID + "}]";
                            simpleDialog("<spring:message code="edit"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                            // Window_course.close();
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

        },
        disabled: true
    });

    var courseSaveOrExitHlayout = isc.HLayout.create({

        width: "100%",
        align: "center",
        // alignLayout: "center",
        membersMargin: 15,
        autoDraw: false,
        // defaultLayoutAlign: "center",
        members: [IButton_course_Save, isc.IButtonCancel.create({
            ID: "EditExitIButton",
            <%--title: "<spring:message code="cancel"/>",--%>
            title: "خروج",
            prompt: "",
            //icon: "<spring:url value="remove.png"/>",
            // orientation: "vertical",
            click: function () {
                Window_course.closeClick();
                ListGrid_Course_refresh();
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
                    ID: "formPreCourse",
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
                            colSpan: 4,
                            // rowSpan: 3,
                            width: "*",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
// height: "400",
                            allowAdvancedCriteria: true,
                            filterOnKeypress: true,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"},{name:"code", title:"کد دوره"}],
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
                            colSpan: 2,
                            align: "center",
                            // rowSpan: 3,
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            // height: "400",
                            width: "*",
                            gridDataSource: "preCourseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}, {name:"code", title:"کد دوره"}],
                            canRemoveRecords: true,
                            canDragRecordsOut: false,
                            // showFilterEditor:true,
                            // filterOnKeypress:true,
                            canAcceptDroppedRecords: true,
                            dragDataAction: "none",
                            canHover: true,
                            showHover: true,
                            showHoverComponents: true,
                            hoverWidth: "30%",
                            hoverHeight: "30%",
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
                                    preCourseGrid.recordDrop(courseAllGrid2.getSelectedRecords(), false, false, courseAllGrid2);
                                }
                            }
                        },
                    ]
                }),
            },
            {
                title: "معادل\u200cها", canClose: false,
                pane: isc.DynamicForm.create({
                    ID: "formEqualCourse",
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
                            colSpan: 4,
                            width: "*",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            allowAdvancedCriteria: true,
                            filterOnKeypress: true,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}, {name:"code", title:"کد دوره"}],
                            canRemoveRecords: false,
                            canDragRecordsOut: true,
                            selectionType: "single",
                            dragDataAction: "none",
                            canHover: false
                        },
                        {
                            name: "equalCourseGrid1",
                            ID: "equalCourseGrid",
                            title: "معادل های دوره",
                            colSpan: 2,
                            align: "center",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            width: "*",
                            gridDataSource: "equalCourseDS",
                            gridFields: [{name: "nameEC", title: "نام دوره"}],
                            canRemoveRecords: true,
                            canDragRecordsOut: false,
                            selectionType: "single",
                            canAcceptDroppedRecords: true,
                            dragDataAction: "none",
                            canHover: true,
                        },
                        {
                            name: "andBtn",
                            ID: "andBtn",
                            colSpan: 4,
                            align: "center",
                            startRow: true,
                            endRow: false,
                            title: "",
                            width: "*",
                            type: "button",
                            click: function () {
                                if (courseAllGrid.getSelectedRecord() == null) {
                                    isc.say("دوره ای انتخاب نشده است");
                                } else {
                                    equalCourseGrid.recordDrop(courseAllGrid.getSelectedRecords(), equalCourseGrid.getSelectedRecord(), false, courseAllGrid);
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
                                    equalCourseGrid.recordDrop(courseAllGrid.getSelectedRecords(), false, false, courseAllGrid);
                                }
                            }
                        },
                    ]
                })
            }
        ],
        tabSelected: function (tabSet) {
            if (DynamicForm_course_MainTab.getItem("titleFa")._value != null) {
                if (tabSet.valueOf() == 2) {
                    andBtn.disable();
                    formEqualCourse.getItem("equalCourseGrid1").title = "معادل\u200cهای " + getFormulaMessage(DynamicForm_course_MainTab.getItem("titleFa")._value, 2, "red", "b");
                    formEqualCourse.reset();
                }
                if (tabSet.valueOf() == 1) {
                    formPreCourse.getItem("preCourseGrid1").title = "پیش\u200cنیازهای " + getFormulaMessage(DynamicForm_course_MainTab.getItem("titleFa")._value, 2, "red", "b");
                    formPreCourse.reset();
                }
                if (tabSet.valueOf() == 0) {
                    setTimeout(function () {
                        ListGrid_Goal_refresh();
                    }, 200)
                }
            }
        }
    });
    var VLayout_Tab_JspCourse = isc.VStack.create({
        membersMargin: 5,
        width: "22%",
        members: [
            isc.DynamicForm.create({
                ID: "lblCourse",
                numCols: 1,
                width: "96%",
// cellBorder:1,
                fields: [{name: "domainCourse", type: "staticText", showTitle: false, width: "*", align: "center"}],
                // padding: 10,
                isGroup: true,
                groupTitle: "حیطه",
                // styleName:"paddingRight",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid LightBlue",
                borderRadius: "6px",
                // align: "center",
                // vAlign: "center",
                // wrap: false,
                // border: "1px solid lightGray",
                height: "30%"
            }),
            isc.DynamicForm.create({
                colWidths: ["8%", "18%", "1%"],
                ID: "teacherForm",
                titleOrientation: "top",
                numCols: 2,
                // padding: 50,
                padding: "10px",
                isGroup: true,
                titleAlign: "center",
                // wrapItemTitles:true,
                groupTitle: "شرایط مدرس دوره",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid lightBlue",
                width: "96%",
                height: "74%",
                borderRadius: "6px",
                validateOnExit: true,
                textAlign: "right",
                // margin:20,
                fields: [
                    {
                        name: "minTeacherDegree",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherDegree"/>:",
                        // autoFetchData: true,
                        required: true,
                        // height: "30",
                        // width: "*",
                        textAlign: "center",
                        titleAlign: "center",
                        displayField: "titleFa",
                        valueField: "titleFa",
                        optionDataSource: RestDataSourceEducationCourseJsp,
                        filterFields: ["titleFa"],
                        sortField: ["id"],
                        click: function (form, item) {
                            item.fetchData();
                        }
                    },
                    {
                        name: "minTeacherExpYears",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherExpYears"/>" + ":",
                        prompt: "لطفا حداقل سال سابقه تدریس وارد کنید",
                        // shouldSaveValue: true,
                        textAlign: "center",
                        required: true,
                        validators: [{
                            type: "integerRange", min: 1, max: 50,
                            errorMessage: "لطفا یک عدد بین 1 تا 50 وارد کنید",
                        }],
                        // height: "30",
                        width: "*",
                        mask:"##",
                        useMask:true,
                        keyPressFilter: "[0-9]",
                        requiredMessage: "لطفا یک عدد بین 1 تا 15 وارد کنید",
                    },
                    {
                        name: "minTeacherEvalScore",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherEvalScore"/>" + ":",
                        prompt: "لطفا حداقل نمره ارزیابی را وارد کنید",
                        shouldSaveValue: true,
                        textAlign: "center",
                        writeStackedIcons: true,
                        // height: "30",
                        required: true,
                        width: "*",
                        mask:"##",
                        useMask:true,
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
            height: "100%",
            groupTitle: "اطلاعات پایه",
            styleName: "paddingRight",
            groupLabelBackgroundColor: "lightBlue",
            groupBorderCSS: "1px solid lightBlue",
            borderRadius: "6px",
            members: [DynamicForm_course_MainTab, DynamicForm_course_GroupTab]
        }), VLayout_Tab_JspCourse]
    });

    var Window_course = isc.Window.create({
        placement: "fillScreen",
        items: [isc.VLayout.create({
            membersMargin: 5,
            // layoutMargin: 5,
            width: "100%",
            height: "100%",
            members: [isc.TrVLayout.create({
                members: [HLayOut_Tab_JspCourse, courseSaveOrExitHlayout],
                border: "3px solid lightBlue",
                borderRadius: "10px",
                height: "40%",
                layoutMargin: 5,
                margin: "2%",
            }), TabSet_Goal_JspCourse],
        })],
        minWidth: 1024,
        closeClick: function () {
            // formEqualCourse.getItem("equalCourseGrid1").title = "معادل های دوره";
            // formEqualCourse.reset();
            // formPreCourse.getItem("preCourseGrid1").title = "پیشنیازهای دوره";
            // formPreCourse.reset();
            // ListGrid_Course_refresh();
            this.close();
        }
    });

    // var VLayout_Grid_Syllabus = isc.VLayout.create({
    //     width: "100%",
    //     height: "100%",
    //     members: [ListGrid_CourseSyllabus]
    // });
    var HLayout_Actions_Course = isc.HLayout.create({
        width: "100%",
        height: "1%",
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
         ID: "tabSetCourse",
        tabBarPosition: "top",
        tabs: [
            {
                // id: "TabPane_Goal_Syllabus",
                title: "<spring:message code="course_syllabus_goal"/>",
                pane: ListGrid_CourseSyllabus
            },
            {
                // id: "TabPane_Job",
                title: "<spring:message code="job"/>",
                pane: ListGrid_CourseJob
            },
            {
                // id: "TabPane_Post",
                title: "<spring:message code="post"/>",
                pane: isc.TrLG.create({
                    ID: "ListGrid_Post_JspCourse",
                    showResizeBar: false,
                    dataSource: isc.TrDS.create({
                        fields: [{name: "id", primaryKey: true, hidden: true},
                            {name: "titleFa", title: "نام فارسی", align: "center"},
                            {name: "titleEn", title: "نام لاتین", align: "center"}
                        ],
                        ID: "RestData_Post_JspCourse",
                        // fetchDataURL:courseUrl + "post/" + ListGrid_Course.getSelectedRecord().id,
                    }),
                })
            },
            {
                // id: "TabPane_Skill",
                title: "<spring:message code="skill"/>",
                pane: ListGrid_CourseSkill

            },
            {
                // id: "TabPane_Competence",
                title: "گروه مهارت",
                pane: ListGrid_CourseCompetence
            },
            <%-- {--%>
            <%-- title: "<spring:message code="course.evaluation"/>",--%>
            <%-- ID:"courseEvaluationTAB",--%>
            <%-- pane: isc.ViewLoader.create({viewURL: "course_evaluation/show-form"})--%>
            <%--}--%>
        ],
         tabSelected: function (tabNum, tabPane, ID, tab, name) {
            if (isc.Page.isLoaded())
                refreshSelectedTab_Course(tab);
        }



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
        ListGrid_CourseJob.setData([]);
        ListGrid_CourseSkill.setData([]);
        ListGrid_CourseSyllabus.setData([]);
        // ListGrid_CourseGoal.setData([]);
        ListGrid_CourseCompetence.setData([]);
        // for (j = 0; j < trainingTabSet.tabs.length; j++) {
        //     if (trainingTabSet.getTab(j).title.substr(0, 5) == "اهداف") {
        //         trainingTabSet.removeTab(j);
        //     }
        // }
    };

    function ListGrid_Course_add() {

        IButton_course_Save.disable();
        DynamicForm_course_GroupTab.getItem("category.id").enable();
        DynamicForm_course_GroupTab.getItem("erunType.id").enable();
        DynamicForm_course_GroupTab.getItem("elevelType.id").enable();
        DynamicForm_course_GroupTab.getItem("etheoType.id").enable();
        course_method = "POST";
        course_url = courseUrl;
        vm_JspCourse.clearValues();
        vm_JspCourse.clearErrors();
        DynamicForm_course_GroupTab.getItem("subCategory.id").disable();
        DynamicForm_course_MainTab.getItem("behavioralLevel").disable();
        DynamicForm_course_MainTab.getItem("acceptancelimit_a").disable();
        Window_course.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="course"/>");
        equalCourse.length = 0;
        testData.length = 0;
        lblCourse.hide();
        preCourseGrid.invalidateCache();
        equalCourseGrid.invalidateCache();
        courseAllGrid.invalidateCache();
        // DynamicForm_course.getItem("epSection").disable();
        // DynamicForm_course.getItem("theoryDuration").clearErrors();
        Window_course.show();
        setTimeout(function () {
            // ToolStrip_Actions_Goal.disable();
            // ToolStrip_Actions_Syllabus.disable();
            TabSet_Goal_JspCourse.disable();
            TabSet_Goal_JspCourse.selectTab(0);
            ListGrid_Goal.setData([]);
            ListGrid_Syllabus_Goal.setData([]);
        }, 500)


// DynamicForm_course.getFields().get(5).prompt = "لطفا مدت دوره را به صورت یک عدد وارد کنید";

    };

    function ListGrid_Course_remove() {
        var record = ListGrid_Course.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message
        code="course_delete"/>" + " " + getFormulaMessage(record.titleFa, 3, "red", "I") + " " + "<spring:message
        code="course_delete1"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="verify.delete"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="yes"/>"}), isc.IButtonCancel.create({
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
                                if (resp.data === "true") {
                                    ListGrid_Course_refresh();
                                    ListGrid_CourseJob.setData([]);
                                    ListGrid_CourseSkill.setData([]);
                                    ListGrid_CourseSyllabus.setData([]);
                                    // ListGrid_CourseGoal.setData([]);
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
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            IButton_course_Save.disable();
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
//======================================================
            if(ListGrid_Course.getSelectedRecord().hasGoal && DynamicForm_course_MainTab.getValue("evaluation") != null)
            {
            Window_course.show();
              }
            if (DynamicForm_course_MainTab.getValue("evaluation") === "3")
             {
               DynamicForm_course_MainTab.getItem("behavioralLevel").enable();
             }
             else
             {
             DynamicForm_course_MainTab.getItem("behavioralLevel").disable();
             }


//=======================================================

            Window_course.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="course"/>");
            lblCourse.getField("domainCourse").setValue("");
            Window_course.show();
            setTimeout(function () {
                ListGrid_Goal_refresh();
                ListGrid_Syllabus_Goal_refresh();
                TabSet_Goal_JspCourse.enable();
                TabSet_Goal_JspCourse.selectTab(0);
                // ToolStrip_Actions_Goal.enable();
                // ToolStrip_Actions_Syllabus.enable();
                lblCourse.show();
            }, 400)
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
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "myToken", type: "hidden"}
                ]
        })
        criteriaForm_course.setValue("CriteriaStr", JSON.stringify(advancedCriteria_course));
        criteriaForm_course.setValue("myToken", "<%=accessToken%>");
        criteriaForm_course.show();
        criteriaForm_course.submitForm();
    };

    function courseCode() {
        var subCatDis = DynamicForm_course_GroupTab.getField("subCategory.id").isDisabled();
        var cat = DynamicForm_course_GroupTab.getField("category.id").getSelectedRecord();
        var subCat = DynamicForm_course_GroupTab.getField("subCategory.id");
        var eRun = DynamicForm_course_GroupTab.getField("erunType.id").getSelectedRecord();
        var eLevel = DynamicForm_course_GroupTab.getField("elevelType.id").getSelectedRecord();
        var eTheo = DynamicForm_course_GroupTab.getField("etheoType.id").getSelectedRecord();
        subCat = subCatDis ? "" : (subCat.getSelectedRecord() == undefined ? cat.code : subCat.getSelectedRecord().code);
        eRun = eRun == undefined ? "" : eRun.code;
        eLevel = eLevel == undefined ? "" : eLevel.code;
        eTheo = eTheo == undefined ? "" : eTheo.code;
        return subCat + eRun + eLevel + eTheo;
    }

    function evalDomain() {
        setTimeout(function () {
            if (ListGrid_Syllabus_Goal.getData().localData.length == 0) {
                lblCourse.getField("domainCourse").setValue("لطفاً اهداف و سرفصل های دوره " + getFormulaMessage(DynamicForm_course_MainTab.getField("titleFa")._value, 2, "maroon", "b") + " وارد کنید.")
                return;
            }
            var allData = ListGrid_Syllabus_Goal.getData().localData;
            let da = 0.0;
            let ma = 0.0;
            let ne = 0.0;
            for (let i = 0; i < allData.length; i++) {
                if (allData.get(i).edomainTypeId == 1) {
                    da = da + allData.get(i).practicalDuration + allData.get(i).theoreticalDuration;
                }
                if (allData.get(i).edomainTypeId == 2) {
                    ma = ma + allData.get(i).practicalDuration + allData.get(i).theoreticalDuration;
                }
                if (allData.get(i).edomainTypeId == 3) {
                    ne = ne + allData.get(i).practicalDuration + allData.get(i).theoreticalDuration;
                }
            }
            let sum = da + ma + ne;
            lblCourse.getField("domainCourse").setValue("دانشی: " + getFormulaMessage(Math.round(da * 100 / sum) + "%", 2, "brown") + "، مهارتی: " + getFormulaMessage(Math.round(ma * 100 / sum) + "%", 2, "green") + "، نگرشی: " + getFormulaMessage(Math.round(ne * 100 / sum) + "%", 2, "blue"));
        }, 1000)
    }

    function setPlus(id, plus, data) {
        setTimeout(function () {
            var listId = [];
            if (plus == "PreCourse") {
                for (let i = 0; i < data.length; i++) {
                    listId.add(data[i].id);
                }
            } else if (plus == "EqualCourse") {
                for (let i = 0; i < data.length; i++) {
                    listId.add(data[i].idEC);
                }
            }
            isc.RPCManager.sendRequest({
                actionURL: courseUrl + "set" + plus + "/" + id,
                httpMethod: "PUT",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(listId),
                serverOutputAsString: false,
                callback: function (resp) {
                }
            }, 1000)
        })
    }

    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendCourseToWorkflow() {

        var sRecord = ListGrid_Course.getSelectedRecord();

        if (sRecord === null || sRecord.id === null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else if (sRecord.workflowStatusCode === "2") {
            createDialog("info", "<spring:message code='course.workflow.confirm'/>");
        } else if (sRecord.workflowStatusCode !== "0" && sRecord.workflowStatusCode !== "-3") {
            createDialog("info", "<spring:message code='course.sent.to.workflow'/>");
        } else {

            isc.MyYesNoDialog.create({
                message: "<spring:message code="course.sent.to.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {

                        var varParams = [{
                            "processKey": "courseWorkflow",
                            "cId": sRecord.id,
                            "mainObjective": sRecord.mainObjective,
                            "titleFa": sRecord.titleFa,
                            "theoryDuration": sRecord.theoryDuration.toString(),
                            "courseCreatorId": "${username}",
                            "courseCreator": userFullName,
                            "REJECTVAL": "",
                            "REJECT": "",
                            "target": "/course/show-form",
                            "targetTitleFa": "دوره",
                            "workflowStatus": "ثبت اولیه",
                            "workflowStatusCode": "0"
                        }]

                        isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));

                    }
                }
            });
        }

    }

    function startProcess_callback(resp) {

        if (resp.httpResponseCode == 200) {
            isc.say("<spring:message code='course.set.on.workflow.engine'/>");
            ListGrid_Course_refresh()
        } else {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        }
    }

    var course_workflowParameters = null;

    function selectWorkflowRecord() {

        if (workflowRecordId !== null) {

            course_workflowParameters = workflowParameters;

            let gridState = "[{id:" + workflowRecordId + "}]";

            ListGrid_Course.setSelectedState(gridState);

            ListGrid_Course.scrollToRow(ListGrid_Course.getRecordIndex(ListGrid_Course.getSelectedRecord()), 0);

            workflowRecordId = null;
            workflowParameters = null;

            ListGrid_Course_Edit();
            taskConfirmationWindow.maximize();
        }

    }

    function sendToWorkflowAfterUpdate(selectedRecord) {

        var sRecord = selectedRecord;

        if (sRecord !== null && sRecord.id !== null && course_workflowParameters !== null) {

            if (sRecord.workflowStatusCode === "-1" || sRecord.workflowStatusCode === "-2") {

                course_workflowParameters.workflowdata["REJECT"] = "N";
                course_workflowParameters.workflowdata["REJECTVAL"] = " ";
                course_workflowParameters.workflowdata["mainObjective"] = sRecord.mainObjective;
                course_workflowParameters.workflowdata["titleFa"] = sRecord.titleFa;
                course_workflowParameters.workflowdata["theoryDuration"] = sRecord.theoryDuration.toString();
                course_workflowParameters.workflowdata["courseCreatorId"] = "${username}";
                course_workflowParameters.workflowdata["courseCreator"] = userFullName;
                course_workflowParameters.workflowdata["workflowStatus"] = "اصلاح دوره";
                course_workflowParameters.workflowdata["workflowStatusCode"] = "20";
                var ndat = course_workflowParameters.workflowdata;
                isc.RPCManager.sendRequest({
                    actionURL: workflowUrl + "/doUserTask",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    httpMethod: "POST",
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    data: JSON.stringify(ndat),
                    params: {"taskId": course_workflowParameters.taskId, "usr": course_workflowParameters.usr},
                    serverOutputAsString: false,
                    callback: function (RpcResponse_o) {
                        console.log(RpcResponse_o);
                        if (RpcResponse_o.data === 'success') {

                            ListGrid_Course_refresh();

                            let responseID = sRecord.id;

                            let gridState = "[{id:" + responseID + "}]";

                            ListGrid_Course.setSelectedState(gridState);

                            ListGrid_Course.scrollToRow(ListGrid_Course.getRecordIndex(ListGrid_Course.getSelectedRecord()), 0);

                            isc.say("دوره ویرایش و به گردش کار ارسال شد");
                            taskConfirmationWindow.hide();
                            taskConfirmationWindow.maximize();
                            ListGrid_UserTaskList.invalidateCache();
                        }
                    }
                });
            }
        }


    }

    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    function refreshSelectedTab_Course(tab) {

       //  courseRecord = ListGrid_Course.getSelectedRecord();

      //  if (!(courseRecord == undefined || courseRecord == null)) {
            switch (tab.ID) {
                case "courseEvaluationTAB": {
                       if (typeof loadPage_course_evaluation !== "undefined")
                       loadPage_course_evaluation();
                    break;
                }
            }
        //}
    }

