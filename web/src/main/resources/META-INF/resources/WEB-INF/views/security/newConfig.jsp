<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    let configComplexTitle=null;


    IButton_course_V2_Config = isc.IButtonSave.create({
        top: 260,
        align: "center",
        title: "ذخیره",
        width: 300,
        click: function () {

        }
    });



    DynamicForm_V2_edit_cource_config = isc.DynamicForm.create({
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        width: "100%",
        align: "right",
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " حداقل تعداد دانشجویان:"
            },
            {
                colSpan: 2,
                autoFetchData: false,
                textAlign: "center",
            }
        ]
    });

    var VLayOut_BTNCourse_V2_Config = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 3,
        members: [
            IButton_course_V2_Config
        ]
    });


    var VLayOut_Course_V2_Config = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_V2_edit_cource_config,
            VLayOut_BTNCourse_V2_Config
        ]
    });


    //----------------------------------------------------RestDataSource------------------------------------------------


    let RestDataSource_config_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });

    //
    let config_tabs = isc.TabSet.create({
        //ID: "PersonnelInfo_ClassInfo_Tab",
        width: "100%",
        height: 500,
        tabBarPosition: "top",
        tabs: [
            {
                id: "Config_Tab_Course",
                title: "تنظیمات دوره",
                pane: VLayOut_Course_V2_Config
            }
        ],
        tabSelected: function () {
        }.bind(this)
    });


    //-------------------------------window-----------------------------------------------------------------------------

    window_edit_config = isc.Window.create({
        title: "",
        width: "70%",
        minWidth: 500,
        height: 500,
        visibility: "hidden",
        items: [config_tabs]
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    //



    DynamicForm_V2_edit_config = isc.DynamicForm.create({
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        width: "100%",
        align: "right",
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " نمایش و تغییر تنظیمات مجتمع مورد نظر:"
            },
            {
                name: "editConfigDepartmentFilter",
                title: " مجتمع :",
                colSpan: 2,
                optionDataSource: RestDataSource_config_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    configComplexTitle=DynamicForm_V2_edit_config.getField("editConfigDepartmentFilter").getDisplayValue();
                },

            },
            {
                colSpan: 2,
                name: "configBtn",
                title: "<spring:message code="configurations"/>",
                type: "Button",
                width: 100,
                startRow: false,
                endRow: false,
                click() {
                    if (configComplexTitle!==null){
                        window_edit_config.setTitle(configComplexTitle);
                        window_edit_config.show();
                    }else {
                        createDialog("info", "مجتمع را انتخاب کنید");
                    }

                }
            },
        ]
    });


    DynamicForm_V2_set_config = isc.DynamicForm.create({
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        width: "100%",
        align: "right",
        numCols: 6,
        fields: [
            {
                colSpan: 2,
                type: "header",
                defaultValue: " کل تنظیمات اپلیکیشن برای شما بر اساس مجتمع زیر است:(برای ثبت تغییر ذخیره را انتخاب کنید)"
            },
            {
                name: "setConfigDepartmentFilter",
                title: " مجتمع :",
                colSpan: 2,
                optionDataSource: RestDataSource_config_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {


                },

            }

        ]
    });

    IButton_V2_Config = isc.IButtonSave.create({
        top: 260,
        title: "ذخیره",
        width: 300,
        click: function () {

        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_V2_Config = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_V2_edit_config,
            DynamicForm_V2_set_config
        ]
    });
    var HLayOut_Confirm_V2_Config = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_V2_Config
        ]
    });

    var VLayout_Body_V2_Config = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            VLayOut_CriteriaForm_V2_Config,
            HLayOut_Confirm_V2_Config
        ]
    });




    //</script>