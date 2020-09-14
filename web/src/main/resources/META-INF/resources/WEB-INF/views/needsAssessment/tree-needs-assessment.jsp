<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    var ACriteriaJspTreeNeedsAssessment = {};
    var recJspTreeNeedsAssessment = null;
    var paramsJspTreeNeedsAssessment = {};
    var treeNeedsAssessmentList = [];


    var DataSource_JspTreeNeedsAssessment = isc.DataSource.create({
        // autoCacheAllData:true,
        clientOnly: true,
        testData: treeNeedsAssessmentList,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectType", title: "<spring:message code="title"/>", width:90, valueMap: priorityList},
            {name: "competence.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            <%--{name: "course.code", title: "<spring:message code="type"/>", filterOperator: "iContains"},--%>
            {name: "needsAssessmentDomain.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
    });

    var ToolStrip_NeedsAssessmentTree_JspTreeNeedAssessment = isc.ToolStrip.create({
        members: [
            <sec:authorize access="hasAuthority('NeedAssessment_C')">
            isc.ToolStripButtonPrint.create({
                click: function () {
                    // isc.Canvas.showPrintPreview(printContainer)
                    // let rec = ListGrid_NeedsAssessment_JspTreeNeedAssessment.getSelectedRecord()
                    // let ACriteriaJspTreeNeedsAssessment = {
                    //     _constructor:"AdvancedCriteria",
                    //     operator:"and",
                    //     criteria:[
                    //         { fieldName:"objectId", operator:"equals", value:rec.objectId },
                    //         { fieldName:"objectType", operator:"equals", value:rec.objectType }
                    //     ]
                    // };
                    // let params = {};
                    printWithCriteria(ACriteriaJspTreeNeedsAssessment, paramsJspTreeNeedsAssessment, "oneNeedsAssessment.jasper")
                }
            }),
            </sec:authorize>
            // isc.ToolStrip.create({
            //     width: "100%",
            //     align: "left",
            //     border: '0px',
            //     members: [
            //         isc.ToolStripButtonRefresh.create({
            //             click: function () {
            //             }
            //         })
            //     ]
            // })
        ]
    });
    var Label_Title_JspTreeNeedsAssessment = isc.LgLabel.create({
        contents:"",
        customEdges: ["R","L","T", "B"]});
    var ListGrid_MoreInformation_JspTreeNeedAssessment = isc.ListGrid.create({
        // groupByField:["objectType"],
        groupByField:["competence.competenceType.title", "needsAssessmentDomain.title", "needsAssessmentPriority.title", "competence.title", "skill.titleFa"],
        // allowAdvancedCriteria: true,
        showFilterEditor: false,
        showHeaderContextMenu: false,
        // filterOnKeypress:true,
        autoFetchData: true,
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
        dataSource: DataSource_JspTreeNeedsAssessment,
        gridComponents: [ToolStrip_NeedsAssessmentTree_JspTreeNeedAssessment, Label_Title_JspTreeNeedsAssessment ,"header", "body"],
        groupStartOpen: "none",
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

    isc.TrVLayout.create({
        members: [ListGrid_MoreInformation_JspTreeNeedAssessment],
    });

    function loadNeedsAssessmentTree(rec, type) {
        recJspTreeNeedsAssessment = rec;
        // this.setTitle(priorityList[rec.objectType] + ": " + rec.objectName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + (rec.objectCode ? " کد: " + rec.objectCode : ""));
        ACriteriaJspTreeNeedsAssessment = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "objectId", operator: "equals", value: rec.id},
                {fieldName: "objectType", operator: "equals", value: type}
            ]
        };
        paramsJspTreeNeedsAssessment.title = priorityList[type] + ": " + recJspTreeNeedsAssessment.titleFa + "        " +(recJspTreeNeedsAssessment.code ? "کد: " + recJspTreeNeedsAssessment.code : "");
        let intervalTreeNeedsAssessment = setInterval(()=>{
            if(ListGrid_MoreInformation_JspTreeNeedAssessment!==undefined) {
                treeNeedsAssessmentList.length = 0;
                ListGrid_MoreInformation_JspTreeNeedAssessment.invalidateCache();
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + type + "/" + rec.id, "GET", null, (resp)=>{
                    wait.close()
                    if(resp.httpResponseCode === 200){
                        list = JSON.parse(resp.data).list
                        Label_Title_JspTreeNeedsAssessment.setContents(priorityList[type] + ": " + rec.titleFa + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + (rec.code ? " کد: " + rec.code : ""));
                        for (let i = 0; i < JSON.parse(resp.data).list.length; i++) {
                            DataSource_JspTreeNeedsAssessment.addData(JSON.parse(resp.data).list[i]);
                        }
                    }
                }));
                clearInterval(intervalTreeNeedsAssessment);
            }
        },50);

        // var url = needsAssessmentUrl + "/iscTree?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria;
        // isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
        //     if (resp.httpResponseCode != 200) {
        //         return flase;
        //     } else {
        //         var Treedata = isc.Tree.create({
        //             modelType: "parent",
        //             nameProperty: "Name",
        //             idField: "id",
        //             parentIdField: "parentId",
        //             data: JSON.parse(resp.data).response.data
        //         });
        //         moreInfoTree.setData(Treedata);
        //         moreInfoTree.getData().openAll();
        //     }
        // }));
    }

    // </script>