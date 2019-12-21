<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>

<html>
<head>
    <title><spring:message code="training.system"/></title>
    <link rel="shortcut icon" href="<spring:url value='/images/nicico.png' />"/>
    <link rel="stylesheet" href='<spring:url value="/css/commonStyle.css"/>'/>

    <SCRIPT>var isomorphicDir = "isomorphic/";</SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Core.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Foundation.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Containers.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Grids.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Forms.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_DataBinding.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Drawing.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Analytics.js></SCRIPT>
    <SCRIPT SRC=isomorphic/skins/Nicico/load_skin.js></SCRIPT>

    <!-- ---------------------------------------- Not Ok - Start ---------------------------------------- -->
    <link rel="stylesheet" href="<spring:url value='/css/calendar.css' />"/>
    <link rel="stylesheet" href="<spring:url value='/css/training.css' />"/>
    <script src="<spring:url value='/js/calendar.js'/>"></script>
    <script src="<spring:url value='/js/jalali.js'/>"></script>
    <script src="<spring:url value='/js/training_function.js'/>"></script>
    <script src="<spring:url value='/js/all.js'/>"></script>
    <script src="<spring:url value='/js/jquery.min.js' />"></script>
    <script src="<spring:url value='/js/changeSkin.js'/>"></script>
    <!-- ---------------------------------------- Not Ok - End ---------------------------------------- -->
</head>

