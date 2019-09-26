<%@ page contentType="text/html;charset=UTF-8" %>
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

    const enFaNumSpcFilter = "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F]|[a-zA-Z0-9 ]";
    const enNumSpcFilter = "[a-zA-Z0-9 ]";
    const numFilter = "[0-9]";

    // -------------------------------------------  Isomorphic Configs & Components   -----------------------------------------------
    isc.setAutoDraw(false);
    isc.TextItem.addProperties({height: 27, length: 255, width: "*"});
    isc.SelectItem.addProperties({height: 27, width: "*"});
    isc.Button.addProperties({height: 27});
    isc.TextAreaItem.addProperties({height: 50, length: 400, width: "*"});
    isc.Label.addProperties({wrap: false});
    isc.Validator.addProperties({requiredField: "<spring:message code="msg.field.is.required"/>"});
    isc.ToolStripMenuButton.addProperties({showMenuOnRollOver: true,});
    isc.TabSet.addProperties({width: "100%", height: "100%",});
    isc.ViewLoader.addProperties({width: "100%", height: "100%", border: "0px", loadingMessage: "<spring:message code="loading"/>",});
    isc.Dialog.addProperties({isModal: true, askIcon: "info.png", autoDraw: true, iconSize: 24});
    isc.DynamicForm.addProperties({
        width: "100%", margin: 5, errorOrientation: "right", showErrorStyle: false, wrapItemTitles: false, titleSuffix: "",
        requiredTitlePrefix: "<span style='color:#ff0842;font-size:140%;'>&#9913; </span>", requiredTitleSuffix: "",
        requiredMessage: "<spring:message code="msg.field.is.required"/>", wrapItemTitles: false
    });
    isc.Window.addProperties({
        autoSize: true, autoCenter: true, isModal: true, showModalMask: true, canFocus: true, dismissOnEscape: true, canDragResize: true,
        showHeaderIcon: false, animateMinimize: true, width: 800, showMaximizeButton: true,
    });
    isc.ComboBoxItem.addProperties({pickListProperties: {showFilterEditor: true}, addUnknownValues: false, emptyPickListMessage: "",});

    isc.defineClass("TrHLayout", HLayout);
    isc.TrHLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

    isc.defineClass("TrVLayout", VLayout);
    isc.TrVLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

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
        alternateRecordStyles: true,
        showResizeBar: true,
        showFilterEditor: true,
        autoFitWidthApproach: "both",
        showRowNumbers: true,
        rowNumberFieldProperties: {
            headerTitle: "<spring:message code="row.number"/>",
            width: 40,
        },
    });

    isc.defineClass("TrRefreshBtn", ToolStripButton);
    isc.TrRefreshBtn.addProperties({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
    });

    isc.defineClass("TrCreateBtn", ToolStripButton);
    isc.TrCreateBtn.addProperties({
        icon: "<spring:url value="create.png"/>",
        title: "<spring:message code="create"/>",
    });

    isc.defineClass("TrEditBtn", ToolStripButton);
    isc.TrEditBtn.addProperties({
        icon: "<spring:url value="edit.png"/>",
        title: "<spring:message code="edit"/>",
    });

    isc.defineClass("TrRemoveBtn", ToolStripButton);
    isc.TrRemoveBtn.addProperties({
        icon: "<spring:url value="remove.png"/>",
        title: "<spring:message code="remove"/>",
    });

    isc.defineClass("TrPrintBtn", ToolStripMenuButton);
    isc.TrPrintBtn.addProperties({
        title: Canvas.imgHTML("<spring:url value="print.png"/>", 16, 16) + "&nbsp; <spring:message code="print"/>",
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
    };

    isc.TextItem.addProperties({validators: [TrValidators.Trimmer]});
    isc.TextAreaItem.addProperties({validators: [TrValidators.Trimmer]});

    isc.defineClass("TrHLayoutButtons", TrHLayout);
    isc.TrHLayoutButtons.addProperties({
        align: "center",
        height: 34,
        defaultLayoutAlign: "top",
        membersMargin: 10,
    });

    isc.defineClass("TrSaveBtn", Button);
    isc.TrSaveBtn.addProperties({
        title: "<spring:message code="save"/>",
    });

    isc.defineClass("TrSaveNextBtn", Button);
    isc.TrSaveNextBtn.addProperties({
        title: "<spring:message code="save.and.next"/>",
    });

    isc.defineClass("TrCancelBtn", Button);
    isc.TrCancelBtn.addProperties({
        title: "<spring:message code="cancel"/>",
    });

    function createDialog(message, type, title) {
        type = type ? type : 'info';
        if (type == 'info') {
            return isc.Dialog.create({
                icon: type + '.png',
                title: title ? title : "<spring:message code='message'/>",
                message: message,
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>",})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else if (type == 'ask') {
            return isc.Dialog.create({
                icon: type + '.png',
                title: title ? title : "<spring:message code='message'/>",
                message: message,
                buttons: [
                    isc.Button.create({title: "<spring:message code="yes"/>",}),
                    isc.Button.create({title: "<spring:message code="no"/>",})
                ],
            });
        } else if (type == 'confirm') {
            return isc.Dialog.create({
                icon: type + '.png',
                title: title ? title : "<spring:message code='message'/>",
                message: message,
                buttons: [
                    isc.Button.create({title: "<spring:message code="yes"/>",}),
                    isc.Button.create({title: "<spring:message code="no"/>",})
                ],
            });
        }
    };

    isc.defineClass("TrComboAutoRefresh", ComboBoxItem);
    isc.TrComboAutoRefresh.addProperties({
        click: function (form, item) {
            item.fetchData();
        }
    });

    // -------------------------------------------  Page UI                          -----------------------------------------------
    systemImg = isc.Img.create({
        src: "<spring:url value="training.png"/>",
        width: 24,
        height: 24,
        imageType: "stretch",
        padding: 5,
    });

    systemLabel = isc.Label.create({
        contents: "<spring:message code="nicico.training.system"/>",
        styleName: "normalBold",
        padding: 5,
    });

    userTSMB = isc.ToolStripMenuButton.create({
        title: "${username}",
        menu: isc.Menu.create({
            data: [
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

    basicTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="basic.information"/>",
        menu: isc.Menu.create({
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

    needAssessmentTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="need.assessment"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="job"/>", icon: "<spring:url value="job.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/job/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="need.assessment"/>", icon: "<spring:url value="research.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/needAssessment/show-form"/>");
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

    designingTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="designing.and.planning"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="course"/>", icon: "<spring:url value="course.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/course/show-form"/>");
                    }
                },
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
                 {
                    title: "<spring:message code="company"/>",
                    icon: "<spring:url value="company.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/company/show-form"/>");
                    }
                },
                 {
                    title: "شرح وظایف",
                    icon: "<spring:url value="committee.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/task/show-form"/>");
                    }
                },

            ]
        }),
     });

    runTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="run"/>",
        menu: isc.Menu.create({
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

    evaluationTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="evaluation"/>",
        menu: isc.Menu.create({
            data: []
        }),
    });

    cartableTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="cartable"/>",
        menu: isc.Menu.create({
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

    reportTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="report"/>",
        menu: isc.Menu.create({
            data: []
        }),
    });

    trainingToolStrip = isc.ToolStrip.create({
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

    trainingTabSet = isc.TabSet.create({
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
            isc.HLayout.create({
                height: "1%",
                defaultLayoutAlign: "center",
                members: [systemImg, systemLabel, isc.LayoutSpacer.create({width: "*"}), userTSMB],
            }),
            isc.HLayout.create({height: "1%", members: [trainingToolStrip]}),
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
                trainingTabSet.setTabPane(tab, isc.ViewLoader.create({viewURL: url}));
            }
            trainingTabSet.selectTab(tab);
            return;
        } else {
            trainingTabSet.addTab({
                title: title,
                ID: title,
                pane: isc.ViewLoader.create({viewURL: url,}),
                canClose: true,
            });
            createTab(title, url);
        }
    };

    // ---------------------------------------- Not Ok - Start ----------------------------------------
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
    const companyUrl=rootUrl +"/company/";


    function TrnXmlHttpRequest(formData1, url, method, cFunction) {
        var xhttp;
        xhttp = new XMLHttpRequest();
        xhttp.willHandleError = true;
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4) {
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
    });

    isc.defineClass("MyButton", Button);
    isc.MyButton.addProperties({
        width: 100,
        height: 27,
    });

    isc.defineClass("MyHLayoutButtons", HLayout);
    isc.MyHLayoutButtons.addProperties({
        width: "100%",
        height: 50,
        align: "center",
        verticalAlign: "center",
        membersMargin: 15,
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
