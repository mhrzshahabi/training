<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>

<html>
<head>
    <title><spring:message code="nicico.training.system"/></title>
    <link rel="shortcut icon" href="<spring:url value='/images/nicico.png' />"/>
    <SCRIPT>var isomorphicDir = "isomorphic/";</SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Core.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Foundation.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Containers.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Grids.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Forms.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_DataBinding.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Drawing.js></SCRIPT>
    <SCRIPT SRC=isomorphic/skins/EnterpriseBlue/load_skin.js></SCRIPT>

    <!-- ---------------------------------------- Not Ok - Start ---------------------------------------- -->
    <link rel="stylesheet" href="<spring:url value='/static/css/calendar.css' />"/>
    <script src="<spring:url value='/static/script/js/calendar.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jalali.js'/>"></script>
    <script src="<spring:url value='/static/script/js/training_function.js'/>"></script>
    <script src="<spring:url value='/static/script/js/all.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jquery.min.js' />"></script>
    <!-- ---------------------------------------- Not Ok - End ---------------------------------------- -->
</head>

<body dir="rtl">

<script type="application/javascript">

    // -------------------------------------------  URLs   -----------------------------------------------
    <spring:eval var="contextPath" expression="pageContext.servletContext.contextPath" />
    const rootUrl = "${contextPath}/api";
    const jobUrl = rootUrl + "/job/";
    const postGradeUrl = rootUrl + "/postGrade/";
    const postUrl = rootUrl + "/post/";
    const competenceUrl = rootUrl + "/competence/";
    const needAssessmentUrl = rootUrl + "/needAssessment/";
    const skillUrl = rootUrl + "/skill/";

    const EnFaNumSpcFilter = "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F]|[a-zA-Z0-9 ]";
    const EnNumSpcFilter = "[a-zA-Z0-9 ]";
    const NumFilter = "[0-9]";

    const okDialogShowTime = 3000;

    // -------------------------------------------  Isomorphic Configs & Components   -----------------------------------------------
    isc.RPCManager.allowCrossDomainCalls = true;
    // isc.FormItem.addProperties({});
    isc.TextItem.addProperties({height: 27, length: 255, width: "*"});
    isc.SelectItem.addProperties({height: 27, width: "*"});
    isc.Button.addProperties({height: 27, autoDraw: false});
    isc.TextAreaItem.addProperties({height: 50, length: 400, width: "*"});
    isc.Validator.addProperties({requiredField: "<spring:message code="msg.field.is.required"/>"});

    var TrDSRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
        return {
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            contentType: "application/json; charset=utf-8",
            useSimpleHttp: true,
            showPrompt: false,
            willHandleError: true,
            actionURL: actionURLParam,
            httpMethod: httpMethodParam,
            data: dataParam,
            callback: callbackParam,
        }
    };

    isc.defineClass("TrDS", RestDataSource);
    isc.TrDS.addProperties({
        dataFormat: "json",
        jsonSuffix: "",
        jsonPrefix: "",
        defaultTextMatchStyle: "substring",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {"Authorization": "Bearer <%= accessToken %>"};
            return this.Super("transformRequest", arguments);
        },
        transformResponse: function (dsResponse, dsRequest, data) {
            return this.Super("transformResponse", arguments);
        }
    });

    isc.defineClass("TrLG", ListGrid);
    isc.TrLG.addProperties({
        selectionType: "single",
        showFilterEditor: true,
        filterOnKeypress: true,
        alternateRecordStyles: true,
        autoDraw: false,
        showResizeBar: true,
        allowAdvancedCriteria: true,
        showRowNumbers: true,
        canDragResize: true,
        rowNumberFieldProperties: {
            headerTitle: "<spring:message code="row.number"/>",
            width: 40,
        },
        autoFetchData: false,
        autoFitWidth: true,
        autoFitWidthApproach: "both",
    });

    isc.defineClass("TrImg", Img);
    isc.TrImg.addProperties({
        autoDraw: false,
    });

    isc.defineClass("TrLabel", Label);
    isc.TrLabel.addProperties({
        autoDraw: false,
        wrap: false,
    });

    isc.defineClass("TrHLayout", HLayout);
    isc.TrHLayout.addProperties({
        width: "100%",
        height: "100%",
        defaultLayoutAlign: "center",
        autoDraw: false,
    });

    isc.defineClass("TrVLayout", VLayout);
    isc.TrVLayout.addProperties({
        width: "100%",
        height: "100%",
        defaultLayoutAlign: "center",
        autoDraw: false,
        overflow: "auto",
    });

    isc.defineClass("TrTS", ToolStrip);
    isc.TrTS.addProperties({
        border: "0px",
        autoDraw: false,
    });

    isc.defineClass("TrTSMB", ToolStripMenuButton);
    isc.TrTSMB.addProperties({
        autoDraw: false,
        showMenuOnRollOver: true,
        click() {
            return false;
        }
    });

    isc.defineClass("TrTSB", ToolStripButton);
    isc.TrTSB.addProperties({
        autoDraw: false,
    });

    isc.defineClass("TrMenu", Menu);

    isc.defineClass("TrTabSet", TabSet);
    isc.TrTabSet.addProperties({
        autoDraw: false,
        width: "100%",
        height: "100%",
    });

    isc.defineClass("TrViewLoader", ViewLoader);
    isc.TrViewLoader.addProperties({
        width: "100%",
        height: "100%",
        border: "0px",
        autoDraw: false,
        loadingMessage: "<spring:message code="loading"/>",
    });

    isc.defineClass("TrRefreshBtn", TrTSB);
    isc.TrRefreshBtn.addProperties({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
    });

    isc.defineClass("TrCreateBtn", TrTSB);
    isc.TrCreateBtn.addProperties({
        icon: "<spring:url value="create.png"/>",
        title: "<spring:message code="create"/>",
    });

    isc.defineClass("TrEditBtn", TrTSB);
    isc.TrEditBtn.addProperties({
        icon: "<spring:url value="edit.png"/>",
        title: "<spring:message code="edit"/>",
    });

    isc.defineClass("TrRemoveBtn", TrTSB);
    isc.TrRemoveBtn.addProperties({
        icon: "<spring:url value="remove.png"/>",
        title: "<spring:message code="remove"/>",
    });

    isc.defineClass("TrPrintBtn", TrTSMB);
    isc.TrPrintBtn.addProperties({
        title: Canvas.imgHTML("<spring:url value="print.png"/>", 16, 16) + "&nbsp; <spring:message code="print"/>",
    });

    isc.defineClass("TrPrintBtnCommon", TrTSMB);
    isc.TrPrintBtnCommon.addProperties({
        title: Canvas.imgHTML("<spring:url value="print.png"/>", 16, 16) + "&nbsp; <spring:message code="print"/>",
        menu: isc.TrMenu.create({
            data: [
                {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>"},
                {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>"},
                {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>"},
            ]
        }),
    });

    isc.defineClass("TrDynamicForm", DynamicForm);
    isc.TrDynamicForm.addProperties({
        width: "100%",
        margin: 5,
        errorOrientation: "right",
        showInlineErrors: true,
        showErrorStyle: false,
        showErrorText: false,
        wrapItemTitles: false,
        titleAlign: "left",
        autoDraw: false,
        titlePrefix: "",
        titleSuffix: "",
        requiredTitlePrefix: "<span style='color:#ff0c5b;font-size:140%;'>* </span>",
        requiredTitleSuffix: "",
        requiredMessage: "<spring:message code="msg.field.is.required"/>",
    });

    TrValidators = {
        NotEmpty: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.is.required"/>",
            expression: /^(?!\s*$).+/
        },
        NotStartWithNumber: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.start.number"/>",
            expression: /^(?!([0-9]))/,
        },
        NotStartWithSpecialChar: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.start.special.char"/>",
            expression: /^(?!([!@#$%^&*~';:.{}_]))/,
        },
        NotContainSpecialChar: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.field.can't.contains.special.chars"/>",
            expression: /^((?![~!@#$%^&*()+='"?]).)*$/,
        },
        Trimmer: {
            type: "custom",
            condition: function (item, validator, value) {
                if (value !== undefined) {
                    var trimmed = trTrim(value);
                    validator.resultingValue = trimmed;
                    item.setValue(trimmed);
                }
                return true;
            }
        }
    };

    function trTrim(value) {
        var trimmed = (value.toString() || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
        return trimmed.replace(/\s\s+/g, ' ');
    }

    isc.TextItem.addProperties({validators: [TrValidators.Trimmer]});
    isc.TextAreaItem.addProperties({validators: [TrValidators.Trimmer]});

    isc.defineClass("TrWindow", Window);
    isc.TrWindow.addProperties({
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        canFocus: true,
        dismissOnEscape: true,
        canDragReposition: true,
        canDragResize: true,
        showHeaderIcon: false,
        showFooter: true,
        animateMinimize: true,
        width: 800,
        showMaximizeButton: true,
        defaultMinimizeHeight: 500,

    });

    isc.defineClass("TrHLayoutButtons", TrHLayout);
    isc.TrHLayoutButtons.addProperties({
        align: "center",
        height: 34,
        defaultLayoutAlign: "top",
        membersMargin: 10,
    });

    isc.defineClass("TrSaveButton", Button);
    isc.TrSaveButton.addProperties({
        title: "<spring:message code="save"/>",
    });

    isc.defineClass("TrSaveNextButton", Button);
    isc.TrSaveNextButton.addProperties({
        title: "<spring:message code="save.and.next"/>",
    });

    isc.defineClass("TrCancelButton", Button);
    isc.TrCancelButton.addProperties({
        title: "<spring:message code="cancel"/>",
    });

    isc.defineClass("TrOkDialog", Dialog);
    isc.TrOkDialog.addProperties({
        title: "<spring:message code='message'/>",
        icon: "[SKIN]say.png",
        isModal: true,
        buttons: [isc.Button.create({title: "<spring:message code="ok"/>",})],
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.defineClass("TrYesNoDialog", Dialog);
    isc.TrYesNoDialog.addProperties({
        title: "<spring:message code='message'/>",
        icon: "[SKIN]ask.png",
        isModal: true,
        buttons: [
            isc.Button.create({title: "<spring:message code="yes"/>",}),
            isc.Button.create({title: "<spring:message code="no"/>",})
        ],
    });

    isc.defineClass("TrComboBoxItem", ComboBoxItem);
    isc.TrComboBoxItem.addProperties({
        addUnknownValues: false,
        emptyPickListMessage: "",
        allowAdvancedCriteria: true,
        textMatchStyle: "substring",
        pickListProperties: {
            showFilterEditor: true
        },
        wrapTitle: false,
        /*useClientFiltering: false,
        cachePickListResults: true,
        changeOnKeypress: false,
        useClientFiltering: true,
        width: "*"*/
    });


    // -------------------------------------------  Page UI                          -----------------------------------------------

    systemImg = isc.TrImg.create({
        src: "<spring:url value="training.png"/>",
        width: 24,
        height: 24,
        imageType: "stretch",
        padding: 5,
    });

    systemLabel = isc.TrLabel.create({
        contents: "<spring:message code="nicico.training.system"/>",
        styleName: "normalBold",
        padding: 5,
    });

    systemHLayout = isc.TrHLayout.create({
        align: "right",
        padding: 5,
        members: [systemImg, systemLabel],
    });

    userTSMB = isc.TrTSMB.create({
        title: "${username}",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="personalization"/>",
                    icon: "<spring:url value="personalization.png"/>"
                },
                {
                    title: "<spring:message code="logout"/>",
                    icon: "<spring:url value="logout.png"/>",
                    click: function () {
                        logout();
                    }
                },
            ]
        }),
    });

    userHLayout = isc.TrHLayout.create({
        align: "left",
        members: [userTSMB],
    });

    basicTSMB = isc.TrTSMB.create({
        title: "<spring:message code="basic.information"/>",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="skill.categorize"/>", icon: "<spring:url value="categorize.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/category/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="skill.level"/>", icon: "<spring:url value="level.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill-level/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="education.degree"/>", icon: "<spring:url value="education.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/education/level/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="equipment.plural"/>", icon: "<spring:url value="equipment.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/equipment/show-form"/>");
                    }
                },
            ]
        }),
    });
    needAssessmentTSMB = isc.TrTSMB.create({
        title: "<spring:message code="training.need.assessment"/>",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="need.assessment"/>", icon: "<spring:url value="research.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/needAssessment/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="job"/>", icon: "<spring:url value="job.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/job/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="post"/>", icon: "<spring:url value="post.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/post/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="post.grade"/>", icon: "<spring:url value="postGrade.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/postGrade/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="competence"/>", icon: "<spring:url value="competence.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/competence/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="skill"/>", icon: "<spring:url value="skill.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="skill.group"/>", icon: "<spring:url value="skillGroup.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill-group/show-form"/>");
                    }
                },
            ]
        }),
    });

    designingTSMB = isc.TrTSMB.create({
        title: "<spring:message code="training.designing.and.planning"/>",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="course"/>", icon: "<spring:url value="course.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/course/show-form"/>");
                    }
                },
                <%--{--%>
                <%--title: "<spring:message code="syllabus"/>", icon: "<spring:url value="syllabus.png"/>",--%>
                <%--click: function () {--%>
                <%--createTab(this.title, "<spring:url value="/syllabus/show-form"/>");--%>
                <%--}--%>
                <%--},--%>
                <%--{--%>
                <%--title: "<spring:message code="goal"/>", icon: "<spring:url value="goal.png"/>",--%>
                <%--click: function () {--%>
                <%--createTab(this.title, "<spring:url value="/goal/show-form"/>");--%>
                <%--}--%>
                <%--},--%>
                {
                    title: "<spring:message code="term"/>", icon: "<spring:url value="term.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/term/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="specialized.committee"/>",
                    icon: "<spring:url value="committee.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/committee/show-form"/>");
                    }
                },
            ]
        }),
    });

    runTSMB = isc.TrTSMB.create({
        title: "<spring:message code="training.run"/>",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="class"/>", icon: "<spring:url value="class.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/tclass/show-form"/>");
                    },
                },
                {
                    title: "<spring:message code="student"/>", icon: "<spring:url value="student.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/student/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="teacher"/>", icon: "<spring:url value="teacher.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/teacher/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="institute"/>", icon: "<spring:url value="institute.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/institute/show-form"/>");
                    }
                },

            ]
        }),
    });

    evaluationTSMB = isc.TrTSMB.create({
        title: "<spring:message code="training.evaluation"/>",
        menu: isc.TrMenu.create({
            data: []
        }),
    });

    cartableTSMB = isc.TrTSMB.create({
        title: "<spring:message code="cartable"/>",
        menu: isc.TrMenu.create({
            data: [
                {
                    title: "<spring:message code="personal"/>", icon: "<spring:url value="personal.png"/>",
                    click: function () {
                    }
                },
                {
                    title: "<spring:message code="group"/>", icon: "<spring:url value="group.png"/>",
                    click: function () {
                    }
                },
                {
                    title: "<spring:message code="workflow"/>", icon: "<spring:url value="workflow.png"/>",
                    click: function () {
                    }
                },
            ]
        }),
    });

    reportTSMB = isc.TrTSMB.create({
        title: "<spring:message code="report"/>",
        menu: isc.TrMenu.create({
            data: []
        }),
    });

    trainingToolStrip = isc.TrTS.create({
        members: [
            basicTSMB,
            needAssessmentTSMB,
            designingTSMB,
            runTSMB,
            evaluationTSMB,
            cartableTSMB,
            reportTSMB
        ]
    });

    trainingTabSet = isc.TrTabSet.create({
        tabs: [],
        tabSelected: function (tabSet, tabNum, tabPane, ID, tab, name) {
            var tabTitle = ID.title;
            if (tabTitle.substr(0, 5) == "اهداف") {
                setTimeout(function () {
                    RestDataSource_CourseGoal.fetchDataURL = courseUrl + courseId.id + "/goal";
                    ListGrid_Goal.fetchData();
                    ListGrid_Goal.invalidateCache();
                    RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
                    ListGrid_Syllabus_Goal.fetchData();
                    ListGrid_Syllabus_Goal.invalidateCache();

                }, 100);
            }
            if (tabTitle.substr(0, 4) == "دوره") {
                setTimeout(function () {
                    ListGrid_CourseCompetence.invalidateCache();
                    ListGrid_CourseSkill.invalidateCache();
                    ListGrid_CourseJob.invalidateCache();
                    // ListGrid_CourseGoal.invalidateCache();
                    if (courseId != "") {
                        RestDataSource_Syllabus.fetchDataURL = syllabusUrl + "course/" + courseId.id;
                        ListGrid_CourseSyllabus.fetchData();
                        ListGrid_CourseSyllabus.invalidateCache();
                    }
                }, 100);
            }
        },
    });

    isc.TrVLayout.create({
        autoDraw: true,
        members: [
            isc.TrHLayout.create({height: "1%", members: [systemHLayout, userHLayout],}),
            isc.TrHLayout.create({height: "1%", members: [trainingToolStrip]}),
            trainingTabSet,
        ]
    });

    // -------------------------------------------  Functions                          -----------------------------------------------

    function logout() {
        document.location.href = "logout";
    };

    function createTab(title, url, autoRefresh) {
        var tab = trainingTabSet.getTabObject(title);
        if (tab !== undefined) {
            if ((autoRefresh !== undefined) && (autoRefresh == true)) {
                trainingTabSet.setTabPane(tab, isc.TrViewLoader.create({viewURL: url}));
            }
            trainingTabSet.selectTab(tab);
            return;
        } else {
            trainingTabSet.addTab({
                title: title,
                ID: title,
                pane: isc.TrViewLoader.create({viewURL: url,}),
                canClose: true,
            });
            createTab(title, url);
        }
    };

    // ---------------------------------------- Not Ok - Start ----------------------------------------
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
    const educationUrl = rootUrl + "/education/";
    const termUrl = rootUrl + "/term/";
    const cityUrl = rootUrl + "/city/";
    const stateUrl = rootUrl + "/state/";
    const personalInfoUrl = rootUrl + "/personalInfo/";
    const committeeUrl = rootUrl + "/committee/";
    const skillGroupUrl = rootUrl + "/skill-group/";


    function TrnXmlHttpRequest(formData1, url, method, cFunction) {
        var xhttp;
        xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                cFunction(this);
            }
        };
        xhttp.open(method, url, true);
        xhttp.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
        xhttp.send(formData1);
    };

    var MyDsRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
        return {
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            contentType: "application/json; charset=utf-8",
            useSimpleHttp: true,
            showPrompt: false,
            serverOutputAsString: false,
            actionURL: actionURLParam,
            httpMethod: httpMethodParam,
            data: dataParam,
            callback: callbackParam,
            willHandleError: true,
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
        autoDraw: true,
        showResizeBar: true,
        sortField: 0,
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

    isc.RPCManager.addClassProperties({
        defaultTimeout: 60000,
        willHandleError: true,
        handleError: function (response, request) {
            isc.say("خطا در اتصال به سرور!");
        }
    });

    // ---------------------------------------- Not Ok - End ----------------------------------------

</script>
</body>
</html>
