<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%
final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var editing = false;
    var priorityList = {
        "Post": "پست",
        "PostGroup": "گروه پستی",
        "Job": "شغل",
        "JobGroup": "گروه شغلی",
        "PostGrade": "رده پستی",
        "PostGradeGroup": "گروه رده پستی",
    };
    var skillData = [];
    var competenceData = [];

    var RestDataSourceNeedsAssessment = isc.TrDS.create({
        // autoCacheAllData:true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectType", title: "<spring:message code="title"/>", width:90, valueMap: priorityList},
            {name: "competence.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: needsAssessmentUrl + "/iscList",
    });
    var ToolStrip_NeedsAssessment_JspNeedAssessment = isc.ToolStrip.create({
        members: [
            <sec:authorize access="hasAuthority('NeedAssessment_C')">
            isc.ToolStripButtonCreate.create({
                click: function () {
                    NeedsAssessmentTargetDF_needsAssessment.clearValues();
                    updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, "Job");
                    Window_NeedsAssessment_JspNeedsAssessment.show();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            isc.ToolStripButtonEdit.create({
                ID: "editButtonJspNeedsAsessment",
                click: function () {
                    if(checkSelectedRecord(ListGrid_NeedsAssessment_JspNeedAssessment)) {
                        if (ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType === "Post") {
                            var criteria = '{"fieldName":"id","operator":"equals","value":"' + ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId + '"}';
                            PostDs_needsAssessment.fetchDataURL = postUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
                        }
                        NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").fetchData(function () {
                            ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="global.waiting"/>";
                            editNeedsAssessmentRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId, ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType);
                            NeedsAssessmentTargetDF_needsAssessment.setValue("objectType", ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType);
                            NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId);
                            Window_NeedsAssessment_JspNeedsAssessment.show();
                        })
                        // editNeedsAssessmentRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId, ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType);
                        // one(two);
                        // function one(callBack) {
                        //     editNeedsAssessmentRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId, ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType);
                        //     callBack();
                        // }
                        // function two() {
                        //     NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").fetchData({"id":ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId} ,function() {
                        //         Window_NeedsAssessment_JspNeedsAssessment.show();
                        //     })
                        // }
                    }
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAuthority('NeedAssessment_R')">
            isc.ToolStripButton.create({
                title: "<spring:message code="more.information"/>",
                click: function () {
                    if(checkSelectedRecord(ListGrid_NeedsAssessment_JspNeedAssessment)){
                        Window_MoreInformation_JspNeedsAssessment.show()
                    }
                }
            }),
            </sec:authorize>


            <sec:authorize access="hasAuthority('NeedAssessment_WFCommittee')">
            isc.ToolStripButton.create({
                title: "<spring:message code="send.to.committee.workflow"/>",
                click: function () {
                    sendNeedAssessment_CommitteeToWorkflow();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAuthority('NeedAssessment_WFMain')">
            isc.ToolStripButton.create({
                title: "<spring:message code="send.to.main.workflow"/>",
                click: function () {
                    sendNeedAssessment_MainWorkflow();
                }
            }),
            </sec:authorize>

            <sec:authorize access="hasAuthority('NeedAssessment_R')">
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            ListGrid_NeedsAssessment_JspNeedAssessment.invalidateCache();
                            ListGrid_NeedsAssessment_JspNeedAssessment.fetchData();
                        }
                    })
                ]
            })
            </sec:authorize>
        ]
    });
    var ToolStrip_NeedsAssessmentTree_JspNeedAssessment = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonPrint.create({
                click: function () {
                    // isc.Canvas.showPrintPreview(printContainer)
                    let rec = ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord()
                    let advancedCriteria = {
                        _constructor:"AdvancedCriteria",
                        operator:"and",
                        criteria:[
                            { fieldName:"objectId", operator:"equals", value:rec.objectId },
                            { fieldName:"objectType", operator:"equals", value:rec.objectType }
                        ]
                    };
                    let params = {};
                    params.title = priorityList[rec.objectType] + ": " + rec.objectName + "        " +(rec.objectCode ? "کد: " + rec.objectCode : "");
                    printWithCriteria(advancedCriteria, params, "oneNeedsAssessment.jasper")
                }
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                        }
                    })
                ]
            })
        ]
    });
    var Label_Title_JspNeedsAssessment = isc.LgLabel.create({
        contents:"",
        customEdges: ["R","L","T", "B"]});

    var ListGrid_NeedsAssessment_JspNeedAssessment = isc.TrLG.create({
        // groupByField:["objectName"],
        // groupByField:["objectType", "objectName"],
        // groupStartOpen: "none",
        allowAdvancedCriteria:true,
        filterOnKeypress:true,
        autoFetchData: true,
        fields:[
            {name: "objectType", title: "<spring:message code="type"/>", filterOperator: "iContains", valueMap: priorityList},
            {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "competence.title", title: "<spring:message code="competence.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="domain"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workflowStatusCode", title: "<spring:message code="status"/>", filterOperator: "iContains", hidden:true},
            {name: "workflowStatus", title: "<spring:message code="committee.workflow.status"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "mainWorkflowStatusCode", title: "<spring:message code="status"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "mainWorkflowStatus", title: "<spring:message code="main.workflow.status"/>", filterOperator: "iContains"}
        ],
        <sec:authorize access="hasAuthority('NeedAssessment_R')">
        dataSource: RestDataSourceNeedsAssessment,
        </sec:authorize>

        gridComponents: [ToolStrip_NeedsAssessment_JspNeedAssessment, "filterEditor", "header", "body"],

        <sec:authorize access="hasAuthority('NeedAssessment_U')">
        recordDoubleClick: function () {
            editButtonJspNeedsAsessment.click();
            changeDirection(0);
        },
        </sec:authorize>

        // groupStartOpen: "all",
        dataArrived: function () {
            // groupStartOpen: "all"

            // console.log(ListGrid_NeedsAssessment_JspNeedAssessment.getRecord(0));
            // ListGrid_NeedsAssessment_JspNeedAssessment.expandRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getRecord(0));

            // let gridState = "[{id:" + 5 + "}]";
            //
            // ListGrid_NeedsAssessment_JspNeedAssessment.setSelectedState(gridState);
            //
            // ListGrid_NeedsAssessment_JspNeedAssessment.scrollToRow(ListGrid_NeedsAssessment_JspNeedAssessment.getRecordIndex(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord()), 0);
            //
            // ListGrid_NeedsAssessment_JspNeedAssessment.expandRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord());

            //console.log(ListGrid_NeedsAssessment_JspNeedAssessment.getGroupTreeSelection());
            setTimeout(function(){ $("tbody tr td:nth-child(7)").css({direction:'ltr'});},100);
            selectWorkflowRecord();
        },
        rowHover: function(){
            changeDirection(0);
        },
        rowOver:function(){
            changeDirection(0);
        },
        rowClick:function(){
            changeDirection(0);
        },
        doubleClick: function () {
            changeDirection(0);
            EditSkill_Skill();
        },
    });



    var ListGrid_MoreInformation_JspNeedAssessment = isc.ListGrid.create({
        // groupByField:["objectType"],
        groupByField:["competence.competenceType.title", "needsAssessmentDomain.title", "needsAssessmentPriority.title", "competence.title", "skill.titleFa"],
        allowAdvancedCriteria: true,
        showFilterEditor: false,
        showHeaderContextMenu: false,
        // filterOnKeypress:true,
        autoFetchData: false,
        fields:[
            <%--{name: "objectType", title: "<spring:message code="type"/>", filterOperator: "iContains", valueMap: priorityList},--%>
            <%--{name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},--%>
            <%--{name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},--%>
            {name: "competence.title", title: "<spring:message code="competence.title"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: false},
            {name: "skill.course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="domain"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},
        ],
        showClippedValuesOnHover: true,
        dataSource: RestDataSourceNeedsAssessment,
        gridComponents: [ToolStrip_NeedsAssessmentTree_JspNeedAssessment, Label_Title_JspNeedsAssessment ,"header", "body"],
        groupStartOpen: "all",
        getCellCSSText: function (record, rowNum, colNum) {

            if (record.skill == undefined) {
                return "color:black; font-size: 12px;";
            }
            else if(record.skill.course == undefined){
                return "color:crimson; font-size: 13px;";
            }
            else{
                return "color:blue; font-size: 13px;";
            }
            // if (!record.hasSkill) {
            //     return "color:orange;font-size: 12px;";
            // }
        }
    });

    //----------------------components of window--------------------------

    let NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",

    });
    let JobDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/iscList"
    });
    let JobGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "iscList"
    });
    let PostDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: postUrl + "/iscList"
    });
    let PostGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGroupUrl + "/spec-list"
    });
    let PostGradeDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    let PostGradeGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });
    var RestDataSource_Skill_JspNeedsAssessment = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });
    var RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment = isc.TrDS.create({
        fields:[
            {name: "id", primaryKey:true},
            {name:"code"},
            {name:"title"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"parameter.code\",\"operator\":\"equals\",\"value\":\"NeedsAssessmentPriority\"}"
    });
    var RestDataSource_Competence_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });

    var DataSource_Competence_JspNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        testData: competenceData,
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var DataSource_Skill_JspNeedsAssessment = isc.DataSource.create({
        ID: "DataSource_Skill_JspNeedsAssessment",
        fields: [
            {name: "id", hidden:true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriorityId", title: "<spring:message code="priority"/>", filterOperator: "iContains", autoFitWidth:true},
            {name: "needsAssessmentDomainId", filterOperator: "iContains", hidden:true},
            {name: "skillId", primaryKey: true, filterOperator: "iContains", hidden:true},
            {name: "competenceId", filterOperator: "iContains", hidden:true},
            {name: "objectId", filterOperator: "iContains", hidden:true},
            {name: "objectType", title: "<spring:message code="type"/>", primaryKey: true, filterOperator: "iContains", valueMap: priorityList},
        ],
        testData: skillData,
        clientOnly: true,
    });

    let CompetenceTS_needsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessment",
        members: [
            // isc.ToolStripButtonRefresh.create({
            //     click: function () { refreshLG(ListGrid_Competence_JspNeedsAssessment); }
            // }),
            isc.ToolStripButtonAdd.create({
                title:"افزودن",
                click: function () {
                    if(NeedsAssessmentTargetDF_needsAssessment.getValue("objectId")!=null) {
                        ListGrid_AllCompetence_JspNeedsAssessment.fetchData();
                        ListGrid_AllCompetence_JspNeedsAssessment.invalidateCache();
                        Window_AddCompetence.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }),
            // isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_needsAssessment"}),
        ]
    });

    var ListGrid_AllCompetence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspNeedsAssessment",
        dataSource: RestDataSource_Competence_JspNeedsAssessment,
        showHeaderContextMenu: false,
        selectionType: "single",
        selectionAppearance: "checkbox",
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "competenceType.title", title: "<spring:message code="type"/>"}
        ],
        gridComponents: ["filterEditor", "header", "body"],
        // selectionUpdated: "ListGrid_Competence_JspNeedsAssessment.setData(this.getSelection())"
        selectionChanged(record, state) {
            if (state == true) {
                if (checkSaveData(record, DataSource_Competence_JspNeedsAssessment, "id")) {
                    ListGrid_Competence_JspNeedsAssessment.transferSelectedData(this);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            }
        }
    });
    var ListGrid_Competence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Competence_JspNeedsAssessment",
        dataSource: DataSource_Competence_JspNeedsAssessment,
        autoFetchData: true,
        selectionType:"single",

        // selectionAppearance: "checkbox",
        showHeaderContextMenu: false,
        showRowNumbers: false,
        border: "1px solid",
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessment, "header", "body"
        ],
        canRemoveRecords:true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        removeRecordClick(rowNum){
            let data = ListGrid_Knowledge_JspNeedsAssessment.data.localData.toArray();
            data.addAll(ListGrid_Attitude_JspNeedsAssessment.data.localData.toArray());
            data.addAll(ListGrid_Ability_JspNeedsAssessment.data.localData.toArray());
            for (let i = 0; i < data.length; i++) {
                if(removeRecord_JspNeedsAssessment(data[i])){
                    return;
                }
            }
            DataSource_Competence_JspNeedsAssessment.removeData(this.getRecord(rowNum));
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsGrid();
        }
    });
    var ListGrid_SkillAll_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspNeedsAssessment",
        dataSource: RestDataSource_Skill_JspNeedsAssessment,
        autoFetchData: true,
        // selectionAppearance: "checkbox",
        showRowNumbers: false,
        showHeaderContextMenu: false,
        selectionType:"single",
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"}
        ],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", customEdges: ["B"]}),
            "filterEditor", "header", "body"
        ],
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
        canDragRecordsOut: true,
        dataArrived:function(){
            setTimeout(function(){ $("tbody tr td:nth-child(1)").css({direction:'ltr'});},300);
        },
        rowHover: function(){
            changeDirection(1);
        },
        rowOver:function(){
            changeDirection(1);
        },
        rowClick:function(){
            changeDirection(1);
        },
        doubleClick: function () {
            changeDirection(1);
        }
    });

    let RestDataSource_Personnel_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    let ListGrid_Personnel_JspNeedsAssessment = isc.TrLG.create({
        width: "100%",
        dataSource: RestDataSource_Personnel_JspNeedsAssessment,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "companyName"},
            {name: "ccpAffairs"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
        ],
        autoFetchData: false,
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="personnel.for"/>" + "</b></span>", customEdges: ["T","L","R","B"]}),
            "header", "body"],
        // canExpandRecords: true,
        // expansionMode: "details",
        // showDetailFields: true
    });

    var ListGrid_Knowledge_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        autoSaveEdits:false,
        implicitCriteria:{"needsAssessmentDomainId":108},
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
                change(form, item){
                    updateSkillRecord(form, item)
                }
                // modalEditing: true,
                // valueMap:["عملکرد ضروری","عملکرد توسعه ای","عملکرد بهبود"]
            }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "needsAssessmentPriorityId"],
                title: "<spring:message code="knowledge"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        // hoverMode: "detailField",
        canRemoveRecords:true,
        showHeaderContextMenu: false,
        showFilterEditor:false,
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 108));
                        // fetchDataDomainsGrid();
                        // this.fetchData();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        canEditCell(rowNum, colNum){
            if(colNum === 1) {
                let record = this.getRecord(rowNum);
                if (record.objectType === NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
                    return true;
                }
            }
            return false;
        }
    });
    var ListGrid_Ability_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Ability_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
        autoFetchData:false,
        showRowNumbers: false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
                change(form, item){
                    updateSkillRecord(form, item)
                }
            }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "needsAssessmentPriorityId"],
                title: "<spring:message code="ability"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        showHeaderContextMenu: false,
        canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        autoSaveEdits:false,
        // hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":109},
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 109));
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        canEditCell(rowNum, colNum){
            if(colNum == 1) {
                let record = this.getRecord(rowNum);
                if (record.objectType == NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
                    return true;
                }
            }
            return false;
        },
    });
    var ListGrid_Attitude_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Attitude_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
                change(form, item){
                    updateSkillRecord(form, item)
                }
            }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "needsAssessmentPriorityId"],
                title: "<spring:message code="attitude"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        canAcceptDroppedRecords: true,
        // canHover: true,
        autoSaveEdits:false,
        showHoverComponents: true,
        // hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":110},
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 110));
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid()
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        canEditCell(rowNum, colNum){
            if(colNum == 1) {
                let record = this.getRecord(rowNum);
                if (record.objectType == NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
                    return true;
                }
            }
            return false;
        },
    });

    //--------------------------------------------------------------------
    var moreInfoTree = isc.TreeGrid.create({
        ID: "needesAssessmentTree",
        data:[],
        fields: [
            {name: "name", title: "<spring:message code="skill"/>"},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", width:"10%"},

        ],
        width: "100%",
        height: "80%",
        autoDraw: false,
        showOpenIcons:false,
        showDropIcons:false,
        showSelectedIcons:false,
        showConnectors: true,
        // baseStyle: "noBorderCell",
        dataProperties:{
        dataArrived:function (parentNode) {
            this.openAll();
        },
        changed:function () {
        },
    }
    });
    //--------------------------------------------------------------------

    var Label_PlusData_JspNeedsAssessment = isc.LgLabel.create({
        // width: "25%",
        // wrap: true,
        align:"left",
        contents:"",
        customEdges: []});
    var Window_AddCompetence = isc.Window.create({
        title: "<spring:message code="skill.plural.list"/>",
        width: "40%",
        height: "50%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    ListGrid_AllCompetence_JspNeedsAssessment
                ]
            })]
    });
    var Window_NeedsAssessment_JspNeedsAssessment = isc.Window.create({
        title: "<spring:message code="needs.assessment"/>",
        minWidth: 1024,
        autoCenter: false,
        showMaximizeButton: false,
        autoSize: false,
        keepInParentRect: true,
        isModal:false,
        placement:"fillScreen",
        close(){
          clearAllGrid();
          ListGridNeedsAssessment_Refresh();
          this.Super("close",arguments)
        },
        show(){
            // updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"));
            // if(NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")==="Post"){
                let record;
                let myVar = setInterval(function () {
                        record = NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord();
                        if(record !== undefined){
                            refreshPersonnelLG(record);
                            if(NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")==="Post") {
                                Label_PlusData_JspNeedsAssessment.setContents(
                                    "عنوان پست: " + record.titleFa
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "عنوان رده پستی: " + record.postGrade.titleFa
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "حوزه: " + record.area
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "معاونت: " + record.assistance
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "امور: " + record.affairs
                                );
                            } else
                                Label_PlusData_JspNeedsAssessment.setContents("");
                            clearInterval(myVar)
                        }
                    },100);
            // }
            // else {
            //     Label_PlusData_JspNeedsAssessment.setContents("")
            // }
            this.Super("show",arguments)
        },
        items:[
            isc.DynamicForm.create({
                ID: "NeedsAssessmentTargetDF_needsAssessment",
                numCols: 2,
                readOnlyDisplay: "readOnly",
                fields: [
                    {
                        name: "objectType",
                        showTitle: false,
                        optionDataSource: NeedsAssessmentTargetDS_needsAssessment,
                        valueField: "code",
                        displayField: "title",
                        defaultValue: "Job",
                        autoFetchData: false,
                        pickListFields: [{name: "title"}],
                        defaultToFirstOption: true,
                        changed: function (form, item, value, oldValue) {
                            if(value !== oldValue) {
                                updateObjectIdLG(form, value);
                                clearAllGrid();
                                form.getItem("objectId").clearValue();
                                Label_PlusData_JspNeedsAssessment.setContents("");
                                refreshPersonnelLG();
                            }
                        },
                    },
                    {
                        name: "objectId",
                        showTitle: false,
                        optionDataSource: JobDs_needsAssessment,
                        type: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        // autoFetchData: false,
                        pickListFields: [
                            {name: "code"},
                            {name: "titleFa"}
                        ],
                        click: function(form){
                            // updateObjectIdLG(form, form.getValue("objectType"));
                            if(form.getValue("objectType") === "Post"){
                                PostDs_needsAssessment.fetchDataURL = postUrl + "/iscList";
                                Window_AddPost_JspNeedsAssessment.show();
                            }
                        },
                        changed: function (form, item, value, oldValue) {
                            if(value !== oldValue){
                                editNeedsAssessmentRecord(NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"), NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"));
                                refreshPersonnelLG();
                            }
                        },
                    },
                ]
            }),
            <%--isc.TrHLayout.create({--%>
                <%--height: "1%",--%>
                <%--members: [--%>
                    <%--Label_PlusData_JspNeedsAssessment,--%>
                    <%--// isc.LgLabel.create({width: "25%", customEdges: []}),--%>
                    <%--isc.LgLabel.create({width: "75%",--%>
                        <%--valign: "bottom",--%>
                        <%--contents: "<span><b>" + "<spring:message code="domain"/>" + "</b></span>", customEdges: ["T", "B", "R", "L"]}),--%>
                <%--]--%>
            <%--}),--%>
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    // isc.LgLabel.create({width: "25%", customEdges: []}),
                    Label_PlusData_JspNeedsAssessment,
                    <%--isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="knowledge"/>" + "</b></span>", customEdges: ["R", "B", "T"]}),--%>
                    <%--isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="ability"/>" + "</b></span>",customEdges: ["R", "B", "T"]}),--%>
                    <%--isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="attitude"/>" + "</b></span>", customEdges: ["R", "L", "B", "T"]}),--%>
                ]
            }),
            isc.TrHLayout.create({
                members: [
                    isc.TrVLayout.create({
                        width: "25%",
                        showResizeBar: true,
                        members: [ListGrid_Competence_JspNeedsAssessment, ListGrid_SkillAll_JspNeedsAssessment]
                    }),
                    isc.TrVLayout.create({
                        // width: "75%",
                        members: [
                            isc.TrHLayout.create({
                                height: "70%",
                                showResizeBar: true,
                                members: [
                                    ListGrid_Knowledge_JspNeedsAssessment,
                                    ListGrid_Ability_JspNeedsAssessment,
                                    ListGrid_Attitude_JspNeedsAssessment
                                ]
                            }),
                            ListGrid_Personnel_JspNeedsAssessment
                        ]
                    }),

                ]
            }),
        ]
    });
    var Window_AddPost_JspNeedsAssessment = isc.Window.create({
        title: "<spring:message code="post.plural.list"/>",
        placement: "fillScreen",
        // width: "80%",
        // height: "50%",
        minWidth: 1024,
        keepInParentRect: true,
        autoSize: false,
        show(){
            ListGrid_Post_JspNeedsAssessment.invalidateCache();
            ListGrid_Post_JspNeedsAssessment.fetchData();
            this.Super("show", arguments);
        },
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_Post_JspNeedsAssessment",
                        dataSource: PostDs_needsAssessment,
                        selectionType: "single",
                        filterOnKeypress: false,
                        // autoFetchData:true,
                        fields: [
                            {name: "id", primaryKey: true, hidden: true},
                            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
                            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                        recordDoubleClick(viewer, record, recordNum, field, fieldNum, value, rawValue){
                            // var criteria = {
                            //     _constructor:"AdvancedCriteria",
                            //     operator:"and",
                            //     criteria:[
                            //         { fieldName:"id", operator:"equals", value:record.id }
                            //     ]
                            // };
                            let criteria = '{"fieldName":"id","operator":"equals","value":"'+record.id+'"}';
                            PostDs_needsAssessment.fetchDataURL = postUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria="+ criteria;
                            wait.show();
                            NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").fetchData(function () {
                                NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", record.id);
                                editNeedsAssessmentRecord(record.id, "Post");
                                Label_PlusData_JspNeedsAssessment.setContents(
                                    "عنوان پست: " + record.titleFa
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "عنوان رده پستی: " + record.postGrade.titleFa
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "حوزه: " + record.area
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "معاونت: " + record.assistance
                                    + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "امور: " + record.affairs
                                );
                                wait.close();
                            });
                            // NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").pickListCriteria = {"id" : record.id};
                            refreshPersonnelLG(record);
                            Window_AddPost_JspNeedsAssessment.close();
                        }
                    }),
                ]
            })]
    });
    var Window_MoreInformation_JspNeedsAssessment = isc.Window.create({
        title: "<spring:message code="more.information"/>",
        // placement: "fillScreen",
        width: "60%",
        height: "90%",
        minWidth: 1024,
        keepInParentRect: true,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                ID: "printContainer",
                members: [
                    isc.TabSet.create({
                        ID: "tabSetNeedsAssessment",
                        // enabled: false,
                        tabBarPosition: "top",
                        tabs: [
                            {
                                title: "درخت نیازسنجی",
                                pane: ListGrid_MoreInformation_JspNeedAssessment
                            },
                            {
                                enabled: false,
                                title: "شرایط احراز",
                                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/checkList-tab"})
                            },
                            {
                                enabled: false,
                                title: "شرح شغل",
                                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/student"})
                            },
                            {
                                enabled: false,
                                title: "آموزش ها",
                                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
                            },
                            {
                                enabled: false,
                                title: "پراکندگی شغل در سازمان",
                                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attendance-tab"})
                            },
                            {
                                enabled: false,
                                title: "شناسنامه شغل",
                                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/scores-tab"})
                            },
                            {
                                title: "درخت اطلاعات",
                                pane: moreInfoTree
                            },
                        ],
                        tabSelected: function (tabNum, tabPane, ID, tab, name) {

                        }
                    })
                ]
            })
        ],
        show() {
            let rec = ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord()
            Label_Title_JspNeedsAssessment.setContents(priorityList[rec.objectType] + ": " + rec.objectName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + (rec.objectCode ? " کد: " + rec.objectCode : ""));
            // this.setTitle(priorityList[rec.objectType] + ": " + rec.objectName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + (rec.objectCode ? " کد: " + rec.objectCode : ""));
            let advancedCriteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "objectId", operator: "equals", value: rec.objectId},
                    {fieldName: "objectType", operator: "equals", value: rec.objectType}
                ]
            };
            let criteria = '{"fieldName":"objectId","operator":"equals","value":"' + rec.objectId + '"},' +
                '{"fieldName":"objectType","operator":"equals","value":"' + rec.objectType + '"}';

            ListGrid_MoreInformation_JspNeedAssessment.invalidateCache();
            ListGrid_MoreInformation_JspNeedAssessment.fetchData(advancedCriteria);

            var url = needsAssessmentUrl + "/iscTree?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria;
            isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
                if (resp.httpResponseCode != 200) {
                    return flase;
                } else {
                    var Treedata = isc.Tree.create({
                        modelType: "parent",
                        nameProperty: "Name",
                        idField: "id",
                        parentIdField: "parentId",
                        data: JSON.parse(resp.data).response.data
                    });
                    moreInfoTree.setData(Treedata);
                    moreInfoTree.getData().openAll();
                }
            }));
            this.Super("show", arguments)
        }
    });

    isc.TrVLayout.create({
        members: [ListGrid_NeedsAssessment_JspNeedAssessment],
    });

    function updateObjectIdLG(form, value) {
        form.getItem("objectId").canEdit = true;
        switch (value) {
            case 'Job':
                form.getItem("objectId").optionDataSource = JobDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false }
                    ];
                break;
            case 'JobGroup':
                form.getItem("objectId").optionDataSource = JobGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'Post':
                form.getItem("objectId").optionDataSource = PostDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
                form.getItem("objectId").canEdit = false;
                // PostDs_needsAssessment.fetchDataURL = postUrl + "/wpIscList";
                break;
            case 'PostGroup':
                form.getItem("objectId").optionDataSource = PostGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'PostGrade':
                form.getItem("objectId").optionDataSource = PostGradeDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}
                    ];
                break;
            case 'PostGradeGroup':
                form.getItem("objectId").optionDataSource = PostGradeGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false},
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}
                    ];
                break;
        }
    }

    function refreshPersonnelLG(pickListRecord) {
        if (pickListRecord == null)
            pickListRecord = NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord();
        if (pickListRecord == null){
            ListGrid_Personnel_JspNeedsAssessment.setData([]);
            return;
        }
        let crt = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: []
        };
        switch (NeedsAssessmentTargetDF_needsAssessment.getItem("objectType").getValue()) {
            case 'Job':
                crt.criteria.add({fieldName: "jobNo", operator: "equals", value: pickListRecord.code});
                break;
            case 'JobGroup':
                crt.criteria.add({fieldName: "jobNo", operator: "inSet", value: pickListRecord.jobSet.map(PG => PG.code)});
                break;
            case 'Post':
                crt.criteria.add({fieldName: "postCode", operator: "equals", value: pickListRecord.code});
                break;
            case 'PostGroup':
                crt.criteria.add({fieldName: "postCode", operator: "inSet", value: pickListRecord.postSet.map(PG => PG.code)});
                break;
            case 'PostGrade':
                crt.criteria.add({fieldName: "postGradeCode", operator: "equals", value: pickListRecord.code});
                break;
            case 'PostGradeGroup':
                crt.criteria.add({fieldName: "postGradeCode", operator: "inSet", value: pickListRecord.postGradeSet.map(PG => PG.code)});
                break;
        }
        ListGrid_Personnel_JspNeedsAssessment.implicitCriteria = crt;
        // refreshLG(ListGrid_Personnel_JspNeedsAssessment);
        ListGrid_Personnel_JspNeedsAssessment.invalidateCache();
        ListGrid_Personnel_JspNeedsAssessment.fetchData();
    }

    function createNeedsAssessmentRecords(data) {
        // fetchDataDomainsGrid();
        if(!checkSaveData(data, DataSource_Skill_JspNeedsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl, "POST", JSON.stringify(data),function(resp){
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id
            DataSource_Skill_JspNeedsAssessment.addData(data);
            fetchDataDomainsGrid();
        }))
    }

    function fetchDataDomainsGrid(){
        let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
        if(record != null) {
            ListGrid_Knowledge_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Knowledge_JspNeedsAssessment.invalidateCache();

            ListGrid_Ability_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Ability_JspNeedsAssessment.invalidateCache();

            ListGrid_Attitude_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Attitude_JspNeedsAssessment.invalidateCache();
        }
    }

    function checkSaveData(data, dataSource, field = "skillId", objectType = null) {
        if(!objectType) {
            if(dataSource.testData.find(f => f[field] === data[field]) != null) {
                return false;
            }
            return true;
        }
        else{
            if(dataSource.testData.find(f => f[field] === data[field] && f["objectType"] === data["objectType"]) != null){
                return false;
            }
            return true;
        }
    }

    function editNeedsAssessmentRecord(objectId, objectType) {
        // let criteria = [
        //     '{"fieldName":"objectType","operator":"equals","value":"'+objectType+'"}',
        //     '{"fieldName":"objectId","operator":"equals","value":'+objectId+'}'
        // ];
        updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, objectType);
        clearAllGrid();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + objectType + "/" + objectId, "GET", null, function(resp){
            if (resp.httpResponseCode !== 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            let data = JSON.parse(resp.data).list;
            let flags  = [];
            for (let i = 0; i < data.length; i++) {
                let skill = {};
                let competence = {};
                skill.id = data[i].id;
                skill.titleFa = data[i].skill.titleFa;
                skill.needsAssessmentPriorityId = data[i].needsAssessmentPriorityId;
                skill.needsAssessmentDomainId = data[i].needsAssessmentDomainId;
                skill.skillId = data[i].skillId;
                skill.competenceId = data[i].competenceId;
                skill.objectId = data[i].objectId;
                skill.objectType = data[i].objectType;
                DataSource_Skill_JspNeedsAssessment.addData(skill);
                if( flags[data[i].competenceId]) continue;
                flags[data[i].competenceId] = true;
                // outPut.push(data[i].competenceId);
                competence.id = data[i].competenceId;
                competence.title = data[i].competence.title;
                competence.competenceType = data[i].competence.competenceType;
                DataSource_Competence_JspNeedsAssessment.addData(competence, ()=>{ListGrid_Competence_JspNeedsAssessment.selectRecord(0)});
            }
            ListGrid_Competence_JspNeedsAssessment.fetchData();
            ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", objectId);
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectType", objectType);
            fetchDataDomainsGrid();
        }))
    }

    function clearAllGrid() {
        competenceData.length = 0;
        skillData.length = 0;
        ListGrid_Competence_JspNeedsAssessment.setData([]);
        ListGrid_Knowledge_JspNeedsAssessment.setData([]);
        ListGrid_Attitude_JspNeedsAssessment.setData([]);
        ListGrid_Ability_JspNeedsAssessment.setData([]);
    }

    function removeRecord_JspNeedsAssessment(record) {
        if(record.objectType == NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "DELETE", null, function (resp) {
                if (resp.httpResponseCode != 200) {
                    return true;
                }
                DataSource_Skill_JspNeedsAssessment.removeData(record);
                // return false;
            }));
        }
    }

    function createData_JspNeedsAssessment(record, DomainId, PriorityId = 111) {
        let data = {
            objectType: NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"),
            objectId: NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"),
            objectName: NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord().titleFa,
            objectCode: NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord().code,
            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
            skillId: record.id,
            titleFa: record.titleFa,
            needsAssessmentPriorityId: PriorityId,
            needsAssessmentDomainId: DomainId
        };
        return data;
    }

    function ListGridNeedsAssessment_Refresh() {
        ListGrid_NeedsAssessment_JspNeedAssessment.invalidateCache();
    }

    function updateSkillRecord(form, item) {
        let record = form.getData();
        record.needsAssessmentPriorityId = item.getSelectedRecord().id;
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "PUT", JSON.stringify(record), function(resp) {
            if(resp.httpResponseCode !== 200){
                createDialog("info", "<spring:message code='error'/>");
            }
            DataSource_Skill_JspNeedsAssessment.updateData(record);
            item.grid.endEditing();
        }));
    }


    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendNeedAssessment_CommitteeToWorkflow() {
        let sRecord = ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord();

        if (sRecord === null || sRecord.id === null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else if ((sRecord.workflowStatusCode !== undefined && sRecord.workflowStatusCode === 0 && sRecord.workflowStatusCode !== -3) || sRecord.workflowStatusCode === 10) {
            createDialog("info", "<spring:message code='needs.assessment.sent.to.workflow'/>");
        } else if (sRecord.workflowStatusCode === 1) {
            createDialog("info", "<spring:message code='needs.assessment.workflow.confirm'/>");
        }
        else if(sRecord.workflowStatusCode === -1){
            sendToWorkflowAfterUpdate_needsAssessment(sRecord, "Committee");
        }
        else {
            let needAssessmentTitle = "نیازسنجی " + priorityList[sRecord.objectType] + " " + sRecord.objectName + " انجام شد";

            isc.MyYesNoDialog.create({
                message: "<spring:message code="needs.assessment.sent.to.committee.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let varParams = [{
                            "processKey": "needAssessment_CommitteeWorkflow",
                            "cId": sRecord.id,
                            "needAssessment": needAssessmentTitle,
                            "needAssessmentCreatorId": "${username}",
                            "needAssessmentCreator": userFullName,
                            "REJECTVAL": " ",
                            "REJECT": "",
                            "target": "/web/needsAssessment",
                            "targetTitleFa": "نیازسنجی",
                            "workflowStatus": "ثبت اولیه",
                            "workflowStatusCode": "0"
                        }];

                        isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
                    }
                }
            });
        }
    }

    function sendNeedAssessment_MainWorkflow() {
        let sRecord = ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord();


        if (sRecord === null || sRecord.id === null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else if ((sRecord.mainWorkflowStatusCode !== undefined && sRecord.mainWorkflowStatusCode === 0 && sRecord.mainWorkflowStatusCode !== -3) || sRecord.mainWorkflowStatusCode === 10) {
            createDialog("info", "<spring:message code='needs.assessment.sent.to.workflow'/>");
        } else if (sRecord.mainWorkflowStatusCode === 1) {
            createDialog("info", "<spring:message code='needs.assessment.workflow.confirm'/>");
        } else if(sRecord.mainWorkflowStatusCode === -1){
            sendToWorkflowAfterUpdate_needsAssessment(sRecord, "Main");
        } else {
            let needAssessmentTitle = "نیازسنجی " + priorityList[sRecord.objectType] + " " + sRecord.objectName + " انجام شد";

            isc.MyYesNoDialog.create({
                message: "<spring:message code="needs.assessment.sent.to.main.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        var varParams = [{
                            "processKey": "needAssessment_MainWorkflow",
                            "cId": sRecord.id,
                            "needAssessment": needAssessmentTitle,
                            "needAssessmentCreatorId": "${username}",
                            "needAssessmentCreator": userFullName,
                            "REJECTVAL": "",
                            "REJECT": "",
                            "target": "/web/needsAssessment",
                            "targetTitleFa": "نیازسنجی",
                            "workflowStatus": "ثبت اولیه",
                            "workflowStatusCode": "0"
                        }];

                        isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
                    }
                }
            });
        }
    }

    function startProcess_callback(resp) {
        if (resp.httpResponseCode === 200) {
            isc.say("<spring:message code='course.set.on.workflow.engine'/>");

            ListGrid_NeedsAssessment_JspNeedAssessment.invalidateCache();
            ListGrid_NeedsAssessment_JspNeedAssessment.fetchData();

        } else  if (resp.httpResponseCode === 404) {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        }
        else
        {
            isc.say("<spring:message code='msg.send.to.workflow.problem'/>");
        }
    }

    var needs_workflowParameters = null;

    function selectWorkflowRecord() {

        if (workflowRecordId !== null) {

            needs_workflowParameters = workflowParameters;

            let gridState = "[{id:" + workflowRecordId + "}]";

            ListGrid_NeedsAssessment_JspNeedAssessment.setSelectedState(gridState);

            ListGrid_NeedsAssessment_JspNeedAssessment.scrollToRow(ListGrid_NeedsAssessment_JspNeedAssessment.getRecordIndex(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord()), 0);

            // ListGrid_NeedsAssessment_JspNeedAssessment.expandRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord());

            workflowRecordId = null;
            workflowParameters = null;

            // ListGrid_Course_Edit();
            // taskConfirmationWindow.maximize();
        }

    }

    function checkSelectedRecord(lg) {
        if(lg.getSelectedRecord() === undefined){
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return false;
        }
        else{
            return true;
        }
    }

    function sendToWorkflowAfterUpdate_needsAssessment(selectedRecord, workflowType) {

        let sRecord = selectedRecord;

        if (needs_workflowParameters !== null) {

            if ((workflowType === "Committee" && sRecord.workflowStatusCode === -1) || (workflowType === "Main" && sRecord.mainWorkflowStatusCode === -1)) {

                isc.MyYesNoDialog.create({
                    message: workflowType === "Main" ? "<spring:message code="needs.assessment.sent.to.main.workflow.ask"/>" : "<spring:message code="needs.assessment.sent.to.committee.workflow.ask"/>",
                    title: "<spring:message code="message"/>",
                    buttonClick:function (button, index) {
                        this.close();
                        if(index === 0)
                        {
                            let needAssessmentTitle = "نیازسنجی " + priorityList[sRecord.objectType] + " " + sRecord.objectName + " اصلاح شد";

                            needs_workflowParameters.workflowdata["REJECT"] = "N";
                            needs_workflowParameters.workflowdata["REJECTVAL"] = " ";
                            needs_workflowParameters.workflowdata["needAssessment"] = needAssessmentTitle;
                            needs_workflowParameters.workflowdata["needAssessmentCreatorId"] = "${username}";
                            needs_workflowParameters.workflowdata["needAssessmentCreator"] = userFullName;
                            needs_workflowParameters.workflowdata["workflowStatus"] = "اصلاح نیازسنجی";
                            needs_workflowParameters.workflowdata["workflowStatusCode"] = "20";

                            var ndat = needs_workflowParameters.workflowdata;

                            isc.RPCManager.sendRequest({
                                actionURL: workflowUrl + "/doUserTask",
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                httpMethod: "POST",
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                showPrompt: false,
                                data: JSON.stringify(ndat),
                                params: {"taskId": needs_workflowParameters.taskId, "usr": needs_workflowParameters.usr},
                                serverOutputAsString: false,
                                callback: function (RpcResponse_o) {

                                    if (RpcResponse_o.data === 'success') {

                                        ListGrid_NeedsAssessment_JspNeedAssessment.invalidateCache();
                                        ListGrid_NeedsAssessment_JspNeedAssessment.fetchData();

                                        setTimeout(function () {
                                            let responseID = sRecord.id;
                                            let gridState = "[{id:" + responseID + "}]";
                                            ListGrid_NeedsAssessment_JspNeedAssessment.setSelectedState(gridState);
                                            ListGrid_NeedsAssessment_JspNeedAssessment.scrollToRow(ListGrid_NeedsAssessment_JspNeedAssessment.getRecordIndex(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord()), 0);
                                        },1500);

                                        createDialog("info", "<spring:message code="msg.needs.assessment.sent.to.workflow.after.correction"/>");
                                        taskConfirmationWindow.hide();
                                        taskConfirmationWindow.maximize();
                                        ListGrid_UserTaskList.invalidateCache();

                                    }
                                }
                            });
                        }
                    }
                });
            }
        }
        else {
            createDialog("info", "<spring:message code="msg.needs.assessment.resend.to.workflow.from.cartable"/>");
        }


    }

    function tree(){

    }

    const changeDirection=(status)=>{
        let classes=".cellAltCol,.cellDarkAltCol, .cellOverAltCol, .cellOverDarkAltCol, .cellSelectedAltCol, .cellSelectedDarkAltCol," +
            " .cellSelectedOverAltCol, .cellSelectedOverDarkAltCol, .cellPendingSelectedAltCol, .cellPendingSelectedDarkAltCol," +
            " .cellPendingSelectedOverAltCol, .cellPendingSelectedOverDarkAltCol, .cellDeselectedAltCol, .cellDeselectedDarkAltCol," +
            " .cellDeselectedOverAltCol, .cellDeselectedOverDarkAltCol, .cellDisabledAltCol, .cellDisabledDarkAltCol";
        setTimeout(function() {
            $(classes).css({'direction': 'ltr!important'});
            if (status==0)
            $("tbody tr td:nth-child(7)").css({'direction':'ltr'});
                else
            $("tbody tr td:nth-child(1)").css({'direction':'ltr'});
        },10);
    };
    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    // </script>