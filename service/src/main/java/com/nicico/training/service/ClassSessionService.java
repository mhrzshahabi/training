package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.enums.EnumsConverter;
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
    private final HolidayDAO holidayDAO;

    private final EnumsConverter.ESessionStateConverter eSessionStateConverter = new EnumsConverter.ESessionStateConverter();
    private final EnumsConverter.ESessionTimeConverter eSessionTimeConverter = new EnumsConverter.ESessionTimeConverter();
    private final EnumsConverter.ESessionTypeConverter eSessionTypeConverter = new EnumsConverter.ESessionTypeConverter();

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

    public Map<Integer, List<String>> MainHoursRange() {
        //********main hours range*********
        Map<Integer, List<String>> mainHoursRange = new HashMap<>();
        mainHoursRange.put(1, Arrays.asList("08:00", "10:00"));
        mainHoursRange.put(2, Arrays.asList("10:00", "12:00"));
        mainHoursRange.put(3, Arrays.asList("14:00", "16:00"));

        return mainHoursRange;
    }

    //*********************************

    public String[] daysName() {
        //********short week days*********
        return new DateFormatSymbols().getShortWeekdays();
    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info create(ClassSessionDTO.ManualSession request) {

        //********generated sessions list*********
        ClassSessionDTO.GeneratedSessions session;

        //********date utils*********
        Calendar calendar = Calendar.getInstance();
        Date gregorianSessionDate = null;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        try {
            gregorianSessionDate = formatter.parse(DateUtil.convertKhToMi1(request.getSessionDate()));

        } catch (ParseException e) {
            e.printStackTrace();
        }

        calendar.setTime(gregorianSessionDate);

        session = new ClassSessionDTO.GeneratedSessions(
                request.getClassId(),
                daysName()[calendar.get(Calendar.DAY_OF_WEEK)],
                request.getSessionDate(),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(0),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(1),
                request.getSessionTypeId(),
                request.getInstituteId(),
                request.getTrainingPlaceId(),
                request.getTeacherId(),
                request.getSessionState(),
                request.getDescription()
        );


        ClassSession generatedSession = modelMapper.map(session, ClassSession.class);

        try {
            return modelMapper.map(classSessionDAO.saveAndFlush(generatedSession), ClassSessionDTO.Info.class);
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

    //*********************************

    @Transactional
    @Override
    public void generateSessions(Long classId, TclassDTO.Create autoSessionsRequirement) {

        //********sending data from t_class*********
        //-----make days code list-----
        List<String> daysCode = new ArrayList<String>();
        if (autoSessionsRequirement.getSaturday() != null && autoSessionsRequirement.getSaturday())
            daysCode.add("Sat");
        if (autoSessionsRequirement.getSunday() != null && autoSessionsRequirement.getSunday())
            daysCode.add("Sun");
        if (autoSessionsRequirement.getMonday() != null && autoSessionsRequirement.getMonday())
            daysCode.add("Mon");
        if (autoSessionsRequirement.getTuesday() != null && autoSessionsRequirement.getTuesday())
            daysCode.add("Tue");
        if (autoSessionsRequirement.getWednesday() != null && autoSessionsRequirement.getWednesday())
            daysCode.add("Wed");
        if (autoSessionsRequirement.getThursday() != null && autoSessionsRequirement.getThursday())
            daysCode.add("Thu");
        if (autoSessionsRequirement.getFriday() != null && autoSessionsRequirement.getFriday())
            daysCode.add("Fri");
        //-----make class hours range list-----
        List<Integer> classHoursRange = new ArrayList<Integer>();
        if (autoSessionsRequirement.getFirst() != null && autoSessionsRequirement.getFirst())
            classHoursRange.add(1);
        if (autoSessionsRequirement.getSecond() != null && autoSessionsRequirement.getSecond())
            classHoursRange.add(2);
        if (autoSessionsRequirement.getThird() != null && autoSessionsRequirement.getThird())
            classHoursRange.add(3);

        Integer sessionTypeId = 1;
        Integer sessionState = 1;
        String classStartDate = autoSessionsRequirement.getStartDate();
        String classEndDate = autoSessionsRequirement.getEndDate();

        //********date utils*********
        Calendar calendar = Calendar.getInstance();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date gregorianStartDate = null, gregorianEndDate = null;

        try {
            gregorianStartDate = formatter.parse(DateUtil.convertKhToMi1(classStartDate));
            gregorianEndDate = formatter.parse(DateUtil.convertKhToMi1(classEndDate));

        } catch (ParseException e) {
            e.printStackTrace();
        }

        //********validate sending data from t_class*********
        if (gregorianStartDate != null && gregorianEndDate != null && gregorianStartDate.compareTo(gregorianEndDate) > 0) {
            //start-date bigger than end-date
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (daysCode.size() == 0) {
            //days code is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (MainHoursRange().size() == 0) {
            //hours rage is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);

        } else if (classId == null ||
                sessionTypeId == null ||
                autoSessionsRequirement.getInstituteId() == null ||
                autoSessionsRequirement.getTrainingPlaceIds() == null ||
                autoSessionsRequirement.getTeacherId() == null ||
                sessionState == null) {

            //require data is null
            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }

        //********generated sessions list*********
        List<ClassSessionDTO.GeneratedSessions> sessions = new ArrayList<ClassSessionDTO.GeneratedSessions>();

        //********fetch holidays*********
        List<String> holidays = holidayDAO.Holidays(classStartDate, classEndDate);


        //*********************************
        //*********************************
        //*********************************

        //********generating sessions*********
        while (gregorianStartDate.compareTo(gregorianEndDate) <= 0) {

            calendar.setTime(gregorianStartDate);
            if (daysCode.contains(daysName()[calendar.get(Calendar.DAY_OF_WEEK)])) {

                if (!holidays.contains(DateUtil.convertMiToKh(formatter.format(gregorianStartDate)))) {

                    for (Integer range : classHoursRange) {

                        sessions.add(new ClassSessionDTO.GeneratedSessions(
                                classId,
                                daysName()[calendar.get(Calendar.DAY_OF_WEEK)],
                                DateUtil.convertMiToKh(formatter.format(gregorianStartDate)),
                                MainHoursRange().get(range).get(0),
                                MainHoursRange().get(range).get(1),
                                sessionTypeId,
                                autoSessionsRequirement.getInstituteId().intValue(),
                                autoSessionsRequirement.getTrainingPlaceIds().get(0).intValue(),
                                autoSessionsRequirement.getTeacherId(),
                                sessionState,
                                null
                        ));

                    }
                }
            }

            gregorianStartDate = DateUtils.addDays(gregorianStartDate, 1);
        }

        //********save generated sessions*********
        if (sessions.size() > 0) {
            classSessionDAO.saveAll(modelMapper.map(sessions, new TypeToken<List<ClassSession>>() {
            }.getType()));
        }
    }

    //*********************************

    private void setEnums(ClassSession classSession, Integer marriedId) {
        if (marriedId != null) {
            classSession.setSessionState(modelMapper.map(eSessionStateConverter.convertToEntityAttribute(marriedId),Integer.class));
        }
//        if (militaryId != null) {
//            personalInfo.setMilitary(eMilitaryConverter.convertToEntityAttribute(militaryId));
//        }
//        if (genderId != null) {
//            personalInfo.setGender(eGenderConverter.convertToEntityAttribute(genderId));
//        }
    }
}
