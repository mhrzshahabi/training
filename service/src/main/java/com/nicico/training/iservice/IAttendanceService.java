package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AttendanceDTO;
import com.nicico.training.dto.ClassSessionDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface IAttendanceService {

	AttendanceDTO.Info get(Long id);

	List<AttendanceDTO.Info> list();

	AttendanceDTO.Info create(AttendanceDTO.Create request);

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

	Float acceptAbsentHoursForClass(Long classId, Float x);

	List<ClassSessionDTO.Info> studentAbsentSessionsInClass(Long classId, Long studentId);
}
