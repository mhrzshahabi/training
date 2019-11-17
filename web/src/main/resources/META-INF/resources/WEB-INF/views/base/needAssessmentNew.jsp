<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var productRevenue_facets = [

        {
            id:"a4",
            title:"a4",
            values:[
                {id:"sum", title:"All Regions"},
                // {id:"North", parentId:"sum", title:"North"},
                // {id:"South", parentId:"sum", title:"South"},
                // {id:"East", parentId:"sum", title:"East"},
                // {id:"West", parentId:"sum", title:"West"}
            ]
        },

        {
            id:"a1",
            title:"a1",
            values:[
                {id:"Actual", title:"Actual"}
            ]
        },

        {
            id:"a2",
            title:"a2",
            width:150,
            values:[
                {id:"sum", title:"All Years"},
            ]
        },

        {
            id:"a3",
            title:"a3",
            width:175,
            values:[
                {id:"sum", title:"All Products"}
            ]
        }
    ];

    var testDS = isc.DataSource.create(
        {}
    )

    var productData = [
        {a1:"مهارت", a2:"دانشی", a3:"شایستگی برنامه نویسی", a4:"عملکرد ضروری", value:"توانایی"},
        {a1:"مهارت", a2:"مهارتی", a3:"شایستگی برنامه نویسی", a4:"عملکرد بهبود", value:"آشنایی"},
        {a1:"مهارت", a2:"نگرشی", a3:"شایستگی برنامه نویسی", a4:"عملکرد توسعه", value:"مهارتییس"},

    ];
    // var productRevenue_facets = [
    //     {
    //         id:"quarter",
    //         title:"مهارت",
    //         isTree:true,
    //         values:[
    //             {id:"1", title:"All a"},
    //             {id:"2", title:"All b"},
    //             {id:"3", title:"All c"}
    //         ]
    //     },
    //     {
    //         id:"month",
    //         title:"حیطه",
    //         values:[
    //             {id:"sum", title:"All Regions"}
    //         ]
    //
    //     },
    //     {
    //         id:"domain",
    //         title:"دامین",
    //         values:[
    //             {id:"sum", title:"All Regions"}
    //         ]
    //
    //     },
    //     {
    //         id:"product",
    //         title:"مولفه شایستگی",
    //         values:[
    //             {id:"sum", title:"All Regions"}
    //         ]
    //
    //     }
    // ]

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
                change:"countryList.getField('countryCode').align = value; countryList.markForRedraw()",
                align:"center",
                // colSpan:1
            },
            {
                name:"combo", type:"TrComboAutoRefresh", showTitle:false,
                width:"250",
                align:"center",

            }
        ]
    });
    // var NeedAssessmentCG_First = isc.CubeGrid.create({
    //     width:"100%",
    //     height:"100%",
    //     // autoSize:true,
    //     // bodyStyleName:"ListGrid",
    //     // baseStyle:"cell",
    //     // overflow:"hidden",
    //     // bodyOverflow:"auto",
    //     ID: "basicCubeGrid",
    //     // border:"2px solid red",
    //     // styleName: "fontSize1",
    //     // autoFitFieldWidths:true,
    //     autoSizeHeaders:true,
    //     enableCharting: true,
    //     defaultFacetWidth:250,
    //     bodyMinWidth:1280,
    //     layoutAlign:"center",
    //     baseStyle:"cell",
    //     wrapFacetTitles:true,
    //     // canCollapseFacets:true,
    //     // facets:productRevenue_facets,
    //
    //     data: productData,
    //     // hideEmptyFacetValues: true,
    //     autoSelectValues:"both",	// both, cols, row, none
    //     // rowHeaderGridMode:false,
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
    var NeedAssessmentCG_First = isc.CubeGrid.create({
        ID:"report",

        // Don't draw this CubeGrid - it will be written into a Layout with the facet-control
        // UI components
        autoDraw:false,

        // data configuration
        facets:         productRevenue_facets, // defined above
        dataSource:     productData,      // defined in datasource file productRevenue.ds.xml
        valueProperty:  "value",
        // cellIdProperty: "cellID",
        // hiliteProperty: "_hilite",

        // initial facet layout
        rowFacets:        ["a3", "a4"],
        columnFacets:     ["a2","a1"],
        // fixedFacetValues: {Scenarios:"Budget"},

        // hover tips
        // canHover:true,
        // cellHoverHTML:"if (record != null) return 'cell value: '+record.value+'<br>cell ID: '+record.cellID;",
        // hoverProperties:{width:150, height:20},

        enableCharting:			true,
        // showFacetValueContextMenus:	true,
        // showFacetContextMenus:		true,
        // showCellContextMenus:		true,
        // valueTitle:"Sales",

        // misc settings for this application
        canCollapseFacets:true,
        canMinimizeFacets:true,
        autoSelectValues:"both",	// both, cols, row, none
        rowHeaderGridMode:true,
        canMoveFacets:true

    });

    isc.VLayout.create({
        // autoDraw:true,
        border:"2px solid red",
        width: "100%",
        height: "100%",
        // membersMargin:10,
        members: [NeedAssessmentDF_First,NeedAssessmentCG_First],
    });