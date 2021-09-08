package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IAttendanceService;
import com.nicico.training.iservice.IStudentService;
import com.nicico.training.model.*;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassSessionDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AttendanceService implements IAttendanceService {

    private final ModelMapper modelMapper;
    private final AttendanceDAO attendanceDAO;
    private final ClassSessionDAO classSessionDAO;
    private final TclassService tclassService;
    private final IStudentService studentService;
    private final ClassSessionService classSessionService;
    private final ParameterService parameterService;
    private final ClassAlarmService classAlarmService;

    @Transactional(readOnly = true)
    @Override
    public AttendanceDTO.Info get(Long id) {
        final Optional<Attendance> sById = attendanceDAO.findById(id);
        final Attendance attendance = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AttendanceNotFound));
        return modelMapper.map(attendance, AttendanceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<AttendanceDTO.Info> list() {
        final List<Attendance> sAll = attendanceDAO.findAll();
        return modelMapper.map(sAll, new TypeToken<List<AttendanceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public AttendanceDTO.Info create(AttendanceDTO.Create request) {
        final Attendance attendance = modelMapper.map(request, Attendance.class);
        return save(attendance);
    }

    @Transactional
    @Override
    public List<List<Map>> getAttendanceByStudent(Long classId, Long studentId) {
        List<ClassSession> sessions = classSessionDAO.findByClassId(classId);
        List<Attendance> attendances = attendanceDAO.findBySessionInAndStudentId(sessions, studentId);
        ArrayList<Long> existIds = new ArrayList<>();
        attendances.forEach(a -> existIds.add(a.getSessionId()));
        List<Map> maps = new ArrayList<>();
        for (ClassSession s : sessions) {
            Map<String, String> map = new HashMap<>();
            map.put("studentId", studentId.toString());
            map.put("sessionId", s.getId().toString());
            map.put("sessionType", s.getSessionType());
            map.put("sessionDate", s.getSessionDate());
            map.put("startHour", s.getSessionStartHour());
            map.put("endHour", s.getSessionEndHour());
            map.put("state", "0");
            map.put("readOnly", isReadOnly(s.getSessionDate()));
            for (Attendance a : attendances) {
                if (a.getSessionId().equals(s.getId())) {
                    map.put("state", a.getState());
                    break;
                }
            }
            maps.add(map);
        }
        List<Attendance> causesOfAbsence = attendances.stream().filter(a -> a.getState().equals("4")).collect(Collectors.toList());
        List<Map> causesMap = new ArrayList<>();
        for (Attendance attendance : causesOfAbsence) {
            Map<String, String> map = new HashMap<>();
            map.put("studentId", attendance.getStudentId().toString());
            map.put("sessionId", attendance.getSessionId().toString());
            map.put("description", attendance.getDescription());
            causesMap.add(map);
        }
        List<List<Map>> returnList = new ArrayList<>();
        returnList.add(maps);
        returnList.add(causesMap);
        return returnList;
    }

    static private String prepareForArabicSort(String text) {
        return text
                .replaceAll("ی", "ي")
                .replaceAll("ک", "ك")
                .replaceAll("گ", "كی")
                .replaceAll("ژ", "زی")
                .replaceAll("چ", "جی")
                .replaceAll("پ", "بی");
    }


    @Transactional
    @Override
    public List<List<Map>> autoCreate(Long classId, String date) {
        List<ClassSessionDTO.Info> sessions = classSessionService.getSessionsForDate(classId, date);
        List<Long> sessionIds = sessions.stream().map(s -> s.getId()).collect(Collectors.toList());
        Tclass tclass = tclassService.getEntity(classId);
        List<Student> students = tclass.getClassStudents().stream().map(ClassStudent::getStudent).collect(Collectors.toList());
        List<Attendance> attendances = new ArrayList<>();
        sessions.forEach(s -> attendances.addAll(attendanceDAO.findBySessionId(s.getId())));
        List<Map> maps = new ArrayList<>();

        for (ClassStudent classStudent : tclass.getClassStudents()) {
            Map<String, String> map = new HashMap<>();
            map.put("studentId", String.valueOf(classStudent.getStudent().getId()));
            map.put("studentName", classStudent.getStudent().getFirstName().trim());
            map.put("studentFamily", classStudent.getStudent().getLastName().trim());
            map.put("personalNum", classStudent.getStudent().getPersonnelNo());
            map.put("nationalCode", classStudent.getStudent().getNationalCode());
            map.put("company", classStudent.getStudent().getCompanyName());
            map.put("studentState", classStudent.getPresenceType().getCode());
            map.put("classStudentId", classStudent.getId().toString());
            List<Attendance> filterAttendance = attendances.stream().filter(a -> a.getStudentId().equals(classStudent.getStudent().getId())).collect(Collectors.toList());
            List<Long> sessionIdsSaved = filterAttendance.stream().map(c -> c.getSessionId()).collect(Collectors.toList());
            for (Long sessionId : sessionIds) {
                map.put("se" + String.valueOf(sessionId), "0");
                for (Attendance a : filterAttendance) {
                    if (sessionIdsSaved.contains(sessionId)) {
                        if (a.getSessionId().equals(sessionId)) {
                            map.put("se" + String.valueOf(a.getSessionId()), a.getState());
                            break;
                        }
                    }
                }
            }
            maps.add(map);
        }

        maps.sort(Comparator.nullsLast(Comparator.comparing(m -> m.get("studentFamily").toString(),
                Comparator.nullsLast(Comparator.naturalOrder()))));

        Collections.reverse(maps);

        List<Attendance> causesOfAbsence = attendances.stream().filter(a -> a.getState().equals("4")).collect(Collectors.toList());
        List<Map> causesMap = new ArrayList<>();
        for (Attendance attendance : causesOfAbsence) {
            Map<String, String> map = new HashMap<>();
            map.put("studentId", attendance.getStudentId().toString());
            map.put("sessionId", attendance.getSessionId().toString());
            map.put("description", attendance.getDescription());
            causesMap.add(map);
        }
        List<List<Map>> returnList = new ArrayList<>();
        returnList.add(maps);
        returnList.add(causesMap);
        return returnList;
    }

    @Transactional
    @Override
    public void studentAttendanceSave(List<List<Map<String, String>>> maps) {
        Set<Long> classIdSet = new HashSet<>();
        List<Map<String, String>> mapList = maps.get(0);
        ArrayList<Attendance> attendanceSaving = new ArrayList<>();
        for (Map<String, String> map : mapList) {
            Attendance attendance = new Attendance();
            attendance.setSessionId(Long.valueOf(map.get("sessionId")));
            attendance.setStudentId(Long.valueOf(map.get("studentId")));
            attendance.setState(map.get("state"));
            for (Map<String, String> causeOfAbsenceList : maps.get(1)) {
                if (map.get("state").equals("4") && causeOfAbsenceList.get("studentId").equals(map.get("studentId")) && causeOfAbsenceList.get("sessionId").equals(map.get("sessionId"))) {
                    attendance.setDescription(causeOfAbsenceList.get("description"));
                }
            }
            attendanceSaving.add(attendance);
        }
        for (Attendance attendance : attendanceSaving) {
            ClassSessionDTO.Info info = classSessionService.get(attendance.getSessionId());
            classIdSet.add(info.getClassId());
            if (!info.getReadOnly()) {
                Optional<Attendance> saved = attendanceDAO.findBySessionIdAndStudentId(attendance.getSessionId(), attendance.getStudentId());
                if (saved.isPresent()) {
                    Attendance oldAttendance = saved.get();
                    oldAttendance.setState(attendance.getState());
                    oldAttendance.setDescription(attendance.getDescription());
                    attendanceDAO.save(oldAttendance);
                } else {
                    attendanceDAO.save(attendance);
                }
            }
        }
//        Iterator<Long> iterator = classIdSet.iterator();
//        while (iterator.hasNext()){
//            Long info = iterator.next();
//            classAlarmService.alarmAttendanceUnjustifiedAbsence(info);
//            classAlarmService.saveAlarms();
//        }
    }

    @Transactional
    @Override
    public void convertToModelAndSave(List<List<Map<String, String>>> maps, Long classId, String date) {
    /*    Map<String, String> map1 = maps.get(0).get(0);
        Set<String> keySet = map1.keySet();
        ArrayList<Long> sessionIds = new ArrayList<>();
        ArrayList<Attendance> attendanceSaving = new ArrayList<>();
        for (String s : keySet) {
            if (s.startsWith("se")) {
                sessionIds.add(Long.valueOf(s.substring(2)));
            }
        }
        for (Map<String, String> map : maps.get(0)) {
            for (Long sessionId : sessionIds) {
                ClassSessionDTO.Info info = classSessionService.get(sessionId);
                if(!info.getReadOnly()){
                    Attendance attendance = new Attendance();
                    attendance.setSessionId(sessionId);
                    attendance.setStudentId(Long.valueOf(map.get("studentId")));
                    attendance.setState(map.get("se" + sessionId));
                    for (Map<String, String> causeOfAbsenceList : maps.get(1)) {
                        if (map.get("se" + sessionId).equals("4") && causeOfAbsenceList.get("studentId").equals(map.get("studentId")) && causeOfAbsenceList.get("sessionId").equals(attendance.getSessionId().toString())) {
                            attendance.setDescription(causeOfAbsenceList.get("description"));
                        }
                    }
                    attendanceSaving.add(attendance);
                }
            }
        }
        final ArrayList<Attendance> attendanceList = new ArrayList<>();
        for (Attendance attendance : attendanceSaving) {
            List<Attendance> saved = attendanceDAO.findBySessionIdAndStudentId(attendance.getSessionId(), attendance.getStudentId());
            if (saved == null || saved.size()==0) {
                attendanceList.add(attendance);
            } else {
                saved.get(0).setState(attendance.getState());
                saved.get(0).setDescription(attendance.getDescription());
                attendanceList.add(saved.get(0));
            }
        }
        attendanceDAO.saveAll(attendanceList);*/
    }

    @Transactional
    @Override
    public AttendanceDTO.Info update(Long id, AttendanceDTO.Update request) {
        final Optional<Attendance> sById = attendanceDAO.findById(id);
        final Attendance attendance = sById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.AttendanceNotFound));
        Attendance updating = new Attendance();
        modelMapper.map(attendance, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        attendanceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(AttendanceDTO.Delete request) {
        final List<Attendance> sAllById = attendanceDAO.findAllById(request.getIds());
        attendanceDAO.deleteAll(sAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AttendanceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(attendanceDAO, request, attendance -> modelMapper.map(attendance, AttendanceDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public Double acceptAbsentHoursForClass(Long classId, Double x) {
        return tclassService.sessionsHourSum(classId) * x;
    }

    @Transactional()
    @Override
    public boolean studentAbsentSessionsInClass(Long classId, List<Long> sessionId, Long studentId) throws ParseException {

        List<ClassSessionDTO.Info> sessions = classSessionService.loadSessions(classId);
        List<Long> sessionIds = sessions.stream().map(ClassSessionDTO.Info::getId).collect(Collectors.toList());
        List<Attendance> absentList = attendanceDAO.findBySessionIdInAndStudentIdAndState(sessionIds, studentId, "3");
        Set<ClassSessionDTO.Info> absentSessionList = new HashSet<>();

        absentList.forEach(a -> absentSessionList.add(modelMapper.map(a.getSession(), ClassSessionDTO.Info.class)));
        for (Long aLong : sessionId) {
            absentSessionList.add(classSessionService.get(aLong));
        }

        Long sum = 0L;
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        for (ClassSessionDTO.Info classSession : absentSessionList) {
            sum += sdf.parse(classSession.getSessionEndHour()).getTime() - sdf.parse(classSession.getSessionStartHour()).getTime();
        }

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        ParameterValueDTO.Info info = parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("VAP")).findFirst().orElse(null);

        Double acceptAbsentHoursForClass = acceptAbsentHoursForClass(classId, Double.valueOf(info == null ? "0" : info.getValue()) / 100);

        return acceptAbsentHoursForClass >= sum;
    }

    // ------------------------------

    private AttendanceDTO.Info save(Attendance attendance) {
        final Attendance saved = attendanceDAO.saveAndFlush(attendance);
        return modelMapper.map(saved, AttendanceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    public List<Attendance> findBySessionInAndState(List<ClassSession> sessions, String state) {
        return attendanceDAO.findBySessionInAndState(sessions, state);
    }

    private String isReadOnly(String startingDate) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todayDate = DateUtil.convertMiToKh(dateFormat.format(date));
        return todayDate.compareTo(startingDate) >= 0 ? "false" : "true";
    }

    //Amin Haeri-------------------
    @Transactional()
    @Override
    public String studentUnknownSessionsInClass(Long classId) {
        List<ClassSessionDTO.Info> sessions = classSessionService.getSessions(classId);
        Tclass tclassOfSession = tclassService.getEntity(classId);
        int numStudents = tclassOfSession.getClassStudents().size();
        Collections.sort(sessions, (ClassSessionDTO.Info s1, ClassSessionDTO.Info s2) -> {
                    if (s1.getSessionDate() != null && s2.getSessionDate() != null)
                        return s1.getSessionDate().compareTo(s2.getSessionDate());
                    return (s1.getSessionDate() != null) ? 1 : -1;
                }
        );

        for (ClassSessionDTO.Info s : sessions) {
            List<Attendance> attendanceList = attendanceDAO.findBySessionId(s.getId());
            if (attendanceList.size() != numStudents) {
                return s.getSessionDate();
            }
            for (Attendance a : attendanceList) {
                if (a.getState().equals("0")) {
                    return s.getSessionDate();
                }
            }
        }

        return new String();
    }

    @Override
    public List<Student> studentAbsentSessionsInClass(Long classId) {
        List<ClassStudentDTO.AttendanceInfo> students = tclassService.getStudents(classId);
        List<Long> absentStudents = new ArrayList<>();
        for (ClassStudentDTO.AttendanceInfo student : students) {
            List<Long> list = attendanceDAO.getAttendanceByClassIdAndStudentId(classId, student.getStudentId());
            if (!list.isEmpty()) {
                boolean allAbsent = list.stream().allMatch(x -> x.equals(3L));
                if (allAbsent) {
                    absentStudents.add(student.getStudentId());
                }
            }
        }
        return studentService.getStudentList(absentStudents);
    }

    @Override
    public boolean saveOrUpdateList(List<Attendance> attendances) {
        List<Attendance> updateAttendanceList = new ArrayList<>();
        List<Attendance> newAttendanceList = new ArrayList<>();
        attendances.forEach(attendance -> {
            Optional<Attendance> optional = getAttendanceBySessionIdAndStudentId(attendance.getSessionId(), attendance.getStudentId());
            if (optional.isPresent()) {
                Attendance oldAttendance = optional.get();
                oldAttendance.setState(attendance.getState());
                oldAttendance.setDescription(attendance.getDescription());
//                attendanceDAO.save(oldAttendance);
                updateAttendanceList.add(oldAttendance);
            } else {
                Student student = studentService.getStudent(attendance.getStudentId());
                ClassSession session = classSessionService.getClassSession(attendance.getSessionId());
                attendance.setStudent(student);
                attendance.setSession(session);
//                attendanceDAO.save(attendance);
                newAttendanceList.add(attendance);

            }
        });
        try {
            if (updateAttendanceList.size() > 0) {
                attendanceDAO.saveAll(updateAttendanceList);
            }

            if (newAttendanceList.size() > 0) {
                attendanceDAO.saveAll(newAttendanceList);
            }
            return true;
        }
        catch (Exception e)
        {
            return false;
        }

    }

    public Optional<Attendance> getAttendanceBySessionIdAndStudentId(Long sessionId, Long studentId) {
        return attendanceDAO.findBySessionIdAndStudentId(sessionId, studentId);
    }

    @Transactional
    @Override
    public boolean FinalApprovalClass(Long classId) {
        try {
            List<ClassSessionDTO.Info> sessions = classSessionService.getSessions(classId);
            for (ClassSessionDTO.Info sessionDTO:sessions){
                ClassSession classSession=classSessionDAO.getClassSessionById(sessionDTO.getId());
                classSession.setTeacherAttendancePermission(true);
                classSessionDAO.save(classSession);
            }
            return true;

        }catch (Exception e){
            return false;
        }


    }
}
