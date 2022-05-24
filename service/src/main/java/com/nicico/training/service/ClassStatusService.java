package com.nicico.training.service;

import com.nicico.training.iservice.IClassStatusService;
import com.nicico.training.iservice.ITclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@RequiredArgsConstructor
@Service
@Slf4j
@EnableScheduling
public class ClassStatusService implements IClassStatusService {
    private final ITclassService tclassService;
    @Scheduled(cron = "0 30 17 1/1 * ?")
    @Transactional
    @Override
    public void changeClassStatus() {

        try {
            tclassService.updateClassStatus();
            log.info(" changeClassStatus scheduler started to run ! ");
        } catch (Exception e) {
            log.info(" Error in running changeClassStatus scheduler ");
            e.printStackTrace();
        }
        log.info("changeClassStatus scheduler finished to run ! ");

    }
}



