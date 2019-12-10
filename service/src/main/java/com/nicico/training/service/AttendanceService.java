package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.iservice.IAttendanceService;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AttendanceService implements IAttendanceService {

    private final ModelMapper modelMapper;
    private final AttendanceDAO attendanceDAO;
    private final TclassService tclassService;
    private final ClassSessionService classSessionService;


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

    //	@Transactional
//	@Override
//	public List<AttendanceDTO.Info> autoCreate(Long classId, String date) {
//		List<ClassSessionDTO.Info> sessions = classSessionService.getSessionsForDate(classId, date);
//		Tclass tclass = tclassService.getEntity(classId);
//		List<Student> students = tclass.getStudentSet();
//		List<Attendance> attendanceList = new ArrayList<>();
//		for (ClassSessionDTO.Info session : sessions) {
//			for (Student student : students) {
//				Attendance attendance = new Attendance();
//				attendance.setSessionId(session.getId());
//				attendance.setStudentId(student.getId());
//				attendance.setStudent(student);
//				attendanceList.add(attendanceDAO.saveAndFlush(attendance));
//			}
//		}
//		return modelMapper.map(attendanceList, new TypeToken<List<AttendanceDTO.Info>>() {
//		}.getType());
//	}
    @Transactional
    @Override
    public List<Map> autoCreate(Long classId, String date) {
        List<ClassSessionDTO.Info> sessions = classSessionService.getSessionsForDate(classId, date);
        List<Long> sessionIds = sessions.stream().map(s -> s.getId()).collect(Collectors.toList());
        Tclass tclass = tclassService.getEntity(classId);
        List<Student> students = tclass.getStudentSet();
//        if(attendanceDAO.existsBySessionId(sessions.get(0).getId())){
//        ArrayList<Long> sessionIds = new ArrayList<>();
        ArrayList<Attendance> attendances = new ArrayList<>();
        sessions.forEach(s -> attendances.addAll(attendanceDAO.findBySessionId(s.getId())));
//        List<Attendance> attendances = attendanceDAO.findBySessionId(sessionIds);
        ArrayList<Map> maps = new ArrayList<>();
        for (Student student : students) {
            Map<String, String> map = new HashMap<>();
            map.put("studentId", String.valueOf(student.getId()));
            map.put("studentName", student.getFirstName());
            map.put("studentFamily", student.getLastName());
            map.put("nationalCode", student.getNationalCode());
            List<Attendance> filterAttendance = attendances.stream().filter(a -> a.getStudentId().equals(student.getId())).collect(Collectors.toList());
            List<Long> sessionIdsSaved = filterAttendance.stream().map(c -> c.getSessionId()).collect(Collectors.toList());
//            for (ClassSessionDTO.Info session : sessions)
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
        return maps;
    }
//        else {
////            tclass = tclassService.getEntity(classId);
////            students = tclass.getStudentSet();
////        List<Attendance> attendanceList = new ArrayList<>();
//            ArrayList<Map> maps = new ArrayList<>();
//            for (Student student : students) {
//                Map<String, String> map = new HashMap<>();
//                map.put("studentId", String.valueOf(student.getId()));
//                map.put("studentName", student.getFirstName());
//                map.put("studentFamily", student.getLastName());
//                map.put("nationalCode", student.getNationalCode());
//                for (ClassSessionDTO.Info session : sessions) {
//                    map.put("se" + String.valueOf(session.getId()), "0");
//                }
//                maps.add(map);
//            }
////		for (ClassSessionDTO.Info session : sessions) {
////			for (Student student : students) {
////				Attendance attendance = new Attendance();
////				attendance.setSessionId(session.getId());
////				attendance.setStudentId(student.getId());
////				attendanceList.add(attendanceDAO.saveAndFlush(attendance));
////			}
////		}
//            return maps;
//        }
//    }

    @Transactional
    @Override
    public void convertToModelAndSave(List<Map<String, String>> maps, Long classId, String date) {
        Map<String, String> map1 = maps.get(0);
        Set<String> keySet = map1.keySet();
        ArrayList<Long> sessionIds = new ArrayList<>();
        ArrayList<Attendance> attendanceSaving = new ArrayList<>();
        for (String s : keySet) {
            if (s.startsWith("se")) {
                sessionIds.add(Long.valueOf(s.substring(2)));
            }
        }
        for (Map<String, String> map : maps) {
            for (Long sessionId : sessionIds) {
                Attendance attendance = new Attendance();
                attendance.setSessionId(sessionId);
                attendance.setStudentId(Long.valueOf(map.get("studentId")));
                attendance.setState(map.get("se" + sessionId));
                attendanceSaving.add(attendance);
            }
        }

        List<ClassSessionDTO.Info> sessions = classSessionService.getSessionsForDate(classId, date);
        ArrayList<Attendance> attendances = new ArrayList<>();
        sessions.forEach(s -> attendances.addAll(attendanceDAO.findBySessionId(s.getId())));
        List<Long> sessionIdSaved = attendances.stream().map(c -> c.getSessionId()).collect(Collectors.toList());
        List<Long> studentIdSaved = attendances.stream().map(c -> c.getStudentId()).collect(Collectors.toList());

        for (Attendance saving : attendanceSaving) {
            if(sessionIdSaved.contains(saving.getSessionId())&&studentIdSaved.contains(saving.getStudentId())){
                List<Attendance> saved = attendances.stream().filter((a) -> a.getSessionId().equals(saving.getSessionId()) && a.getStudentId().equals(saving.getStudentId())).collect(Collectors.toList());
                Attendance attendanceNull = new Attendance();
                modelMapper.map(saved, attendanceNull);
                modelMapper.map(saving, attendanceNull);
                attendanceDAO.saveAndFlush(attendanceNull);
            }
            else {
                attendanceDAO.saveAndFlush(saving);
            }
        }
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

    // ------------------------------

    private AttendanceDTO.Info save(Attendance attendance) {

        final Attendance saved = attendanceDAO.saveAndFlush(attendance);
        return modelMapper.map(saved, AttendanceDTO.Info.class);
    }
}
