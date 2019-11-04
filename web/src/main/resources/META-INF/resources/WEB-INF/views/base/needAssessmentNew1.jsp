<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var restData_Job = isc.TrDS.create(
        {
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: jobUrl + "iscList"
        }
    );
    var restData_Post = isc.TrDS.create(
        {
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            ],
        }
    );

    // var productData = [
    //     {quarter:"مهارت", month:"دانشی", domain:"شایستگی برنامه نویسی", product:"عملکرد ضروری", value:"توانایی"},
    //     {quarter:"مهارت", month:"مهارتی", domain:"شایستگی برنامه نویسی", product:"عملکرد بهبود", value:"آشنایی"},
    //     {quarter:"مهارت", month:"نگرشی", domain:"شایستگی برنامه نویسی", product:"عملکرد توسعه", value:"مهارتییس"},
    //
    // ];
    // isc.DataSource.create({
    //     ID: "needDS",
    //     clientOnly: true,
    //     testData: productData,
    //     fields: [
    //         {name: "quarter", type: "text", title: "مهارت"},
    //         {name: "month", type: "text", title: "حیطه"},
    //         {name: "domain", type: "text", title: "شایستگی برنامه نویسی"},
    //         {product: "month", type: "text", title: "عملکرد ضروری"},
    //         {value: "month", type: "text"}
    //     ]
    // });

    var productRevenue_facets = [
        {
            id:"quarter",
            title:"مهارت",
        },
        {
            id:"month",
            title:"حیطه",
        },
        {
            id:"domain",
            title:"مهارت",
        },
        {
            id:"product",
            title:"مولفه شایستگی",
        }
    ]

    var NeedAssessmentDF_First = isc.DynamicForm.create({
        numCols:8,
        margin: 20,
        border:"2px solid red",
        fields:[
            {
              type:"SpacerItem",
                colSpan:2
            },
            {
                name:"alignment", type:"radioGroup", showTitle:false,
                valueMap:["شغل","گروه شغلی","پست","گروه پستی"], defaultValue:"center",
                change: function(form, item, value, oldValue) {
                    if(value == "شغل"){
                        form.getField("combo").setValue("");
                        restData_Job.fetchDataURL = jobUrl + "iscList";
                    }
                    else if(value == "پست"){
                        form.getField("combo").setValue("");
                        restData_Post.fetchDataURL = postUrl + "iscList";
                        item.pickListFields = [
                            {name:"code"},
                            {name:"titleFa"},
                            {name: "job.titleFa"}

                        ]
                    }
                    else if(value == "گروه شغلی"){

                    }
                    else if(value == "گروه پستی"){

                    }
                },
                align:"center",
                // colSpan:1
            },
            {
                name:"combo", type:"TrComboAutoRefresh", showTitle:false,
                width:"250",
                align:"center",
                optionDataSource:restData_Job,
                // addUnknownValues:false,
                displayField:"titleFa", valueField:"id",
                filterFields:["titleFa", "code"],
                // pickListPlacement: "fillScreen",
                // pickListWidth:300,
                pickListFields:[
                    {name:"code"},
                    {name:"titleFa"}
                ]

            }
        ]
    });
    // var NeedAssessmentCG_First = isc.CubeGrid.create({
    //     ID:"cube1",
    //     width:"100%",
    //     height:"100%",
    //     // autoSize:true,
    //     // bodyStyleName:"ListGrid",
    //     // baseStyle:"cell",
    //     // overflow:"hidden",
    //     // bodyOverflow:"auto",
    //     border:"2px solid red",
    //     // styleName: "fontSize1",
    //     autoFitFieldWidths:true,
    //     enableCharting: true,
    //     defaultFacetWidth:300,
    //     autoSizeHeaders:true,
    //     bodyMinWidth:1280,
    //     layoutAlign:"center",
    //     // baseStyle:"cell",
    //     // canCollapseFacets:true,
    //     // facts:productRevenue_facets,
    //     dataSource:needDS,
    //
    //     // data: productData,
    //     // hideEmptyFacetValues: true,
    //     // valueTitle:"",
    //     // autoSelectValues:"both",	// both, cols, row, none
    //     rowHeaderGridMode:false,
    //     // valueFormat: "\u00A4,0.00",
    //     columnFacets: ["quarter",
    //         "month"
    //     ],
    //     rowFacets: ["domain",
    //         "product"
    //     ],
    //
    //     // configure export colors
    //     exportFacetTextColor: "blue",
    //     exportFacetBGColor: "yellow",
    //
    //     exportColumnFacetTextColor: "red",
    //     exportColumnFacetBGColor: "#44FF44",
    //
    //     exportDefaultBGColor: "#FFDDAA",
    //     cellClick :function(record, rowNum, colNum){
    //         isc.say(record)
    //     }
    // });
    var NeedAssessmentDF2 = isc.DynamicForm.create({
        numCols:5,
        margin:10,
        layoutAlign:"center",
        // border:"2px solid blue",
        cellBorder:2,
        colWidths:["20%","20%","20%","20%","20%"],
        fields:[
            {type:"SpacerItem",showTitle:false,colSpan:2,align:"center"},
            {type:"staticText",showTitle:false,colSpan:3,align:"center"},
            {type:"SpacerItem",showTitle:false,colSpan:2,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"دانشی",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"مهارتی",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"نگرشی",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,rowSpan:3,defaultValue:"مولفه های شایستگی",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"عملکرد ضروری",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"عملکرد بهبود",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,defaultValue:"عملکرد توسعه",align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
            {type:"staticText",showTitle:false,colSpan:1,align:"center"},
        ]
    });

    isc.VLayout.create({
        // autoDraw:true,
        border:"2px solid red",
        width: "100%",
        height: "100%",
        // membersMargin:10,
        members: [NeedAssessmentDF_First,NeedAssessmentDF2],
    });