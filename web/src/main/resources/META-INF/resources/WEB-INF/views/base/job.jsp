<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // -------------------------------------------  Menu -------------------------------------------
    JobMenu_job = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshJobLG_job();
                }
            }, {
                title: "<spring:message code="print"/>", icon: "<spring:url value="print.png"/>",
                submenu: [
                    {title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>"},
                    {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>"},
                    {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>"},
                ],
            }
        ]
    });

    // -------------------------------------------  ToolStrip -------------------------------------------
    JobTS_job = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshJobLG_job();
                }
            }),
            isc.TrPrintBtn.create({
                click: function () {
                }
            }),
        ]
    });

    // -------------------------------------------  DataSource & ListGrid -------------------------------------------
    JobDS_job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "contains"},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "contains"},
        ],
        fetchDataURL: jobUrl + "iscList"
    });

    JobLG_job = isc.TrLG.create({
        dataSource: JobDS_job,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [JobTS_job, "header", "filterEditor", "body",],
        contextMenu: JobMenu_job,
        sortField: 0,
    });

    // -------------------------------------------  Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [JobTS_job, JobLG_job],
    });