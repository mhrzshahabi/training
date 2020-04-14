<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var wait_Variable;
    var flag = 0;

    var selectedPerson_CurrentTerm = null;

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_AllClass_CalenderCurrentCourse = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "term.startDate"},
            {name: "term.endDate"},
            {name: "course.code"},
            {name: "course.titleFa"},
            {name: "teacher"},

        ],

        fetchDataURL: calenderCurrentTerm + "speclist"
    });

    var RestDataSource_AllCourses_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "course.titleFa"},
            {name: "course.code"},
            {name: "course.evaluation"},

        ],
        fetchDataURL: calenderCurrentTerm + "spec-list"
    });

    var RestDataSource_Class_CurrentTerm = isc.TrDS.create({
        ID: "RestDataSource_Class_CurrentTerm",
        fields: [
            {name: "corseCode"},
            {name: "titleClass"},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "hduration"},
            {name: "classStatus"},
            {name: "statusRegister"},
            {name: "scoresState"},
        ],
    });


    //******************************
    //Menu
    //******************************
    Menu_ListGrid_CurrentTerm = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    //  ListGrid_Term.invalidateCache();
                }
            }]
    });
    var ListGrid_All_Courses_CalculatorCurrentTerm = isc.TrLG.create({
        dataSource: RestDataSource_AllCourses_CurrentTerm,
        contextMenu: Menu_ListGrid_CurrentTerm,
        autoFetchData: true,
        headerHeight: 65,
        fields: [
            {
                name: "course.code",
                title: "<spring:message code='course.code'/>",
                width: 90,
                align: "center",
                filterOperator: "iContains"

            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
             {name: "course.evaluation",title:"نیازسنجی/غیر نیازسنجی"},
        ],
        click: function (record, rowNum, colNum) {
          

        },

        headerSpans: [
            {
                fields: ["course.code", "course.titleFa","course.evaluation"],
                title: "دوره های ترم جاری"
            }],


        showFilterEditor: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",

    });


    var ListGrid_ALLClass_CalculatorCurrentTerm1 = isc.TrLG.create({
        dataSource: RestDataSource_AllClass_CalenderCurrentCourse,
        autoFetchData: true,
        headerHeight: 65,
        contextMenu: Menu_ListGrid_CurrentTerm,
        fields: [
            {
                name: "course.code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                // autoFitWidth: true
            },

            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                //autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "term.startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                //   autoFitWidth: true,
            },
            {
                name: "term.endDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains", // autoFitWidth: true
            },
            {
                name: "teacher",
                title: "<spring:message code='teacher'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
            },
          ],
        headerSpans: [
            {
                fields: ["course.code", "course.titleFa", "term.startDate", "term.endDate", "teacher"],
                title: "کلاس های ترم جاری"
            }],
              showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",
    });

    var ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1 = isc.TrLG.create({
        dataSource: RestDataSource_Class_CurrentTerm,

        headerHeight: 65,
        contextMenu: Menu_ListGrid_CurrentTerm,
        fields: [
            {name: "corseCode", title: "کد دوره", autoFitWidth: true, align: "center",},
            {name: "titleClass", title: "عنوان کلاس", autoFitWidth: true, align: "center",},
            {name: "code", title: "کد کلاس", autoFitWidth: true, align: "center",},
            {name: "startDate", title: "تاریخ شروع", align: "center",},
            {name: "endDate", title: "تاریخ پایان", align: "center",},
            {name: "hduration", title: "مدن زمان(ساعت)", autoFitWidth: true, align: "center",},
            {
                name: "classStatus", title: "وضعیت کلاس", autoFitWidth: true, valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                }, align: "center",
            },
            {
                name: "statusRegister",
                align: "center",
                title: "وضعیت فرد",
                autoFitWidth: true,
                valueMap: {"1": "ثبت نام شده", "0": "ثبت نام نشده"}
            },
            {name: "scoresState", title: "وضعیت قبولی", autoFitWidth: true},
        ],
        headerSpans: [
            {
                fields: ["corseCode", "titleClass", "code", "startDate", "endDate", "hduration", "classStatus", "statusRegister", "scoresState"],
                title: "کلاس های نیازسنجی شده"
            }],
        recordDoubleClick: function () {
        },
        dataArrived: function () {
            wait_Variable.close()
        },
        showFilterEditor: false,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",
    });
    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************

    PersonnelDS_Calender_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postCode",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    Menu_Calender_CurrentTerm = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1.invalidateCache();
                ListGrid_ALLClass_CalculatorCurrentTerm1.invalidateCache();
                ListGrid_All_Courses_CalculatorCurrentTerm.invalidateCache();
            }
        }]
    });
    PersonnelsLG_Calender_CurrentTerm = isc.TrLG.create({
        dataSource: PersonnelDS_Calender_CurrentTerm,
        contextMenu: Menu_Calender_CurrentTerm,
        autoFetchData: true,
        selectionType: "single",
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "postCode"},
        ],
        rowDoubleClick: Select_Person

    });


    Window_Calender_CurrentTerm = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel.choose"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                PersonnelsLG_Calender_CurrentTerm,
            ]
        })]
    });

    function Select_Person(record) {
        record = (record == null) ? PersonnelsLG_Calender_CurrentTerm.getSelectedRecord() : record;
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (record.postCode !== undefined) {

            var code = record.postCode.replace("/", ".");
            selectedPerson_CurrentTerm = record;
            wait_Variable = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + code, "GET", null, PostCodeSearch));

        } else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function PostCodeSearch(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {
            needAssessmentClass_CurrentTerm(JSON.parse(resp.httpResponseText));
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            wait_Variable.close();
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            wait_Variable.close();
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({

        title: "<spring:message code="refresh"/>",
        click: function () {

            if (flag === 1) {
                wait_Variable = createDialog("wait");
                ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1.invalidateCache();
                ListGrid_ALLClass_CalculatorCurrentTerm1.invalidateCache();
                ListGrid_All_Courses_CalculatorCurrentTerm.invalidateCache();
            } else {

                ListGrid_ALLClass_CalculatorCurrentTerm1.invalidateCache();
                ListGrid_All_Courses_CalculatorCurrentTerm.invalidateCache();
            }

        }
    });
    var ToolStripButton_Print = isc.IButton.create({
        title: "انتخاب پرسنل",
        click: function () {
            Window_Calender_CurrentTerm.show()
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
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    var VLayout_AllCourse_CalculatorCurrentTerm1 = isc.HLayout.create({
        width: "100%",

        members: [ListGrid_ALLClass_CalculatorCurrentTerm1]
    });


    var VLayout_Course_CalculatorCurrentTerm1 = isc.HLayout.create({
        width: "100%",
        members: [ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1]
    });


    var VLayout2 = isc.VLayout.create({
        width: "55%",
        // height: "100%",
        members: [VLayout_AllCourse_CalculatorCurrentTerm1, VLayout_Course_CalculatorCurrentTerm1],

    });

    var VLayout1 = isc.VLayout.create({
        width: "18%",
        //height: "100%",
        members: [ListGrid_All_Courses_CalculatorCurrentTerm]
    });

    var HLayout_Grid_CalculatorCurrentTerm = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout1, VLayout2]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Group
            , HLayout_Grid_CalculatorCurrentTerm
        ]
    });

    //************************************************************************************
    //function
    //************************************************************************************
    //===================================================================================
    function needAssessmentClass_CurrentTerm(post) {
        Window_Calender_CurrentTerm.close();
        RestDataSource_Class_CurrentTerm.fetchDataURL = calenderCurrentTerm + "needassessmentClass" + "?objectId=" + post.id + "&postTitle=" + selectedPerson_CurrentTerm.postTitle + "&postCode=" + selectedPerson_CurrentTerm.postCode + "&personnelNo=" + selectedPerson_CurrentTerm.personnelNo + "&personnelNo2=" + selectedPerson_CurrentTerm.personnelNo2 + "&companyName=" + selectedPerson_CurrentTerm.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson_CurrentTerm.nationalCode + "&firstName=" + selectedPerson_CurrentTerm.firstName + "&lastName=" + selectedPerson_CurrentTerm.lastName;
        flag = 1;
        ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1.fetchData();
        ListGrid_NeedAssessmentClass_CalculatorCurrentTerm1.invalidateCache()
    }

    function call_calenderCurrentTerm(selected_person) {
        ToolStripButton_Print.hide();
        Select_Person(selected_person);
    }

    //</script>