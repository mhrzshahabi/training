<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var DynamicForm_AddressInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        titleAlign: "left",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "personality.contactInfo.homeAddress.id", hidden: true},
            {
                name: "personality.contactInfo.homeAddress.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10"
            },
            {
                name: "personality.contactInfo.homeAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Home_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.cityId",
                title: "<spring:message code='city'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true
            },
            {
                name: "personality.contactInfo.homeAddress.phone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },


            {
                name: "personality.contactInfo.homeAddress.fax",
                title: "<spring:message code='telefax'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },

            {
                name: "personality.contactInfo.email",
                title: "<spring:message code='email'/>",
                showHintInField: true,
                length: "30"
                , changed: function () {
                    var emailCheck;
                    emailCheck = checkEmail(DynamicForm_AddressInfo_JspTeacher.getValue("personality.contactInfo.email"));
                    mailCheck = emailCheck;
                    if (emailCheck === false)
                        DynamicForm_AddressInfo_JspTeacher.addFieldErrors("personality.contactInfo.email",
                            "<spring:message code='msg.email.validation'/>", true);
                    if (emailCheck === true)
                        DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
                }
            },
            {
                name: "personality.contactInfo.personalWebSite",
                title: "<spring:message code='personal.website'/>",
                stopOnError: true,
                keyPressFilter: "[a-z|A-Z |]",
                length: "30"
            },
            {
                name: "temp",
                title: "",
                canEdit: false
            },
            {
                name: "personality.contactInfo.homeAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                type: "textArea",
                height: "100",
                length: "255"
            }

        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.homeAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                } else {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                    RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
                    DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
                }
            } else if (item.name === "personality.contactInfo.homeAddress.otherCountry") {
                DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.stateId");
                if (newValue === true) {
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").disable();
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").disable();
                } else {
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").enable();
                    DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.stateId").enable();
                }
            } else if (item.name === "personality.contactInfo.homeAddress.postalCode") {
                if (newValue < 1e9)
                    DynamicForm_AddressInfo_JspTeacher.addFieldErrors("personality.contactInfo.homeAddress.postalCode",
                        "<spring:message code='msg.postal.code.validation'/>", true);
                else {
                    DynamicForm_AddressInfo_JspTeacher.clearFieldErrors("personality.contactInfo.homeAddress.postalCode", true);
                    fillHomeAddressFields(DynamicForm_AddressInfo_JspTeacher.getValue("personality.contactInfo.homeAddress.postalCode"));
                }
            }
        }
    });

    var VLayOut_JspAddressInfo = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "right",
        members: [DynamicForm_AddressInfo_JspTeacher]
    });



    //</script>