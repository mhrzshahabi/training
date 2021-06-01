package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.model.Attendance;
import com.nicico.training.model.Student;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface IAttendanceService {

    AttendanceDTO.Info get(Long id);

    List<AttendanceDTO.Info> list();

    AttendanceDTO.Info create(AttendanceDTO.Create request);

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
    List<List<Map>> getAttendanceByStudent(Long classId, Long studentId);

    @Transactional
    List<List<Map>> autoCreate(Long classId, String date);


    @Transactional
    void convertToModelAndSave(List<List<Map<String, String>>> maps, Long classId, String date);

    AttendanceDTO.Info update(Long id, AttendanceDTO.Update request);

    void delete(Long id);

    void delete(AttendanceDTO.Delete request);

    SearchDTO.SearchRs<AttendanceDTO.Info> search(SearchDTO.SearchRq request);

//	Integer acceptAbsent(Long classId, Long studentId);

//	@Transactional(readOnly = true)
//	Integer acceptAbsentHoursForClass(Long classId, Integer x);

    Double acceptAbsentHoursForClass(Long classId, Double x);

    boolean studentAbsentSessionsInClass(Long classId, List<Long> sessionId, Long studentId) throws ParseException;

    void studentAttendanceSave(List<List<Map<String, String>>> maps);

    String studentUnknownSessionsInClass(Long classId);
    List<Student> studentAbsentSessionsInClass(Long classId);

    boolean saveOrUpdateList(List<Attendance> attendances);
}
