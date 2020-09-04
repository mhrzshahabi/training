<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var endDateCheckReportCOCT = true;
    var RestDataSource_Term_JspCOCT = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list"
    });
    var RestDataSource_subCategory_COCT = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ]
    });
    var RestDataSource_category_COCT = isc.TrDS.create({

        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_classOutsideCurrentTerm = isc.TrDS.create({

        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleClass"},
            {name: "term.titleFa"},
            {name: "startDate"},
            {name: "endDate"},

        ], dataFormat: "json",

        // autoFetchData: true,
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        ID: "ToolStrip_Actions1",
        // width: "100%",
        members: [
            isc.Label.create({
                ID: "totalRecords_COCT"
            })]
    })
    var List_Grid_Reaport_classOutsideCurrentTerm = isc.TrLG.create({
        dataSource: RestDataSource_classOutsideCurrentTerm,
        showRowNumbers: true,
        //autoFetchData: true,
        initialSort: [

            {property: "startDate", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "titleClass", title: "عنوان کلاس", align: "center", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains"},
            {name: "startDate",title: "تاریخ شروع",align: "center",filterOperator: "iContains"},
            {name: "endDate",title: "تاریخ پایان",align: "center",filterOperator: "iContains"},
            {name: "term.titleFa",title: "ترم",align: "center",filterOperator: "iContains"},



        ],
        recordDoubleClick: function () {

        },
        dataChanged: function () {
            this.Super("dataChanged", arguments);
           let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {

                totalRecords_COCT.setContents("<spring:message code="number.of.Items"/>" + ":&nbsp;<b>" + totalRows + "</b>");

            } else {
                totalRecords_COCT.setContents("&nbsp;");
            }
        },
        gridComponents: [
            isc.ToolStripButtonExcel.create({
                margin:5,
                click: function() {
                    if (endDateCheckReportCOCT == false)
                        return;

                    if (!DynamicForm_Report_COCT.validate()) {
                        return;
                    }

                    let criteria = List_Grid_Reaport_classOutsideCurrentTerm.getCriteria();

                    if (typeof (criteria.operator) == 'undefined') {
                        criteria._constructor = "AdvancedCriteria";
                        criteria.operator = "and";
                    }

                    if (typeof (criteria.criteria) == 'undefined') {
                        criteria.criteria = [];
                    }

                    let cat=DynamicForm_Report_COCT.getField("category.Id").getValue();
                    let subCat=DynamicForm_Report_COCT.getField("subCategory.id").getValue();
                    var strSData=DynamicForm_Report_COCT.getItem("termId").getSelectedRecord().startDate;

                     criteria.criteria.push({fieldName: "costumeStartDate", operator: "equals", value: strSData});
                     criteria.criteria.push({fieldName: "course.category.id", operator: "equals", value: cat});
                     criteria.criteria.push({ operator:"or", criteria:[  {fieldName: "course.subCategory.id", operator: "equals", value: subCat?subCat:subCat=[]}]});

                    ExportToFile.showDialog(null, List_Grid_Reaport_classOutsideCurrentTerm, 'classOutsideCurrentTerm', 0, null, '',  "کلاس هاي برگزار شده خارج از تقويم جاري", criteria, null);
                }
            }),ToolStrip_Actions,"filterEditor", "header", "body"],
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,    });

    var DynamicForm_Report_COCT = isc.DynamicForm.create({
        numCols: 9,
        colWidths: ["2%","20%","5%","17%","5%","17%","5%"],
        fields: [
            {
                name: "termId",
// titleColSpan: 1,
                title: "<spring:message code='term'/>",
                textAlign: "center",
                required: true,
                addUnknownValues:false,
                defaultToFirstOption:true,
               // editorType: "ComboBoxItem",
                displayField: ["code","startDate"],

                valueField: "id",
                optionDataSource: RestDataSource_Term_JspCOCT,
// autoFetchData: true,
//                 cachePickListResults: true,
                 useClientFiltering: true,
                filterFields: ["code","startDate"],
                 // textMatchStyle: "startsWith",
                // generateExactMatchCriteria: true,
                colSpan: 1,
                initialSort: [

                    {property: "code", direction: "descending", primarySort: true}
                ],
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains"
                    },

                ],
                formatValue : function (value, record, form, item) {
                    var selectedRecord = item.getSelectedRecord();
                    if (selectedRecord != null) {
                       return   selectedRecord.endDate + "-" +selectedRecord.startDate ;

                    } else {
                        return value;
                    }
                },
                defaultDynamicValue:function () {
                    return
                },
                changed:function () {
                    List_Grid_Reaport_classOutsideCurrentTerm.setData([])

                }
            },

            {
                name: "category.Id",
                colSpan: 1,
                title: "<spring:message code="course_category"/>",
                textAlign: "center",
                // autoFetchData: true,
                required: true,
                // titleOrientation: "top",
                 height: "30",
                width: "*",
              //  editorType: "ComboBoxItem",
               // changeOnKeypress: true,
               // filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category_COCT,
                filterFields: ["titleFa"],
                pickListProperties:{
                    showFilterEditor: false
                },
                sortField: ["id"],
                changed: function (form, item, value) {
                    DynamicForm_Report_COCT.getItem("subCategory.id").enable();
                    DynamicForm_Report_COCT.getItem("subCategory.id").setValue([]);
                    RestDataSource_subCategory_COCT.fetchDataURL = categoryUrl + value + "/sub-categories";
                    DynamicForm_Report_COCT.getItem("subCategory.id").fetchData();
                   // DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                    List_Grid_Reaport_classOutsideCurrentTerm.setData([])
                },
                click: function (form, item) {
                 //   item.fetchData();
                }
            },
            {
                name: "subCategory.id",
               // colSpan: 1,
                title: "<spring:message code="course_subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                //required: true,
                autoFetchData: false,
                editorType: "ComboBoxItem",


                height: "30",
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_subCategory_COCT,
                filterFields: ["titleFa"],
                sortField: ["id"],
                pickListProperties:{
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                   // DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                    List_Grid_Reaport_classOutsideCurrentTerm.setData([])
                }
            },
            {
                type: "button",
                title: "تهیه گزارش",
                height:"25",
                align:"left",
                endRow:false,
                startRow: false,

                click:function () {
                    if (endDateCheckReportCOCT == false)
                        return;

                    if (!DynamicForm_Report_COCT.validate()) {
                        return;
                    }
                    let cat=DynamicForm_Report_COCT.getField("category.Id").getValue();
                    let subCat=DynamicForm_Report_COCT.getField("subCategory.id").getValue();
                    RestDataSource_classOutsideCurrentTerm.implicitCriteria = {
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [
                                {fieldName: "course.category.id", operator: "equals", value: cat},
                                { operator:"or", criteria:[  {fieldName: "course.subCategory.id", operator: "equals", value: subCat?subCat:subCat=[]}]}
                            ]
                        };

                    var strSData=DynamicForm_Report_COCT.getItem("termId").getSelectedRecord().startDate
                    let term_id=DynamicForm_Report_COCT.getItem("termId").getSelectedRecord().id
                  //  var strEData = DynamicForm_Report_COCT.getItem("endDate").getValue().replace(/(\/)/g, "");
                    RestDataSource_classOutsideCurrentTerm.fetchDataURL=classOutsideCurrentTerm + "/"+"spec-list" + "?startDate=" +strSData +"&term_id="+term_id;
                    List_Grid_Reaport_classOutsideCurrentTerm.invalidateCache();
                    List_Grid_Reaport_classOutsideCurrentTerm.fetchData();

                }
            },
            // {
            //     type: "button",
            //     startRow:false,
            //     align:"center",
            //     title: "چاپ گزارش",
            //     height:"25",
            //     click:function () {
            //         if (endDateCheckReportCOCT == false)
            //             return;
            //         if (!DynamicForm_Report_COCT.validate()) {
            //             return;
            //         }
            //         var strSData=DynamicForm_Report_COCT.getItem("startDate").getValue().replace(/(\/)/g, "");
            //         var strEData = DynamicForm_Report_COCT.getItem("endDate").getValue().replace(/(\/)/g, "");
            //         PrintPreTest(strSData,strEData)
            //     }
            //
            //
            // }
            // {
            //     type: "button",
            //     startRow:false,
            //     align:"left",
            //     title: "گزارش غیبت ناموجه",
            //     height:"30",
            //    click:function () {
            //         if (endDateCheckReportCOCT == false)
            //             return;
            //         if (!DynamicForm_Report_COCT.validate()) {
            //             return;
            //         }
            //         var strSData=DynamicForm_Report_COCT.getItem("startDate").getValue().replace(/(\/)/g, "");
            //         var strEData = DynamicForm_Report_COCT.getItem("endDate").getValue().replace(/(\/)/g, "");
            //            Print(strSData,strEData);
            //     }
            //
            // }

        ]
    })

    var Hlayout_Reaport_body = isc.HLayout.create({
        height:"10%",
        members: [DynamicForm_Report_COCT]
    })

    var Hlayout_Reaport_body1=isc.HLayout.create({
        members:[List_Grid_Reaport_classOutsideCurrentTerm],
    })

    var Vlayout_Report_body = isc.VLayout.create({
        members: [Hlayout_Reaport_body,Hlayout_Reaport_body1]
    })

    function Print(startDate,endDate) {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/unjustified/unjustifiedabsence"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function  PrintPreTest(startDate,endDate)
    {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/preTestScoreReport/printPreTestScore"/>" +"/"+startDate + "/" + endDate,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }
