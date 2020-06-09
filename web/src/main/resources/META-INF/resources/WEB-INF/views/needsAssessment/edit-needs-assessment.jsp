<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    var view_ENA = null;

    Window_NeedsAssessment_ENA = isc.Window.create({
        title: "<spring:message code="needs.assessment"/>",
        minWidth: 1024,
        // autoCenter: false,
        // showMaximizeButton: false,
        // autoSize: false,
        // keepInParentRect: true,
        // isModal: false,
        placement: "fillScreen",
        // close() {
        //     // clearAllGrid();
        //     // ListGridNeedsAssessment_Refresh();
        //     view_ENA.close();
        //     this.Super("close", arguments);
        // },
        // show() {
        //     let record;
        //     let myVar = setInterval(function () {
        //         record = NeedsAssessmentTargetDF_ENA.getItem("objectId").getSelectedRecord();
        //         if(record !== undefined){
        //             refreshPersonnelLG(record);
        //             if(NeedsAssessmentTargetDF_ENA.getValue("objectType")==="Post") {
        //                 Label_PlusData_ENA.setContents(
        //                     "عنوان پست: " + record.titleFa
        //                     + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "عنوان رده پستی: " + record.postGrade.titleFa
        //                     + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "حوزه: " + record.area
        //                     + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "معاونت: " + record.assistance
        //                     + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "امور: " + record.affairs
        //                 );
        //             } else
        //                 Label_PlusData_ENA.setContents("");
        //             clearInterval(myVar)
        //         }
        //     },100);
        //     this.Super("show", arguments)
        // },
        items: [
            isc.DynamicForm.create({
                ID: "NeedsAssessmentTargetDF_ENA",
                numCols: 2,
                readOnlyDisplay: "readOnly",
                fields: [
                    {
                        name: "objectType",
                        showTitle: false,
                        // optionDataSource: NeedsAssessmentTargetDS_needsAssessment,
                        valueField: "code",
                        displayField: "title",
                        defaultValue: "Job",
                        autoFetchData: false,
                        pickListFields: [{name: "title"}],
                        defaultToFirstOption: true,
                        changed: function (form, item, value, oldValue) {
                            // if(value !== oldValue) {
                            //     updateObjectIdLG(form, value);
                            //     clearAllGrid();
                            //     form.getItem("objectId").clearValue();
                            //     Label_PlusData_ENA.setContents("");
                            //     refreshPersonnelLG();
                            // }
                        },
                    },
                    {
                        name: "objectId",
                        showTitle: false,
                        // optionDataSource: JobDs_needsAssessment,
                        type: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        pickListFields: [
                            {name: "code"},
                            {name: "titleFa"}
                        ],
                        changed: function (form, item, value, oldValue) {
                            // if(value !== oldValue){
                            //     editNeedsAssessmentRecord(NeedsAssessmentTargetDF_ENA.getValue("objectId"), NeedsAssessmentTargetDF_ENA.getValue("objectType"));
                            //     refreshPersonnelLG();
                            // }
                        },
                    },
                ]
            }),
            // isc.TrHLayout.create({
            //     height: "1%",
            //     members: [Label_PlusData_ENA,]
            // }),
            // isc.TrHLayout.create({
            //     members: [
            //         isc.TrVLayout.create({width: "25%", showResizeBar: true, members: [ListGrid_Competence_ENA, ListGrid_SkillAll_ENA]}),
            //         isc.TrVLayout.create({
            //             members: [
            //                 isc.TrHLayout.create({height: "70%", showResizeBar: true, members: [ListGrid_Knowledge_ENA, ListGrid_Ability_ENA, ListGrid_Attitude_ENA]}),
            //                 ListGrid_Personnel_ENA
            //             ]
            //         }),
            //
            //     ]
            // }),
        ]
    });


    function aaaaaaaaaa(view){
        view_ENA = view;
    }

    // </script>