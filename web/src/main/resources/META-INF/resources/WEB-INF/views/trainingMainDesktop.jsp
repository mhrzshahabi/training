<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

<html>
<head>
    <title>سیستم آموزش     </title>

    <link rel="stylesheet" href="<spring:url value='/static/css/smartStyle.css' />"/>
    <link rel="shortcut icon" href="<spring:url value='/static/img/icon/nicico.ico' />"/>

    <script src="<spring:url value='/static/script/js/calendar.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jalali.js'/>"></script>
    <script src="<spring:url value='/static/script/js/training_function.js'/>"></script>
    <script src="<spring:url value='/static/script/js/all.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jquery.min.js' />"></script>
    <link rel="stylesheet" href="<spring:url value='/static/css/calendar.css' />"/>

    <SCRIPT>var isomorphicDir = "isomorphic/";</SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Core.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Foundation.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Containers.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Grids.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Forms.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_DataBinding.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Drawing.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Charts.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Analytics.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_FileLoader.js></SCRIPT>
    <SCRIPT SRC=isomorphic/skins/Tahoe/load_skin.js></SCRIPT>
    <SCRIPT SRC=isomorphic/locales/frameworkMessages_fa.properties></SCRIPT>

</head>

<body dir="rtl">

<form action="<spring:url value='/logout' />" method="get" id="logoutForm">
</form>

