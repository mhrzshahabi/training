package com.nicico.training.service;

import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.ClassSessionsDTO;
import com.nicico.training.iservice.IClassSessions;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.apache.commons.lang3.time.DateUtils;

import java.lang.reflect.Array;
import java.text.DateFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ClassSessionsService implements IClassSessions {

    public static void main(String[] args) {

//        List<String> days_code = Arrays.asList("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri");
        List<String> days_code = Arrays.asList("Fri");

        List<Integer> hours_range = Arrays.asList(3);

        ClassSessionsDTO.AutoSessionsRequirement AS = new ClassSessionsDTO.AutoSessionsRequirement(days_code, 1, "1398/08/18", "1398/09/01", hours_range);

        ClassSessionsService fff = new ClassSessionsService();
        fff.generateSessions(AS);
    }

    @Override
    public List<ClassSessionsDTO.GeneratedSessions> generateSessions(ClassSessionsDTO.AutoSessionsRequirement autoSessionsRequirement) {

        //********sending data from class*********
        List<String> DaysCode = autoSessionsRequirement.getDaysCode();
        Integer TrainingType = autoSessionsRequirement.getTrainingType();
        String ClassStartDate = autoSessionsRequirement.getClassStartDate();
        String ClassEndDate = autoSessionsRequirement.getClassEndDate();
        List<Integer> ClassHoursRange = autoSessionsRequirement.getClassHoursRange();

        //********main hours range*********
        Map<Integer, List<String>> MainHoursRange = new HashMap<>();
        MainHoursRange.put(1, Arrays.asList("08:00", "10:00"));
        MainHoursRange.put(2, Arrays.asList("10:00", "12:00"));
        MainHoursRange.put(3, Arrays.asList("14:00", "16:00"));

        //********date utils*********
        Calendar calendar = Calendar.getInstance();
        String dayNames[] = new DateFormatSymbols().getShortWeekdays();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date G_StartDate = null, G_EndDate = null;

        try {
            G_StartDate = formatter.parse(DateUtil.convertKhToMi1(ClassStartDate));
            G_EndDate = formatter.parse(DateUtil.convertKhToMi1(ClassEndDate));

        } catch (ParseException e) {
            e.printStackTrace();
        }

        //********generated sessions*********
        List<ClassSessionsDTO.GeneratedSessions> Sessions = new ArrayList<ClassSessionsDTO.GeneratedSessions>();


        //*********************************
        //*********************************
        //*********************************

        boolean validation = true;

        if (!validation)
            return null;

        //********generating sessions*********
        while (G_StartDate.compareTo(G_EndDate) <= 0) {

            calendar.setTime(G_StartDate);
            if (DaysCode.contains(dayNames[calendar.get(Calendar.DAY_OF_WEEK)])) {

                for (Integer range : ClassHoursRange) {

                    Sessions.add(new ClassSessionsDTO.GeneratedSessions(
                            dayNames[calendar.get(Calendar.DAY_OF_WEEK)],
                            DateUtil.convertMiToKh(formatter.format(G_StartDate)),
                            MainHoursRange.get(range).get(0),
                            MainHoursRange.get(range).get(1)
                    ));

                }


//                System.out.println(G_StartDate);
//                System.out.println(dayNames[calendar.get(Calendar.DAY_OF_WEEK)]);
            }

            G_StartDate = DateUtils.addDays(G_StartDate, 1);

        }

        System.out.println(Arrays.toString(Sessions.toArray()));
        return Sessions;
    }
}
