<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    var change_value
    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************

    RestDataSource_evaluationAnalysist_learning = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "tclass.scoringMethod"},
            {
                name: "student.firstName",filterOperator: "iContains",
            },
            {
                name: "student.lastName",filterOperator: "iContains",
            },
            {
                name: "student.nationalCode",filterOperator: "iContains",
            },

            {
                name: "student.personnelNo",filterOperator: "iContains",
            },
            {name:"preTestScore", filterOperator: "iContains"},
            {name:"score", filterOperator: "iContains"},
            {name:"valence", filterOperator: "iContains"},
        ],
    });
    //**************************************************************************
    var ListGrid_evaluationAnalysist_learning = isc.TrLG.create({
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
//------------
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,

//------
        canSelectCells: true,
// sortField: 0,
        dataSource: RestDataSource_evaluationAnalysist_learning,
        fields: [

            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",autoFitWidth:true

            },

            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name:"score", title: "نمره پس آزمون",  filterOperator: "iContains",autoFitWidth:true,

            },
                {
                name: "preTestScore",
                title: "نمره پيش تست",
                filterOperator: "iContains",
                canEdit: true,
                validateOnChange: false,
                editEvent: "click",
                    change:function(){
                        change_value=true
                    },
                    editorExit:function(editCompletionEvent, record, newValue)
                    {

                        if (newValue != null) {
                        if (validators_evaluarionAnalysist_Learning_ScorePreTest(newValue)) {
                            ListGrid_Cell_evaluationAnalysist_learning(record, newValue);
                        } else {
                            createDialog("info", "<spring:message code="enter.current.score"/>", "<spring:message code="message"/>")

                        }
                          }
                        else if(change_value) {
                            ListGrid_Cell_evaluationAnalysist_learning(record, newValue);
                            change_value=false
                        }
                        else {return true}
                    }

             },
            {
                name:"valence",title: "نمره معادل ارزشی",  filterOperator: "iContains",autoFitWidth:true,
                valueMap: {"1001": "20", "1002": "50", "1003": "65", "1004": "100"},
            },


        ],

    });
    //**************************************************************************



   function ListGrid_Cell_evaluationAnalysist_learning(record,newValue)
   {
       record.preTestScore=newValue
       isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/score-pre-test"+"/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update(rpcResponse)"));
   }

    function validators_evaluarionAnalysist_Learning_ScorePreTest(value) {

            if (value.match(/^(100|[1-9]?\d)$/)) {
                return true
            } else {
                return false
            }
    }

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
            RestDataSource_evaluationAnalysist_learning.fetchDataURL = tclassStudentUrl + "/pre-test-score-iscList/" + Record.id
            ListGrid_evaluationAnalysist_learning.invalidateCache()

        }
    });

    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({

        title: "چاپ خلاصه ای از وضعیت ارزیابی یادگیری",
        click: function () {
            print_evaluationAnalysist_learning()
        }
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Print,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            })
        ]
    });



    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });


    var HLayout_Grid_evaluationAnalysist_learning=isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_evaluationAnalysist_learning]
    })

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
              HLayout_Actions_Group,HLayout_Grid_evaluationAnalysist_learning
        ]
    });

    function evaluationAnalysist_learning() {

        var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        if (!(Record === undefined || Record == null)) {
            RestDataSource_evaluationAnalysist_learning.fetchDataURL = tclassStudentUrl + "/evaluationAnalysistLearning/" + Record.id
            ListGrid_evaluationAnalysist_learning.invalidateCache()
            ListGrid_evaluationAnalysist_learning.fetchData()
            if (Record.scoringMethod == "1") {
                ListGrid_evaluationAnalysist_learning.hideField('score');
                ListGrid_evaluationAnalysist_learning.showField('valence')
            } else if (Record.scoringMethod == "2") {
                ListGrid_evaluationAnalysist_learning.showField('score')
                ListGrid_evaluationAnalysist_learning.hideField('valence');
            }
            else if (Record.scoringMethod == "3") {
                ListGrid_evaluationAnalysist_learning.showField('score')
                ListGrid_evaluationAnalysist_learning.hideField('valence');
            }
            else if (Record.scoringMethod == "4") {
                ListGrid_evaluationAnalysist_learning.hideField('valence')
                ListGrid_evaluationAnalysist_learning.hideField('score');
            }
        }
    }

    function print_evaluationAnalysist_learning() {
        var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
             var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/evaluationAnalysist-learning/evaluaationAnalysist-learningReport"/>",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "recordId", type: "hidden"},
                    {name: "token", type: "hidden"},
                    {name: "scoringMethod", type: "hidden"},

                ]

        })
        criteriaForm.setValue("recordId", JSON.stringify(Record.id));
        criteriaForm.setValue("scoringMethod", Record.scoringMethod);
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    };










