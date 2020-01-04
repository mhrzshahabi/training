<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>

// <script>
    var dummy;

    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPostLG_post();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    PostTS_post = isc.ToolStrip.create({
        membersMargin: 5,
        members: [
            isc.ToolStripButtonPrint.create({
                //icon:"[SKIN]/RichTextEditor/print.png",
                title: "<spring:message code='print'/>",
                click: function () {
                    print_PostListGrid("pdf");
                }
            }),

            isc.ToolStripButton.create({
                top: 260,
                align: "center",
                title: "<spring:message code='post.person.assign'/>",
                click: function () {
                    if (!(PostLG_post.getSelectedRecord() == undefined || PostLG_post.getSelectedRecord() == null)) {
                        setDetailViewer_Personnel(PostLG_post.getSelectedRecord().id);
                        DetailViewer_Personnel.show();
                        Window_DetailViewer_Personnel.show();
                    }else{
                            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    }

                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_post"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshPostLG_post();
                        }
                    }),
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleFa",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "job.titleFa",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postGrade.titleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "assistance",
                title: "<spring:message code="assistance"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "section",
                title: "<spring:message code="section"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "costCenterCode",
                title: "<spring:message code="reward.cost.center.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "costCenterTitleFa",
                title: "<spring:message code="reward.cost.center.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ],
        fetchDataURL: postUrl + "/iscList"
    });

    PostLG_post = isc.TrLG.create({
        dataSource: PostDS_post,
        fields: [
            {name: "code",},
            {name: "titleFa",},
            {name: "job.titleFa",},
            {name: "postGrade.titleFa",},
            {name: "area",},
            {name: "assistance",},
            {name: "affairs",},
            {name: "section",},
            {name: "unit",},
            {name: "costCenterCode",},
            {name: "costCenterTitleFa",},
        ],
        autoFetchData: true,
        gridComponents: [PostTS_post, "filterEditor", "header", "body",],
        contextMenu: PostMenu_post,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_post.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- DynamicForm -------------------------------------------
    isc.DynamicForm.create({
        ID: "postFilterForm_post",
        saveOnEnter: true,
        dataSource: PostDS_post,
        numCols: 2,
        submit: function () {
            PostLG_post.filterData(postFilterForm_post.getValuesAsCriteria());
        },
        fields: [
            {name: "departmentArea", title: "<spring:message code="area"/>", operator: "iContains",},
            {name: "departmentAssistance", title: "<spring:message code="assistance"/>", operator: "iContains",},
            {name: "departmentAffairs", title: "<spring:message code="affairs"/>", operator: "iContains",},
        ]
    })

    // ------------------------------------------- Page UI -------------------------------------------


    ////////////////////////////Detail Viewer Personnel ////////////////////////////

    PersonnelDS_personnel = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
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
                name: "workPlace",
                title: "<spring:message code="work.place"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                width: "*"
            },
            {
                name: "employmentStatus",
                title: "<spring:message code="employment.status"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                detail: true
            },
            {
                name: "complexTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                detail: true
            },
            {
                name: "workPlaceTitle",
                title: "<spring:message code="work.place"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                detail: true
            },
            {
                name: "workTurnTitle",
                title: "<spring:message code="work.turn"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "postTitle",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "postCode",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "workYears",
                title: "<spring:message code="work.years"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "educationLevelTitle",
                title: "<spring:message code="education.degree"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "educationMajorTitle",
                title: "<spring:message code="education.major"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },
            {
                name: "jobTitle",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                detail: true,
                autoFitWidth: true
            },

        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        // fetchDataURL: personnelUrl + "/byPostCode"
    });

    var DetailViewer_Personnel = isc.DetailViewer.create({

    // var DetailViewer_Personnel = isc.TrLG.create({
        width: 430,
        height: "90%",
        autoDraw: false,
        border: "2px solid black",
        layoutMargin: 5,
        autoFetchData: false,
        dataSource: PersonnelDS_personnel,
        fields: [

            // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "jobTitle"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
            {name: "postTitle"},
            {name: "postCode"},
            {name: "educationLevelTitle"},
            {name: "educationMajorTitle"},
            {name: "workYears"}
        ]
    });

    function setDetailViewer_Personnel(postId) {
        // dummy = postCode;
        // temp = postCode.split('/');
        // postCode = temp[0] + '-' + temp[1];
        // var JSONObj = {"postCode": dummy};


        PersonnelDS_personnel.fetchDataURL = personnelUrl + "/byPostCode/" + postId;
        DetailViewer_Personnel.invalidateCache();
        DetailViewer_Personnel.fetchData();


        // DetailViewer_Personnel.invalidateCache();
        // DetailViewer_Personnel.fetchData({"postId":postId});
    }

    var DetailViewer_Personnel_HLayout = isc.HLayout.create({
        width: "100%",
        height: "5%",
        autoDraw: false,
        border: "0px solid red",
        align: "center",
        valign: "center",
        layoutMargin: 5,
        membersMargin: 7,
        members: [
            DetailViewer_Personnel
        ]
    });


    var DetailViewer_Personnel_closeButton_HLayout = isc.HLayout.create({
        width: "100%",
        height: "6%",
        autoDraw: false,
        align: "center",
        members: [
            isc.IButton.create({
                title: "<spring:message code='close'/>",
                icon: "[SKIN]/actions/cancel.png",
                width: "70",
                align: "center",
                click: function () {
                    try {
                        Window_DetailViewer_Personnel.close();

                    } catch (e) {
                    }
                }
            })
        ]
    });


    var Window_DetailViewer_Personnel = isc.Window.create({
        title: "<spring:message code='personal'/>",
        width: 460,
        height: 515,
        autoSize: false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        valign: "center",
        autoDraw: false,
        dismissOnEscape: true,
        layoutMargin: 5,
        membersMargin: 7,
        items: [
            DetailViewer_Personnel_HLayout,
            DetailViewer_Personnel_closeButton_HLayout

        ]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostLG_post() {
        PostLG_post.filterByEditor();
        PostLG_post.invalidateCache();
    }

    function print_PostListGrid(type) {
        var advancedCriteria_post = PostLG_post.getCriteria();
        var print_form_post = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/web/post_print_list/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields: [
                {name: "CriteriaStr", type: "hidden"},
                {name: "myToken", type: "hidden"}
            ]
        })
        print_form_post.setValue("CriteriaStr", JSON.stringify(advancedCriteria_post));
        print_form_post.setValue("myToken", "<%=accessToken%>");
        print_form_post.show();
        print_form_post.submitForm();
    }
    DetailViewer_Personnel.hide();
    isc.TrVLayout.create({
        members: [
            <%--isc.HLayout.create({--%>
            <%--    height: "10%",--%>
            <%--    // defaultLayoutAlign: "center",--%>
            <%--    members: [--%>
            <%--        // postFilterForm_post,--%>
            <%--        isc.Button.create({--%>
            <%--            title: "<spring:message code="filter"/>",--%>
            <%--            click: function () {--%>
            <%--                postFilterForm_post.submit();--%>
            <%--            }--%>
            <%--        }),]--%>
            <%--}),--%>
            PostLG_post],
    });


    // </script>