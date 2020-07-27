package com.nicico.training.controller.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Setter
@Getter
@Component
@ConfigurationProperties(prefix = "nicico.jasper.server")
public class JasperServerConfigs {

    private String restApiUrl = "http://10.1.254.65:8080/jasperserver-pro/rest_v2";
    private String httpApiUrl = "http://10.1.254.65:8080/jasperserver-pro/flow.html";
    private String defaultAuthentication = "sessionDecorator=no&orgID=nicico_education&j_username=edu_user&j_password=edu_user";
}

