/*
ghazanfari_f, 9/30/2019, 9:29 AM
*/
package com.nicico.training.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.File;
import java.util.Map;

@Setter
@Getter
@Component
@ConfigurationProperties(prefix = "nicico")
public class InitDirectories {

    private Map<String, String> dirs;

    @PostConstruct
    private void init() {
        try {
            for (String dir : dirs.values()) {
                createDir(dir);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void createDir(String path) {
        try {
            File dir = new File(path);
            if (!dir.exists()) {
                dir.mkdirs();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