<body dir="rtl">
<script type="application/javascript">

    // -------------------------------------------  URLs  -----------------------------------------------
    <spring:eval var="contextPath" expression="pageContext.servletContext.contextPath" />
    const userFullName = '<%= SecurityUtil.getFullName()%>';
    const rootUrl = "${contextPath}/api";
    const workflowUrl = rootUrl + "/workflow";
    const jobUrl = rootUrl + "/job";
    const postGroupUrl = rootUrl + "/post-group";
    const postGradeUrl = rootUrl + "/postGrade";
    const postUrl = rootUrl + "/post";
    const competenceUrl = rootUrl + "/competence";
    const needAssessmentUrl = rootUrl + "/needAssessment";
    const skillUrl = rootUrl + "/skill";
    const attachmentUrl = rootUrl + "/attachment";
    const trainingPlaceUrl = rootUrl + "/training-place";
    const personnelUrl = rootUrl + "/personnel";
    const personnelRegUrl = rootUrl + "/personnelRegistered";
    const attendanceUrl = rootUrl + "/attendance";
    const parameterUrl = rootUrl + "/parameter";
    const parameterValueUrl = rootUrl + "/parameter-value";
    const employmentHistoryUrl = rootUrl + "/employmentHistory";
    const teachingHistoryUrl = rootUrl + "/teachingHistory";

    // -------------------------------------------  Variables  -----------------------------------------------
    var workflowRecordId = null;
    var workflowParameters = null;
    var todayDate = JalaliDate.gregorianToJalali(new Date().getFullYear(), new Date().getMonth(), new Date().getDay());
    const teacherCertificationUrl = rootUrl + "/teacherCertification";

    // -------------------------------------------  Filters  -----------------------------------------------
    const enFaNumSpcFilter = "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F]|[a-zA-Z0-9 ]";
    const enNumSpcFilter = "[a-zA-Z0-9 ]";
    const numFilter = "[0-9]";

    // -------------------------------------------  Constant Variables  -----------------------------------------------
    const dialogShowTime = 2000;

    // -------------------------------------------  Variables  -----------------------------------------------
    var workflowRecordId = null;
    var workflowParameters = null;
    var todayDate = JalaliDate.gregorianToJalali(new Date().getFullYear(),new Date().getMonth(),new Date().getDay());

    // -------------------------------------------  Isomorphic Configs & Components   -----------------------------------------------
    isc.setAutoDraw(false);
    isc.TextItem.addProperties({height: 27, length: 255, width: "*"});
    isc.SelectItem.addProperties({height: 27, width: "*"});
    isc.Button.addProperties({height: 27});
    isc.TextAreaItem.addProperties({height: 50, length: 400, width: "*"});
    isc.Label.addProperties({wrap: false});
    isc.Validator.addProperties({requiredField: "<spring:message code="msg.field.is.required"/>"});
    isc.ToolStripMenuButton.addProperties({showMenuOnRollOver: true});
    isc.TabSet.addProperties({width: "100%", height: "100%",});
    isc.ViewLoader.addProperties({
        width: "100%",
        height: "100%",
        border: "0px",
        loadingMessage: "<spring:message code="loading"/>",
    });
    isc.Dialog.addProperties({isModal: true, askIcon: "info.png", autoDraw: true, iconSize: 24});
    isc.DynamicForm.addProperties({
        width: "100%", errorOrientation: "right", showErrorStyle: false, wrapItemTitles: false,
        titleSuffix: "", requiredTitlePrefix: "<span style='color:#ff0842;font-size:22px; padding-left: 2px;'>*</span>",
        requiredTitleSuffix: "", requiredMessage: "<spring:message code="msg.field.is.required"/>"
    });
    isc.Window.addProperties({
        autoSize: true, autoCenter: true, isModal: true, showModalMask: true, canFocus: true, dismissOnEscape: true,
        canDragResize: true, showHeaderIcon: false, animateMinimize: true, showMaximizeButton: true,
    });
    isc.ComboBoxItem.addProperties({
        pickListProperties: {showFilterEditor: true},
        addUnknownValues: false,
        emptyPickListMessage: "",
        useClientFiltering: false,
        changeOnKeypress: false,
    });
    isc.defineClass("TrHLayout", HLayout);
    isc.TrHLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

    isc.defineClass("TrVLayout", VLayout);
    isc.TrVLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

    TrDSRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
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
        showFilterEditor: true,
        autoFitWidthApproach: "both",
        showClippedValuesOnHover: true,
        hoverMoveWithMouse: true,
        showRowNumbers: true,
        rowNumberFieldProperties: {
            headerTitle: "<spring:message code="row.number"/>",
            width: 50,
            align: "center"
        },
        sortFieldAscendingText: "<spring:message code="sort.ascending"/>",
        sortFieldDescendingText: "<spring:message code="sort.descending"/>",
        configureSortText: "<spring:message code="sort.config"/>",
        clearSortFieldText: "<spring:message code="sort.clear"/>",
        autoFitAllText: "<spring:message code="auto.fit.all.columns"/>",
        autoFitFieldText: "<spring:message code="auto.fit"/>",
        emptyMessage: "",
        loadingDataMessage: "<spring:message code="loading"/>"
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
        EmailValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.email.address"/>",
            expression: /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/,
        },
        WebsiteValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.web.address"/>",
            expression: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
        },
        MobileValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.mobile.number"/>",
            expression: /^([+]\d{2})?\d{10}$/,
        },
        PhoneValidate: {
            type: "regexp",
            errorMessage: "<spring:message code="msg.invalid.phone.number"/>",
            expression: /^[(0)[1-9][0-9]\d{8}|(\+9)[0-9][1-9]\d{9}]$/,
        },
        Trimmer: {
            type: "custom",
            condition: function (item, validator, value) {
                if (value !== undefined) {
                    trimmed = trTrim(value);
                    validator.resultingValue = trimmed;
                    // item.setValue(trimmed); #TODO
                }
                return true;
            }
        }
    };

    function trTrim(value) {
        trimmed = (value.toString() || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
        return trimmed.replace(/\s\s+/g, ' ');
    }

    isc.TextItem.addProperties({validators: [TrValidators.Trimmer]});
    isc.TextAreaItem.addProperties({validators: [TrValidators.Trimmer]});

    isc.defineClass("TrHLayoutButtons", TrHLayout);
    isc.TrHLayoutButtons.addProperties({
        align: "center",
        height: 40,
        defaultLayoutAlign: "center",
        membersMargin: 10,
    });

    isc.defineClass("TrComboAutoRefresh", ComboBoxItem);
    isc.TrComboAutoRefresh.addProperties({
        click: function (form, item) {
            item.fetchData();
        }
    });

    isc.ToolStripButtonRefresh.addProperties({
        title: "<spring:message code="refresh"/>",
    });

    isc.ToolStripButtonCreate.addProperties({
        title: "<spring:message code="create"/>",
    });

    isc.ToolStripButtonAdd.addProperties({
        title: "<spring:message code="add"/>",
    });

    isc.ToolStripButtonEdit.addProperties({
        title: "<spring:message code="edit"/>",
    });

    isc.ToolStripButtonRemove.addProperties({
        title: "<spring:message code="remove"/>",
    });

    isc.ToolStripButtonPrint.addProperties({
        title: "<spring:message code="print"/>",
    });

    isc.IButtonSave.addProperties({
        title: "<spring:message code="save"/>",
    });

    isc.IButtonCancel.addProperties({
        title: "<spring:message code="cancel"/>",
    });

    // -------------------------------------------  Page UI - Header  -----------------------------------------------
    var headerLogo = isc.HTMLFlow.create({
        width: "50",
        height: "100%",
        styleName: "header-logo",
        contents: "<img width='50' height='50' src='images/nicicoBlack.png'/>"
    });

    var headerFlow = isc.HTMLFlow.create({
        width: "10%",
        height: "100%",
        styleName: "mainHeaderStyleOnline header-logo-title",
        contents: "<span><spring:message code="training.system.version"/></span>"
    });

    var label_Username = isc.Label.create({
        width: "10%",
        dynamicContents: true,
        styleName: "header-label-username",
        contents: "<spring:message code="user"/>" + ": " + `<%= SecurityUtil.getFullName()%>`,
    });

    var userNameHLayout = isc.HLayout.create({
        width: "10%",
        align: "center",
        members: [label_Username]
    });

    languageForm = isc.DynamicForm.create({
        width: 120,
        height: 30,
        styleName: "header-change-lng",
        fields: [{
            name: "languageName",
            showTitle: false,
            width: "100%",
            type: "select",
            valueMap: {
                "fa": "پارسی",
                "en": "English",
            },
            imageURLSuffix: ".png",
            valueIconRightPadding: "10",
            valueIcons: {
                "fa": "<spring:url value="flags/iran"/>",
                "en": "<spring:url value="flags/united-kingdom"/>",
            },
            changed: function () {
                newUrl = window.location.href;
                newLang = languageForm.getValue("languageName");
                if (newUrl.indexOf("lang") > 0) {
                    newUrl = newUrl.replace(new RegExp("lang=[a-zA-Z_]+"), "lang=" + newLang);
                } else {
                    if (newUrl.indexOf("?") > 0) {
                        if (newUrl.indexOf("#") > 0) {
                            newUrl = newUrl.replace("#", "&lang=" + newLang + "#")
                        } else {
                            newUrl += "&lang=" + newLang;
                        }
                    } else {
                        newUrl = newUrl + "?lang=" + newLang;
                    }
                }
                window.location.href = newUrl;
            }
        }]
    });

    languageForm.setValue("languageName", "<c:out value='${pageContext.response.locale}'/>");

    var languageVLayout = isc.VLayout.create({
        width: "5%",
        align: "center",
        defaultLayoutAlign: "left",
        members: [languageForm]
    });

    logoutButton = isc.IButton.create({
        width: "100",
        baseStyle: "header-logout",
        title: "<spring:message code="logout"/>",
        icon: "<spring:url value="logout.png"/>",
        click: function () {
            logout();
        }
    });

    var logoutVLayout = isc.VLayout.create({
        width: "5%",
        align: "center",
        defaultLayoutAlign: "left",
        members: [logoutButton]
    });

    // -------------------------------------------  Page UI - Menu  -----------------------------------------------

    basicTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="basic.information"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="parameter"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/parameter-type/"/>");
                    }
                },
                {
                    title: "<spring:message code="skill.categorize"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/category/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="skill.level"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill-level/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="education.degree"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/education/level/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="equipment.plural"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/equipment/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="department"/>",
                    click: function () {
                        createTab(this.title, '<spring:url value="/department/show-form"/>');
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
                    title: "<spring:message code="job"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/job/"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="job.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="job-group/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="post.grade"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGrade/"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="post.grade.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGradeGroup/"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="post"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post/"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="post.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post-group/"/>");
                    }
                },
                {
                    title: "<spring:message code="skill"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="skill.group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/skill-group/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="need.assessment.skill.based"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/needAssessmentSkillBased/"/>");
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
                    title: "<spring:message code="course"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/course/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="term"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/term/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="specialized.committee"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/committee/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="company"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/company/show-form"/>");
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
                    title: "<spring:message code="class"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/tclass/show-form"/>");
                    },
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="student"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/personnelRegistered/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="teacher"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/teacher/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="institute"/>",
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
                    title: "<spring:message code="personal"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/userCartable/showForm"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="group"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/groupCartable/showForm"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="workflow"/>",
                    submenu: [
                        {
                            title: "<spring:message code="process.definition"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/processDefinition/showForm"/>");
                            }
                        },
                        {isSeparator: true},
                        {
                            title: "<spring:message code="all.processes"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/processInstance/showForm"/>")
                            }
                        }
                    ]
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

    securityTSMB = isc.ToolStripMenuButton.create({
        title: "<spring:message code="security"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="user.plural"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/users/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "گروه دسترسی",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/groups/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "نقش ها",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/app-roles/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "تخصیص نقش",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/users/show-form"/>");
                    }
                },
                {isSeparator: true},
                {
                    title: "<spring:message code="operational.unit"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/operational-unit/show-form"/>");
                    }
                }
            ]
        }),
    });

    trainingToolStrip = isc.ToolStrip.create({
        align: "center",
        membersMargin: 20,
        layoutMargin: 5,
        showShadow: true,
        shadowDepth: 3,
        shadowColor: "#153560",
        members: [
            basicTSMB,
            needAssessmentTSMB,
            designingTSMB,
            runTSMB,
            evaluationTSMB,
            cartableTSMB,
            reportTSMB,
            securityTSMB
        ]
    });

    // -------------------------------------------  Page UI - TabSet  -----------------------------------------------

    closeAllButton = isc.IButtonClose.create({
        width: 100,
        title: "<spring:message code="close.all"/>",
        click: function () {
            if (trainingTabSet.tabs.length == 0) return;
            dialog = createDialog("ask", "<spring:message code="close.all.tabs?"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        trainingTabSet.removeTabs(trainingTabSet.tabs);
                    }
                }
            });
        }
    });

    trainingTabSet = isc.TabSet.create({
        minWidth: 1024,
        tabs: [],
        tabBarControls: [closeAllButton]
    });

    // -------------------------------------------  Page UI -----------------------------------------------

    var headerExitHLayout = isc.HLayout.create({
        width: "60%",
        height: "100%",
        align: "center",
        styleName: "header-exit",
        members: [isc.LayoutSpacer.create({width: "80%"}), userNameHLayout, languageVLayout, logoutVLayout]
    });

    var headerLayout = isc.HLayout.create({
        width: "100%",
        height: "52",
        styleName: "header",
        members: [headerLogo, headerFlow, headerExitHLayout],
    });

    var MainDesktopMenuH = isc.HLayout.create({
        width: "100%",
        height: "4%",
        styleName: "main-menu",
        align: "center",
        members: [
            trainingToolStrip
        ]
    });

    isc.TrVLayout.create({
        autoDraw: true,
        styleName: "relativePosition",
        members: [
            headerLayout,
            MainDesktopMenuH,
            trainingTabSet,
        ]
    });

    // -------------------------------------------  Functions  -----------------------------------------------
    function logout() {
        document.location.href = "logout";
    }

    function createTab(title, url, autoRefresh) {
        tab = trainingTabSet.getTabObject(title);
        if (tab !== undefined) {
            if ((autoRefresh !== undefined) && (autoRefresh == true)) {
                trainingTabSet.setTabPane(tab, isc.ViewLoader.create({viewURL: url}));
            }
            trainingTabSet.selectTab(tab);
        } else {
            trainingTabSet.addTab({
                title: title,
                ID: title,
                pane: isc.ViewLoader.create({viewURL: url,}),
                canClose: true,
            });
            createTab(title, url);
        }
    }

    function createDialog(type, message, title) {
        if (type === 'wait'){
            message = message ? message : "<spring:message code='in.operation'/>"
        }
        var dialog = isc.Dialog.create({
            icon: type + '.png',
            title: title ? title : "<spring:message code="message"/>",
            message: message,
        });

        if (type === 'info') {
            dialog.setButtons([
                isc.IButtonSave.create({
                    title: "<spring:message code="ok"/>",
                    click: function () {
                        dialog.close();
                    }
                })
            ]);
        } else if (type === 'ask') {
            dialog.setButtons([
                isc.IButtonSave.create({title: "<spring:message code="yes"/>",}),
                isc.IButtonCancel.create({title: "<spring:message code="no"/>",})
            ]);
        } else if (type === 'confirm') {
            dialog.setButtons([
                isc.IButtonSave.create({title: "<spring:message code="ok"/>",}),
                isc.IButtonCancel.create({title: "<spring:message code="cancel"/>",})
            ]);
        }
        return dialog;
    }

    // ---------------------------------------- Not Ok - Start ----------------------------------------
    const enumUrl = rootUrl + "/enum/";
    const goalUrl = rootUrl + "/goal/";
    const syllabusUrl = rootUrl + "/syllabus/";
    const courseUrl = rootUrl + "/course/";
    const categoryUrl = rootUrl + "/category/";
    const subCategoryUrl = rootUrl + "/sub-category/";
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
    const jobGroupUrl = rootUrl + "/job-group/";
    const companyUrl = rootUrl + "/company/";
    const addressUrl = rootUrl + "/address/";
    const operationalUnitUrl = rootUrl + "/operationalUnit/";
    const postGradeGroupUrl = rootUrl + "/postGradeGroup/";
    const checklistUrl = rootUrl + "/checklist/";
    const checklistItemUrl = rootUrl + "/checklistItem/";
    const classCheckListUrl = rootUrl + "/class-checklist/";
    const needAssessmentSkillBasedUrl = rootUrl + "/needAssessmentSkillBased/";
    const sessionServiceUrl = rootUrl + "/sessionService/";
    const classStudent=rootUrl +"/classStudent/";
    const classAlarm=rootUrl +"/classAlarm/";
    const personnelRegByNationalCodeUrl = rootUrl + "/personnelRegistered/";

    const classStudent = rootUrl + "/classStudent/";
    const classAlarm = rootUrl + "/classAlarm/";

    function TrnXmlHttpRequest(formData1, url, method, cFunction) {
        let xhttpRequest = new XMLHttpRequest();
        xhttpRequest.willHandleError = true;
        xhttpRequest.onreadystatechange = function () {
            if (this.readyState === 4) {
                cFunction(this);
            } else {
                // isc.say("خطا در اتصال به سرور");

            }
        };
        xhttpRequest.open(method, url, true);
        xhttpRequest.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
        xhttpRequest.send(formData1);
    }

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
        width: "*"
    });

    isc.defineClass("MyOkDialog", Dialog);
    isc.MyOkDialog.addProperties({
        title: "<spring:message code='message'/>",
        isModal: true,
        buttons: [isc.IButtonSave.create({title: "تائید"})],
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
            isc.IButtonSave.create({title: "بله",}),
            isc.IButtonCancel.create({title: "خير",})],
        buttonClick: function (button, index) {
            this.close();
        }
    });

    function handleErrors(resp, req) {

        if (resp == null || resp.httpResponseText == null)
            return;

        const title = {title: "<spring:message code='error'/>"};
        if (resp.httpResponseCode === 401 || resp.httpResponseCode === 302) {
            isc.say('<spring:message code="global.form.refresh" />', null, title);
            return;
        }
        if (resp.httpResponseCode === 400) {
            isc.say('<spring:message code="exception.too-large" />', null, title);
            return;
        }

        var errText = "";
        var response = JSON.parse(resp.httpResponseText);

        if (response == null || response.length === 0)
            return;

        if (response.errors != null)
            response.errors.forEach(value => {

                // if (value.field !== "")
                //     errText += "<strong>" + value.field + "</strong>:<br>";
                if (value.message != null && value.message !== "") {
                    if (value.message.startsWith('{') && value.message.endsWith('}'))
                        errText += "<em><spring:message code='exception.data-validation'/>.</em><br>";
                    else
                        errText += "<em>" + value.message + "</em><br>";
                }
            });
        else if (response.exception != null)
            if (response.exception !== "") {
                if (response.exception.startsWith('{') && response.exception.endsWith('}'))
                    errText += "<em><spring:message code='exception.data-validation'/>.</em><br>";
                else
                    errText += "<em>" + response.exception + "</em><br>";
            }

        if (errText !== "")
            isc.say(errText, null, title);
        else if (response.error === "NotFound")
            isc.say('<spring:message code="exception.record.not−found" />', null, title);
        else if (response.error === "Unauthorized")
            isc.say('<spring:message code="exception.unauthorized" />', null, title);
        else
            isc.say('<spring:message code="exception.server.connection" />', null, title);
    }

    isc.RPCManager.addClassProperties({

        defaultTimeout: 60000,
        willHandleError: true,
        handleError: handleErrors
    });
    isc.ViewLoader.addClassProperties({

        defaultTimeout: 60000,
        willHandleError: true,
        handleError: handleErrors,
        handleTransportError: handleErrors
    });

    function trPrintWithCriteria(url, advancedCriteria) {
        trCriteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: url,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "token", type: "hidden"}
                ]
        });
        trCriteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        trCriteriaForm.setValue("token", "<%=accessToken%>");
        trCriteriaForm.show();
        trCriteriaForm.submitForm();
    }

    function checkNationalCode(code) {
        if (code === "undefined" || code === null || code === "")
            return false;
        let L = code.length;

        if (L < 8 || parseFloat(code, 10) === 0)
            return false;
        code = ('0000' + code).substr(L + 4 - 10);
        if (parseFloat(code.substr(3, 6), 10) === 0)
            return false;
        let c = parseFloat(code.substr(9, 1), 10);
        let s = 0;
        for (let i = 0; i < 9; i++) {
            s += parseFloat(code.substr(i, 1), 10) * (10 - i);
        }
        s = s % 11;
        return (s < 2 && c === s) || (s >= 2 && c === (11 - s));

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

        isc.defineClass("TrAddBtn", TrCreateBtn);
        isc.TrAddBtn.addProperties({
            title: "<spring:message code="add"/>",
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
    }

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

    <%--createTab("پارامترها", "<spring:url value="web/parameter-type/"/>");--%>


    // ---------------------------------------- Not Ok - End ----------------------------------------

</script>
</body>
</html>
