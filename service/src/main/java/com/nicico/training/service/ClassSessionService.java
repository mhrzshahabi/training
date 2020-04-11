package com.nicico.training.service;

import com.ibm.icu.util.PersianCalendar;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IClassSession;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.ClassSession;
import com.nicico.training.model.IClassSessionDTO;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassSessionDAO;
import com.nicico.training.repository.HolidayDAO;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.time.DateUtils;
import org.joda.time.DateTimeComparator;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.text.DateFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ClassSessionService implements IClassSession {

    private final ClassSessionDAO classSessionDAO;
    private final AttendanceDAO attendanceDAO;
    private final ModelMapper modelMapper;
    private final HolidayDAO holidayDAO;
    private final MessageSource messageSource;

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
    public ClassSessionDTO.Info create(ClassSessionDTO.ManualSession request, HttpServletResponse response) {

        ClassSessionDTO.Info info = null;

        try {
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

                info = modelMapper.map(classSessionDAO.saveAndFlush(generatedSession), ClassSessionDTO.Info.class);

            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return info;
    }

    //*********************************

    @Transactional
    @Override
    public ClassSessionDTO.Info update(Long id, ClassSessionDTO.Update request, HttpServletResponse response) {

        ClassSessionDTO.Info updateResult = null;

        try {

            if (!attendanceDAO.existsBySessionId(id)) {

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

                    updateResult = modelMapper.map(classSessionDAO.saveAndFlush(classSession), ClassSessionDTO.Info.class);

                } else {

                    Locale locale = LocaleContextHolder.getLocale();
                    response.sendError(406, messageSource.getMessage("msg.record.duplicate", null, locale));
                }
            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(503, messageSource.getMessage("attendance.meeting", null, locale));
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return updateResult;
    }

    //*********************************

    @Transactional
    @Override
    public void delete(Long id, HttpServletResponse response) {

        try {
            if (!attendanceDAO.existsBySessionId(id)) {
                classSessionDAO.deleteById(id);
            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(503, messageSource.getMessage("attendance.meeting", null, locale));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
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


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassSessionDTO.Info> searchWithCriteria(SearchDTO.SearchRq request, Long classId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (classId != null) {
            list.add(makeNewCriteria("classId", classId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(classSessionDAO, request, classStudent -> modelMapper.map(classStudent, ClassSessionDTO.Info.class));
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
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
        return modelMapper.map(classSessionDAO.findByClassIdAndSessionDate(classId, date), new TypeToken<List<ClassSessionDTO.Info>>() {
        }.getType());
    }

//    public List<ClassSessionDTO.Info> getSessionsForStudent(Long classId, Long studentId) {
//        classSessionDAO.findByClassIdAndStudent
//        return null;
//    }
    //*********************************

    @Override
    @Transactional
    public List<ClassSessionDTO.ClassSessionsDateForOneClass> getDateForOneClass(Long classId) {
        List<IClassSessionDTO> dateByClassId = classSessionDAO.findSessionDateDistinctByClassId(classId);
        return modelMapper.map(dateByClassId, new TypeToken<List<ClassSessionDTO.ClassSessionsDateForOneClass>>() {
        }.getType());
    }

    //*********************************

    @Transactional
    @Override
    public void generateSessions(Long classId, TclassDTO.Create autoSessionsRequirement, HttpServletResponse response) {

        try {
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
            while (DateTimeComparator.getDateOnlyInstance().compare(gregorianStartDate, gregorianEndDate) <= 0) {

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
            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(407, messageSource.getMessage("no.sessions.was.scheduled.for.class", null, locale));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Transactional(readOnly = true)
    public List<ClassSession> findBySessionDateBetween(String start, String end){
        return classSessionDAO.findBySessionDateBetween(start, end);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassSessionDTO.WeeklySchedule> searchWeeklyTrainingSchedule(SearchDTO.SearchRq request, String userNationalCode) {
        userNationalCode = "3149573092";
        LocalDate inputDate = LocalDate.now();
        LocalDate prevSat = inputDate.with(TemporalAdjusters.previous(DayOfWeek.SATURDAY));
        LocalDate nextFri = inputDate.with(TemporalAdjusters.next(DayOfWeek.FRIDAY));
//        String prevSaturday = getPersianDate(prevSat.getYear(),prevSat.getMonthValue(),prevSat.getDayOfMonth());
//        String nextFriday = getPersianDate(nextFri.getYear(),nextFri.getMonthValue(),nextFri.getDayOfMonth());
        String prevSaturday = "1398/12/01";
        String nextFriday = "1398/12/29";

        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("sessionDate", prevSaturday, EOperator.greaterOrEqual, null));
            list.add(makeNewCriteria("sessionDate", nextFriday, EOperator.lessOrEqual, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);

        Long studentId = null;
        List<ClassSession> sessions = null;
         SearchDTO.SearchRs<ClassSessionDTO.WeeklySchedule> resp =  SearchUtil.search(classSessionDAO, request, classStudent -> modelMapper.map(classStudent, ClassSessionDTO.WeeklySchedule.class));
        for ( ClassSessionDTO.WeeklySchedule classSession : resp.getList()) {
            classSession.setStudentStatus("ثبت نام نشده");
            for (ClassStudentDTO.WeeklySchedule attendanceInfo : classSession.getTclass().getClassStudents()) {
                if(attendanceInfo.getNationalCodeStudent().equalsIgnoreCase(userNationalCode)) {
                    studentId = attendanceInfo.getStudent().getId();
                    classSession.setStudentStatus("ثبت نام شده");
                }
            }
            Attendance attendance = attendanceDAO.findBySessionIdAndStudentId(classSession.getId(),studentId);
            classSession.setStudentPresentStatus(attendance.getState());
            sessions.add(modelMapper.map(classSession,ClassSession.class));
        }
        return resp;
    }

    //--------------------------------------------- Calender -----------------------------------------------------------
    private static double greg_len = 365.2425;
    private static double greg_origin_from_jalali_base = 629964;
    private static double len = 365.24219879;

    public static String getPersianDate(Date d) {
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(d);
        int year = gc.get(Calendar.YEAR);
        return getPersianDate(year, (gc.get(Calendar.MONTH)) + 1,
                gc.get(Calendar.DAY_OF_MONTH));
    }

    public static String getPersianDate(int gregYear, int gregMonth, int gregDay) {
        // passed days from Greg orig
        double d = Math.ceil((gregYear - 1) * greg_len);
        // passed days from jalali base
        double d_j = d + greg_origin_from_jalali_base
                + getGregDayOfYear(gregYear, gregMonth, gregDay);

        // first result! jalali year
        double j_y = Math.ceil(d_j / len) - 2346;
        // day of the year
        double j_days_of_year = Math
                .floor(((d_j / len) - Math.floor(d_j / len)) * 365) + 1;

        // System.out.println(j_days_of_year);
        StringBuffer result = new StringBuffer();

        result.append((int) j_y + "/" + (int) month(j_days_of_year) + "/"
                + (int) dayOfMonth(j_days_of_year));
        return result.toString();
    }

    private static double month(double day) {

        if (day < 6 * 31)
            return Math.ceil(day / 31);
        else
            return Math.ceil((day - 6 * 31) / 30) + 6;
    }

    private static double dayOfMonth(double day) {

        double m = month(day);
        if (m <= 6)
            return day - 31 * (m - 1);
        else
            return day - (6 * 31) - (m - 7) * 30;
    }

    private static double getGregDayOfYear(double year, double month, double day) {
        int greg_moneths_len[] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31,
                30, 31 };
        boolean leap = false;
        if (((year % 4) == 0) && (((year % 400) != 0)))
            leap = true;
        if (leap)
            greg_moneths_len[2] = 29;
        int sum = 0;
        for (int i = 0; i < month; i++)
            sum += greg_moneths_len[i];
        return sum + day - 2;
    }
    //--------------------------------------------- Calender -----------------------------------------------------------

}