<script type="application/javascript">

    <%--<script>--%>

	<spring:eval var="contextPath" expression="pageContext.servletContext.contextPath" />
    const rootUrl = "${contextPath}/api";
    const jobUrl = rootUrl + "/job/";
    const competenceUrl = rootUrl + "/competence/";
    const jobCompetenceUrl = rootUrl + "/job-competence/";
    const enumUrl = rootUrl + "/enum/";
    const goalUrl = rootUrl + "/goal/";
    const syllabusUrl = rootUrl + "/syllabus/";
    const courseUrl = rootUrl + "/course/";
    const categoryUrl = rootUrl + "/category/";
    const teacherUrl = rootUrl + "/teacher/";
    const studentUrl = rootUrl + "/student/";
    const classUrl = rootUrl + "/tclass/";
    const classReportUrl = rootUrl + "/classReport/";
    const instituteUrl = rootUrl + "/institute/";
    const educationLevelUrl = rootUrl + "/educationLevel/";
    const educationMajorUrl = rootUrl + "/educationMajor/";
    const educationOrientationUrl = rootUrl + "/educationOrientation/";
    const termUrl=rootUrl + "/term/";
    const cityUrl=rootUrl + "/city/";
    const stateUrl=rootUrl + "/state/";
    const committeeUrl=rootUrl + "/committee/";

    var MyDsRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
        return {
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            contentType: "application/json; charset=utf-8",
            useSimpleHttp: true,
            showPrompt: false,
            serverOutputAsString: false,
            httpMethod: httpMethodParam,
            actionURL: actionURLParam,
            data: dataParam,
            callback: callbackParam
        }
    };

    isc.defineClass("MyRestDataSource", RestDataSource);

    isc.MyRestDataSource.addProperties({
        dataFormat: "json",
        jsonSuffix: "",
        jsonPrefix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },

        transformResponse: function (dsResponse, dsRequest, data) {
            return this.Super("transformResponse", arguments);
        }
    });

	<%--isc.RestDataSource.addProperties({--%>
		<%--dataFormat: "json",--%>
		<%--jsonSuffix: "",--%>
		<%--jsonPrefix: "",--%>
		<%--transformRequest: function (dsRequest) {--%>
			<%--dsRequest.httpHeaders = {--%>
				<%--"Authorization": "Bearer <%= accessToken %>"--%>
			<%--};--%>
			<%--return this.Super("transformRequest", arguments);--%>
		<%--},--%>

		<%--transformResponse: function (dsResponse, dsRequest, data) {--%>
			<%--return this.Super("transformResponse", arguments);--%>
		<%--}--%>
	<%--});--%>

    isc.defineClass("MyListGrid", ListGrid);
    isc.MyListGrid.addProperties({
        width: "100%",
        height: "100%",
        dataPageSize: 50,
        useAllDataSourceFields: true,
        selectionType: "single",
        showFilterEditor: true,
        filterOnKeypress: true,
        alternateRecordStyles: true,
        sortFieldAscendingText: "مرتب سازي صعودي",
        sortFieldDescendingText: "مرتب سازي نزولي",
        autoDraw: true,
        showResizeBar: true,
        sortField: 0
    });

    isc.defineClass("MyToolStrip", ToolStrip);

    isc.MyToolStrip.addProperties({
        border: "0px"
    });

    isc.defineClass("MyRefreshButton", ToolStripButton);

    isc.MyRefreshButton.addProperties({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخواني اطلاعات",
        autoDraw: false,
    });

    isc.defineClass("MyCreateButton", ToolStripButton);

    isc.MyCreateButton.addProperties({
        icon: "[SKIN]/actions/add.png",
        title: "ايجاد",
        autoDraw: false,
    });

    isc.defineClass("MyEditButton", ToolStripButton);

    isc.MyEditButton.addProperties({
        icon: "[SKIN]/actions/edit.png",
        title: "ويرايش",
        autoDraw: false,
    });

    isc.defineClass("MyRemoveButton", ToolStripButton);

    isc.MyRemoveButton.addProperties({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        autoDraw: false,
    });

    isc.defineClass("MyPrintButton", ToolStripButton);

    isc.MyPrintButton.addProperties({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ",
        autoDraw: false,
    });

    isc.defineClass("MyDynamicForm", DynamicForm);

    isc.MyDynamicForm.addProperties({
        width: "100%",
        align: "center",
        margin: 10,
        cellPadding: 3,
        wrapItemTitles: false,
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        canSubmit: true,
        autoDraw: false,
    });

    MyValidators = {
        NotEmpty: {
            type: "regexp",
            errorMessage: "فيلد اجباري است.",
            expression: /^(?!\s*$).+/
        },
    NotStartWithNumber:{
        type:"regexp",
        errorMessage:"این فیلد نباید با عدد شروع شود.",
        expression:/^(?!([0-9]))/,
    },
        NotStartWithSpecialChar:{
            type:"regexp",
            errorMessage:"این فیلد نباید با حروف خاص(!و؟و..) شروع شود.",
            expression:/^(?!([!@#$%^&*~';:.{}_]))/,
        },
        NotContainSpecialChar:{
            type:"regexp",
            errorMessage:"این فیلد نباید شامل حروف خاص باشد.",
            expression:/^((?![~!@#$%^&*()+='"?]).)*$/,
        },
       };

    isc.defineClass("MyButton", Button);

    isc.MyButton.addProperties({
        width: 100,
        height: 27,
        autoDraw: false,
    });

    isc.defineClass("MyHLayoutButtons", HLayout);

    isc.MyHLayoutButtons.addProperties({
        width: "100%",
        height: 50,
        align: "center",
        verticalAlign: "center",
        membersMargin: 15,
        autoDraw: false,
        defaultLayoutAlign: "center",
    });

    isc.defineClass("MyWindow", Window);

    isc.MyWindow.addProperties({
        autoSize: true,
        autoCenter: true,
        isModal: true,
        autoDraw: false,
        canFocus: true,
        dismissOnEscape: true,
    });

    isc.defineClass("MyComboBoxItem", ComboBoxItem);

    isc.MyComboBoxItem.addProperties({
        addUnknownValues: false,
        useClientFiltering: false,
        cachePickListResults: true,
        changeOnKeypress: false,
        useClientFiltering: true,
        width: "*"
    });

    isc.defineClass("MyOkDialog", Dialog);

    isc.MyOkDialog.addProperties({
        title: "<spring:message code='message'/>",
        isModal: true,
        buttons: [isc.MyButton.create({title: "تائید"})],
        icon: "[SKIN]say.png",
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.defineClass("MyYesNoDialog", Dialog);

    isc.MyYesNoDialog.addProperties({
        isModal: true,
        icon: "[SKIN]say.png",
        title: "<spring:message code='message'/>",
        buttons: [
            isc.MyButton.create({title: "بله",}),
            isc.MyButton.create({title: "خير",})],
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.defineClass("MyTabSet", TabSet);

    isc.TabSet.addProperties({
        width: "100%",
        height: "100%",
        autoDraw: false,
    });

    isc.defineClass("MyVLayout", VLayout);

    isc.MyVLayout.addProperties({
        width: "100%",
        height: "100%",
        autoDraw: false,
    });

    isc.defineClass("MyHLayout", HLayout);

    isc.MyHLayout.addProperties({
        width: "100%",
        height: "100%",
        autoDraw: false,
    });


    isc.RPCManager.allowCrossDomainCalls = true;
    isc.FileLoader.loadLocale("fa");
    isc.FileLoader.cacheLocale("fa");

    isc.RPCManager.addClassProperties({
        defaultTimeout: 60000,
        willHandleError: true,
        handleError: function (response, request) {
            isc.say('ارتباط با سرور قطع شده است.');
        }
    });

    Page.setAppImgDir("static/img/");
    var headerLayout;

    function getIconButton(title, props) {
        return isc.IconButton.create(isc.addProperties({
                title: title
                // icon: "pieces/16/cube_blue.png",
                //largeIcon: "pieces/48/cube_blue.png",
                /*                click: "isc.say(this.title + ' button clicked');"*/
            }, props)
        );
    }


    function createTab(title, url, canRefresh) {
        var localViewLoder = isc.ViewLoader.create({
            width: "100%",
            height: "100%",
            autoDraw: true,
            viewURL: url,
            loadingMessage: " در حال بارگذاری ..."
        });

        var flagTabExist = false;

        if (mainTabSet.tabs != null) {
            //alert(mainTabSet.tabs.length);
            for (i = 0; i < mainTabSet.tabs.length; i++) {

                if (title == mainTabSet.getTab(i).title) {
                    if(title == "دوره")
                    {
                        for (j = 0; j < mainTabSet.tabs.length; j++)
                        {
                            if(mainTabSet.getTab(j).title.substr(0,5)=="اهداف")
                            {
                                mainTabSet.removeTab(j);
                            }
                        }
                    }
                    if (!canRefresh) {
                        mainTabSet.selectTab(i);
                        mainTabSet.setTabPane(i, localViewLoder);
                        flagTabExist = true;
                        break;

                    } else {
                        //mainTabSet.setTabPane(i,"");
                        mainTabSet.setTabPane(i, localViewLoder);
                        flagTabExist = true;
                        break;

                    }

                }

            }

        }
        if (!flagTabExist)
            mainTabSet.selectTab(mainTabSet.addTab({
                    title: title,
                    canClose: true,
                    pane: localViewLoder
                })
            );

    }

    var languageForm = isc.DynamicForm.create({
        width: 120,
        height: 30,
        wrapItemTitles: true,

        fields: [{
            name: "languageName", title: "<span style=\"color:white\">زبان</span>",

            type: "select",
            width: 100,
            height: 30,

            wrapHintText: false,
            valueMap: {
                "fa": "پارسی",
                "en": "English"
            },
            imageURLPrefix: "flags/16/",
            imageURLSuffix: ".png",
            valueIcons: {
                "fa": "fa",
                "en": "en"
            },

            changed: function () {
                var newUrl = window.location.href;
                var selLocale = languageForm.getValue("languageName");

                if (newUrl.indexOf("lang") > 0) {

                    var regex = new RegExp("lang=[a-zA-Z_]+");
                    newUrl = newUrl.replace(regex, "lang=" + selLocale);
                } else {

                    if (newUrl.indexOf("?") > 0) {
                        if (newUrl.indexOf("#") > 0) {
                            newUrl = newUrl.replace("#", "&lang=" + selLocale + "#")
                        } else {
                            newUrl += "&lang=" + selLocale;
                        }
                    } else {
                        //newUrl = newUrl.replace("#", "?lang=" + selLocale )
                        newUrl = newUrl + "?lang=" + selLocale;

                    }
                }
                window.location.href = newUrl;
            }
        }]
    });

    languageForm.setValue("languageName", "<c:out value='${pageContext.response.locale}'/>");

    var userCartableButton = isc.IconButton.create({


        title: "شخصی (${cartableCount})",
        icon: "pieces/512/userCartable.png",
        largeIcon: "pieces/512/userCartable.png",
        orientation: "vertical",
        click: function () {
            createTab("شخصی  ", "<spring:url value='/web/workflow/userCartable/showForm'/>", true);
            isc.RPCManager.sendRequest({
                /*willHandleError: true,
                timeout: 500,*/
                actionURL: "<spring:url value='${contextPath}/api/workflow/userTask/count/' />" + "${username}",
                httpMethod: "GET",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                serverOutputAsString: false,
                callback: function (RpcResponse_o) {
                    if (RpcResponse_o.status < 0) {
                        isc.say('خطا در اتصال به سرور !!!');
                    }
                    // isc.say(RpcResponse_o);
                    if (RpcResponse_o.data != 'failed') {


                        cartableCount = RpcResponse_o.data;
                        console.log("${cartableCount}", cartableCount);
                        if (userCartableButton != null)
                            userCartableButton.setTitle("شخصی (" + cartableCount + "   )");
                    } else if (RpcResponse_o.data == 'failed') {
                        isc.say(RpcResponse_o.data);
                    }
                }
            });

        }

    });

    var groupCartableButton = isc.IconButton.create({
        title: "گروهی (0)",
        icon: "pieces/512/groupCartable.png",
        largeIcon: "pieces/512/groupCartable.png",
        orientation: "vertical",
        click: function () {
            createTab("گروهی", "<spring:url value='/web/workflow/groupCartable/showForm'/>", true)
        }

    });

    var Menu_Workflow_Util = {
        _constructor: "Menu",
        autoDraw: true,
        showShadow: true,
        shadowDepth: 10,
        data: [
            {
                title: "تعریف فرایندها", icon: "pieces/512/processDefinition.png", click: function () {
                    createTab("تعریف فرایندها", "<spring:url value='/web/workflow/processDefinition/showForm'/>", true);

                }
            },
            {
                title: "همه فرایندها", icon: "pieces/512/processList.png", click: function () {
                    createTab("همه فرآیندها", "<spring:url value='/web/workflow/processInstance/showForm'/>", true)
                }
            }
        ]
    };


    var workflowUtilMenuButton = isc.IconMenuButton.create({
        title: "فرآیند",
        orientation: "vertical",
        menu: Menu_Workflow_Util,
        showMenuIconOver: false,
        showMenuOnClick: true,
        icon: "pieces/512/processDefinition.png"
    });

    var classButton = isc.IconButton.create({
        title: "کلاس",
        icon: "pieces/512/class.png",
        largeIcon: "pieces/512/class.png",
        orientation: "vertical",
        click: function () {
            createTab("کلاس", "<spring:url value="/tclass/show-form"/>", false)
        }
    });

    var studentButton = isc.IconButton.create({
        title: "دانشجو",
        icon: "pieces/512/student.png",
        largeIcon: "pieces/512/student.png",
        orientation: "vertical",
        click: function () {
            createTab("دانشجو", "<spring:url value="/student/show-form"/>", false)
        }
    });


    var courseButton = isc.IconButton.create({
        title: "<spring:message code="course"/>",
        icon: "pieces/512/course.png",
        largeIcon: "pieces/512/course.png",
        orientation: "vertical",
        click: function () {

            createTab("<spring:message code="course"/>", "<spring:url value="/course/show-form"/>", false);
        }
    });

    var termButton = isc.IconButton.create({
        title: "ترم",
        icon: "pieces/512/term.png",
        largeIcon: "pieces/512/term.png",
        orientation: "vertical",
        click: function () {

            createTab("ترم", "<spring:url value="/term/show-form"/>", false);
        }
    });


 var memberButton = isc.IconButton.create({
        title: "اعضا",
        icon: "pieces/512/member.png",
        largeIcon: "pieces/512/member.png",
        orientation: "vertical",
        click: function () {

            createTab("اعضا", "<spring:url value="/user/show-form"/>", false);
        }
    });

      var committeeButton = isc.IconButton.create({
        title: "کمیته تخصصی",
        icon: "pieces/512/committee.png",
        largeIcon: "pieces/512/committee.png",
        orientation: "vertical",
        click: function () {

            createTab("کمیته تخصصی", "<spring:url value="/committee/show-form"/>", false);
        }
    });


    var jobButton = isc.IconButton.create({
        title: "شغل",
        icon: "pieces/512/job.png",
        largeIcon: "pieces/512/job.png",
        orientation: "vertical",
        click: function () {
            createTab("شغل", "<spring:url value="/job/show-form"/>", false);
        }
    });

    var instituteButton = isc.IconButton.create({
        title: "مراکز آموزشي",
        icon: "pieces/512/institute.png",
        largeIcon: "pieces/512/institute.png",
        orientation: "vertical",
        click: function () {
            createTab("مراکز آموزشي", "<spring:url value="/institute/show-form"/>", false);
        }
    })

    var competenceButton = isc.IconButton.create({
        title: "شايستگي شغلي",
        icon: "pieces/512/competence.png",
        largeIcon: "pieces/512/competence.png",
        orientation: "vertical",
        click: function () {
            createTab("شايستگي شغلي", "/competence/show-form", false);
        }
    })

    var categoryButton = isc.IconButton.create({
        title: "گروه بندی",
        icon: "pieces/512/category.png",
        largeIcon: "pieces/512/category.png",
        orientation: "vertical",
        click: function () {
            createTab("گروه بندي", "<spring:url value="/category/show-form"/>", false);
        }
    })

    var skillLevelButton = isc.IconButton.create({
        title: "سطح مهارت",
        icon: "pieces/512/skill-level.png",
        largeIcon: "pieces/512/skill-level.png",
        orientation: "vertical",
        click: function () {
            createTab("سطح مهارت",  "<spring:url value="/skill-level/show-form"/>", false);
        }
    })

    var skillButton = isc.IconButton.create({
        title: "مهارت",
        icon: "pieces/512/skill.png",
        largeIcon: "pieces/512/skill.png",
        orientation: "vertical",
        click: function () {
            createTab("مهارت",  "<spring:url value="/skill/show-form"/>", false)
        }
    })

    var skillStandardGroupButton = isc.IconButton.create({
        title: "گروه مهارت",
        icon: "pieces/512/ssg.png",
        largeIcon: "pieces/512/ssg.png",
        orientation: "vertical",
        click: function () {
            createTab("گروه مهارت", "/skill-group/show-form", false);
        }
    })

    var teacherButton = isc.IconButton.create({
        title: "اساتید",
        icon: "pieces/512/teacher.png",
        largeIcon: "pieces/512/teacher.png",
        orientation: "vertical",
        click: function () {
            createTab("استاد", "<spring:url value="/teacher/show-form"/>", false)
        }
    })
    var educationButton = isc.IconButton.create({
        title: "تحصیلات",
        icon: "pieces/512/education.png",
        largeIcon: "pieces/512/education.png",
        orientation: "vertical",
        click: function () {
            createTab("تحصیلات", "<spring:url value="/education/show-form"/>", false)
        }
    })

    var competencyReportButton = isc.IconButton.create({
        title: "گزارش کلاس ها",
        icon: "pieces/512/repo1.png",
        largeIcon: "pieces/512/repo1.png",
        orientation: "vertical",
        click: function () {
            createTab("گزارش کلاس ها", "<spring:url value="/classReport/show-form"/>", false)
        }
    })
    var baseRibbon = isc.RibbonGroup.create({
        title: "<spring:message code='base.system.info'/>",
        numRows: 3,
        colWidths: [40, "*"],
        showTitle: true,
        titleAlign: "center",
        controls: [
            jobButton,
            categoryButton,
            skillLevelButton,
            instituteButton,
            teacherButton,
            educationButton
        ],
        autoDraw: true
    });

    var reqRibbon = isc.RibbonGroup.create({
        title: "نیازسنجی",
        numRows: 3,
        colWidths: [40, "*"],
        showTitle: true,
        titleAlign: "center",
        controls: [
            competenceButton,
            skillButton,
            skillStandardGroupButton

        ],
        autoDraw: true
    });

    var cartableRibbon = isc.RibbonGroup.create({
        title: "کارتابل",
        numRows: 3,
        colWidths: [40, "*"],
        showTitle: true,
        titleAlign: "center",
        controls: [
            userCartableButton,
            groupCartableButton,
            workflowUtilMenuButton
        ],
        autoDraw: true
    });

    var reportRibbon = isc.RibbonGroup.create({
        title: "گزارشات",
        numRows: 3,
        colWidths: [40, "*"],
        showTitle: true,
        titleAlign: "center",
        controls: [
            competencyReportButton,
        ],
        autoDraw: true
    });

    var trainingRibbon = isc.RibbonGroup.create({
        title: "آموزش",
        numRows: 3,
        colWidths: [40, "*"],
        showTitle: true,
        titleAlign: "center",
        controls: [
            classButton,
            courseButton,
            termButton,
            memberButton,
            committeeButton,
            studentButton,
        ],
        autoDraw: true
    });


    var headerFlow = isc.HTMLFlow.create({
        width: "20%",
        height: "100%",
        styleName: "mainHeaderStyleOnline",
        contents: "سیستم آموزش"

    });

    var label_Username = isc.Label.create({
        width: "30%",
        height: "100%",
        align: "left",
        styleName: "mainHeaderStyleOnline",
        contents: "کاربر : ${userFullName}",
        dynamicContents: true
    });


    var logoutButton = isc.IButton.create({
        width: "100",
        height: "100%",
        title: "خروج",
        icon: "pieces/512/logout.png",
        click: function () {
            document.getElementById("logoutForm").submit();
        }
    });

    var headerExitHLayout = isc.HLayout.create({
        width: "40%",
        height: "30",
        align: "left",
        backgroundColor: "#2319ff",
        members: [
            languageForm, label_Username, logoutButton]
    });


    headerLayout = isc.HLayout.create({
        width: "100%",
        height: "30",
        // border: "1px solid black",
        backgroundColor: "#2319ff",
        // styleName:"mainHeaderStyleOnline",
        members: [headerFlow, headerExitHLayout]
    });


    var ribbonBar = isc.RibbonBar.create({
        backgroundColor: "#f0f0f0",
        groupTitleAlign: "center",
        groupTitleOrientation: "top"
    });

    ribbonBar.addGroup(baseRibbon, 0);
    ribbonBar.addGroup(reqRibbon, 1);
    ribbonBar.addGroup(trainingRibbon, 2)
    ribbonBar.addGroup(cartableRibbon, 3);
    ribbonBar.addGroup(reportRibbon, 3);


    var ribbonHLayout = isc.HLayout.create({
        width: "100%",
        height: "60",
        // border: "2px solid green",
        showResizeBar: true,
        showShadow: false,
        backgroundColor: "#2319ff",
        members: [ribbonBar]
    });


    var mainTabSet = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [],
        closeClick: function (tab) {
            var tTitle = tab.ID;

            if (tTitle.startsWith("tabDocument")) {
                //alert("test");
            }

            this.Super("closeClick", arguments);
        },

        tabSelected: function (tabSet, tabNum, tabPane, ID, tab, name){
            var tabTitle = ID.title;
            if(tabTitle.substr(0,5) == "اهداف"){
                setTimeout(function () {

                   RestDataSource_CourseGoal.fetchDataURL = courseUrl + courseId.id +"/goal";
                   ListGrid_Goal.fetchData();
                   ListGrid_Goal.invalidateCache();
                   RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
                   ListGrid_Syllabus_Goal.fetchData();
                   ListGrid_Syllabus_Goal.invalidateCache();

                }, 100);
            }
            if(tabTitle.substr(0,4) == "دوره"){
                setTimeout(function () {
                    ListGrid_CourseCompetence.invalidateCache();
                    ListGrid_CourseSkill.invalidateCache();
                    ListGrid_CourseJob.invalidateCache();
                    ListGrid_CourseGoal.invalidateCache();
                    if(courseId != ""){
                        RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
                        ListGrid_CourseSyllabus.fetchData();
                        ListGrid_CourseSyllabus.invalidateCache();
                    }
                }, 100);
            }
        },

        tabBarControls: [
            isc.IButton.create({
                title: "بستن همه",
                icon: "icon/closeAllTabs.png",
                width: 100, height: 20,
                click: function () {
                    isc.Dialog.create({
                        message: "آیا شما برای بستن همه تبها مطمئن هستید؟",
                        icon: "[SKIN]ask.png",
                        title: "تائید",
                        isModal: true,
                        buttons: [isc.Button.create({title: "بله"}), isc.Button.create({title: "خیر"})],
                        buttonClick: function (button, index) {
                            this.hide();
                            if (index == 0) {
                                mainTabSet.removeTabs(mainTabSet.tabs);
                            }
                        }
                    });

                }

            }),
            "tabScroller", "tabPicker"
        ]
    });
    isc.VLayout.create({
        width: "100%",
        height: "100%",
        // border: "2px solid red",
        overflow: "auto",

        backgroundColor: "",
        members: [headerLayout, ribbonHLayout, mainTabSet]
    });



</script>

</body>
</html>



