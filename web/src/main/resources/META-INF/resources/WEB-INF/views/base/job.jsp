<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    JobMenu_job = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshJobLG_job();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    JobTS_job = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshJobLG_job();
                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "totalsLabel_job"
            }),
            isc.LayoutSpacer.create({
                width: 40
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
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
        dataChanged : function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows > 0 && this.data.lengthIsKnown()) {
                totalsLabel_job.setContents("<spring:message code="records.count"/>" + ": <b>" + totalRows + "</b>");
            } else {
                totalsLabel_job.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [JobTS_job, JobLG_job],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshJobLG_job() {
        JobLG_job.invalidateCache();
    };