package com.nicico.training.controller;

import com.nicico.training.controller.config.JasperServerConfigs;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/jasperSoft")
@RequiredArgsConstructor
public class JasperSoftWebController {

    public static final String ORGANIZATIONS_NICICO_TRAINING = "/organizations/nicico_education";
    private final JasperServerConfigs jasperServerConfig;
    public static final String JASPER_SOFT_MAP_MODEL = "jasperSoftUrl";
    public static final String REPORT_JASPER_SOFT_SERVER_PAGE = "/report/jasperSoftServer";

    @RequestMapping("/adhocsShow")
//    @PreAuthorize("hasAuthority('Adhocs_View')")
    public String showAdhocsList(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=searchFlow&folderUri=" + ORGANIZATIONS_NICICO_TRAINING + "/adhoc_1/topics&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

    @RequestMapping("/adhocCreate")
//    @PreAuthorize("hasAuthority('Adhocs_View')")
    public String createAdhoc(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=adhocFlow&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

    @RequestMapping("/domains")
//    @PreAuthorize("hasAuthority('Domains_View')")
    public String showDomains(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=searchFlow&folderUri=" + ORGANIZATIONS_NICICO_TRAINING + "/Domain&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

    @RequestMapping("/dataSources")
//    @PreAuthorize("hasAuthority('DataSources_View')")
    public String showDataSources(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=searchFlow&folderUri=" + ORGANIZATIONS_NICICO_TRAINING + "/DataSource&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

    @RequestMapping("/reports")
//    @PreAuthorize("hasAuthority('Reports_View')")
    public String showReports(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=searchFlow&folderUri=" + ORGANIZATIONS_NICICO_TRAINING + "/Reports&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

    @RequestMapping("/dashboards")
//    @PreAuthorize("hasAuthority('Dashboards_View')")
    public String showDashboards(ModelMap model) {

        model.addAttribute(JASPER_SOFT_MAP_MODEL, jasperServerConfig.getHttpApiUrl() + "?_flowId=searchFlow&folderUri=" + ORGANIZATIONS_NICICO_TRAINING + "/Dashboard&userLocale=fa&" + jasperServerConfig.getDefaultAuthentication());
        return REPORT_JASPER_SOFT_SERVER_PAGE;
    }

}