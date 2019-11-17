<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <SCRIPT SRC=isomorphic/locales/frameworkMessages_fa.properties></SCRIPT>
</head>
<script type="application/javascript">

    isc.FileLoader.loadLocale("fa");
    isc.FileLoader.cacheLocale("fa");

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

    var competencyReportButton = isc.IconButton.create({
        title: "گزارش کلاس ها",
        icon: "pieces/512/repo1.png",
        largeIcon: "pieces/512/repo1.png",
        orientation: "vertical",
        click: function () {
            createTab("گزارش کلاس ها", "<spring:url value="/classReport/show-form"/>", false)
        }
    })

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

</script>

</body>
</html>



