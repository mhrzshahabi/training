package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.model.ClassSession;
import com.nicico.training.repository.ClassSessionDAO;
import com.nicico.training.repository.HolidayDAO;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.time.DateUtils;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DateFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ClassSessionService implements IClassSession {

    private final ClassSessionDAO classSessionDAO;
    private final ModelMapper modelMapper;

    //*********************************

    @Transactional(readOnly = true)
    @Override
    public ClassSessionDTO.Info get(Long id) {
        final Optional<ClassSession> optionalOperationalUnit = classSessionDAO.findById(id);
        final ClassSession operationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return modelMapper.map(operationalUnit, ClassSessionDTO.Info.class);
    }

    //*********************************

    @Transactional
    @Override
    public List<ClassSessionDTO.Info> list() {
        List<ClassSession> operationalUnitList = classSessionDAO.findAll();
        return modelMapper.map(operationalUnitList, new TypeToken<List<ClassSessionDTO.Info>>() {
        }.getType());
    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info create(ClassSessionDTO.Create request) {
        ClassSession operationalUnit = modelMapper.map(request, ClassSession.class);
        try {
            return modelMapper.map(classSessionDAO.saveAndFlush(operationalUnit), ClassSessionDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }
    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info update(Long id, ClassSessionDTO.Update request) {
        Optional<ClassSession> optionalOperationalUnit = classSessionDAO.findById(id);
        ClassSession currentOperationalUnit = optionalOperationalUnit.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        ClassSession operationalUnit = new ClassSession();
        modelMapper.map(currentOperationalUnit, operationalUnit);
        modelMapper.map(request, operationalUnit);

        try {
            return modelMapper.map(classSessionDAO.saveAndFlush(operationalUnit), ClassSessionDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }

    }

    //*********************************

    @Transactional
    @Override
    public void delete(Long id) {
        classSessionDAO.deleteById(id);
    }

    //*********************************

    @Transactional
    @Override
    public void delete(ClassSessionDTO.Delete request) {
        final List<ClassSession> operationalUnitList = classSessionDAO.findAllById(request.getIds());
        classSessionDAO.deleteAll(operationalUnitList);
    }

    //*********************************

    @Transactional
    @Override
    public SearchDTO.SearchRs<ClassSessionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classSessionDAO, request, operationalUnit -> modelMapper.map(operationalUnit, ClassSessionDTO.Info.class));
    }


    //**********************
    //**********************
    //**********************
    //**********************

    public static void main(String[] args) {

//        List<String> days_code = Arrays.asList("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri");
        List<String> days_code = Arrays.asList("Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri");

        List<Integer> hours_range = Arrays.asList(1, 2, 3);

        ClassSessionDTO.AutoSessionsRequirement AS = new ClassSessionDTO.AutoSessionsRequirement
                (
                        1L,
                        days_code,
                        1,
                        "1398/07/01",
                        "1398/08/30",
                        hours_range, 1,
                        221,
                        22,
                        602L,
                        1,
                        "توضیحات"
                );
        ClassSessionService fff = new ClassSessionService(null, null);
        fff.generateSessions(AS);


    }

    @Transactional
    @Override
    public List<ClassSessionDTO.GeneratedSessions> generateSessions(ClassSessionDTO.AutoSessionsRequirement autoSessionsRequirement) {

        //********sending data from t_class*********
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

        //********validate sending data from t_class*********
        if (G_StartDate.compareTo(G_EndDate) > 0) {
            //start-date bigger than end-date
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (DaysCode.size() == 0) {
            //days code is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (MainHoursRange.size() == 0) {
            //hours rage is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (autoSessionsRequirement.getClassId() == null ||
                autoSessionsRequirement.getTrainingType() == null ||
                autoSessionsRequirement.getInstituteId() == null ||
                autoSessionsRequirement.getTrainingPlaceId() == null ||
                autoSessionsRequirement.getTeacherId() == null ||
                autoSessionsRequirement.getSessionState() == null) {

            //require data is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }

        //********generated sessions*********
        List<ClassSessionDTO.GeneratedSessions> Sessions = new ArrayList<ClassSessionDTO.GeneratedSessions>();

        //********fetch holidays*********
        List<String> Holidays = Arrays.asList("", "", "");
//        List<String> Holidays =  holidayDAO.Holidays(ClassStartDate, ClassEndDate);


        //*********************************
        //*********************************
        //*********************************

        //********generating sessions*********
        while (G_StartDate.compareTo(G_EndDate) <= 0) {

            calendar.setTime(G_StartDate);
            if (DaysCode.contains(dayNames[calendar.get(Calendar.DAY_OF_WEEK)])) {

                if (!Holidays.contains(DateUtil.convertMiToKh(formatter.format(G_StartDate)))) {

                    for (Integer range : ClassHoursRange) {

                        Sessions.add(new ClassSessionDTO.GeneratedSessions(
                                autoSessionsRequirement.getClassId(),
                                dayNames[calendar.get(Calendar.DAY_OF_WEEK)],
                                DateUtil.convertMiToKh(formatter.format(G_StartDate)),
                                MainHoursRange.get(range).get(0),
                                MainHoursRange.get(range).get(1),
                                autoSessionsRequirement.getSessionTypeId(),
                                autoSessionsRequirement.getInstituteId(),
                                autoSessionsRequirement.getTrainingPlaceId(),
                                autoSessionsRequirement.getTeacherId(),
                                autoSessionsRequirement.getSessionState(),
                                autoSessionsRequirement.getDescription()
                        ));

                    }
                }
            }

            G_StartDate = DateUtils.addDays(G_StartDate, 1);
        }

        if (Sessions.size() > 0) {
            // save data here
        }

        return Sessions;
    }
}
