/*
ghazanfari_f, 9/30/2019, 9:29 AM
*/
package com.nicico.training.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.File;

@Component
public class InitDirectories {

    @Value("${nicico.dir.upload.person.img}")
    private String personImgDir;

    @Value("${nicico.dir.upload.person.tmp}")
    private String personImgTmpDir;

    @Value("${nicico.dir.upload.bpmn}")
    private String bpmnDir;

    @PostConstruct
    private void init() {
        try {
            createDir(personImgDir);
            createDir(personImgTmpDir);
            createDir(bpmnDir);
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
