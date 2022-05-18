package com.nicico.training.service;

import com.nicico.training.iservice.IClassStatusService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.Tclass;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.w3c.dom.stylesheets.LinkStyle;

import java.security.PrivateKey;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RequiredArgsConstructor
@Service
@Slf4j
public class ClassStatusService implements IClassStatusService {

    private final ITclassService tclassService;

    @Scheduled(cron = "0 30 17 1/1 * ?")
    @Transactional
    @Override
    public void changeClassStatus() throws ParseException {
        List<Tclass> tClassList = tclassService.getTclassList();

        DateFormat format = new SimpleDateFormat("yyyy/MM/dd");
        Date currentDateAndTime = new Date();
        Date currentDate = format.parse(String.valueOf(currentDateAndTime));

        for (Tclass tclass : tClassList) {
            Date tClassStartDate = format.parse(tclass.getStartDate());
            Date startDate1400 = format.parse("1401/01/01");

            if (tclass.getClassStudents().size() != 0 &&
                    (tClassStartDate.after(startDate1400) || tClassStartDate.compareTo(startDate1400) == 0) &&
                    (tClassStartDate.before(currentDate) || tClassStartDate.compareTo(currentDate) == 0)
            ) {
                tclass.setClassStatus("2"); // در حال اجرا
                tclassService.saveOrUpdate(tclass);
            }
        }

        log.info("changeClassStatus در حال اجرا scheduler ");
    }
}
