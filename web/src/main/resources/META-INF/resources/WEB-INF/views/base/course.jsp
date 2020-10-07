<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    wait.show();
    var numClasses = 0;
    let numSkills = 0, numGoals = 0;
    var testData = [];
    var mainObjectiveList = [];
    var equalCourse = [];
    var preCourseIdList = [];
    var equalPreCourse = [];
    var equalCourseIdList = [];
    var courseRecord = {};
    var editingCourseRecord = {};
    var runV = "";
    var eLevelTypeV = "";
    var course_method = "";
    var x;
    var ChangeEtechnicalType = false;
    var course_url = courseUrl;
    var RestDataSource_category = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_SubCategory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });
    var RestDataSource_Skill_JspCourse = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان"},
            {name: "courseId", hidden: true},
            {
                name: "category.id",
                title: "گروه",
                optionDataSource: RestDataSource_category,
                displayField: "titleFa",
                valueField: "id",
                filterOperator: "equals",
                autoFitWidth: true,
            },
            {
                name: "subCategory.id",
                title: "زیر گروه",
                optionDataSource: RestDataSource_SubCategory,
                displayField: "titleFa",
                valueField: "id",
                filterOperator: "equals",
                autoFitWidth: true,
            },
            {name: "code", title: "کد", autoFitWidth: true},
        ],
        fetchDataURL: skillUrl + "/spec-list",
    });

    var RestDataSource_teacherInformation_Course = isc.TrDS.create({
        fields: [
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "personality.contactInfo.mobile"},
            {name: "personality.contactInfo.homeAddress.state.name"},
            {name: "personality.contactInfo.homeAddress.city.name"},
        ]
    });

    var RestDataSource_course = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category"},
            {name: "subCategory.titleFa"},
            {name: "runType.titleFa"},
            {name: "levelType.titleFa"},
            {name: "theoType.titleFa"},
            {name: "duration"},
            {name: "technicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            {name: "issueTitle"},
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
        fetchDataURL: courseUrl + "search",
    });
    var RestDataSource_eTechnicalType = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTechnicalType/spec-list",
    });
    var RestDataSource_e_level_type = isc.TrDS.create({
        autoCacheAllData: false,
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLevelType",
    });
    var RestDataSource_e_run_type = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eRunType/spec-list",
    });
    var RestDataSourceETheoType = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTheoType",
    });
    var RestDataSourceSubCategory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ]
    });
    var RestDataSource_CourseGoal = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.id"},
            {name: "subCategory.id"},
        ],
        // fetchDataURL: courseUrl + courseRecord.id + "/goal"
    });

    var RestDataSource_CourseSkill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ],
        fetchDataURL: courseUrl + "skill/" + courseRecord.id
    });
    var RestDataSource_CourseJob = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ],
        fetchDataURL: courseUrl + "job/" + courseRecord.id
    });
    var RestDataSource_Syllabus = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "goal.titleFa"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "edomainType.titleFa"},
            {name: "practicalDuration"},
            {name: "theoreticalDuration"}
        ],
        fetchDataURL: syllabusUrl + "spec-list"
    });
    var RestDataSourceEducationCourseJsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],

        fetchDataURL: educationLevelUrl + "spec-list",
    });
    var Menu_ListGrid_course = isc.Menu.create({
        width: 150,
        data: [
            <sec:authorize access="hasAuthority('Course_R')">
            {
                title: "<spring:message code="refresh"/>",
                <%--icon: "<spring:url value="refresh.png"/>", --%>
                click: function () {
                    ListGrid_Course_refresh();
                    // ListGrid_CourseJob.setData([]);
                    // ListGrid_CourseSkill.setData([]);
                    // ListGrid_CourseSyllabus.setData([]);
                    refreshSelectedTab_Course(tabSetCourse.getSelectedTab())
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Course_C')">
            {
                title: "<spring:message code="create"/>",
                <%--icon: "<spring:url value="create.png"/>", --%>
                click: function () {
                    ListGrid_Course_add();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_U')">
            {
                title: "<spring:message code="edit"/>",
                <%--icon: "<spring:url value="edit.png"/>", --%>
                click: function () {
                    ListGrid_Course_Edit();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_D')">
            {
                title: "<spring:message code="remove"/>",
                <%--icon: "<spring:url value="remove.png"/>", --%>
                click: function () {
                    ListGrid_Course_remove()
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_WF')">
            {
                title: "<spring:message code='send.to.workflow'/>",
                click: function () {
                    getCourseMainObjective_RunWorkflow();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAnyAuthority('Course_C','Course_R','Course_U','Course_D','Course_WF')">
            {
                isSeparator: true
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_P')">
            {
                title: "<spring:message code="format.pdf"/>",
                <%--icon: "<spring:url value="pdf.png"/>",--%>
                click: function () {
                    print_CourseListGrid("pdf");
                }
            }, {
                title: "<spring:message code="format.excel"/>",
                <%--icon: "<spring:url value="excel.png"/>",--%>
                click: function () {
                    print_CourseListGrid("excel");
                }
            }, {
                title: "<spring:message code="format.html"/>",
                <%--icon: "<spring:url value="html.png"/>",--%>
                click: function () {
                    print_CourseListGrid("html");
                }
            },
            {
                title: "<spring:message code="print.with.details"/>",
                <%--icon: "<spring:url value="print.png"/>", --%>
                click: function () {
                    window.open("course/testCourse/" + ListGrid_Course.getSelectedRecord().id + "/pdf/<%=accessToken%>");
                }
            }
            </sec:authorize>
        ]
    });
    var ListGrid_Course = isc.TrLG.create({
        ID: "gridCourse",
        <sec:authorize access="hasAuthority('Course_R')">
        dataSource: RestDataSource_course,
        </sec:authorize>
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_course,
        allowAdvancedCriteria: true,
        hoverMoveWithMouse: true,
        sortField: "id",
        sortDirection: "descending",

        <sec:authorize access="hasAuthority('Course_U')">
        rowDoubleClick: function () {
            ListGrid_Course_Edit()
        },
        </sec:authorize>

        <sec:authorize access="hasAnyAuthority('Course_Syllabus','Course_Job','Course_Post','Course_Skill','Course_Teachers')">
        selectionChanged: function (record, state) {
            if (state) {
                courseRecord = record;
                refreshSelectedTab_Course(tabSetCourse.getSelectedTab());
            }
        },
        </sec:authorize>

        dataArrived: function () {
            wait.close();
            selectWorkflowRecord();
        },
        fields: [
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
                name: "category.titleFa",
                title: "<spring:message code="course_category"/>",
                align: "center", filterOnKeypress:true,
                // filterOperator: "iC",
                // optionDataSource: RestDataSource_category,
                // displayField: "titleFa",
                // valueField: "id"
                sortNormalizer: function (record) {
                    return record.category.titleFa;
                }
            },
            {
                name: "subCategory.titleFa",
                title: "<spring:message
        code="course_subcategory"/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.subCategory.titleFa;
                }
            },
            {
                name: "runType.titleFa",
                title: "<spring:message code="course_eruntype"/>",
                align: "center",
                filterOperator: "iContains",
                // allowFilterOperators: false,
                canFilter: false,
                canSort: false,
            },
            {
                name: "levelType.titleFa", title: "<spring:message
        code="cousre_elevelType"/>", align: "center", filterOperator: "iContains",
                canFilter: false,
                canSort: false
            },
            {
                name: "theoType.titleFa", title: "<spring:message
        code="course_etheoType"/>", align: "center", filterOperator: "iContains",
                canFilter: false,
                canSort: false
            },
            {
                name: "duration",
                title: "<spring:message
                code="course_theoryDuration"/>",
                align: "center",
                filterOperator: "equals",
                // canSort: false,
                // canFilter: false,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]",
                    // criteriaField: "theoryDuration",
                },
            },
            {
                name: "technicalType.titleFa", title: "<spring:message
                 code="course_etechnicalType"/>", align: "center", filterOperator: "iContains",
                canSort: false,
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

            {name: "issueTitle", title: "شرح", hidden: true},
            {name: "description", title: "توضیحات", hidden: true},
            {
                name: "workflowStatus",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains"
            },
            {
                name: "behavioralLevel", title: "سطح رفتاری", filterOnKeypress:true,
                // hidden:true,
                valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای"
                }
            },
            {
                name: "evaluation", title: "<spring:message code="evaluation.level"/>", filterOnKeypress:true,
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                }
            },
            {
                name: "workflowStatusCode",
                title: "<spring:message code="status"/>",
                align: "center",
                autoFitWidth: true,
                filterOperator: "iContains",
                hidden: true
            },
            {name: "hasGoal", type: "boolean", title: "بدون هدف", hidden: true, canFilter: false},
            {name: "hasSkill", type: "boolean", title: "بدون مهارت", hidden: true, canFilter: false}
        ],
        autoFetchData: true,
        showFilterEditor: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        getCellCSSText: function (record, rowNum, colNum) {
            // if (record.attitude==0 && record.knowledge==0 && record.skill==0) {
            // if (!record.hasGoal && !record.hasSkill) {
            //     return "color:red;font-size: 12px;";
            // }
            if (!record.hasGoal) {
                return "color:crimson; font-size: 12px;";
            }
            // if (!record.hasSkill) {
            //     return "color:orange;font-size: 12px;";
            // }
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
        filterOnKeypress: false,
        selectionType: "single",
        showResizeBar: false,

    });
    var ListGrid_CourseJob = isc.TrLG.create({
        dataSource: RestDataSource_CourseJob,
        fields: [
            // {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", align: "center"},
            {name: "code", title: "<spring:message code="job.code"/>", align: "center",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            // {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showResizeBar: false,

    });

    var ListGrid_teacherInformation_Course = isc.TrLG.create({
        dataSource: RestDataSource_teacherInformation_Course,
        fields: [
            {
                name: "personality.firstNameFa",
                title: "<spring:message code="firstName"/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer(record){
                    return record.personality.firstNameFa
                },
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code="lastName"/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer(record){
                    return record.personality.lastNameFa
                },
            },

            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code="mobile"/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                sortNormalizer(record){
                    let tmp = record.personality?.contactInfo?.mobile;
                    return tmp ? "" : tmp;
                },
            },
            {
                name: "personality.nationalCode",
                title: "<spring:message code="national.code"/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                sortNormalizer(record){
                    return record.personality.nationalCode
                },
            },
        ],
        filterOnKeypress: false,
    });

    var ListGrid_CourseSyllabus = isc.TrLG.create({
        dataSource: RestDataSource_Syllabus,
        groupByField: "goal.titleFa",
        groupStartOpen: "none",
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
                title: "مدت زمان عملی",
                align: "center",
                summaryFunction: "sum",
                format: "0.00 ساعت"
            },
            {
                name: "theoreticalDuration",
                title: "مدت زمان تئوری",
                align: "center",
                summaryFunction: "sum",
                format: "0.00 ساعت"
            },
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showResizeBar: false,
    });

    <sec:authorize access="hasAuthority('Course_R')">
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Course_refresh();
            refreshSelectedTab_Course(tabSetCourse.getSelectedTab())


        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_U')">
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Course_Edit()
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_C')">
    var ToolStripButton_Add = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Course_add();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_D')">
    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Course_remove()
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_P')">
    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
        click: function () {
            print_CourseListGrid("pdf");
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_P')">
    var ToolStripExcel_JspCourse = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Course, courseUrl + "search", 0, null, '', "طراحی و برنامه ریزی - دوره", ListGrid_Course.getCriteria(), null);
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Course_WF')">
    var ToolStripButton_SendToWorkflow = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code='send.to.workflow'/>",
        click: function () {
            getCourseMainObjective_RunWorkflow();
        }
    });
    </sec:authorize>

    var Window_AddMainObjective = isc.Window.create({
        title: "<spring:message code="skill.plural.list"/>",
        width: "40%",
        height: "50%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_AllSkill_mainObjective_JspCourse",
                        dataSource: RestDataSource_Skill_JspCourse,
                        selectionType: "single",
                        filterOnKeypress: false,
                        canDragRecordsOut: true,
                        dragDataAction: "none",
                        canAcceptDroppedRecords: true,
                        fields: [
                            {name: "titleFa", title: "عنوان"},
                            {name: "code", title: "کد",

                            },
                            {name: "category.id",canFilter:false, filterOnKeypress:true},
                            {name: "subCategory.id",canFilter:false, filterOnKeypress:true
                            },
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                    }),
                ]
            })]
    })

    var Window_AddSkill = isc.Window.create({
        title: "<spring:message code="relate/delete.relation.skill.course"/>",
        width: "90%",
        height: "70%",
        keepInParentRect: true,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                ID: "HLayoutWindowAddSkill",
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_AllSkill_JspCourse",
                        dataSource: RestDataSource_Skill_JspCourse,
                        selectionType: "single",
                        filterOnKeypress: false,
                        canDragRecordsOut: true,
                        dragDataAction: "none",
                        canAcceptDroppedRecords: true,
                        fields: [
                            {name: "titleFa", title: "عنوان"},
                            {name: "code", title: "کد",
                                filterEditorProperties: {
                                    keyPressFilter: "[0-9/]"
                                }
                            },
                            {
                                name: "category.id", canFilter: false
                            },
                            {name: "subCategory.id", canFilter: false}
                        ],
                        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
                            if (ListGridOwnSkill_JspCourse.getSelectedRecord() == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else if(numClasses>0) {
                                let dialog = createDialog("ask","از این دوره در کلاس استفاده شده است. از تغییرات مطمئن هستید؟", "اخطار");
                                dialog.addProperties({
                                    buttonClick(button, index) {
                                        this.close();
                                        if (index === 0) {
                                            if (!ListGridOwnSkill_JspCourse.getSelectedRecord().courseMainObjectiveId) {
                                                wait.show();
                                                isc.RPCManager.sendRequest(
                                                    TrDSRequest(skillUrl + "/remove-course/" + courseRecord.id + "/" + ListGridOwnSkill_JspCourse.getSelectedRecord().id, "DELETE", null, (resp)=>{
                                                        isChangeable();
                                                        wait.close();
                                                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                                            mainObjectiveGrid_Refresh();
                                                            ListGridAllSkillRefresh();
                                                        }
                                                    })
                                                );
                                            }
                                        }
                                    }
                                })
                            }
                        },
                        gridComponents: [
                            isc.Label.create({
                            contents: "<spring:message code="skill.plural.list"/>",
                            align: "center",
                            height: 30,
                            showEdges: true
                        }),
                            "filterEditor",
                            "header",
                            "body"
                        ],
                    }),
                    isc.ToolStrip.create({
                        ID: "ListGridOwnSkill_ToolStrip",
                        width: "4%",
                        height: "100%",
                        align: "center",
                        vertical: "center",
                        membersMargin: 5,
                        members: [
                            isc.IconButton.create({
                                icon: "<spring:url value="double-arrow-left.png"/>",
                                showButtonTitle: false,
                                prompt: "افزودن",
                                click: function () {
                                    ListGridOwnSkill_JspCourse.recordDrop();
                                }
                            }),
                            isc.IconButton.create({
                                icon: "<spring:url value="double-arrow-right.png"/>",
                                showButtonTitle: false,
                                prompt: "حذف",
                                click: function () {
                                    ListGrid_AllSkill_JspCourse.recordDrop();
                                }
                            })
                        ]
                    }),
                    isc.TrLG.create({
                        ID: "ListGridOwnSkill_JspCourse",
                        dataSource: RestDataSource_Skill_JspCourse,
                        selectionType: "single",
                        filterOnKeypress: false,
                        canDragRecordsOut: true,
                        dragDataAction: "none",
                        canAcceptDroppedRecords: true,
                        fields: [
                            {name: "titleFa", title: "عنوان"},
                            {name: "code", title: "کد",
                                filterEditorProperties: {
                                    keyPressFilter: "[0-9/]"
                                }
                            },
                            {name: "category.id", filterOnKeypress:true},
                            {name: "subCategory.id", filterOnKeypress:true},
                            {name: "courseMainObjectiveId", type: "boolean", title: "هدف کلی", canFilter: false}
                        ],
                        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
                            if (ListGrid_AllSkill_JspCourse.getSelectedRecord() == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else if(numClasses>0) {
                              let dialog = createDialog("ask","از این دوره در کلاس استفاده شده است. از تغییرات مطمئن هستید؟", "اخطار");
                              dialog.addProperties({
                                  buttonClick(button, index){
                                      this.close();
                                      if(index === 0){
                                          wait.show();
                                          isc.RPCManager.sendRequest(
                                              TrDSRequest(skillUrl + "/add-course/" + courseRecord.id + "/" + ListGrid_AllSkill_JspCourse.getSelectedRecord().id, "POST", null, (resp)=>{
                                                  wait.close();
                                                  if(resp.httpResponseCode === 409){
                                              createDialog("warning", JSON.parse(resp.httpResponseText).message, "اخطار")
                                          }
                                                  if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                              ListGridAllSkillRefresh();
                                              isChangeable();
                                          }
                                                })
                                            );
                                      }
                                  }
                              })
                            }
                        },
                        gridComponents: [isc.Label.create({
                            ID: "labelSkill",
                            showEdges: true,
                            contents: "<spring:message code="list.skill.course"/>",
                            align: "center",
                            height: 30
                        }), "filterEditor", "header", "body"]
                    })
                ]
            })
        ],
        close() {
            this.Super("close", arguments);
            if (!ListGrid_Course.isMasked()) {
                ListGrid_Course_refresh();
            }
        }
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Course_C')">
            ToolStripButton_Add,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_U')">
            ToolStripButton_Edit,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_D')">
            ToolStripButton_Remove,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_P')">
            ToolStripButton_Print,

            ToolStripExcel_JspCourse,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_WF')">
            ToolStripButton_SendToWorkflow,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_R')">
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh
                ]
            })
            </sec:authorize>
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
                allowFilterExpressions: true,
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
                        orBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به معادل های دوره");
                        if (equalCourseGrid.getSelectedRecord() != null) {
                            andBtn.enable();
                            andBtn.setTitle("افزودن " + "'" + record.titleFa + "'" + " و " + equalCourseGrid.getSelectedRecord().nameEC + " به معادل های دوره")
                        } else {
                            andBtn.disable();
                        }
                    }
                    if (this.ID == "courseAllGrid2") {
                        addPreCourseBtn.enable();
                        addPreCourseBtn.setTitle("افزودن دوره " + "'" + record.titleFa + "'" + " به پیش نیازهای دوره");
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
                    if (sourceWidget.ID === "ListGrid_AllSkill_mainObjective_JspCourse") {
                        mainObjectiveGrid.transferSelectedData(ListGrid_AllSkill_mainObjective_JspCourse);
                        if(course_method === "PUT") {
                            isChangeable(false);
                        }
                    }
                    if (dropRecords[0].titleFa == DynamicForm_course_MainTab.getItem("titleFa")._value) {
                        createDialog("info", "دوره " + getFormulaMessage(dropRecords[0].titleFa, 2, "red", "b") + " نمیتواند پیشنیاز یا معادل خودش باشد.",
                            "خطا");
                        return;
                    }
                    if (sourceWidget.ID === "courseAllGrid2") {
                        preCourseGrid.transferSelectedData(courseAllGrid2);
                        setPlus(vm_JspCourse.values.id, "PreCourse", dropRecords);
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
                    let record = this.getRecord(rowNum);
                    this.removeData(record, function (dsResponse, data, dsRequest) {
                        if(course_method === "PUT"){
                            isChangeable(false);
                        }
                    });
                    if (this.ID == "equalCourseGrid") {
                        andBtn.disable();
                        setPlus(vm_JspCourse.values.id, "EqualCourse", equalCourse)
                    } else if (this.ID == "preCourseGrid") {
                        setPlus(vm_JspCourse.values.id, "PreCourse", [record], "remove");
                    }
                },
                hoverWidth: this.hoverWidth,
                hoverHeight: this.hoverHeight,
                hoverMoveWithMouse: true,
                canHover: this.canHover,
                showHeader: this.showHeader,
                showHover: this.showHover,
                showClippedValuesOnHover: true,
                showHoverComponents: this.showHoverComponents,
                getCellHoverComponent: function (record, rowNum, colNum) {
                    equalPreCourse.length = 0;
                    isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "equalCourse/" + record.id, "GET", null, (resp)=>{
                        wait.close();
                        for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                            equalPreCourseDS.addData(JSON.parse(resp.data)[i]);
                        }
                    }));
                    this.rowHoverComponent = isc.ListGrid.create({
                        dataSource: "equalPreCourseDS",
                        autoFetchData: true,
                        fields: [{name: "nameEC", title: "معادل های دوره " + record.titleFa}]
                    });
                    return this.rowHoverComponent;
                },
                // gridComponents:["header", "filterEditor", "body"],
                gridComponents: this.gridComponents,


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
    });

    isc.DataSource.create({
        ID: "mainObjectiveDS",
        clientOnly: true,
        testData: mainObjectiveList,
        fields: [
            {name: "id", type: "integer", primaryKey: true, hidden: true},
            {name: "titleFa", type: "text", title: "نام دوره"},
            {name: "subCategoryId", type: "text", title: "زیرگروه", hidden: true},
            {name: "code", type: "text", title: "کد"},
        ]
    });
    var mainObjectiveGridToolbar = isc.ToolStrip.create({
        height: 15,
        members: [
            isc.ToolStripButton.create({
                width: 15,
                height: 15,
                icon: "[SKIN]/actions/add.png",
                prompt: "<spring:message code='add'/>",
                click: function () {
                    if((typeof DynamicForm_course_GroupTab.getValue("subCategory.id") != "number") || (DynamicForm_course_GroupTab.getValue("subCategory.id") == null)){
                        createDialog("warning", "ابتدا گروه و زیر گروه را انتخاب نمایید", "اخطار");
                        return;
                    }
                    let cr = {};
                    if (course_method === "POST") {
                        cr = {
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [
                                {fieldName: "courseId", operator: "isNull"},
                                {fieldName: "categoryId", operator: "equals", value: DynamicForm_course_GroupTab.getValue("category.id")},
                                {fieldName: "subCategoryId", operator: "equals", value: DynamicForm_course_GroupTab.getValue("subCategory.id")},
                                // {fieldName: "code", operator: "notInSet", value: mainObjectiveList.getProperty("code") },
                            ]
                        }
                    } else {
                        cr = {
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [
                                {fieldName: "courseMainObjectiveId", operator: "isNull"},
                                {fieldName: "categoryId", operator: "equals", value: DynamicForm_course_GroupTab.getValue("category.id")},
                                {fieldName: "subCategoryId", operator: "equals", value: DynamicForm_course_GroupTab.getValue("subCategory.id")},
                                // {fieldName: "code", operator: "notInSet", value: mainObjectiveList.getProperty("code") },
                                {
                                    operator: "or", criteria: [
                                        {fieldName: "courseId", operator: "isNull"},
                                        {
                                            fieldName: "courseId",
                                            operator: "equals",
                                            value: parseInt(vm_JspCourse.getValue("id"))
                                        }
                                    ]
                                }
                            ]
                        };
                    }
                    Window_AddMainObjective.show();
                    ListGrid_AllSkill_mainObjective_JspCourse.setImplicitCriteria(cr);
                    ListGrid_AllSkill_mainObjective_JspCourse.fetchData();
                    ListGrid_AllSkill_mainObjective_JspCourse.invalidateCache();
                }
            }),
            isc.ToolStripButton.create({
                width: 15,
                height: 15,
                icon: "[SKIN]/actions/undo.png",
                prompt: "لغو تغییرات",
                click: "mainObjectiveGrid_Refresh()"
            }),
        ]
    });
    var DynamicForm_course_MainTab = isc.DynamicForm.create({
        // sectionVisibilityMode: "mutex",
        colWidths: ["10%", "20%", "9%", "10%", "10%"],
        titleAlign: "left",
        validateOnExit: true,
        wrapItemTitles: false,
        showInlineErrors: true,
        numCols: 5,
        fields: [
            {
                name: "mainObjectiveIds",
                ID: "mainObjectiveGrid",
                title: "<spring:message code="course_mainObjective"/>",
                canRemoveRecords: true,
                type: "ListGridItem",
                canDragRecordsOut: false,
                canAcceptDroppedRecords: true,
                showHeader: false,
                gridComponents: [mainObjectiveGridToolbar, "body"],
                gridDataSource: mainObjectiveDS,
                textAlign: "center",
                colSpan: 5,
                rowSpan: 3,
                width: "*",
                height: "*",
                endRow: false,
                selectionType: "none",
            },
            {name: "id", hidden: true},
            {
                colSpan: 3,
                name: "titleFa",
                title: "<spring:message code="course_fa_name"/>",
                editorType: "ComboBoxItem",
                optionDataSource: RestDataSource_course,
                addUnknownValues: true,
                // valueField:"id",
                filterFields: ["titleFa", "code"],
                pickListWidth: 300,
                //  displayField:["titleFa","code"],
                pickListProperties: {
                    showFilterEditor: false,
                },
                pickListFields: [
                    {name: "titleFa", title: "<spring:message code="title"/>"},
                    {name: "code", title: "<spring:message code="code"/>"}
                ],
                // length: "250",
                required: true,
                // titleOrientation: "top",
                // type: 'text',
                width: "*",
                height: "25",
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

                },


            },
            {
                name: "evaluation",
                title: "<spring:message code="evaluation.level"/>",
                colSpan: 1,

                required:true,// editorType: "ComboBoxItem",
                textAlign: "center",
                // type: "select",
                endRow: false,
                //     defaultValue: "1",
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
                pickListProperties:{
                    showFilterEditor: false
                },
                change: function (form, item, value, oldValue) {
                    if (value === "3") {
                        DynamicForm_course_MainTab.getItem("startEvaluation").required = true
                        DynamicForm_course_MainTab.getItem("behavioralLevel").setDisabled(false);
                        DynamicForm_course_MainTab.getItem("startEvaluation").setDisabled(false);
                        DynamicForm_course_MainTab.getItem("startEvaluation").enable();
                        //DynamicForm_course_MainTab.getItem("startEvaluation").setRequired(true);
                        DynamicForm_course_MainTab.getItem("startEvaluation").setValue("3");
                    } else {
                        DynamicForm_course_MainTab.getItem("startEvaluation").required = false;
                        DynamicForm_course_MainTab.getItem("behavioralLevel").setDisabled(true);
                        DynamicForm_course_MainTab.getItem("startEvaluation").setDisabled(true);
                        //DynamicForm_course_MainTab.getItem("startEvaluation").setRequired(false);
                        //DynamicForm_course_MainTab.getItem("startEvaluation").clearErrors();
                        DynamicForm_course_MainTab.getItem("startEvaluation").setValue();
                    }
                }
            },
            {
                name: "startEvaluation",
                title: "<spring:message code="start.evaluation"/>",
                // validateOnChange: true,
                required : false,
                defaultValue:"",
                textAlign: "center",
                width: 60,
                hint: "&nbsp;ماه",
                pickListProperties:{
                    showFilterEditor: false
                },
                valueMap: {
                    1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7", 8: "8", 9: "9", 10: "10", 11: "11", 12: "12"
                }
            },
            {
                name: "behavioralLevel",
                title: "<spring:message code="behavioral.Level"/>",
                colSpan: 3,
                type: "radioGroup",
                vertical: false,
                endRow: true,
                fillHorizontalSpace: true,
                defaultValue: "1",
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
                required: true,
                textAlign: "center",
                valueMap: {
                    "1": "ارزشی",
                    "2": "نمره از صد",
                    "3": "نمره از بیست",
                    "4": "بدون نمره",
                },
                pickListProperties:{
                    showFilterEditor: false
                },
                change: function (form, item, value) {

                    if (value == "1") {
                        form.getItem("acceptancelimit").validators = [{}];
                        form.getItem("acceptancelimit").hide();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit_a").show();
                        form.getItem("acceptancelimit_a").enable();
                        form.getItem("acceptancelimit_a").setRequired(true);
                        form.getItem("acceptancelimit_a").setDisabled(false);

                    } else if (value == "2") {
                        form.getItem("acceptancelimit").show();

                        form.getItem("acceptancelimit").enable();
                        form.getItem("acceptancelimit").setRequired(true);
                        DynamicForm_course_MainTab.getItem("acceptancelimit").validators = [{
                            type: "integerRange", min: 0, max: 100,
                            errorMessage: "لطفا یک عدد بین 0 تا 100 وارد کنید",
                        }, {type: "required"}]
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);

                    } else if (value == "3") {
                        form.getItem("acceptancelimit").validators = [{
                            type: "regexp",
                            errorMessage: "<spring:message code="msg.validate.score"/>",
                            expression: /^((([0-9]|1[0-9]|20)([.][0-9][0-9]?)?)?)$/,
                        }, {type: "required"}];
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").setRequired(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);

                    } else if (value == "4") {
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue()
                        form.getItem("acceptancelimit_a").setRequired(false);
                    }
                },

            },
            {
                name: "acceptancelimit",
                title: "حد نمره قبولی",
                required: true,
            },
            {
                name: "acceptancelimit_a",
                colSpan: 2,
                hidden: true,
                required: true,
                textAlign: "center",
                title: "حد نمره قبولی",
                valueMap: {
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
        titleAlign: "left",
        validateOnExit: true,
        fields: [
            {
                name: "code",
                title: "کد دوره:",
                type: "staticText",
                align: "center",
                // startRow: false,
                colSpan: 1,
                // height: "30",
            },
            {
                name: "duration",
                colSpan: 1,
                // endRow: true,
                title: "<spring:message code="course_theoryDuration"/>",
                prompt: "لطفا مدت دوره را به صورت یک عدد حداکثر 3 رقمی وارد کنید",
                // height: "30",
                required: true,
                mask: "000",
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
                ID: "statusGroupTab",
                name: "statusGroupTab",
                title: "",
                type:"label",
                canEdit: false,
                colSpan:3,
                hidden:true,
                baseStyle: "eval-code"
            },
            {
                name: "category.id",
                colSpan: 1,
                title: "<spring:message code="course_category"/>",
                textAlign: "center",
                autoFetchData: false,
                required: true,
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                pickListProperties:{
                    showFilterEditor: false
                },
                sortField: ["id"],
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("subCategory.id").enable();
                    DynamicForm_course_GroupTab.getItem("subCategory.id").setValue([]);
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                    DynamicForm_course_GroupTab.getItem("subCategory.id").fetchData();
                    DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                    mainObjectiveGrid_Refresh("clear");
                    if(course_method === "PUT"){
                        disabledTabs();
                    }
                    // ListGrid_AllSkill_JspCourse.setData([])
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
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                    mainObjectiveGrid_Refresh("clear");
                    if(course_method === "PUT"){
                        disabledTabs();
                    }
                    // ListGridAllSkillRefresh();
                }
            },
            {
                name: "runType.id",
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
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
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
                name: "levelType.id",
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
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
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
                name: "theoType.id",
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
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                },
            },
            {
                name: "technicalType.id",
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
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    ChangeEtechnicalType = true;
                },
            },
            {
                name: "titleEn",
                title: "<spring:message code="course_en_name"/>",
                colSpan: 3,
                // keyPressFilter: "[a-z|A-Z|0-9-|' '|'_']",
                hidden:true,
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber,],
                changed: function (_1, _2, _3) {
                    convertFa2En(_1, _2, _3, []);
                },
            },
            {
                name: "issueTitle",
                title: "درخواست",
                colSpan: 3,
                rowSpan: 1,
                readonly: true,
                type: "textArea",
                showHintInField: true,
                hint: "شرح مشکل/نیاز/درخواست",
                width: "*",
                length: "*",
                required: false,
                endRow: true,
                wrapTitle: true
            },
            {
                name: "description",
                type: "TextAreaItem",
                colSpan: 3,
                rowSpan: 4,
                height: "*",
                title: "توضیحات",
                width: "100%",
                length: 5000,
            }
        ],
        valuesManager: "vm_JspCourse"
    });

    var IButton_course_Save = isc.IButtonSave.create({
        ID: "courseSaveBtn",
        title: "<spring:message code="save"/>",
        click: function () {
            if (mainObjectiveGrid.data.isEmpty()) {
                createDialog("info", "دوره، بدون هدف اصلي نمي توان ايجاد کرد.");
                return;
            }
            vm_JspCourse.validate();
            if (vm_JspCourse.hasErrors()) {
                createDialog("info", "<spring:message code="msg.validate.values.form"/>");
                return;
            }
//------------------------------------
            let data = vm_JspCourse.getValues();
            if (course_method == "POST") {
                x = courseCode();
                DynamicForm_course_GroupTab.getItem('statusGroupTab').hide();
                ChangeEtechnicalType = false;
                let mainObjectiveIdList = [];
                if (mainObjectiveGrid.data.localData !== undefined) {
                    for (let k = 0; k < mainObjectiveGrid.data.localData.length; k++) {
                        mainObjectiveIdList.add(mainObjectiveGrid.data.localData[k].id);
                    }
                    data.mainObjectiveIds = mainObjectiveIdList;
                } else {
                    createDialog("info", "دوره، بدون هدف اصلي نمي توان ايجاد کرد.");
                    return;
                }
                if (data.scoringMethod === "1") {
                    data.acceptancelimit = data.acceptancelimit_a
                }
                data.workflowStatus = "ثبت اولیه";
                data.workflowStatusCode = "0";
                delete data["subCategoryId"];
                delete data["categoryId"];
                delete data["levelType"];
                delete data["theoType"];
                delete data["runType"];
                delete data["technicalType"];
                data.subCategory = DynamicForm_course_GroupTab.getItem("subCategory.id").getSelectedRecord();
                data.category = DynamicForm_course_GroupTab.getItem("category.id").getSelectedRecord();
                data.technicalTypeId = DynamicForm_course_GroupTab.getValue("technicalType.id");
                data.runTypeId = DynamicForm_course_GroupTab.getValue("runType.id");
                data.levelTypeId = DynamicForm_course_GroupTab.getValue("levelType.id");
                data.theoTypeId = DynamicForm_course_GroupTab.getValue("theoType.id");
                data.needText = DynamicForm_course_GroupTab.getValue("issueTitle");
                data.theoryDuration = DynamicForm_course_GroupTab.getValue("duration");
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(courseUrl, course_method, JSON.stringify(data), function (resp) {
                    wait.close();
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        Window_course.close();
                        TabSet_Goal_JspCourse.enable();
                        simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                        courseRecord = JSON.parse(resp.data);
                        ListGrid_Course_Edit();
                    } else if (resp.httpResponseCode === 406) {
                        let myDialog = createDialog("info", "قبلاً دوره\u200cای با این نام ذخیره شده است.",
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
                }))
            }
            else if (course_method == "PUT") {
                let sendData = vm_JspCourse.getValues();
                if (sendData.scoringMethod === "1") {
                    sendData.acceptancelimit = sendData.acceptancelimit_a
                }
                ChangeEtechnicalType = false;
                preCourseIdList = [];
                equalCourseIdList = [];
                for (let i = 0; i < testData.length; i++) {
                    preCourseIdList.add(testData[i].id);
                }
                for (let j = 0; j < equalCourse.length; j++) {
                    equalCourseIdList.add(equalCourse[j].idEC);
                }
                let mainSkills = [];
                for (let k = 0; k < mainObjectiveList.length; k++) {
                    let skill = {};
                    skill.id = mainObjectiveList[k].id;
                    skill.subCategoryId = mainObjectiveList[k].subCategoryId;
                    mainSkills.add(skill);
                }
                sendData.mainSkills = mainSkills;
                sendData.equalCourseListId = equalCourseIdList;
                sendData.preCourseListId = preCourseIdList;
                sendData.runType = sendData.runType.id;
                sendData.theoType = sendData.theoType.id;
                sendData.technicalType = sendData.technicalType.id;
                sendData.levelType = sendData.levelType.id;
                sendData.category = DynamicForm_course_GroupTab.getItem("category.id").getSelectedRecord();
                sendData.subCategory = DynamicForm_course_GroupTab.getItem("subCategory.id").getSelectedRecord();
                sendData.duration = parseInt(DynamicForm_course_GroupTab.getValue("duration"));

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(course_url, course_method, JSON.stringify(sendData), function (resp) {
                    wait.close();
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        let response = JSON.parse(resp.httpResponseText);
                        if(response.status != 200){
                            createDialog("warning", response.message);
                            return
                        }
                        sendToWorkflowAfterUpdate(response.record);
                        courseRecord = response.record;
                        DynamicForm_course_GroupTab.setValue("code", {...courseRecord}.code);
                        disabledTabs();
                        simpleDialog("<spring:message code="edit"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                    } else {
                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                    }
                }))
            } else {
                simpleDialog("<spring:message code="edit"/>", "<spring:message code="course_noEdit"/>", 3000, "say");
            }
//-------------------------------------------
        },
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
                RestDataSource_Skill_JspCourse.fetchDataURL = skillUrl + "/spec-list",
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


    var TabSet_Goal_JspCourse = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        titleEditorTopOffset: 2,
        tabs: [
            {
                title: "هدف و سرفصل", canClose: false,
                pane: isc.ViewLoader.create(
                    {viewURL: "goal/show-form"}
                )
            },
            {
                title: "<spring:message code="skill.plural.list"/>", canClose: false,
                pane: HLayoutWindowAddSkill,
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
                            showHeader: true,
                            title: "دوره ها",
                            align: "center",
                            colSpan: 4,
                            width: "*",
                            titleOrientation: "top",
                            gridComponents: ["header", "filterEditor", "body"],
                            editorType: "ListGridItem",
                            allowAdvancedCriteria: true,
                            filterOnKeypress: false,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}, {name: "code", title: "کد دوره"}],
                            canRemoveRecords: false,
                            canDragRecordsOut: true,
                            selectionType: "single",
                            dragDataAction: "none",
                            canHover: false
                        },
                        {
                            name: "preCourseGrid1",
                            ID: "preCourseGrid",
                            title: "پیش نیازهای دوره",
                            colSpan: 2,
                            align: "center",
                            showHeader: true,
                            gridComponents: ["header", "filterEditor", "body"],
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            width: "*",
                            gridDataSource: "preCourseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}, {name: "code", title: "کد دوره"}],
                            canRemoveRecords: true,
                            canDragRecordsOut: false,
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
                            showHeader: true,
                            align: "center",
                            colSpan: 4,
                            width: "*",
                            titleOrientation: "top",
                            editorType: "ListGridItem",
                            allowAdvancedCriteria: true,
                            gridComponents: ["header", "filterEditor", "body"],
                            filterOnKeypress: false,
                            showFilterEditor: true,
                            gridDataSource: "courseDS",
                            gridFields: [{name: "titleFa", title: "نام دوره"}, {name: "code", title: "کد دوره"}],
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
                            showHeader: true,
                            align: "center",
                            titleOrientation: "top",
                            gridComponents: ["header", "filterEditor", "body"],
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
            },
        ],
        tabSelected: function (tabSet) {
            if (DynamicForm_course_MainTab.getValue("titleFa") != null) {
                if (tabSet.valueOf() == 3) {
                    andBtn.disable();
                    formEqualCourse.getItem("equalCourseGrid1").title = "معادل\u200cهای " + getFormulaMessage(courseRecord.titleFa, 2, "red", "b");
                    formEqualCourse.reset();
                } else if (tabSet.valueOf() == 2) {
                    formPreCourse.getItem("preCourseGrid1").title = "پیش\u200cنیازهای " + getFormulaMessage(courseRecord.titleFa, 2, "red", "b");
                    formPreCourse.reset();
                } else if (tabSet.valueOf() == 0) {
                    setTimeout(function () {
                        ListGrid_Goal_refresh();
                    }, 1000)
                } else if (tabSet.valueOf() == 1) {
                    ListGridAllSkillRefresh();
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
                fields: [{name: "domainCourse", type: "staticText", showTitle: false, width: "*", align: "center"}],

                isGroup: true,
                groupTitle: "حیطه",
                // styleName:"paddingRight",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid LightBlue",
                borderRadius: "6px",
                height: "30%"
            }),
            isc.DynamicForm.create({
                colWidths: ["8%", "18%", "1%"],
                ID: "teacherForm",
                titleOrientation: "top",
                numCols: 2,
                padding: "10px",
                isGroup: true,
                titleAlign: "center",
                groupTitle: "شرایط مدرس دوره",
                groupLabelBackgroundColor: "lightBlue",
                groupBorderCSS: "1px solid lightBlue",
                width: "96%",
                height: "74%",
                borderRadius: "6px",
                validateOnChange: true,
                textAlign: "right",
                fields: [
                    {
                        name: "minTeacherDegree",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherDegree"/>:",
                        defaultValue: "دیپلم",
                        required: true,
                        textAlign: "center",
                        titleAlign: "center",
                        displayField: "titleFa",
                        valueField: "titleFa",
                        optionDataSource: RestDataSourceEducationCourseJsp,
                        sortField: ["id"],
                        type: "ComboBoxItem",
                        filterFields: ["titleFa","titleFa"],
                        textMatchStyle: "substring",
                        generateExactMatchCriteria: true,
                        pickListProperties: {
                            showFilterEditor: false,
                            autoFitWidthApproach: "both"
                        },
                        pickListFields: [
                            {name: "titleFa"}
                        ],

                        click: function (form, item) {
                            item.fetchData();
                        }
                    },
                    {
                        name: "minTeacherExpYears",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherExpYears"/>" + ":",
                        prompt: "لطفا یک عدد بین 1 تا 50 وارد کنید",
                        // shouldSaveValue: true,
                        textAlign: "center",
                        required: true,
                        defaultValue: 1,
                        validators: [{
                            type: "integerRange", min: 1, max: 50,
                            errorMessage: "لطفا یک عدد بین 1 تا 50 وارد کنید",
                        }],
                        width: "*",
                        mask: "00",
                        useMask: true,
                        keyPressFilter: "[0-9]",
                        requiredMessage: "لطفا یک عدد بین 1 تا 50 وارد کنید",
                    },
                    {
                        name: "minTeacherEvalScore",
                        colSpan: 2,
                        title: "<spring:message code="course_minTeacherEvalScore"/>" + ":",
                        prompt: "لطفا یک عدد بین 65 تا 100 وارد کنید",
                        shouldSaveValue: true,
                        textAlign: "center",
                        defaultValue: 65,
                        writeStackedIcons: true,
                        required: true,
                        width: "*",
                        mask: "00",
                        useMask: true,
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

    var HLayOut_Tab_JspCourse = isc.HLayout.create({
        layoutMargin: 5,
        height: "40%",
        width: "100%",
        membersMargin: 5,
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
                showResizeBar: true,
                borderRadius: "10px",
                height: "40%",
                layoutMargin: 5,
                margin: "2%",
            }), TabSet_Goal_JspCourse],
        })],
        minWidth: 1024,
        autoCenter: false,
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        canDragReposition: false,
        closeClick: function () {
            this.close();
        },
        close: function () {
            DynamicForm_course_MainTab.setDisabled(false);
            Window_AddMainObjective.close();
            ListGrid_Course_refresh();
            this.Super("close", arguments);
        }
    });

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
    var Detail_Tab_Course = isc.TabSet.create({
        ID: "tabSetCourse",
        tabBarPosition: "top",
        tabs: [
            <sec:authorize access="hasAuthority('Course_Syllabus')">
            {
                ID: "tabGoal",
                title: "<spring:message code="syllabus"/>",
                pane:isc.TrVLayout.create({
                    width: "100%",
                    height: "100%",
                    overflow: "scroll",
                    members: [
                        isc.HLayout.create({
                            width: "100%",
                            height: "1%",
                            margin: 10,
                            members: [
                                isc.ToolStrip.create({
                                    width: "100%",
                                    align: "left",
                                    border: '0px',
                                    members: [
                                        isc.ToolStripButtonRefresh.create({
                                            click: function () {
                                                ListGrid_CourseSyllabus.invalidateCache();
                                            }
                                        })
                                    ]
                                })
                            ]
                        }),ListGrid_CourseSyllabus
                    ]
                })
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_Post')">
            {
                ID: "tabPostJspCourse",
                title: "<spring:message code="need.assessment"/>",
                pane:
                    isc.TrVLayout.create({
                        width: "100%",
                        height: "100%",
                        overflow: "scroll",
                        members: [
                            isc.HLayout.create({
                                width: "100%",
                                height: "1%",
                                margin: 10,
                                members: [ isc.ToolStripButtonExcel.create({
                                    click: function () {
                                        let record = ListGrid_Course.getSelectedRecord();
                                        if (record == null) {
                                            createDialog("info", "دوره ای از جدول بالا انتخاب نشده است");
                                            return;
                                        }
                                        ExportToFile.downloadExcelRestUrl(null, ListGrid_Post_JspCourse , skillNAUrl, 0, ListGrid_Course, '',"لیست موارد نیازسنجی شده برای دوره " + record.titleFa + " با کد " + record.code, null, null, 0, true);
                                    }
                                }),isc.ToolStrip.create({
                                    width: "100%",
                                    align: "left",
                                    border: '0px',
                                    members: [
                                        isc.ToolStripButtonRefresh.create({
                                            click: function () {
                                                ListGrid_Post_JspCourse.invalidateCache();
                                            }
                                        })
                                    ]
                                })
                                ]
                            }),

                            isc.TrLG.create({
                                ID: "ListGrid_Post_JspCourse",
                                showResizeBar: false,
                                selectionType: "none",
                                autoFetchData: false,
                                sortField: "objectType",
                                // groupByField: "objectType",
                                fields: [
                                    {name: "objectType", filterOnKeypress: true},
                                    {name: "peopleType", filterOnKeypress: true},
                                    {name: "objectCode"},
                                    {name: "objectName"},
                                    {name: "area"},
                                    {name: "assistance"},
                                    {name: "affairs"},
                                    {name: "section"},
                                    {name: "unit"},
                                    {
                                        name: "enabled",
                                        valueMap:{
                                            // undefined : "فعال",
                                            74 : "غیر فعال"
                                        },
                                        filterOnKeypress: true
                                    }
                                ],
                                dataSource: isc.TrDS.create({
                                    ID: "RestData_Post_JspCourse",
                                    fields: [
                                        {name: "id", primaryKey: true, hidden: true},
                                        {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
                                        {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "objectId", hidden: true, filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "objectType", title: "نوع نیازسنجی", filterOperator: "equals", autoFitWidth: true, valueMap:{
                                                "Post": "پست انفرادی",
                                                "PostGroup": "گروه پستی",
                                                "Job": "شغل",
                                                "JobGroup": "گروه شغلی",
                                                "PostGrade": "رده پستی",
                                                "PostGradeGroup": "گروه رده پستی",
                                                "TrainingPost": "پست"
                                            }},
                                        {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                                        {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"}
                                    ],
                                    fetchDataURL: skillNAUrl
                                })})
                        ]
                    })
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_Skill')">
            {
                ID: "tabSkillJspCourse",
                title: "<spring:message code="skill"/>",
                pane:
                    isc.TrVLayout.create({
                        width: "100%",
                        height: "100%",
                        overflow: "scroll",
                        members: [
                            isc.HLayout.create({
                                width: "100%",
                                height: "1%",
                                margin: 10,
                                members: [ isc.ToolStripButtonExcel.create({
                                    click: function () {
                                        let record = ListGrid_Course.getSelectedRecord();
                                        if (!(record === undefined || record == null)) {
                                            ExportToFile.downloadExcelRestUrl(null, ListGrid_CourseSkill, courseUrl + "skill/" + record.id, 0, ListGrid_Course, '', "دوره - مهارت", ListGrid_CourseSkill.getCriteria(), null);
                                        }
                                    }
                                }), isc.ToolStrip.create({
                                    width: "100%",
                                    align: "left",
                                    border: '0px',
                                    members: [
                                        isc.ToolStripButtonRefresh.create({
                                            click: function () {
                                                ListGrid_CourseSkill.invalidateCache();
                                            }
                                        })
                                    ]
                                })
                                ]
                            }), ListGrid_CourseSkill
                        ]
                    })
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Course_Teachers')">
            {
                ID: "teacherInformationCourse",
                title: "<spring:message code='teacher.information'/>",
                pane:   isc.TrVLayout.create({
                    width: "100%",
                    height: "100%",
                    overflow: "scroll",
                    members: [
                        isc.HLayout.create({
                            width: "100%",
                            height: "1%",
                            margin: 10,
                            members: [isc.ToolStripButtonExcel.create({
                                click: function () {
                                    if (ListGrid_teacherInformation_Course.data.size() < 1)
                                        return;

                                    let record = ListGrid_Course.getSelectedRecord();
                                    if (!(record === undefined || record == null)) {
                                        ExportToFile.downloadExcelRestUrl(null, ListGrid_teacherInformation_Course,teacherInformation + "/teacher-information-iscList" + "/" + record.code, 0, ListGrid_Course, '', "دوره - اساتیدی که این دوره را تدریس کرده اند", ListGrid_teacherInformation_Course.getCriteria(), null);
                                    }
                                }
                            }), isc.ToolStrip.create({
                                width: "100%",
                                align: "left",
                                border: '0px',
                                members: [
                                    isc.ToolStripButtonRefresh.create({
                                        click: function () {
                                            ListGrid_teacherInformation_Course.invalidateCache();
                                        }
                                    })
                                ]
                            })
                            ]
                        }), ListGrid_teacherInformation_Course
                    ]
                })
            }
            </sec:authorize>
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
    let VLayout_Body_Course = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_Course, HLayout_Grid_Course, HLayout_Tab_Course]
    });

    function ListGrid_Course_refresh() {
        ListGrid_Course.invalidateCache();
        ListGrid_CourseJob.setData([]);
        ListGrid_CourseSkill.setData([]);
        ListGrid_CourseSyllabus.setData([]);
        courseRecord = {};
    }

    function ListGrid_Course_add() {
        DynamicForm_course_GroupTab.getItem("category.id").enable();
        DynamicForm_course_GroupTab.getItem("runType.id").enable();
        DynamicForm_course_GroupTab.getItem("levelType.id").enable();
        DynamicForm_course_GroupTab.getItem("theoType.id").enable();
        course_method = "POST";
        DynamicForm_course_GroupTab.getItem('statusGroupTab').hide();
        course_url = courseUrl;
        vm_JspCourse.clearValues();
        vm_JspCourse.clearErrors();
        DynamicForm_course_GroupTab.getItem("subCategory.id").disable();
        DynamicForm_course_MainTab.getItem("behavioralLevel").disable();
        DynamicForm_course_MainTab.getItem("startEvaluation").disable();
        Window_course.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="course"/>");
        equalCourse.length = 0;
        testData.length = 0;
        lblCourse.hide();
        preCourseGrid.invalidateCache();
        equalCourseGrid.invalidateCache();
        courseAllGrid.invalidateCache();
        Window_course.show();
        courseRecord = {};

        disabledTabs()
        mainObjectiveGrid_Refresh(1);
    }
    let disabledTabs = function () {
            TabSet_Goal_JspCourse.setDisabled((courseRecord.subCategory == null) || (courseRecord.subCategory.id !== editingCourseRecord.subCategory.id));
            TabSet_Goal_JspCourse.selectTab(0);
            ListGrid_Goal.setData([]);
            ListGrid_Syllabus_Goal.setData([]);
    }

    function ListGrid_Course_remove() {
        let record = ListGrid_Course.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = isc.Dialog.create({
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
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "deleteCourse/" + record.id, "DELETE", null, resp=>{
                            wait.close();
                            let response = JSON.parse(resp.httpResponseText);
                            if (response.status === 200) {
                                ListGrid_Course_refresh();
                                ListGrid_CourseJob.setData([]);
                                ListGrid_CourseSkill.setData([]);
                                ListGrid_CourseSyllabus.setData([]);
                            }
                            createDialog("info", response.message);
                        }));
                    }
                }
            });
        }
    }

    let toggleGroupTabs = status => {
        DynamicForm_course_GroupTab.getItem("category.id").setDisabled(status);
        DynamicForm_course_GroupTab.getItem("subCategory.id").setDisabled(status);
        DynamicForm_course_GroupTab.getItem("runType.id").setDisabled(status);
        DynamicForm_course_GroupTab.getItem("levelType.id").setDisabled(status);
        DynamicForm_course_GroupTab.getItem("theoType.id").setDisabled(status);
        DynamicForm_course_GroupTab.getItem('statusGroupTab').hide();
        DynamicForm_course_MainTab.setDisabled(numClasses>0);
        if (status){
            DynamicForm_course_GroupTab.getItem('statusGroupTab').show();
            DynamicForm_course_GroupTab.getItem('statusGroupTab').setCellStyle('eval-code-label');
            let str = "";
            if(numClasses !== 0){
                str = numClasses.toString() + " " + "<spring:message code='class'/>";
            }else if(numSkills !== 0){
                str = numSkills.toString() + " "+"<spring:message code='skill'/>";
            }else if(numGoals !== 0){
                str = numGoals.toString() + " " + "هدف";
            }else if(equalCourse.length > 0){
                str = equalCourse.length.toString() + " " + "دوره معادل";
            }else if(preCourseGrid.getData().localData === undefined ? false : preCourseGrid.getData().localData.length > 0){
                str = preCourseGrid.getData().localData.length.toString() + " " + "دوره پیشنیاز";
            }else if(mainObjectiveList.length > 0){
                str = mainObjectiveList.length.toString() + " " + "هدف اصلی";
            }
            statusGroupTab.setValue("<spring:message code='status.course.groupTabSectionOne'/>" + str + " " + "<spring:message code='status.course.groupTabSectionTwo'/>");
        }
    };

    function ListGrid_Course_Edit() {
        testData.length = 0;
        equalCourse.length = 0;
        preCourseGrid.invalidateCache();
        equalCourseGrid.invalidateCache();

        if (courseRecord == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            editingCourseRecord = JSON.parse(JSON.stringify(courseRecord));
            vm_JspCourse.clearValues();
            vm_JspCourse.clearErrors();
            wait.show();
            isc.RPCManager.sendRequest(
                TrDSRequest(courseUrl + "preCourse/" + courseRecord.id, "GET", null, (resp)=>{
                    for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                        preCourseDS.addData(JSON.parse(resp.data)[i]);
                    }
                    isc.RPCManager.sendRequest(
                        TrDSRequest(courseUrl + "equalCourse/" + courseRecord.id, "GET", null, (resp)=>{
                            wait.close();
                            isChangeable();
                            for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                                equalCourseDS.addData(JSON.parse(resp.data)[i]);
                            }
                        })
                    );
                })
            );
            mainObjectiveGrid_Refresh();

            course_method = "PUT";
            course_url = courseUrl + courseRecord.id;
            RestDataSourceSubCategory.fetchDataURL = categoryUrl + courseRecord.category.id + "/sub-categories";
            DynamicForm_course_GroupTab.getItem("subCategory.id").fetchData();
            vm_JspCourse.editRecord(editingCourseRecord);
            DynamicForm_course_GroupTab.setValue("subCategory.id", editingCourseRecord.subCategory.id);
//======================================================
//             if (courseRecord.hasGoal && DynamicForm_course_MainTab.getValue("evaluation") != null) {
//                 Window_course.show();
//             }
            if (DynamicForm_course_MainTab.getValue("evaluation") === "3") {
                DynamicForm_course_MainTab.getItem("behavioralLevel").enable();
                DynamicForm_course_MainTab.getItem("startEvaluation").enable();
            } else {
                DynamicForm_course_MainTab.getItem("behavioralLevel").disable();
                DynamicForm_course_MainTab.getItem("startEvaluation").disable();
            }
//=======================================================

            Window_course.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="course"/>");
            lblCourse.getField("domainCourse").setValue("");
            Window_course.show();
            if (courseRecord.scoringMethod === "1") {
                DynamicForm_course_MainTab.setValue("acceptancelimit_a", editingCourseRecord.acceptancelimit);
            }
            DynamicForm_course_MainTab.getItem("scoringMethod").change(DynamicForm_course_MainTab, DynamicForm_course_MainTab.getItem("scoringMethod"), DynamicForm_course_MainTab.getValue("scoringMethod"));
            let val = setInterval(function () {
                ListGrid_Goal_refresh();
                ListGrid_Syllabus_Goal_refresh();
                TabSet_Goal_JspCourse.enable();
                TabSet_Goal_JspCourse.selectTab(0);
                lblCourse.show();
                clearInterval(val);
            }, 400)
        }
    }

    function mainObjectiveGrid_Refresh(x1 = 0) {
        mainObjectiveList.length = 0;
        mainObjectiveGrid.invalidateCache();
        mainObjectiveGrid.fetchData();
        if (x1 === 0) {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(skillUrl + "/main-objective/" + courseRecord.id, "GET", null, (resp)=>{
                wait.close();
                for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                    mainObjectiveDS.addData(JSON.parse(resp.data)[i]);
                }
            }))
        }
    }

    var isChangeable = (canShowWaitWindow = true) => {
        if (canShowWaitWindow){
            wait.show();
        }
        isc.RPCManager.sendRequest(
            TrDSRequest(courseUrl + "checkDependence/" + courseRecord.id, "GET", null, (resp)=>{
                numClasses = 0;
                numSkills = 0;
                numGoals = 0;
                if(canShowWaitWindow) {
                    wait.close();
                }
                let normalizedResp=JSON.parse(resp.httpResponseText);
                numClasses = normalizedResp.numClasses;
                numSkills = normalizedResp.numSkills;
                numGoals = normalizedResp.numGoals;
                toggleGroupTabs(
                    numClasses > 0 || numSkills > 0 || mainObjectiveList.length > 0 || equalCourse.length > 0 || (preCourseGrid.getData().localData === undefined ? false : preCourseGrid.getData().localData.length > 0) || numGoals > 0
                );
            })
        );
    }

    function print_CourseListGrid(type) {
        let direction = ListGrid_Course.getSort()[0]["direction"] === "descending" ? "-" : "";
        printWithCriteria(ListGrid_Course.getCriteria(), {}, "CourseByCriteria.jasper", type,direction+ListGrid_Course.getSort()[0]["property"]);
    }

    function courseCode() {
        let subCatDis = DynamicForm_course_GroupTab.getItem("subCategory.id").isDisabled();
        let cat = DynamicForm_course_GroupTab.getItem("category.id").getSelectedRecord();
        let subCat = DynamicForm_course_GroupTab.getItem("subCategory.id");
        let eRun = DynamicForm_course_GroupTab.getItem("runType.id").getSelectedRecord();
        let eLevel = DynamicForm_course_GroupTab.getItem("levelType.id").getSelectedRecord();
        let eTheo = DynamicForm_course_GroupTab.getItem("theoType.id").getSelectedRecord();
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
            let allData = ListGrid_Syllabus_Goal.getData().localData;
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
            if (sum == 0) {
                sum = 1;
            }
            lblCourse.getField("domainCourse").setValue("دانشی: " + getFormulaMessage(Math.round(da * 100 / sum) + "%", 2, "brown") + "، مهارتی: " + getFormulaMessage(Math.round(ma * 100 / sum) + "%", 2, "green") + "، نگرشی: " + getFormulaMessage(Math.round(ne * 100 / sum) + "%", 2, "blue"));
        }, 1000)
    }

    function setPlus(id, plus, data, type = "create") {
        setTimeout(function () {
            let listId = [];
            if (plus == "PreCourse") {
                for (let i = 0; i < data.length; i++) {
                    listId.add(data[i].id);
                }
            } else if (plus == "EqualCourse") {
                for (let i = 0; i < data.length; i++) {
                    listId.add(data[i].idEC);
                }
            }
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "set" + plus + "/" + id + "?type=" + type, "PUT", JSON.stringify(listId), () => {
                wait.close();
                isChangeable();
            }));
        }, 1000)
    }

    // <<---------------------------------------- Send To Workflow ----------------------------------------
    //*****get course main objective*****
    function getCourseMainObjective_RunWorkflow(oldValue) {
        let record = ListGrid_Course.getSelectedRecord();
        if (record !== null) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "getCourseMainObjective/" + record.id, "GET", null, function (resp) {
                wait.close()
                sendCourseToWorkflow(resp.data);
            }));
        }
    }

    function sendCourseToWorkflow(courseMainObjective) {

        // let sRecord = ListGrid_Course.getSelectedRecord();

        if (courseRecord === null || courseRecord.id === null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else if (courseRecord.workflowStatusCode === "2") {
            createDialog("info", "<spring:message code='course.workflow.confirm'/>");
        } else if (courseRecord.workflowStatusCode !== "0" && courseRecord.workflowStatusCode !== "-3") {
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
                            "cId": courseRecord.id,
                            "mainObjective": courseRecord.titleFa + " (" + courseMainObjective + ") ",
                            "titleFa": courseRecord.titleFa,
                            "theoryDuration": courseRecord.duration.toString(),
                            "courseCreatorId": "${username}",
                            "courseCreator": userFullName,
                            "REJECTVAL": "",
                            "REJECT": "",
                            "target": "/course/show-form",
                            "targetTitleFa": "دوره",
                            "workflowStatus": "ثبت اولیه",
                            "workflowStatusCode": "0"
                        }];

                        // wait.show()
                        ///// //disable until set permission to verify course//  isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), (resp)=>{
                        ///// //disable until set permission to verify course//     wait.close()
                        ///// //disable until set permission to verify course//     startProcess_callback
                        ///// //disable until set permission to verify course// }));

                    }
                }
            });
        }

    }

    function startProcess_callback(resp) {
        if (resp.httpResponseCode === 200) {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='course.set.on.workflow.engine'/>", 3000, "say");
            ListGrid_Course_refresh()

        } else if (resp.httpResponseCode === 404) {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='workflow.bpmn.not.uploaded'/>", 3000, "stop");
        } else {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='msg.send.to.workflow.problem'/>", 3000, "stop");
        }
    }

    let course_workflowParameters = null;

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

        let sRecord = selectedRecord;

        if (sRecord !== null && sRecord.id !== null && course_workflowParameters !== null) {

            if (sRecord.workflowStatusCode === "-1" || sRecord.workflowStatusCode === "-2") {

                course_workflowParameters.workflowdata["REJECT"] = "N";
                course_workflowParameters.workflowdata["REJECTVAL"] = " ";
                course_workflowParameters.workflowdata["mainObjective"] = sRecord.mainObjective;
                course_workflowParameters.workflowdata["titleFa"] = sRecord.titleFa;
                course_workflowParameters.workflowdata["theoryDuration"] = sRecord.duration.toString();
                course_workflowParameters.workflowdata["courseCreatorId"] = "${username}";
                course_workflowParameters.workflowdata["courseCreator"] = userFullName;
                course_workflowParameters.workflowdata["workflowStatus"] = "اصلاح دوره";
                course_workflowParameters.workflowdata["workflowStatusCode"] = "20";
                let ndat = course_workflowParameters.workflowdata;
                wait.show()
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
                        wait.close();
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

        setTimeout(()=> {
            switch (tab.ID) {
                case "courseEvaluationTAB":
                    if (typeof loadPage_course_evaluation !== "undefined")
                        loadPage_course_evaluation();
                    break;
                case "teacherInformationCourse":
                    RestDataSource_teacherInformation_Course.fetchDataURL = teacherInformation + "/teacher-information-iscList" + "/" + courseRecord.id;
                    ListGrid_teacherInformation_Course.fetchData();
                    ListGrid_teacherInformation_Course.invalidateCache();
                    break;
                case "tabGoal":
                    if (ListGrid_Course.getSelectedRecord() != null) {
                        RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + ListGrid_Course.getSelectedRecord().id;
                        ListGrid_CourseSyllabus.fetchData();
                        ListGrid_CourseSyllabus.invalidateCache();
                    }
                    break;
                case "tabJobJspCourse":
                    RestDataSource_CourseJob.fetchDataURL = courseUrl + "job/" + courseRecord.id;
                    ListGrid_CourseJob.fetchData();
                    ListGrid_CourseJob.invalidateCache();
                    break;
                case "tabPostJspCourse":
                    ListGrid_Post_JspCourse.clearFilterValues();
                    ListGrid_Post_JspCourse.setImplicitCriteria({
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "courseId", operator: "equals", value: courseRecord.id}]
                    });
                    ListGrid_Post_JspCourse.invalidateCache();
                    ListGrid_Post_JspCourse.fetchData();
                    break;
                case "tabSkillJspCourse":
                    if (!jQuery.isEmptyObject(courseRecord)) {
                        RestDataSource_CourseSkill.fetchDataURL = courseUrl + "skill/" + courseRecord.id;
                        ListGrid_CourseSkill.fetchData();
                        ListGrid_CourseSkill.invalidateCache();
                    }
                    break;
            }
        },0);
    }

    let ListGridAllSkillRefresh = function () {
        if (DynamicForm_course_GroupTab.getValue("subCategory.id") != null) {

            ListGrid_AllSkill_JspCourse.invalidateCache();
            ListGrid_AllSkill_JspCourse.setImplicitCriteria({
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "courseId", operator: "isNull"},
                    {
                        fieldName: "subCategoryId",
                        operator: "equals",
                        value: courseRecord.subCategory.id
                    },
                ]
            });
            ListGrid_AllSkill_JspCourse.fetchData();

            ListGridOwnSkill_JspCourse.invalidateCache();
            ListGridOwnSkill_JspCourse.setImplicitCriteria({
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "courseId", operator: "equals", value: courseRecord.id},
                ]
            });
            ListGridOwnSkill_JspCourse.fetchData();
            labelSkill.contents = "مهارت های دوره  " + getFormulaMessage(courseRecord.titleFa, "2", "red", "b");
            labelSkill.redraw();
        }
    }



    // </script>