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
    <SCRIPT>var isomorphicDir = "isomorphic/";</SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Core.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Foundation.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Containers.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Grids.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Forms.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_DataBinding.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Drawing.js></SCRIPT>
    <SCRIPT SRC=isomorphic/system/modules/ISC_Analytics.js></SCRIPT>
    <SCRIPT SRC=isomorphic/skins/Tahoe/load_skin.js></SCRIPT>

    <!-- ---------------------------------------- Not Ok - Start ---------------------------------------- -->
    <link rel="stylesheet" href="<spring:url value='/static/css/calendar.css' />"/>
    <link rel="stylesheet" href="<spring:url value='/static/css/training.css' />"/>
    <script src="<spring:url value='/static/script/js/calendar.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jalali.js'/>"></script>
    <script src="<spring:url value='/static/script/js/training_function.js'/>"></script>
    <script src="<spring:url value='/static/script/js/all.js'/>"></script>
    <script src="<spring:url value='/static/script/js/jquery.min.js' />"></script>
    <!-- ---------------------------------------- Not Ok - End ---------------------------------------- -->
</head>

<body dir="rtl">

<script type="application/javascript">

    // -------------------------------------------  URLs & Filters  -----------------------------------------------
    const userFullName = '<%= SecurityUtil.getFullName()%>';
    <spring:eval var="contextPath" expression="pageContext.servletContext.contextPath" />
    const rootUrl = "${contextPath}/api";
    const workflowUrl = rootUrl + "/workflow/";
    const jobUrl = rootUrl + "/job/";
    const postGroupUrl = rootUrl + "/post-group/";
    const postGradeUrl = rootUrl + "/postGrade/";
    const postUrl = rootUrl + "/post/";
    const competenceUrl = rootUrl + "/competence/";
    const needAssessmentUrl = rootUrl + "/needAssessment/";
    const skillUrl = rootUrl + "/skill/";
    const attachmentUrl = rootUrl + "/attachment/";

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
    isc.ToolStripMenuButton.addProperties({showMenuOnRollOver: true});
    isc.TabSet.addProperties({width: "100%", height: "100%",});
    isc.ViewLoader.addProperties({width: "100%", height: "100%", border: "0px", loadingMessage: "<spring:message code="loading"/>",});
    isc.Dialog.addProperties({isModal: true, askIcon: "info.png", autoDraw: true, iconSize: 24});
    isc.DynamicForm.addProperties({
        width: "100%", errorOrientation: "right", showErrorStyle: false, wrapItemTitles: false,
        titleSuffix: "", requiredTitlePrefix: "<span style='color:#ff0842;font-size:140%;'>&#9913; </span>",
        requiredTitleSuffix: "", requiredMessage: "<spring:message code="msg.field.is.required"/>"
    });
    isc.Window.addProperties({
        autoSize: true, autoCenter: true, isModal: true, showModalMask: true, canFocus: true, dismissOnEscape: true,
        canDragResize: true, showHeaderIcon: false, animateMinimize: true, showMaximizeButton: true,
    });
    isc.ComboBoxItem.addProperties({
        pickListProperties: {showFilterEditor: true}, addUnknownValues: false, emptyPickListMessage: "", useClientFiltering: false,
        changeOnKeypress: false,
    });
    isc.defineClass("TrHLayout", HLayout);
    isc.TrHLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

    isc.defineClass("TrVLayout", VLayout);
    isc.TrVLayout.addProperties({width: "100%", height: "100%", defaultLayoutAlign: "center",});

    let TrDSRequest = function (actionURLParam, httpMethodParam, dataParam, callbackParam) {
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
        showRowNumbers: true,
        rowNumberFieldProperties: {
            headerTitle: "<spring:message code="row.number"/>",
            width: 40,
        },
        sortField: 0,
        sortFieldAscendingText: "<spring:message code="sort.ascending"/>",
        sortFieldDescendingText: "<spring:message code="sort.descending"/>",
        configureSortText: "<spring:message code="sort.config"/>",
        clearSortFieldText: "<spring:message code="sort.clear"/>",
        autoFitAllText: "<spring:message code="auto.fit.all.columns"/>",
        autoFitFieldText: "<spring:message code="auto.fit"/>",
        emptyMessage: "",
        loadingDataMessag: "<spring:message code="loading"/>",
    });

    isc.defineClass("TrRefreshBtn", ToolStripButton);
    isc.TrRefreshBtn.addProperties({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
    });

    isc.defineClass("TrEditBtn", ToolStripButton);
    isc.TrEditBtn.addProperties({
        icon: "<spring:url value="edit.png"/>",
        title: "<spring:message code="edit"/>",
    });

    isc.defineClass("TrCreateBtn", ToolStripButton);
    isc.TrCreateBtn.addProperties({
        icon: "<spring:url value="create.png"/>",
        title: "<spring:message code="create"/>",
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
                    var trimmed = trTrim(value);
                    validator.resultingValue = trimmed;
                    item.setValue(trimmed);
                }
                return true;
            }
        }
    };

    function trTrim(value) {
        let trimmed = (value.toString() || "").replace(/^(\s|\u00A0)+|(\s|\u00A0)+$/g, "");
        return trimmed.replace(/\s\s+/g, ' ');
    }

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

    function createDialog(type, message, title) {
        dialog = isc.Dialog.create({
            icon: type + '.png',
            title: title ? title : "<spring:message code="message"/>",
            message: message,
        });

        if (type === 'info') {
            dialog.setButtons([
                isc.Button.create({
                    title: "<spring:message code="ok"/>",
                    click: function () {
                        dialog.close();
                    }
                })
            ]);
        } else if (type === 'ask') {
            dialog.setButtons([
                isc.Button.create({title: "<spring:message code="yes"/>",}),
                isc.Button.create({title: "<spring:message code="no"/>",})
            ]);
        } else if (type === 'confirm') {
            dialog.setButtons([
                isc.Button.create({title: "<spring:message code="ok"/>",}),
                isc.Button.create({title: "<spring:message code="cancel"/>",})
            ]);
        } else if (type === 'wait') {
            dialog.message = message ? message : "<spring:message code='in.operation'/>";
        }
        return dialog;
    }

    isc.defineClass("TrComboAutoRefresh", ComboBoxItem);
    isc.TrComboAutoRefresh.addProperties({
        click: function (form, item) {
            item.fetchData();
        }
    });

    // -------------------------------------------  Page UI                          -----------------------------------------------
    nicicoIcon = isc.Img.create({
        src: "<spring:url value="nicico.png"/>",
        width: 24,
        height: 24,
        imageType: "stretch",
        padding: 4,
    });

    systemLabel = isc.Label.create({
        contents: "<spring:message code="training.system.version"/>",
        styleName: "customHeader",
        padding: 4,
    });

    userLabel = isc.Label.create({
        contents: "<spring:message code="user"/>" + ": " + `<%= SecurityUtil.getFullName()%>`,
        styleName: "customHeader",
        padding: 4,
    });

    logoutButton = isc.Button.create({
        title: "<spring:message code="logout"/>",
        width: "100",
        icon: "logout.png",
        click: function () {
            logout();
        }
    });

    var languageForm = isc.DynamicForm.create({
        width: 120,
        height: "100%",
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
                var newUrl = window.location.href;
                var newLang = languageForm.getValue("languageName");
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

    basicTSMB = isc.ToolStripMenuButton.create({
        title: Canvas.imgHTML("<spring:url value="information.png"/>", 16, 16) + "&nbsp; <spring:message code="basic.information"/>",
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
        title: Canvas.imgHTML("<spring:url value="need.png"/>", 16, 16) + "&nbsp; <spring:message code="need.assessment"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="job"/>", icon: "<spring:url value="job.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/job/"/>");
                    }
                },
                {
                    title: "<spring:message code="job.group"/>", icon: "<spring:url value="jobGroup.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="job-group/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="post.grade"/>", icon: "<spring:url value="postGrade.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGrade/"/>");
                    }
                },
                {
                    title: "<spring:message code="post.grade.group"/>", icon: "<spring:url value="postGrade.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/postGradeGroup/"/>");
                    }
                },
                {
                    title: "<spring:message code="post"/>", icon: "<spring:url value="post.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post/"/>");
                    }
                },
                {
                    title: "<spring:message code="post.group"/>", icon: "<spring:url value="jobGroup.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/post-group/"/>");
                    }
                },

                {
                    title: "<spring:message code="competence"/>", icon: "<spring:url value="competence.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/competence/"/>");
                    }
                },
                {
                    title: "<spring:message code="need.assessment"/>", icon: "<spring:url value="research.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/needAssessment/"/>");
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
        title: Canvas.imgHTML("<spring:url value="plan.png"/>", 16, 16) + "&nbsp; <spring:message code="designing.and.planning"/>",
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
            ]
        }),
    });

    runTSMB = isc.ToolStripMenuButton.create({
        title: Canvas.imgHTML("<spring:url value="seo-training (1).png"/>", 16, 16) + "&nbsp; <spring:message code="run"/>",
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
        title: Canvas.imgHTML("<spring:url value="test.png"/>", 16, 16) + "&nbsp; <spring:message code="evaluation"/>",
        menu: isc.Menu.create({
            data: []
        }),
    });

    cartableTSMB = isc.ToolStripMenuButton.create({
        title: Canvas.imgHTML("<spring:url value="folder.png"/>", 16, 16) + "&nbsp; <spring:message code="cartable"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="personal"/>", icon: "<spring:url value="personal.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/userCartable/showForm"/>");
                    }
                },
                {
                    title: "<spring:message code="group"/>", icon: "<spring:url value="group.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/web/workflow/groupCartable/showForm"/>");
                    }
                },
                {
                    title: "<spring:message code="workflow"/>", icon: "<spring:url value="workflow.png"/>",
                    submenu: [
                        {
                            title: "<spring:message code="process.definition"/>",
                            icon: "<spring:url value="processDefinition.png"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/processDefinition/showForm"/>");
                            }
                        },
                        {
                            title: "<spring:message code="all.processes"/>",
                            icon: "<spring:url value="processList.png"/>",
                            click: function () {
                                createTab(this.title, "<spring:url value="/web/workflow/processInstance/showForm"/>")
                            }
                        }
                    ]
                },
            ]
        }),
    });

    securityTSMB = isc.ToolStripMenuButton.create({
        title: Canvas.imgHTML("<spring:url value="folder.png"/>", 16, 16) + "&nbsp; <spring:message code="security"/>",
        menu: isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="user.plural"/>", icon: "<spring:url value="personal.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/users/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="group.plural"/>", icon: "<spring:url value="group.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="web/oauth/groups/show-form"/>");
                    }
                },
                {
                    title: "<spring:message code="operationalUnit"/>",
                    icon: "<spring:url value="operationalUnit.png"/>",
                    click: function () {
                        createTab(this.title, "<spring:url value="/operational-unit/show-form"/>");
                    }
                }
            ]
        }),
    });

    reportTSMB = isc.ToolStripMenuButton.create({
        title: Canvas.imgHTML("<spring:url value="report.png"/>", 16, 16) + "&nbsp; <spring:message code="report"/>",
        menu: isc.Menu.create({
            data: []
        }),
    });

    trainingToolStrip = isc.ToolStrip.create({
        membersMargin: 5,
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

    var closeAllButton = isc.Button.create({
        width: 100,
        icon: "<spring:url value="closeAllTabs.png"/>",
        title: "<spring:message code="close.all"/>",
        click: function () {
            if (trainingTabSet.tabs.length == 0) return;
            dialog = createDialog("ask", "<spring:message code="close.all.the.tabs?"/>");
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

    isc.TrVLayout.create({
        autoDraw: true,
        styleName: "relativePosition",
        members: [
            isc.HLayout.create({
                height: "1%",
                minWidth: 1024,
                backgroundColor: "#003168",
                defaultLayoutAlign: "center",
                members: [nicicoIcon, systemLabel, isc.LayoutSpacer.create({width: "*"}), userLabel, isc.LayoutSpacer.create({width: "15"}), languageForm, logoutButton],
            }),
            isc.HLayout.create({height: "1%", minWidth: 1024, members: [trainingToolStrip]}),
            trainingTabSet,
        ]
    });

    // -------------------------------------------  Functions  -----------------------------------------------

    function logout() {
        document.location.href = "logout";
    }

    function createTab(title, url, autoRefresh) {
        let tab = trainingTabSet.getTabObject(title);
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
    const jobGroupUrl = rootUrl + "/job-group/";
    const companyUrl = rootUrl + "/company/";
    const addressUrl = rootUrl + "/address/";
    const operationalUnitUrl = rootUrl + "/operationalUnit/";
    const postGradeGroupUrl = rootUrl + "/postGradeGroup/";

    function TrnXmlHttpRequest(formData1, url, method, cFunction) {
        var xhttp;
        xhttp = new XMLHttpRequest();
        xhttp.willHandleError = true;
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4) {
                cFunction(this);
            } else {
                // isc.say("خطا در اتصال به سرور");

            }
        };

        xhttp.open(method, url, true);
        xhttp.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
        xhttp.send(formData1);
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
        useClientFiltering: true,
        width: "*"
    });

    isc.defineClass("MyOkDialog", Dialog);
    isc.MyOkDialog.addProperties({
        title: "<spring:message code='message'/>",
        isModal: true,
        buttons: [isc.Button.create({title: "تائید"})],
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
            isc.Button.create({title: "بله",}),
            isc.Button.create({title: "خير",})],
        buttonClick: function (button, index) {
            this.close();
        }
    });

    isc.RPCManager.addClassProperties({
        defaultTimeout: 60000,
        willHandleError: true,
        handleError: function (response, request) {
            isc.say("خطا در اتصال به سرور!");
        }
    });

    function trPrintWithCriteria(url, advancedCriteria) {
        let trCriteriaForm = isc.DynamicForm.create({
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

    // ---------------------------------------- Not Ok - End ----------------------------------------

</script>
</body>
</html>
