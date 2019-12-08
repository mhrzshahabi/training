package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
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
    private final HolidayDAO holidayDAO;

    //*********************************

    @Transactional(readOnly = true)
    @Override
    public ClassSessionDTO.Info get(Long id) {
        final Optional<ClassSession> optionalClassSession = classSessionDAO.findById(id);
        final ClassSession classSession = optionalClassSession.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
        return modelMapper.map(classSession, ClassSessionDTO.Info.class);
    }

    //*********************************
    @Transactional
    @Override
    public List<ClassSessionDTO.Info> list() {
        List<ClassSession> classSessionList = classSessionDAO.findAll();
        return modelMapper.map(classSessionList, new TypeToken<List<ClassSessionDTO.Info>>() {
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

    public String getDayNameFa(String dayCode) {

        switch (dayCode) {
            case "Sat":
                return "شنبه";
            case "Sun":
                return "یکشنبه";
            case "Mon":
                return "دوشنبه";
            case "Tue":
                return "سه شنبه";
            case "Wed":
                return "چهارشنبه";
            case "Thu":
                return "پنجشنبه";
            case "Fri":
                return "جمعه";
            default:
                return "";
        }
    }

    //*********************************

    private String[] daysName() {
        //********short week days*********
        return new DateFormatSymbols().getShortWeekdays();
    }

    //*********************************

    private Date ConvertToGregorianDate(String jalaliDate) {
        //********convert jalali date to gregorian Date*********
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

        try {
            return formatter.parse(DateUtil.convertKhToMi1(jalaliDate));
        } catch (ParseException e) {
            throw new TrainingException(TrainingException.ErrorType.Unknown);
        }
    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info create(ClassSessionDTO.ManualSession request) {

        if (!classSessionDAO.existsByClassIdAndSessionDateAndSessionStartHourAndSessionEndHour(
                request.getClassId(),
                request.getSessionDate(),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(0),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(1)
        )) {

            //********generated sessions list*********
            ClassSessionDTO.GeneratedSessions session;

            //********date utils*********
            Calendar calendar = Calendar.getInstance();
            Date gregorianSessionDate = ConvertToGregorianDate(request.getSessionDate());
            calendar.setTime(gregorianSessionDate);


            session = new ClassSessionDTO.GeneratedSessions(
                    request.getClassId(),
                    daysName()[calendar.get(Calendar.DAY_OF_WEEK)],
                    getDayNameFa(daysName()[calendar.get(Calendar.DAY_OF_WEEK)]),
                    request.getSessionDate(),
                    MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(0),
                    MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(1),
                    request.getSessionTypeId(),
                    request.getSessionType(),
                    request.getInstituteId(),
                    request.getTrainingPlaceId(),
                    request.getTeacherId(),
                    request.getSessionState(),
                    request.getSessionStateFa(),
                    request.getDescription()
            );


            ClassSession generatedSession = modelMapper.map(session, ClassSession.class);

            try {
                return modelMapper.map(classSessionDAO.saveAndFlush(generatedSession), ClassSessionDTO.Info.class);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
            }

        } else {

            throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
        }

    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info update(Long id, ClassSessionDTO.Update request) {

        if (!classSessionDAO.existsByClassIdAndSessionDateAndSessionStartHourAndSessionEndHourAndIdNot(
                request.getClassId(),
                request.getSessionDate(),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(0),
                MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(1),
                id
        )) {

            //********date utils*********
            Calendar calendar = Calendar.getInstance();
            Date gregorianSessionDate = ConvertToGregorianDate(request.getSessionDate());
            calendar.setTime(gregorianSessionDate);

            request.setDayCode(daysName()[calendar.get(Calendar.DAY_OF_WEEK)]);
            request.setDayName(getDayNameFa(daysName()[calendar.get(Calendar.DAY_OF_WEEK)]));
            request.setSessionStartHour(MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(0));
            request.setSessionEndHour(MainHoursRange().get(Integer.parseInt(request.getSessionTime())).get(1));

            Optional<ClassSession> optionalClassSession = classSessionDAO.findById(id);
            ClassSession currentClassSession = optionalClassSession.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TermNotFound));
            ClassSession classSession = new ClassSession();
            modelMapper.map(currentClassSession, classSession);
            modelMapper.map(request, classSession);

            try {
                return modelMapper.map(classSessionDAO.saveAndFlush(classSession), ClassSessionDTO.Info.class);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.OperationalUnitDuplicateRecord);
            }
        } else {

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
        final List<ClassSession> classSessionList = classSessionDAO.findAllById(request.getIds());
        classSessionDAO.deleteAll(classSessionList);
    }

    //*********************************

    @Transactional
    @Override
    public SearchDTO.SearchRs<ClassSessionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classSessionDAO, request, classSession -> modelMapper.map(classSession, ClassSessionDTO.Info.class));
    }

    //*********************************

    @Override
    @Transactional
    public List<ClassSessionDTO.Info> loadSessions(Long classId) {
        return modelMapper.map(classSessionDAO.findByClassId(classId), new TypeToken<List<ClassSessionDTO.Info>>() {
        }.getType());
    }
    //*********************************

    @Override
    @Transactional
    public List<ClassSessionDTO.Info> getSessionsForDate(Long classId, String date) {
        return modelMapper.map(classSessionDAO.findByClassIdAndSessionDate(classId,date), new TypeToken<List<ClassSessionDTO.Info>>() {
        }.getType());
    }
    //*********************************

    @Override
    @Transactional
    public List<ClassSessionDTO.ClassSessionsDateForOneClass> getDateForOneClass(Long classId) {
        return modelMapper.map(classSessionDAO.findDistinctSessionDateByClassId(classId), new TypeToken<List<ClassSessionDTO.ClassSessionsDateForOneClass>>() {
        }.getType());
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
        Date gregorianStartDate = ConvertToGregorianDate(classStartDate);
        Date gregorianEndDate = ConvertToGregorianDate(classEndDate);


        //********validate sending data from t_class*********
        if (gregorianStartDate != null && gregorianEndDate != null && gregorianStartDate.compareTo(gregorianEndDate) > 0) {
            //start-date bigger than end-date
            throw new TrainingException(TrainingException.ErrorType.NotFound);

        } else if (daysCode.size() == 0) {
            //days code is null
            throw new TrainingException(TrainingException.ErrorType.NotFound);

        } else if (MainHoursRange().size() == 0) {
            //hours rage is null
            throw new TrainingException(TrainingException.ErrorType.NotFound);

        } else if (classId == null ||
                sessionTypeId == null ||
                autoSessionsRequirement.getInstituteId() == null ||
                autoSessionsRequirement.getTrainingPlaceIds() == null ||
                autoSessionsRequirement.getTeacherId() == null ||
                sessionState == null) {

            //require data is null
            throw new TrainingException(TrainingException.ErrorType.NotFound);
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
                                getDayNameFa(daysName()[calendar.get(Calendar.DAY_OF_WEEK)]),
                                DateUtil.convertMiToKh(formatter.format(gregorianStartDate)),
                                MainHoursRange().get(range).get(0),
                                MainHoursRange().get(range).get(1),
                                sessionTypeId,
                                "آموزش",
                                autoSessionsRequirement.getInstituteId().intValue(),
                                autoSessionsRequirement.getTrainingPlaceIds().get(0).intValue(),
                                autoSessionsRequirement.getTeacherId(),
                                sessionState,
                                "شروع نشده",
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

}
